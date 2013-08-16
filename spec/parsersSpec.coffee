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

    it "should instantiate a games collection on creation", ->
        expect(parser.games).toBeDefined()
        expect(parser.games instanceof games.Games).toBe(true)

    it "should mark started games", ->
        for line in testData_q3
            parser.processLine(line)

        expect(parser.games.length).toBe(3)
        expect(parser.games.where({started: true}).length).toBe(1)


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

    it "should instantiate a games collection on creation", ->
        expect(parser.games).toBeDefined()
        expect(parser.games instanceof games.Games).toBe(true)

