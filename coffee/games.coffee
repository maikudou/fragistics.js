backbone = require("backbone")

games = {}

#Generic game round entity
games.Game = backbone.Model.extend
    defaults:
        started: false

    locationsHitRate: ->
        return null unless @get('hits')?
        
        locations = {}

        for hit in @get('hits').models
            if locations[hit.get('location')]?
                locations[hit.get('location')]++
            else
                locations[hit.get('location')] = 1 if hit.get('location')? 

        return locations

    playersHitRate: ->
        return null unless @get('hits')?

        hits = {}

        for hit in @get('hits').models
            if hits[hit.get('attacker')]?
                hits[hit.get('attacker')]++
            else
                hits[hit.get('attacker')] = 1 if hit.get('attacker')? 

        return hits

    playersHurtRate: ->
        return null unless @get('hits')?

        hurts = {}

        for hit in @get('hits').models
            if hurts[hit.get('defendant')]?
                hurts[hit.get('defendant')]++
            else
                hurts[hit.get('defendant')] = 1 if hit.get('defendant')? 

        return hurts

    playersKillRate:->
        return null unless @get('kills')?

        deaths = {}

        for death in @get('kills').models
            if deaths[death.get('killer')]?
                deaths[death.get('killer')]++
            else
                deaths[death.get('killer')] = 1 if death.get('killer')? 

        return deaths

    playerKillVictimRate: (killer)->
        return null unless @get('kills')?

        deaths = {}

        for death in @get('kills').where({killer: killer})
            if deaths[death.get('victim')]?
                deaths[death.get('victim')]++
            else
                deaths[death.get('victim')] = 1 if death.get('victim')? 

        return deaths

    playersDeathRate: ->
        return null unless @get('kills')?

        deaths = {}

        for death in @get('kills').models
            if deaths[death.get('victim')]?
                deaths[death.get('victim')]++
            else
                deaths[death.get('victim')] = 1 if death.get('victim')? 

        return deaths

    playerDeathKillerRate: (victim)->
        return null unless @get('kills')?

        deaths = {}

        for death in @get('kills').where({victim: victim})
            if deaths[death.get('killer')]?
                deaths[death.get('killer')]++
            else
                deaths[death.get('killer')] = 1 if death.get('killer')? 

        return deaths

    playersItemGetRate: ->
        return null unless @get('items')?
        
        items = {}

        for item in @get('items').models
            if items[item.get('player')]?
                items[item.get('player')]++
            else
                items[item.get('player')] = 1 if item.get('player')? 

        return items

    playerItemTypeGetRate: (player)->
        return null unless @get('items')?

        items = {}

        for item in @get('items').where({player: player})
            if items[item.get('type')]?
                items[item.get('type')]++
            else
                items[item.get('type')] = 1 if item.get('type')? 

        return items

    playerItemNameGetRate: (player)->
        return null unless @get('items')?

        items = {}

        for item in @get('items').where({player: player})
            if items[item.get('name')]?
                items[item.get('name')]++
            else
                items[item.get('name')] = 1 if item.get('name')? 

        return items

games.Games = backbone.Collection.extend
    model: games.Game


#Generic player
games.Player = backbone.Model.extend
    defaults:
        name: 'unnamed'

games.Players = backbone.Collection.extend
    model: games.Player


#Generic obtainable game item event (i.e.: ammo, powerups, etc.)
games.Item = backbone.Model.extend
    defaults:
        type: null
        name: null
        player: null
        timeOffset: null

games.Items = backbone.Collection.extend
    model: games.Item


#Generic kill event
games.Kill = backbone.Model.extend
    defaults:
        killer: null
        victim: null
        meansOfDeath: null
        killerWeapon: null
        victimWeapon: null
        timeOffset: null

games.Kills = backbone.Collection.extend
    model: games.Kill


#Generic hit event
games.Hit = backbone.Model.extend
    defaults:
        attacker: null
        defendant: null
        weapon: null
        location: null
        timeOffset: null

games.Hits = backbone.Collection.extend
    model: games.Hit


module.exports = games