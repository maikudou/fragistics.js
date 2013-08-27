games       = require('../js/games.js')
parsers     = require('../js/parsers.js')

testData_q3 = require('../testdata/q3_lines.json')

q3logfile   = 'testdata/q3.log'
cod4logfile = 'testdata/cod4.log'
jsonfile    = 'testdata/gamesSpec_cod4.json'


describe "createParser", ->
    it "should instantiate appropriate parser basing on file type", ->
        q3parser = parsers.createParser(q3logfile)
        cod4parser = parsers.createParser(cod4logfile)

        expect(q3parser instanceof parsers.Q3Parser).toBe(true)
        expect(cod4parser instanceof parsers.COD4Parser).toBe(true)

    it "should throw an error in case of unknown file type", ->
        tester = ->
            parsers.createParser(jsonfile)

        expect(tester).toThrow()


describe "Parser", ->
    parser = null

    beforeEach ->
        parser = new parsers.Parser()

    afterEach ->
        parser = null

    it "should have 'createGame' method", ->
        expect(parser.createGame).toBeDefined()

    it "should have 'processLine' method", ->
        expect(parser.processLine).toBeDefined()

    it "should have proper name", ->
        expect(parser.name).toBe('Generic Parser')

    it "should instantiate a games collection on creation", ->
        expect(parser.games).toBeDefined()
        expect(parser.games instanceof games.Games).toBe(true)



describe "Q3Parser", ->
    parser = null

    beforeEach ->
        parser = new parsers.Q3Parser()

    afterEach ->
        parser = null

    it "should have 'createGame' method", ->
        expect(parser.createGame).toBeDefined()

    it "should have 'processLine' method", ->
        expect(parser.processLine).toBeDefined()

    it "should have proper name", ->
        expect(parser.name).toBe('Q3 OSP Parser')

    it "instantiates a games collection on creation", ->
        expect(parser.games).toBeDefined()
        expect(parser.games instanceof games.Games).toBe(true)

    it "marks started games", ->
        for line in testData_q3
            parser.processLine(line)

        expect(parser.games.length).toBe(4)
        expect(parser.games.where({started: true}).length).toBe(2)

    it "bypasses unrecognized strings", ->
        tester = ->
            parser.processLine(testData_q3[0])
            parser.processLine('some generic random string')

        expect(tester).not.toThrow()

    it "parses 'InitGame' strings and creates items and kills collections", ->
        parser.processLine(testData_q3[1])

        expect(parser.games.length).toBe(1)
        expect(parser.games.at(0).get('items')).toBeDefined()
        expect(parser.games.at(0).get('items') instanceof games.Items).toBe(true)
        expect(parser.games.at(0).get('kills')).toBeDefined()
        expect(parser.games.at(0).get('kills') instanceof games.Kills).toBe(true)
        expect(parser.games.at(0).get('started')).toBe(false)

        for i in [2..29]
            parser.processLine(testData_q3[i])

        expect(parser.games.at(0).get('started')).toBe(false)
        expect(parser.games.at(1).get('started')).toBe(false)
        expect(parser.games.last().get('started')).toBe(true)

        expect(parser.games.last().attributes).toBe
        expect(parser.games.last().get('g_blueTeam')).toBe('Pagans')
        expect(parser.games.last().get('g_redTeam')).toBe('Stroggs')
        expect(parser.games.last().get('sv_floodProtect')).toBe('1')
        expect(parser.games.last().get('sv_maxPing')).toBe('0')
        expect(parser.games.last().get('sv_minPing')).toBe('0')
        expect(parser.games.last().get('sv_maxRate')).toBe('0')
        expect(parser.games.last().get('sv_minRate')).toBe('0')
        expect(parser.games.last().get('sv_hostname')).toBe('...yahoo...')
        expect(parser.games.last().get('dmflags')).toBe('0')
        expect(parser.games.last().get('fraglimit')).toBe('0')
        expect(parser.games.last().get('timelimit')).toBe('15')
        expect(parser.games.last().get('sv_maxclients')).toBe('64')
        expect(parser.games.last().get('capturelimit')).toBe('0')
        expect(parser.games.last().get('version')).toBe('ioq3 1.36 linux-x86_64 Apr 12 2009')
        expect(parser.games.last().get('g_gametype')).toBe('1')
        expect(parser.games.last().get('protocol')).toBe('68')
        expect(parser.games.last().get('mapname')).toBe('ztn3tourney1')
        expect(parser.games.last().get('sv_privateClients')).toBe('0')
        expect(parser.games.last().get('sv_allowDownload')).toBe('0')
        expect(parser.games.last().get('gamename')).toBe('osp')
        expect(parser.games.last().get('gameversion')).toBe('OSP v1.03a')
        expect(parser.games.last().get('Players_Active')).toBe('1 2 ')
        expect(parser.games.last().get('server_promode')).toBe('0')
        expect(parser.games.last().get('g_needpass')).toBe('0')
        expect(parser.games.last().get('server_freezetag')).toBe('0')
        expect(parser.games.last().get('server_ospauth')).toBe('0')
        expect(parser.games.last().get('Score_Time')).toBe('Waiting for Players')
        expect(parser.games.last().get('started')).toBe(true)

    it "parses 'ServerTime' strings and sets real time date to game", ->
        for i in [0..29]
            parser.processLine(testData_q3[i])

        expect(parser.games.at(0).get('serverTime').toString()).toBe(new Date('Fri May 17 2013 18:01:51 GMT+0400 (MSK)').toString())
        expect(parser.games.at(0).get('serverTimeOffset')).toBe(0)

        expect(parser.games.at(1).get('serverTime').toString()).toBe(new Date('Fri May 17 2013 18:02:02 GMT+0400 (MSK)').toString())
        expect(parser.games.at(1).get('serverTimeOffset')).toBe(0)

        expect(parser.games.last().get('serverTime').toString()).toBe(new Date('Fri May 17 2013 18:03:53 GMT+0400 (MSK)').toString())
        expect(parser.games.last().get('serverTimeOffset')).toBe(110.2)
        

    it "parses 'Game_Start' strings and sets game start time offset", ->
        for i in [0..29]
            parser.processLine(testData_q3[i])

        expect(parser.games.at(0).get('startTimeOffset')).toBeUndefined()
        expect(parser.games.at(1).get('startTimeOffset')).toBeUndefined()

        expect(parser.games.last().get('startTimeOffset')).toBe(110.2)

    it "parses 'ClientConnect' strings and creates players", ->
        for i in [13..22]
            parser.processLine(testData_q3[i])

        expect(parser.games.first().get('players').length).toBe(2)
        expect(parser.games.first().get('players').first().get('connectOffset')).toBe(0.2)
        expect(parser.games.first().get('players').last().get('connectOffset')).toBe(2.8)
        expect(parser.games.first().get('players').first().get('active')).toBe(true)
        expect(parser.games.first().get('players').last().get('active')).toBe(true)

    it "parses 'ClientBegin' strings and sets players' joinedGame attribute", ->
        for i in [13..22]
            parser.processLine(testData_q3[i])

        players = parser.games.first().get('players')

        expect(players.first().get('joinedGame')).toBe(true)
        expect(players.last().get('joinedGame')).toBe(false)
        expect(players.first().get('joinedGameOffset')).toBe(0.7)
        expect(players.last().get('joinedGameOffset')).toBeUndefined()

    it "parses 'ClientUserinfoChanged' strings and sets players' attributes", ->
        for i in [13..22]
            parser.processLine(testData_q3[i])

        firstPlayer = parser.games.first().get('players').first()
        secondPlayer = parser.games.first().get('players').last()

        expect(firstPlayer.get('name')).toBe('^0br^3a^0hm^3a^0n')
        expect(firstPlayer.get('t')).toBe('0')
        expect(firstPlayer.get('model')).toBe('ranger/blue')
        expect(firstPlayer.get('hmodel')).toBe('ranger/blue')
        expect(firstPlayer.get('c1')).toBe('1')
        expect(firstPlayer.get('c2')).toBe('y')
        expect(firstPlayer.get('hc')).toBe('100')
        expect(firstPlayer.get('w')).toBe('0')
        expect(firstPlayer.get('l')).toBe('0')
        expect(firstPlayer.get('rt')).toBe('0')
        expect(firstPlayer.get('st')).toBe('0')
        expect(firstPlayer.get('clientId')).toBe('0')

        expect(secondPlayer.get('name')).toBe('emuravjev')
        expect(secondPlayer.get('t')).toBe('0')
        expect(secondPlayer.get('model')).toBe('sarge')
        expect(secondPlayer.get('hmodel')).toBe('sarge')
        expect(secondPlayer.get('c1')).toBe('1')
        expect(secondPlayer.get('c2')).toBe('5')
        expect(secondPlayer.get('hc')).toBe('100')
        expect(secondPlayer.get('w')).toBe('0')
        expect(secondPlayer.get('l')).toBe('0')
        expect(secondPlayer.get('rt')).toBe('0')
        expect(secondPlayer.get('st')).toBe('0')
        expect(secondPlayer.get('clientId')).toBe('1')


    it "parses 'Item' strings and logs items pickups", ->
        for i in [13..66]
            parser.processLine(testData_q3[i])

        items = parser.games.last().get('items')

        expect(items.length).toBe(31)

        expect(items.at(30).toJSON()).toEqual({ player: 0, type: 'weapon', name: 'railgun', timeOffset: 152.3 })
        expect(items.at(29).toJSON()).toEqual({ player: 0, type: 'health', name: 'mega', timeOffset: 149.3 })
        expect(items.at(26).toJSON()).toEqual({ player: 1, type: 'ammo', name: 'shells', timeOffset: 144.9 })
        expect(items.at(24).toJSON()).toEqual({ player: 0, type: 'armor', name: 'combat', timeOffset: 138.4 })


    it "parses 'Kill' strings and logs frags", ->
        for i in [13..71]
            parser.processLine(testData_q3[i])

        kills = parser.games.last().get('kills')

        expect(kills.length).toBe(2)
        expect(kills.first().toJSON()).toEqual({ killer: 0, victim: 1, meansOfDeath: '11', killerWeapon: 'MOD_LIGHTNING', victimWeapon: '6', timeOffset: 154.4 })
        expect(kills.last().toJSON()).toEqual({ killer: 0, victim: 1, meansOfDeath: '7', killerWeapon: 'MOD_ROCKET_SPLASH', victimWeapon: '2', timeOffset: 164.5})


    it "parses 'say' and 'sayteam' strings and logs players' talks", ->
        for i in [13..379]
            parser.processLine(testData_q3[i])

        chats = parser.games.last().get('chats')

        expect(chats).toBeDefined()
        expect(chats.length).toBe(2)
        expect(chats.first().toJSON()).toEqual({ type: 'global', player: 0, rawText: '^0br^3a^0hm^3a^0n: ^2:^4Q', message: '^2:^4Q', timeOffset: 494.5})
        expect(chats.last().toJSON()).toEqual({ type: 'team', player: 0, rawText: '^0br^3a^0hm^3a^0n: MEGA', message: 'MEGA', timeOffset: 630.7})


    it "parses 'Game_End' and logs game end reason", ->
        for i in [13..643]
            parser.processLine(testData_q3[i])

        game = parser.games.last()

        expect(game.get('endReason')).toBe('Timelimit')
        expect(game.get('endTimeOffset')).toBe(1010.2)


    it "parses 'score' and logs players' scores", ->
        for line in testData_q3
            parser.processLine(line)

        players = parser.games.last().get('players')

        expect(players.get(0).get('score')).toBe(25)
        expect(players.get(0).get('ping')).toBe(0)
        expect(players.get(1).get('score')).toBe(-2)
        expect(players.get(1).get('ping')).toBe(6)


    it "parses 'Weapon_Stats' and logs players' stats", ->
        for line in testData_q3
            parser.processLine(line)

        players = parser.games.at(2).get('players')

        expect(players.get(0).getWeaponStats('LightningGun')).toEqual({shots: 1149, hits: 209, pickups: 19, drops: 0})
        expect(players.get(0).getWeaponStats('R.Launcher')).toEqual({shots: 88, hits: 23, pickups: 17, drops: 1})
        expect(players.get(0).getStats()).toEqual({damageGiven: 4622, damageRecieved: 2961, armorTaken: 3170, healthTaken: 2480})

    
    it "parses 'ClientDisconnect', logs player disconnect event and creates a new player on new ClientConnect with same clientId", ->
        for i in [655..1033]
            parser.processLine(testData_q3[i])

        players = parser.games.last().get('players')

        expect(players.length).toBe(4)
        expect(players.get(2).get('active')).toBe(false)
        expect(players.get(2).get('joinedGame')).toBe(true)
        expect(players.get(3).get('active')).toBe(true)
        expect(players.get(3).get('joinedGame')).toBe(false)



describe "COD4Parser", ->
    parser = null

    beforeEach ->
        parser = new parsers.COD4Parser()

    afterEach ->
        parser = null

    it "should have 'createGame' method", ->
        expect(parser.createGame).toBeDefined()

    it "should have 'processLine' method", ->
        expect(parser.processLine).toBeDefined()

    it "should have proper name", ->
        expect(parser.name).toBe('CoD 4 Parser')

    it "instantiates a games collection on creation", ->
        expect(parser.games).toBeDefined()
        expect(parser.games instanceof games.Games).toBe(true)


