fs       = require('fs')
parsers = {}
games    = require('./games.js')

###
Prototype
###

parsers.createParser = (file)->
    file = fs.openSync(file, 'r')
    buffer = new Buffer(6)
    fs.readSync(file, buffer, 0, 6, 0)
    fs.closeSync(file)

    if /^\d+\.\d+ \-/.exec(buffer.toString())
        return new parsers.Q3Parser()

    if /^\s+\d+\:\d+/.exec(buffer.toString())
        return new parsers.COD4Parser()
    
    throw new Error('Unknown file format')

class parsers.Parser
    constructor: ->
        @games = new games.Games()
        return @

    createGame: (params)->
    
    processLine: (lineString)->

    name: 'Generic Parser'


###
Quake III Arena (OSP)
###

class parsers.Q3Parser extends parsers.Parser
    name: 'Q3 OSP Parser'
    processLine: (lineString)->
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
            @createGame obj

        
        #process other game events
        @currentGame = @games.last()
        
        if @currentGame?
            
            #real time of game
            if lineString.indexOf('ServerTime') > -1
                date = /(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/.exec(lineString)
                @currentGame.set
                    serverTime:        new Date(date[1], Number(date[2])-1, date[3], date[4], date[5], date[6])
                    serverTimeOffset:  lineOffset

            #game actually started
            if lineString.indexOf('Game_Start') > -1
                @currentGame.set
                    started:            true
                    startTimeOffset:    lineOffset

            #player connect
            if lineString.indexOf('ClientConnect') > -1
                if searchResult = /ClientConnect: (\d+)/.exec(lineString)
                    clientId = searchResult[1]
                    
                    @currentGame.set('players', new games.Players()) unless @currentGame.get('players')

                    @currentGame.get('players').add
                        id:             clientId
                        connectOffset:  lineOffset

            #player begun game
            if lineString.indexOf('ClientBegun') > -1
                if searchResult = /ClientBegun: (\d+)/.exec(lineString)
                    clientId = searchResult[1]

                    if user = @currentGame.get('players').get(searchResult[1])

                        user.set
                            begun:          true
                            begunOffset:    lineOffset

            #user info
            if lineString.indexOf('ClientUserinfoChanged') > -1
                if searchResult = /ClientUserinfoChanged: (\d+) (.+)/.exec(lineString)

                    if user = @currentGame.get('players').get(searchResult[1])
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

                    @currentGame.get('items').add
                        player:     Number(searchResult[1])
                        type:       itemType
                        name:       itemName
                        timeOffset: lineOffset

            #kills
            if lineString.indexOf('Kill:') > -1
                if searchResult = /Kill: (\d+) (\d+) (\d+): .+ by (\w+) (\d+)/.exec(lineString)

                    @currentGame.get('kills').add
                        killer:         Number(searchResult[1])
                        victim:         Number(searchResult[2])
                        meansOfDeath:   searchResult[3]
                        killerWeapon:   searchResult[4]
                        victimWeapon:   searchResult[5]
                        timeOffset:     lineOffset

    createGame: (params)->
        @games.add(new games.Game(params))
        @games.last().set 'items', new games.Items()
        @games.last().set 'kills', new games.Kills()



###
Call of Duty 4: Modern Warfare
###

class parsers.COD4Parser extends parsers.Parser
    name: 'CoD 4 Parser'
    processLine: (lineString)->
        #event time offset

        timeTry = /^\s+(\d+)\:(\d+) .+/.exec(lineString)
        return false unless timeTry
        
        lineOffset = Number(timeTry[1])*60+Number(timeTry[2])

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
            @createGame obj

        #process other game events
        @currentGame = @games.last()

        #player connect
        if searchResult = /J;(.*);(\d+);(.*)/.exec(lineString)
            
            @currentGame.set('players', new games.Players()) unless @currentGame.get('players')

            @currentGame.get('players').add
                id:             searchResult[2]
                connectOffset:  lineOffset
                name:           searchResult[3]
                hash:           searchResult[1]

        #kills and hits
        if searchResult = /(K|D);(.*);(\d+);(.*);(.*);(.*);(\d+);(.*);(.*);(.*);(\d+);(.*);(.*)/.exec(lineString)

            eventType = searchResult[0]

            #a kill is always preceded by a hit in a single event

            @currentGame.get('hits').add
                attacker:   Number(searchResult[3])
                defendant:  Number(searchResult[7])
                weapon:     searchResult[10]
                hitpoints:  searchResult[11]
                medium:     searchResult[12]
                location:   if searchResult[13] != 'none' then searchResult[13] else null
                timeOffset: lineOffset

            #if kill
            if eventType = 'K'
                @currentGame.get('kills').add
                    killer:         Number(searchResult[3])
                    victim:         Number(searchResult[7])
                    meansOfDeath:   searchResult[12]
                    killerWeapon:   searchResult[10]
                    victimWeapon:   null
                    timeOffset:     lineOffset

        #item get
        if searchResult = /Weapon;(.*);(\d+);(.*);(.*)/.exec(lineString)

            @currentGame.get('items').add
                player:     Number(searchResult[2])
                type:       'weapon'
                name:       searchResult[4]
                timeOffset: lineOffset

        #  4:48 Weapon;82ceb3742e4cbd6cd0523fb6fa0973b7;1;nim579;mp5_mp

    createGame: (params)->
        @games.add(new games.Game(params))
        @games.last().set 
            started: true
            items: new games.Items()
            kills: new games.Kills()
            hits:  new games.Hits()

module.exports = parsers;
