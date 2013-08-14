(function() {
  var fs, games, parsers, _ref, _ref1,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  fs = require('fs');

  parsers = {};

  games = require('./games.js');

  /*
  Prototype
  */


  parsers.createParser = function(file) {
    var buffer;

    file = fs.openSync(file, 'r');
    buffer = new Buffer(6);
    fs.readSync(file, buffer, 0, 6, 0);
    fs.closeSync(file);
    if (/^\d+\.\d+ \-/.exec(buffer.toString())) {
      return new parsers.Q3Parser();
    }
    if (/^\s+\d+\:\d+/.exec(buffer.toString())) {
      return new parsers.COD4Parser();
    }
    throw new Error('Unknown file format');
  };

  parsers.Parser = (function() {
    function Parser() {
      this.games = new games.Games();
      return this;
    }

    Parser.prototype.createGame = function(params) {};

    Parser.prototype.processLine = function(lineString) {};

    Parser.prototype.name = 'Generic Parser';

    return Parser;

  })();

  /*
  Quake III Arena (OSP)
  */


  parsers.Q3Parser = (function(_super) {
    __extends(Q3Parser, _super);

    function Q3Parser() {
      _ref = Q3Parser.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Q3Parser.prototype.name = 'Q3 OSP Parser';

    Q3Parser.prototype.processLine = function(lineString) {
      var clientId, date, i, itemName, itemType, lineOffset, obj, paramName, prevIndex, searchResult, user, value, _i, _j, _len, _len1, _ref1, _ref2;

      lineOffset = Number(/^(\d+\.\d+) .+/.exec(lineString)[1]);
      if (lineString.indexOf('InitGame') > -1) {
        obj = {};
        if (searchResult = /InitGame: \\(.+)/.exec(lineString)) {
          _ref1 = searchResult[1].split('\\');
          for (i = _i = 0, _len = _ref1.length; _i < _len; i = ++_i) {
            value = _ref1[i];
            if (i % 2) {
              obj[paramName] = value;
            } else {
              paramName = value;
            }
          }
        }
        this.createGame(obj);
      }
      this.currentGame = this.games.last();
      if (this.currentGame != null) {
        if (lineString.indexOf('ServerTime') > -1) {
          date = /(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/.exec(lineString);
          this.currentGame.set({
            serverTime: new Date(date[1], Number(date[2]) - 1, date[3], date[4], date[5], date[6]),
            serverTimeOffset: lineOffset
          });
        }
        if (lineString.indexOf('Game_Start') > -1) {
          this.currentGame.set({
            started: true,
            startTimeOffset: lineOffset
          });
        }
        if (lineString.indexOf('ClientConnect') > -1) {
          if (searchResult = /ClientConnect: (\d+)/.exec(lineString)) {
            clientId = searchResult[1];
            if (!this.currentGame.get('players')) {
              this.currentGame.set('players', new games.Players());
            }
            this.currentGame.get('players').add({
              id: clientId,
              connectOffset: lineOffset
            });
          }
        }
        if (lineString.indexOf('ClientBegun') > -1) {
          if (searchResult = /ClientBegun: (\d+)/.exec(lineString)) {
            clientId = searchResult[1];
            if (user = this.currentGame.get('players').get(searchResult[1])) {
              user.set({
                begun: true,
                begunOffset: lineOffset
              });
            }
          }
        }
        if (lineString.indexOf('ClientUserinfoChanged') > -1) {
          if (searchResult = /ClientUserinfoChanged: (\d+) (.+)/.exec(lineString)) {
            if (user = this.currentGame.get('players').get(searchResult[1])) {
              obj = {};
              prevIndex = '';
              _ref2 = searchResult[2].split('\\');
              for (i = _j = 0, _len1 = _ref2.length; _j < _len1; i = ++_j) {
                value = _ref2[i];
                if (i % 2) {
                  obj[prevIndex] = value;
                } else {
                  if (value === 'n') {
                    prevIndex = 'name';
                  } else {
                    prevIndex = value;
                  }
                }
              }
              user.set(obj);
            }
          }
        }
        if (lineString.indexOf('Item:') > -1) {
          if (searchResult = /Item: (\d+) ([A-Za-z]+)_([A-Za-z]+)(?:_([A-Za-z]+))?/.exec(lineString)) {
            if (searchResult[2] === 'item') {
              itemType = searchResult[3];
              itemName = searchResult[4];
            } else {
              itemType = searchResult[2];
              itemName = searchResult[3];
            }
            this.currentGame.get('items').add({
              player: Number(searchResult[1]),
              type: itemType,
              name: itemName,
              timeOffset: lineOffset
            });
          }
        }
        if (lineString.indexOf('Kill:') > -1) {
          if (searchResult = /Kill: (\d+) (\d+) (\d+): .+ by (\w+) (\d+)/.exec(lineString)) {
            return this.currentGame.get('kills').add({
              killer: Number(searchResult[1]),
              victim: Number(searchResult[2]),
              meansOfDeath: searchResult[3],
              killerWeapon: searchResult[4],
              victimWeapon: searchResult[5],
              timeOffset: lineOffset
            });
          }
        }
      }
    };

    Q3Parser.prototype.createGame = function(params) {
      this.games.add(new games.Game(params));
      this.games.last().set('items', new games.Items());
      return this.games.last().set('kills', new games.Kills());
    };

    return Q3Parser;

  })(parsers.Parser);

  /*
  Call of Duty 4: Modern Warfare
  */


  parsers.COD4Parser = (function(_super) {
    __extends(COD4Parser, _super);

    function COD4Parser() {
      _ref1 = COD4Parser.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    COD4Parser.prototype.name = 'CoD 4 Parser';

    COD4Parser.prototype.processLine = function(lineString) {
      var eventType, i, lineOffset, obj, paramName, searchResult, timeTry, value, _i, _len, _ref2;

      timeTry = /^\s+(\d+)\:(\d+) .+/.exec(lineString);
      if (!timeTry) {
        return false;
      }
      lineOffset = Number(timeTry[1]) * 60 + Number(timeTry[2]);
      if (lineString.indexOf('InitGame') > -1) {
        obj = {};
        if (searchResult = /InitGame: \\(.+)/.exec(lineString)) {
          _ref2 = searchResult[1].split('\\');
          for (i = _i = 0, _len = _ref2.length; _i < _len; i = ++_i) {
            value = _ref2[i];
            if (i % 2) {
              obj[paramName] = value;
            } else {
              paramName = value;
            }
          }
        }
        this.createGame(obj);
      }
      this.currentGame = this.games.last();
      if (searchResult = /J;(.*);(\d+);(.*)/.exec(lineString)) {
        if (!this.currentGame.get('players')) {
          this.currentGame.set('players', new games.Players());
        }
        this.currentGame.get('players').add({
          id: searchResult[2],
          connectOffset: lineOffset,
          name: searchResult[3],
          hash: searchResult[1]
        });
      }
      if (searchResult = /(K|D);(.*);(\d+);(.*);(.*);(.*);(\d+);(.*);(.*);(.*);(\d+);(.*);(.*)/.exec(lineString)) {
        eventType = searchResult[0];
        this.currentGame.get('hits').add({
          attacker: Number(searchResult[3]),
          defendant: Number(searchResult[7]),
          weapon: searchResult[10],
          hitpoints: searchResult[11],
          medium: searchResult[12],
          location: searchResult[13] !== 'none' ? searchResult[13] : null,
          timeOffset: lineOffset
        });
        if (eventType = 'K') {
          this.currentGame.get('kills').add({
            killer: Number(searchResult[3]),
            victim: Number(searchResult[7]),
            meansOfDeath: searchResult[12],
            killerWeapon: searchResult[10],
            victimWeapon: null,
            timeOffset: lineOffset
          });
        }
      }
      if (searchResult = /Weapon;(.*);(\d+);(.*);(.*)/.exec(lineString)) {
        return this.currentGame.get('items').add({
          player: Number(searchResult[2]),
          type: 'weapon',
          name: searchResult[4],
          timeOffset: lineOffset
        });
      }
    };

    COD4Parser.prototype.createGame = function(params) {
      this.games.add(new games.Game(params));
      return this.games.last().set({
        started: true,
        items: new games.Items(),
        kills: new games.Kills(),
        hits: new games.Hits()
      });
    };

    return COD4Parser;

  })(parsers.Parser);

  module.exports = parsers;

}).call(this);
