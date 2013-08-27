fs       = require('fs')
parsers = {}
games    = require('./games.js')
players  = require('./players.js')

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
        lineOffset = Number(/^(\d+\.\d+) .+/.exec(lineString)[1]) if /^(\d+\.\d+) .+/.exec(lineString)

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

            if lineString.indexOf('Game_End') > -1
                if searchResult = /Game_End: (.+)/.exec(lineString)
                    @currentGame.set
                        endReason:      searchResult[1]
                        endTimeOffset:  lineOffset

            #player connect
            if lineString.indexOf('ClientConnect') > -1
                if searchResult = /ClientConnect: (\d+)/.exec(lineString)
                    clientId = searchResult[1]
                    
                    @currentGame.set('players', new players.Players()) unless @currentGame.get('players')

                    if user = @currentGame.get('players').where({clientId: clientId, active: true})[0]
                        user.set
                            active: false

                    @currentGame.get('players').add
                        id:             @currentGame.get('players').length
                        connectOffset:  lineOffset
                        active:         true
                        clientId:       clientId

            #player begun game
            if lineString.indexOf('ClientBegin') > -1
                if searchResult = /ClientBegin: (\d+)/.exec(lineString)
                    clientId = searchResult[1]

                    if user = @currentGame.get('players').where({clientId: clientId, active: true})[0]

                        user.set
                            joinedGame:          true
                            joinedGameOffset:    lineOffset

            #user info
            if lineString.indexOf('ClientUserinfoChanged') > -1
                if searchResult = /ClientUserinfoChanged: (\d+) (.+)/.exec(lineString)

                    if user = @currentGame.get('players').where({clientId: searchResult[1], active: true})[0]
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

            #chats
            if lineString.indexOf('say:') > -1
                if searchResult = /say: ((\S+): (\S+))/.exec(lineString)

                    @currentGame.get('chats').add
                        type:       'global'
                        player:     @currentGame.get('players').where({name: searchResult[2], active: true})[0].id
                        rawText:    searchResult[1]
                        message:    searchResult[3]
                        timeOffset: lineOffset

            if lineString.indexOf('sayteam:') > -1
                if searchResult = /sayteam: ((\S+): (\S+))/.exec(lineString)

                    @currentGame.get('chats').add
                        type:       'team'
                        player:     @currentGame.get('players').where({name: searchResult[2], active: true})[0].id
                        rawText:    searchResult[1]
                        message:    searchResult[3]
                        timeOffset: lineOffset

            #scores
            if lineString.indexOf('score:') > -1
                if searchResult = /score: (\-?\d+)\s+ping: (\d+)\s+client: (\d+)/.exec(lineString)
                    @currentGame.get('players').where({clientId: searchResult[3], active: true})[0].set
                        score: Number(searchResult[1])
                        ping: Number(searchResult[2])

            #stats
            if lineString.indexOf('Weapon_Stats:') > -1
                if searchResult = /Weapon_Stats: (\d+)\s?(.*) Given:(\d+) Recvd:(\d+) Armor:(\d+) Health:(\d+)/.exec(lineString)
                    player = @currentGame.get('players').where({clientId: searchResult[1], active: true})[0]

                    player.set
                        damageGiven:    Number(searchResult[3])
                        damageRecieved: Number(searchResult[4])
                        armorTaken:     Number(searchResult[5])
                        healthTaken:    Number(searchResult[6])

                    if searchResult = /((\D+):(\d+):(\d+):(\d+):(\d+) )+/.exec(searchResult[2])

                        for stat in searchResult[0].split(' ')
                            if statSearch = /(\D+):(\d+):(\d+):(\d+):(\d+)/.exec(stat)
                            
                                player.get('weaponStats').add
                                    weapon:     statSearch[1]
                                    shots:      Number(statSearch[2])
                                    hits:       Number(statSearch[3])
                                    pickups:    Number(statSearch[4])
                                    drops:      Number(statSearch[5])
                            

    createGame: (params)->
        @games.add(new games.Game(params))
        @games.last().set 'items', new games.Items()
        @games.last().set 'kills', new games.Kills()
        @games.last().set 'chats', new games.Chats()


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
            
            @currentGame.set('players', new players.Players()) unless @currentGame.get('players')

            @currentGame.get('players').add
                id:             searchResult[2]
                connectOffset:  lineOffset
                name:           searchResult[3]
                hash:           searchResult[1]
                joinedGame:     true

        #kills and hits
        if searchResult = /(K|D);(.*);(\d+);(.*);(.*);(.*);(\d+);(.*);(.*);(.*);(\d+);(.*);(.*)/.exec(lineString)

            @currentGame.set('started', true) unless @currentGame.get('started')

            eventType = searchResult[1]

            #a kill is always preceded by a hit in a single event

            @currentGame.get('hits').add
                attacker:   Number(searchResult[7])
                defendant:  Number(searchResult[3])
                weapon:     searchResult[10]
                hitpoints:  searchResult[11]
                medium:     searchResult[12]
                location:   if searchResult[13] != 'none' then searchResult[13] else null
                timeOffset: lineOffset

            #if kill
            if eventType == 'K'
                @currentGame.get('kills').add
                    killer:         Number(searchResult[7])
                    victim:         Number(searchResult[3])
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
            items: new games.Items()
            kills: new games.Kills()
            hits:  new games.Hits()

    locationsHitRate: ->
        locations = {}

        for game in @games.where({started: true})
            for location, rate of game.locationsHitRate()
                if locations[location]?
                    locations[location] += rate
                else
                    locations[location] = 0

        return locations

module.exports = parsers;
