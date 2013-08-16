games = require('../js/games.js')
testData_cod4 = require('../testdata/gamesSpec_cod4.json')[0]


describe "Game", ->
    game = null
    
    beforeEach ->
        game = new games.Game()

    afterEach ->
        game = null

    it "should have 'started' attribute", ->
        expect(game.get('started')).toBeDefined()

    it "should have 'locationsHitRate' method", ->
        expect(game.locationsHitRate).toBeDefined()

    it "should have 'playersHitRate' method", ->
        expect(game.playersHitRate).toBeDefined()

    it "should have 'playersHurtRate' method", ->
        expect(game.playersHurtRate).toBeDefined()

    it "should have 'playersKillRate' method", ->
        expect(game.playersKillRate).toBeDefined()

    it "should have 'playerKillVictimRate' method", ->
        expect(game.playersKillRate).toBeDefined()

    it "should have 'playersDeathRate' method", ->
        expect(game.playersDeathRate).toBeDefined()

    it "should have 'playerDeathKillerRate' method", ->
        expect(game.playersDeathRate).toBeDefined()

    it "should have 'playersItemGetRate' method", ->
        expect(game.playersItemGetRate).toBeDefined()

    it "should have 'playerItemTypeGetRate' method", ->
        expect(game.playerItemTypeGetRate).toBeDefined()

    it "should have 'playerItemNameGetRate' method", ->
        expect(game.playerItemNameGetRate).toBeDefined()

describe "Game.locationsHitRate", ->
    game = null
    
    beforeEach ->
        game = new games.Game(testData_cod4)
        game.set 'items',   new games.Items(game.get('items'))
        game.set 'kills',   new games.Kills(game.get('kills'))
        game.set 'hits',    new games.Hits(game.get('hits'))
        game.set 'players', new games.Players(game.get('players'))

    afterEach ->
        game = null

    it "should return correct values", ->
        expect(game.locationsHitRate).toBeDefined()

        correctValues = 
            left_leg_upper: 13
            torso_lower: 47
            torso_upper: 24
            neck: 3
            right_arm_lower: 6
            head: 20
            right_leg_upper: 3
            left_arm_lower: 5
            right_leg_lower: 3
            left_leg_lower: 3
            left_arm_upper: 4
            left_foot: 1
            right_arm_upper: 3
            right_foot: 1

        testValues = game.locationsHitRate()

        for location, value of correctValues
            expect(testValues[location]).toBe(value)


describe "Game.playersHitRate", ->
    game = null
    
    beforeEach ->
        game = new games.Game(testData_cod4)
        game.set 'items',   new games.Items(game.get('items'))
        game.set 'kills',   new games.Kills(game.get('kills'))
        game.set 'hits',    new games.Hits(game.get('hits'))
        game.set 'players', new games.Players(game.get('players'))

    afterEach ->
        game = null

    it "should return correct values", ->
        expect(game.playersHitRate).toBeDefined()

        correctValues =
            maikudou: 23
            nim579: 41
            kuteev: 13
            emuravjev: 70

        testValues = game.playersHitRate()

        for player, value of correctValues
            expect(testValues[player]).toBe(value)


describe "Game.playersHurtRate", ->
    game = null
    
    beforeEach ->
        game = new games.Game(testData_cod4)
        game.set 'items',   new games.Items(game.get('items'))
        game.set 'kills',   new games.Kills(game.get('kills'))
        game.set 'hits',    new games.Hits(game.get('hits'))
        game.set 'players', new games.Players(game.get('players'))

    afterEach ->
        game = null

    it "should return correct values", ->
        expect(game.playersHurtRate).toBeDefined()

        correctValues =
            maikudou: 28
            nim579: 50
            kuteev: 42
            emuravjev: 27

        testValues = game.playersHurtRate()

        for player, value of correctValues
            expect(testValues[player]).toBe(value)


describe "Game.playersKillRate", ->
    game = null
    
    beforeEach ->
        game = new games.Game(testData_cod4)
        game.set 'items',   new games.Items(game.get('items'))
        game.set 'kills',   new games.Kills(game.get('kills'))
        game.set 'hits',    new games.Hits(game.get('hits'))
        game.set 'players', new games.Players(game.get('players'))

    afterEach ->
        game = null

    it "should return correct values", ->
        expect(game.playersKillRate).toBeDefined()

        correctValues =
            maikudou: 7
            nim579: 10
            kuteev: 3
            emuravjev: 13

        testValues = game.playersKillRate()

        for player, value of correctValues
            expect(testValues[player]).toBe(value)

describe "Game.playerKillVictimRate", ->
    game = null
    
    beforeEach ->
        game = new games.Game(testData_cod4)
        game.set 'items',   new games.Items(game.get('items'))
        game.set 'kills',   new games.Kills(game.get('kills'))
        game.set 'hits',    new games.Hits(game.get('hits'))
        game.set 'players', new games.Players(game.get('players'))

    afterEach ->
        game = null

    it "should return correct values", ->
        expect(game.playerKillVictimRate).toBeDefined()

        correctValues =
            nim579: 7
            kuteev: 6

        testValues = game.playerKillVictimRate(3)

        for player, value of correctValues
            expect(testValues[player]).toBe(value)


describe "Game.playersDeathRate", ->
    game = null
    
    beforeEach ->
        game = new games.Game(testData_cod4)
        game.set 'items',   new games.Items(game.get('items'))
        game.set 'kills',   new games.Kills(game.get('kills'))
        game.set 'hits',    new games.Hits(game.get('hits'))
        game.set 'players', new games.Players(game.get('players'))

    afterEach ->
        game = null

    it "should return correct values", ->
        expect(game.playersDeathRate).toBeDefined()

        correctValues =
            maikudou: 5
            nim579: 9
            kuteev: 11
            emuravjev: 8

        testValues = game.playersDeathRate()

        for player, value of correctValues
            expect(testValues[player]).toBe(value)


describe "Game.playerDeathKillerRate", ->
    game = null
    
    beforeEach ->
        game = new games.Game(testData_cod4)
        game.set 'items',   new games.Items(game.get('items'))
        game.set 'kills',   new games.Kills(game.get('kills'))
        game.set 'hits',    new games.Hits(game.get('hits'))
        game.set 'players', new games.Players(game.get('players'))

    afterEach ->
        game = null

    it "should return correct values", ->
        expect(game.playerKillVictimRate).toBeDefined()

        correctValues =
            maikudou: 2
            emuravjev: 7

        testValues = game.playerKillVictimRate(1)

        for player, value of correctValues
            expect(testValues[player]).toBe(value)


describe "Game.playersItemGetRate", ->
    game = null
    
    beforeEach ->
        game = new games.Game(testData_cod4)
        game.set 'items',   new games.Items(game.get('items'))
        game.set 'kills',   new games.Kills(game.get('kills'))
        game.set 'hits',    new games.Hits(game.get('hits'))
        game.set 'players', new games.Players(game.get('players'))

    afterEach ->
        game = null

    it "should return correct values", ->
        expect(game.playersItemGetRate).toBeDefined()

        correctValues =
            maikudou: 2
            nim579: 38
            emuravjev: 6

        testValues = game.playersItemGetRate()

        for player, value of correctValues
            expect(testValues[player]).toBe(value)

describe "Game.playerItemTypeGetRate", ->
    game = null
    
    beforeEach ->
        game = new games.Game(testData_cod4)
        game.set 'items',   new games.Items(game.get('items'))
        game.set 'kills',   new games.Kills(game.get('kills'))
        game.set 'hits',    new games.Hits(game.get('hits'))
        game.set 'players', new games.Players(game.get('players'))

    afterEach ->
        game = null

    it "should return correct values", ->
        expect(game.playerItemTypeGetRate).toBeDefined()

        correctValues =
            weapon: 38

        testValues = game.playerItemTypeGetRate(1)

        for type, value of correctValues
            expect(testValues[type]).toBe(value)


describe "Game.playerItemNameGetRate", ->
    game = null
    
    beforeEach ->
        game = new games.Game(testData_cod4)
        game.set 'items',   new games.Items(game.get('items'))
        game.set 'kills',   new games.Kills(game.get('kills'))
        game.set 'hits',    new games.Hits(game.get('hits'))
        game.set 'players', new games.Players(game.get('players'))

    afterEach ->
        game = null

    it "should return correct values", ->
        expect(game.playerItemNameGetRate).toBeDefined()

        correctValues =
            mp5_mp: 4
            usp_silencer_mp: 34

        testValues = game.playerItemNameGetRate(1)

        for item, value of correctValues
            expect(testValues[item]).toBe(value)

