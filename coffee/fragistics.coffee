fs       = require('fs')
lazy     = require("lazy")
backbone = require("backbone")


Game = backbone.Model.extend
    defaults:
        started: false

Games = backbone.Collection.extend
    model: Game


Client = backbone.Model.extend
    defaults:
        name: 'unnamed'

Clients = backbone.Collection.extend
    model: Client


Item = backbone.Model.extend
    defaults:
        type: null
        name: null
        client: null
        offset: null

Items = backbone.Collection.extend
    model: Item


Kill = backbone.Model.extend
    defaults:
        killer: null
        victim: null
        meansOfDeath: null
        killerWeapon: null
        victimWeapon: null
        offset: null

Kills = backbone.Collection.extend
    model: Kill


result = {}

result.games = new Games()

file = fs.createReadStream 'testdata/games.log', 
    flags: 'r'
    encoding: null
    fd: null
    mode: '0666'
    bufferSize: 64 * 1024
    autoClose: true

games = 0

lazyStream = new lazy(file);

lazyStream.on 'end', ->
    console.log(result.games.where({started: true}).length)

lazyStream.lines
.forEach (line)->
    lineString = line.toString()

    #event time offset
    lineOffset = Number(/^(\d+\.\d+) .+/.exec(lineString)[1])

    #game loads
    if lineString.indexOf('InitGame') > -1
        
        obj = {}
        
        if searchResult = /InitGame: \\(.+)/.exec(lineString)

            for value, i in searchResult[1].split('\\')
                if i%2
                    #even iterations create entries in object by parameter name
                    obj[paramName] = value
                else
                    #first interation leads here, save parameter name
                    paramName = value

        #create new game
        result.games.add(new Game(obj))
        result.games.last().set 'items', new Items()
        result.games.last().set 'kills', new Kills()


    #process other game events
    currentGame = result.games.last()
    
    
    if currentGame?
        
        #real time of game
        if lineString.indexOf('ServerTime') > -1
            date = /(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/.exec(lineString)
            currentGame.set
                serverTime:        new Date(date[1], Number(date[2])-1, date[3], date[4], date[5], date[6])
                serverTimeOffset:  lineOffset

        #game actually started
        if lineString.indexOf('Game_Start') > -1
            currentGame.set
                started:            true
                startTimeOffset:    lineOffset

        #player connect
        if lineString.indexOf('ClientConnect') > -1
            if searchResult = /ClientConnect: (\d+)/.exec(lineString)
                clientId = searchResult[1]
                
                currentGame.set('clients', new Clients()) unless currentGame.get('clients')

                currentGame.get('clients').add
                    id:             clientId
                    connectOffset:  lineOffset

        #player begun game
        if lineString.indexOf('ClientBegun') > -1
            if searchResult = /ClientBegun: (\d+)/.exec(lineString)
                clientId = searchResult[1]

                if user = currentGame.get('clients').get(searchResult[1])

                    user.set
                        begun:          true
                        begunOffset:    lineOffset

        #user info
        if lineString.indexOf('ClientUserinfoChanged') > -1
            if searchResult = /ClientUserinfoChanged: (\d+) (.+)/.exec(lineString)

                if user = currentGame.get('clients').get(searchResult[1])
                    obj = {}
                    prevIndex = ''

                    for value, i in searchResult[2].split('\\')
                        if i%2
                            obj[prevIndex] = value
                        else
                            if value == 'n'
                                prevIndex = 'name'
                            else
                                prevIndex = value
                    
                    user.set(obj)

        #item get
        if lineString.indexOf('Item:') > -1
            if searchResult = /Item: (\d+) ([A-Za-z]+)_([A-Za-z]+)(?:_([A-Za-z]+))?/.exec(lineString)

                if searchResult[2] == 'item'
                    itemType = searchResult[3]
                    itemName = searchResult[4]
                else
                    itemType = searchResult[2]
                    itemName = searchResult[3]

                currentGame.get('items').add
                    client: searchResult[1]
                    type: itemType
                    name: itemName
                    offset: lineOffset

        #kills
        if lineString.indexOf('Kill:') > -1
            if searchResult = /Kill: (\d+) (\d+) (\d+): .+ by (\w+) (\d+)/.exec(lineString)

                currentGame.get('kills').add
                    killer:         searchResult[1]
                    victim:         searchResult[2]
                    meansOfDeath:   searchResult[3]
                    killerWeapon:   searchResult[4]
                    victimWeapon:   searchResult[5]

    return true

    
    
