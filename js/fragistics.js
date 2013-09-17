(function() {
  var backbone, commander, error, file, filename, fs, games, lazy, lazyStream, parser, parsers, path;

  fs = require('fs');

  path = require('path');

  lazy = require("lazy");

  backbone = require("backbone");

  commander = require('commander');

  commander.version(require('../package').version).option('-f, --file [name]', 'Logfile name').parse(process.argv);

  games = require('./games.js');

  parsers = require('./parsers.js');

  filename = commander.file;

  if (filename == null) {
    console.log('No logfile name given');
    return false;
  }

  console.log('Processing file "' + filename + '"');

  try {
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
      return fs.writeFile('tmp/' + path.basename(filename, path.extname(filename)) + '_parsed.json', JSON.stringify(parser.games.toJSON(), null, '  '), function(err) {
        if (err) {
          throw err;
        }
        return console.log('Parsed file saved in "' + 'tmp/' + path.basename(filename, path.extname(filename)) + '_parsed.json' + '"');
      });
    });
    lazyStream.lines.forEach(function(line) {
      var lineString;

      lineString = line.toString();
      parser.processLine(lineString);
      return true;
    });
  } catch (_error) {
    error = _error;
    console.log(error);
  }

}).call(this);
