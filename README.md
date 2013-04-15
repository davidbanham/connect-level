# Connect-level

Connect level is a Connect session store backed by [levelup](https://github.com/rvagg/node-levelup). It aims to be a simple to use as MemoryStore while providing session persistence beyond the life of the process.

This store requires no external processes, databases, etc.

## Installation
	$ npm install connect-level

## Usage
    var connect = require('connect')
    , LevelStore = require('connect-level')(connect)

    connect().use(connect.session({ store: new LevelStore(), secret: 'super sekkrit' }))

## Options
There are options you can pass to the store if you like, but you don't need to.

    var options = {
      path: './data/sessions' // Optional. Defaults to ./connect-level-sessionstore
      interval: 6000 // Optional. How often the database prunes expired sessions in ms. Defaults to 1 hour, however expiry is checked as keys are read out.

    connect().use(connect.session({ store: new LevelStore(options), secret: 'super sekkrit' }))

[![Build Status](https://travis-ci.org/davidbanham/connect-level.png?branch=master)](https://travis-ci.org/davidbanham/connect-level)

## License
Licensed under [BSD](LICENSE.md)
