fs       = require('fs')
path     = require('path')
lazy     = require("lazy")
backbone = require("backbone")

games    = require('./games.js')
parsers  = require('./parsers.js')

filename = 'testdata/cod4.log'

console.log('Processing file "'+filename+'"');

parser = new parsers.createParser(filename)

console.log("Parser found - #{parser.name}, parsing...");

file = fs.createReadStream filename, 
    flags: 'r'
    encoding: null
    fd: null
    mode: '0666'
    bufferSize: 64 * 1024
    autoClose: true

lazyStream = new lazy(file);

lazyStream.on 'end', ->
    console.log("#{parser.name} - Games: #{parser.games.length}    Started: #{parser.games.where({started: true}).length}")

    fs.mkdirSync('tmp') unless fs.existsSync('tmp')

    fs.writeFile 'tmp/'+path.basename(filename, path.extname(filename))+'_parsed.json', JSON.stringify(parser.games.toJSON(), null, '  '), (err)->
        throw err if err
        console.log('Parsed file saved in "'+'tmp/'+path.basename(filename, path.extname(filename))+'_parsed.json'+'"');

lazyStream.lines
.forEach (line)->
    lineString = line.toString()

    parser.processLine(lineString)

    return true

    
