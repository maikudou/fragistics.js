(function() {
  var backbone, file, filename, fs, games, lazy, lazyStream, parser, parsers, path;

  fs = require('fs');

  path = require('path');

  lazy = require("lazy");

  backbone = require("backbone");

  games = require('./games.js');

  parsers = require('./parsers.js');

  filename = 'testdata/cod4.log';

  console.log('Processing file "' + filename + '"');

  parser = new parsers.createParser(filename);

  console.log("Parser found - " + parser.name + ", parsing...");

  file = fs.createReadStream(filename, {
    flags: 'r',
    encoding: null,
    fd: null,
    mode: '0666',
    bufferSize: 64 * 1024,
    autoClose: true
  });

  lazyStream = new lazy(file);

  lazyStream.on('end', function() {
    console.log("" + parser.name + " - Games: " + parser.games.length + "    Started: " + (parser.games.where({
      started: true
    }).length));
    if (!fs.existsSync('tmp')) {
      fs.mkdirSync('tmp');
    }
    fs.writeFile('tmp/' + path.basename(filename, path.extname(filename)) + '_parsed.json', JSON.stringify(parser.games.toJSON(), null, '  '), function(err) {
      if (err) {
        throw err;
      }
      return console.log('Parsed file saved in "' + 'tmp/' + path.basename(filename, path.extname(filename)) + '_parsed.json' + '"');
    });
    if (parser.locationsHitRate != null) {
      return console.log(parser.locationsHitRate());
    }
  });

  lazyStream.lines.forEach(function(line) {
    var lineString;

    lineString = line.toString();
    parser.processLine(lineString);
    return true;
  });

}).call(this);
