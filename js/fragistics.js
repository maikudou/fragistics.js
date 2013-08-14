(function() {
  var Client, Clients, Game, Games, Item, Items, Kill, Kills, backbone, file, fs, games, lazy, lazyStream, result;

  fs = require('fs');

  lazy = require("lazy");

  backbone = require("backbone");

  Game = backbone.Model.extend({
    defaults: {
      started: false
    }
  });

  Games = backbone.Collection.extend({
    model: Game
  });

  Client = backbone.Model.extend({
    defaults: {
      name: 'unnamed'
    }
  });

  Clients = backbone.Collection.extend({
    model: Client
  });

  Item = backbone.Model.extend({
    defaults: {
      type: null,
      name: null,
      client: null,
      offset: null
    }
  });

  Items = backbone.Collection.extend({
    model: Item
  });

  Kill = backbone.Model.extend({
    defaults: {
      killer: null,
      victim: null,
      meansOfDeath: null,
      killerWeapon: null,
      victimWeapon: null,
      offset: null
    }
  });

  Kills = backbone.Collection.extend({
    model: Kill
  });

  result = {};

  result.games = new Games();

  file = fs.createReadStream('testdata/games.log', {
    flags: 'r',
    encoding: null,
    fd: null,
    mode: '0666',
    bufferSize: 64 * 1024,
    autoClose: true
  });

  games = 0;

  lazyStream = new lazy(file);

  lazyStream.on('end', function() {
    return console.log(result.games.where({
      started: true
    }).length);
  });

  lazyStream.lines.forEach(function(line) {
    var clientId, currentGame, date, i, itemName, itemType, lineOffset, lineString, obj, paramName, prevIndex, searchResult, user, value, _i, _j, _len, _len1, _ref, _ref1;

    lineString = line.toString();
    lineOffset = Number(/^(\d+\.\d+) .+/.exec(lineString)[1]);
    if (lineString.indexOf('InitGame') > -1) {
      obj = {};
      if (searchResult = /InitGame: \\(.+)/.exec(lineString)) {
        _ref = searchResult[1].split('\\');
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          value = _ref[i];
          if (i % 2) {
            obj[paramName] = value;
          } else {
            paramName = value;
          }
        }
      }
      result.games.add(new Game(obj));
      result.games.last().set('items', new Items());
      result.games.last().set('kills', new Kills());
    }
    currentGame = result.games.last();
    if (currentGame != null) {
      if (lineString.indexOf('ServerTime') > -1) {
        date = /(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/.exec(lineString);
        currentGame.set({
          serverTime: new Date(date[1], Number(date[2]) - 1, date[3], date[4], date[5], date[6]),
          serverTimeOffset: lineOffset
        });
      }
      if (lineString.indexOf('Game_Start') > -1) {
        currentGame.set({
          started: true,
          startTimeOffset: lineOffset
        });
      }
      if (lineString.indexOf('ClientConnect') > -1) {
        if (searchResult = /ClientConnect: (\d+)/.exec(lineString)) {
          clientId = searchResult[1];
          if (!currentGame.get('clients')) {
            currentGame.set('clients', new Clients());
          }
          currentGame.get('clients').add({
            id: clientId,
            connectOffset: lineOffset
          });
        }
      }
      if (lineString.indexOf('ClientBegun') > -1) {
        if (searchResult = /ClientBegun: (\d+)/.exec(lineString)) {
          clientId = searchResult[1];
          if (user = currentGame.get('clients').get(searchResult[1])) {
            user.set({
              begun: true,
              begunOffset: lineOffset
            });
          }
        }
      }
      if (lineString.indexOf('ClientUserinfoChanged') > -1) {
        if (searchResult = /ClientUserinfoChanged: (\d+) (.+)/.exec(lineString)) {
          if (user = currentGame.get('clients').get(searchResult[1])) {
            obj = {};
            prevIndex = '';
            _ref1 = searchResult[2].split('\\');
            for (i = _j = 0, _len1 = _ref1.length; _j < _len1; i = ++_j) {
              value = _ref1[i];
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
          currentGame.get('items').add({
            client: searchResult[1],
            type: itemType,
            name: itemName,
            offset: lineOffset
          });
        }
      }
      if (lineString.indexOf('Kill:') > -1) {
        if (searchResult = /Kill: (\d+) (\d+) (\d+): .+ by (\w+) (\d+)/.exec(lineString)) {
          currentGame.get('kills').add({
            killer: searchResult[1],
            victim: searchResult[2],
            meansOfDeath: searchResult[3],
            killerWeapon: searchResult[4],
            victimWeapon: searchResult[5]
          });
        }
      }
    }
    return true;
  });

}).call(this);
