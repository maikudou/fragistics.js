(function() {
  var backbone, games;

  backbone = require("backbone");

  games = {};

  games.Game = backbone.Model.extend({
    defaults: {
      started: false
    },
    locationsHitRate: function() {
      var hit, locations, _i, _len, _ref;

      if (this.get('hits') == null) {
        return null;
      }
      locations = {};
      _ref = this.get('hits').models;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hit = _ref[_i];
        if (locations[hit.get('location')] != null) {
          locations[hit.get('location')]++;
        } else {
          if (hit.get('location') != null) {
            locations[hit.get('location')] = 0;
          }
        }
      }
      return locations;
    }
  });

  games.Games = backbone.Collection.extend({
    model: games.Game
  });

  games.Player = backbone.Model.extend({
    defaults: {
      name: 'unnamed'
    }
  });

  games.Players = backbone.Collection.extend({
    model: games.Player
  });

  games.Item = backbone.Model.extend({
    defaults: {
      type: null,
      name: null,
      player: null,
      timeOffset: null
    }
  });

  games.Items = backbone.Collection.extend({
    model: games.Item
  });

  games.Kill = backbone.Model.extend({
    defaults: {
      killer: null,
      victim: null,
      meansOfDeath: null,
      killerWeapon: null,
      victimWeapon: null,
      timeOffset: null
    }
  });

  games.Kills = backbone.Collection.extend({
    model: games.Kill
  });

  games.Hit = backbone.Model.extend({
    defaults: {
      attacker: null,
      defendant: null,
      weapon: null,
      location: null,
      timeOffset: null
    }
  });

  games.Hits = backbone.Collection.extend({
    model: games.Hit
  });

  module.exports = games;

}).call(this);
