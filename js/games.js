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
            locations[hit.get('location')] = 1;
          }
        }
      }
      return locations;
    },
    playersHitRate: function() {
      var hit, hits, _i, _len, _ref;

      if (this.get('hits') == null) {
        return null;
      }
      hits = {};
      _ref = this.get('hits').models;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hit = _ref[_i];
        if (hits[hit.get('attacker')] != null) {
          hits[hit.get('attacker')]++;
        } else {
          if (hit.get('attacker') != null) {
            hits[hit.get('attacker')] = 1;
          }
        }
      }
      return hits;
    },
    playersHurtRate: function() {
      var hit, hurts, _i, _len, _ref;

      if (this.get('hits') == null) {
        return null;
      }
      hurts = {};
      _ref = this.get('hits').models;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hit = _ref[_i];
        if (hurts[hit.get('defendant')] != null) {
          hurts[hit.get('defendant')]++;
        } else {
          if (hit.get('defendant') != null) {
            hurts[hit.get('defendant')] = 1;
          }
        }
      }
      return hurts;
    },
    playersKillRate: function() {
      var death, deaths, _i, _len, _ref;

      if (this.get('kills') == null) {
        return null;
      }
      deaths = {};
      _ref = this.get('kills').models;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        death = _ref[_i];
        if (deaths[death.get('killer')] != null) {
          deaths[death.get('killer')]++;
        } else {
          if (death.get('killer') != null) {
            deaths[death.get('killer')] = 1;
          }
        }
      }
      return deaths;
    },
    playerKillVictimRate: function(killer) {
      var death, deaths, _i, _len, _ref;

      if (this.get('kills') == null) {
        return null;
      }
      deaths = {};
      _ref = this.get('kills').where({
        killer: killer
      });
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        death = _ref[_i];
        if (deaths[death.get('victim')] != null) {
          deaths[death.get('victim')]++;
        } else {
          if (death.get('victim') != null) {
            deaths[death.get('victim')] = 1;
          }
        }
      }
      return deaths;
    },
    playersDeathRate: function() {
      var death, deaths, _i, _len, _ref;

      if (this.get('kills') == null) {
        return null;
      }
      deaths = {};
      _ref = this.get('kills').models;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        death = _ref[_i];
        if (deaths[death.get('victim')] != null) {
          deaths[death.get('victim')]++;
        } else {
          if (death.get('victim') != null) {
            deaths[death.get('victim')] = 1;
          }
        }
      }
      return deaths;
    },
    playerDeathKillerRate: function(victim) {
      var death, deaths, _i, _len, _ref;

      if (this.get('kills') == null) {
        return null;
      }
      deaths = {};
      _ref = this.get('kills').where({
        victim: victim
      });
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        death = _ref[_i];
        if (deaths[death.get('killer')] != null) {
          deaths[death.get('killer')]++;
        } else {
          if (death.get('killer') != null) {
            deaths[death.get('killer')] = 1;
          }
        }
      }
      return deaths;
    },
    playersItemGetRate: function() {
      var item, items, _i, _len, _ref;

      if (this.get('items') == null) {
        return null;
      }
      items = {};
      _ref = this.get('items').models;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if (items[item.get('player')] != null) {
          items[item.get('player')]++;
        } else {
          if (item.get('player') != null) {
            items[item.get('player')] = 1;
          }
        }
      }
      return items;
    },
    playerItemTypeGetRate: function(player) {
      var item, items, _i, _len, _ref;

      if (this.get('items') == null) {
        return null;
      }
      items = {};
      _ref = this.get('items').where({
        player: player
      });
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if (items[item.get('type')] != null) {
          items[item.get('type')]++;
        } else {
          if (item.get('type') != null) {
            items[item.get('type')] = 1;
          }
        }
      }
      return items;
    },
    playerItemNameGetRate: function(player) {
      var item, items, _i, _len, _ref;

      if (this.get('items') == null) {
        return null;
      }
      items = {};
      _ref = this.get('items').where({
        player: player
      });
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if (items[item.get('name')] != null) {
          items[item.get('name')]++;
        } else {
          if (item.get('name') != null) {
            items[item.get('name')] = 1;
          }
        }
      }
      return items;
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
