backbone = require("backbone")
_        = require("underscore")

players = {}

#Generic player
players.Player = backbone.Model.extend
    defaults:
        name: 'unnamed'
        joinedGame: false

    initialize: ->
        @set 'weaponStats', new players.WeaponStats()

    getStats: ->
        returnObject = 
            damageGiven:    @get('damageGiven')
            damageRecieved: @get('damageRecieved')
            armorTaken:     @get('armorTaken')
            healthTaken:    @get('healthTaken')

    getWeaponStats: (weapon)->
        if weapon?
            weapon = @get('weaponStats').where({weapon: weapon})

            if weapon.length == 0
                return null
            
            returnObject = 
                shots: weapon[0].get('shots')
                hits: weapon[0].get('hits')
                pickups: weapon[0].get('pickups')
                drops: weapon[0].get('drops')

        else
            returnObject = {}

            for weapon in @get('weaponStats').models
                returnObject[weapon.get('weapon')] =
                    shots: weapon.get('shots')
                    hits: weapon.get('hits')
                    pickups: weapon.get('pickups')
                    drops: weapon.get('drops')

        return null if _.isEmpty(returnObject) 

        return returnObject

players.Players = backbone.Collection.extend
    model: players.Player

players.WeaponStat = backbone.Model.extend
    defaults:
        weapon: null
        shots: null
        hits: null
        pickups: null
        drops: null

players.WeaponStats = backbone.Collection.extend
    model: players.WeaponStat

module.exports = players;