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

    it "should return 'null' if no values", ->
        emptyGame = new games.Game()
        expect(emptyGame.locationsHitRate()).toBe(null)


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
            0: 23
            1: 41
            2: 13
            3: 70

        testValues = game.playersHitRate()

        for player, value of correctValues
            expect(testValues[player]).toBe(value)

    it "should return 'null' if no values", ->
        emptyGame = new games.Game()
        expect(emptyGame.playersHitRate()).toBe(null)

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
            0: 28
            1: 50
            2: 42
            3: 27

        testValues = game.playersHurtRate()

        for player, value of correctValues
            expect(testValues[player]).toBe(value)

    it "should return 'null' if no values", ->
        emptyGame = new games.Game()
        expect(emptyGame.playersHurtRate()).toBe(null)


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
            0: 7
            1: 10
            2: 3
            3: 13

        testValues = game.playersKillRate()

        for player, value of correctValues
            expect(testValues[player]).toBe(value)

    it "should return 'null' if no values", ->
        emptyGame = new games.Game()
        expect(emptyGame.playersKillRate()).toBe(null)

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
            1: 7
            2: 6

        testValues = game.playerKillVictimRate(3)

        for player, value of correctValues
            expect(testValues[player]).toBe(value)

    it "should return 'null' if no values", ->
        emptyGame = new games.Game()
        expect(emptyGame.playerKillVictimRate()).toBe(null)


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
            0: 5
            1: 9
            2: 11
            3: 8

        testValues = game.playersDeathRate()

        for player, value of correctValues
            expect(testValues[player]).toBe(value)

    it "should return 'null' if no values", ->
        emptyGame = new games.Game()
        expect(emptyGame.playersDeathRate()).toBe(null)


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
        expect(game.playerDeathKillerRate).toBeDefined()

        correctValues =
            0: 2
            3: 7

        testValues = game.playerDeathKillerRate(1)

        for player, value of correctValues
            expect(testValues[player]).toBe(value)

    it "should return 'null' if no values", ->
        emptyGame = new games.Game()
        expect(emptyGame.playerDeathKillerRate()).toBe(null)


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
            0: 2
            1: 38
            3: 6

        testValues = game.playersItemGetRate()

        for player, value of correctValues
            expect(testValues[player]).toBe(value)

    it "should return 'null' if no values", ->
        emptyGame = new games.Game()
        expect(emptyGame.playersItemGetRate()).toBe(null)


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

    it "should return 'null' if no values", ->
        emptyGame = new games.Game()
        expect(emptyGame.playerItemTypeGetRate()).toBe(null)


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

    it "should return 'null' if no values", ->
        emptyGame = new games.Game()
        expect(emptyGame.playerItemNameGetRate()).toBe(null)


