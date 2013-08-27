games           = require('../js/games.js')
players         = require('../js/players.js')

testData_cod4   = require('../testdata/gamesSpec_cod4.json')[0]
testData_q3     = require('../testdata/q3_lines.json')[0]


describe "Player", ->
    player = null
    
    beforeEach ->
        player = new players.Player()

    afterEach ->
        player = null

    it "has 'getStats' method", ->
        expect(player.getStats).toBeDefined()

    it "has 'getWeaponStats' method", ->
        expect(player.getWeaponStats).toBeDefined()

    it "has 'weaponStats' argument", ->
        expect(player.get('weaponStats')).toBeDefined()
        expect(player.get('weaponStats') instanceof players.WeaponStats).toBe(true)


describe "Player.getStats", ->
    player = null
    
    beforeEach ->
        player = new players.Player()

    afterEach ->
        player = null

    it "should return correct values", ->
        player.set
            damageGiven:    111
            damageRecieved: 222
            armorTaken:     333
            healthTaken:    444

        expect(player.getStats()).toEqual
            damageGiven:    111
            damageRecieved: 222
            armorTaken:     333
            healthTaken:    444

describe "Player.getWeaponStats", ->
    player = null
    
    beforeEach ->
        player = new players.Player()

    afterEach ->
        player = null

    it "should return all data if no weapon argument supplied", ->
        expect(player.getWeaponStats()).toBe(null)

        player.get('weaponStats').add
            weapon:     'WeaponName1'
            shots:      10
            hits:       20
            pickups:    30
            drops:      40

        expect(player.getWeaponStats()).toEqual
            WeaponName1:
                shots:      10
                hits:       20
                pickups:    30
                drops:      40

        player.get('weaponStats').add
            weapon:     'WeaponName2'
            shots:      101
            hits:       202
            pickups:    303
            drops:      404

        expect(player.getWeaponStats()).toEqual
            WeaponName1:
                shots:      10
                hits:       20
                pickups:    30
                drops:      40
            WeaponName2:
                shots:      101
                hits:       202
                pickups:    303
                drops:      404


    it "should return 'null' if no weapon was found", ->
        checker = ->
            player.getWeaponStats('WeaponName1')
        
        expect(checker).not.toThrow();
        expect(player.getWeaponStats('WeaponName1')).toBe(null)

        player.get('weaponStats').add
            weapon:     'WeaponName2'
            shots:      101
            hits:       202
            pickups:    303
            drops:      404

        expect(player.getWeaponStats('WeaponName1')).toBe(null)

    it "should return correct values", ->
        player.get('weaponStats').add
            weapon:     'WeaponName1'
            shots:      10
            hits:       20
            pickups:    30
            drops:      40
        player.get('weaponStats').add
            weapon:     'WeaponName2'
            shots:      101
            hits:       202
            pickups:    303
            drops:      404

        expect(player.getWeaponStats('WeaponName1')).toEqual
            shots:      10
            hits:       20
            pickups:    30
            drops:      40

        expect(player.getWeaponStats('WeaponName2')).toEqual
            shots:      101
            hits:       202
            pickups:    303
            drops:      404


