(function() {
  var backbone, players, _;

  backbone = require("backbone");

  _ = require("underscore");

  players = {};

  players.Player = backbone.Model.extend({
    defaults: {
      name: 'unnamed',
      joinedGame: false
    },
    initialize: function() {
      return this.set('weaponStats', new players.WeaponStats());
    },
    getStats: function() {
      var returnObject;

      return returnObject = {
        damageGiven: this.get('damageGiven'),
        damageRecieved: this.get('damageRecieved'),
        armorTaken: this.get('armorTaken'),
        healthTaken: this.get('healthTaken')
      };
    },
    getWeaponStats: function(weapon) {
      var returnObject, _i, _len, _ref;

      if (weapon != null) {
        weapon = this.get('weaponStats').where({
          weapon: weapon
        });
        if (weapon.length === 0) {
          return null;
        }
        returnObject = {
          shots: weapon[0].get('shots'),
          hits: weapon[0].get('hits'),
          pickups: weapon[0].get('pickups'),
          drops: weapon[0].get('drops')
        };
      } else {
        returnObject = {};
        _ref = this.get('weaponStats').models;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          weapon = _ref[_i];
          returnObject[weapon.get('weapon')] = {
            shots: weapon.get('shots'),
            hits: weapon.get('hits'),
            pickups: weapon.get('pickups'),
            drops: weapon.get('drops')
          };
        }
      }
      if (_.isEmpty(returnObject)) {
        return null;
      }
      return returnObject;
    }
  });

  players.Players = backbone.Collection.extend({
    model: players.Player
  });

  players.WeaponStat = backbone.Model.extend({
    defaults: {
      weapon: null,
      shots: null,
      hits: null,
      pickups: null,
      drops: null
    }
  });

  players.WeaponStats = backbone.Collection.extend({
    model: players.WeaponStat
  });

  module.exports = players;

}).call(this);
