assert = require 'assert'
connect = require 'connect'
path = require 'path'
async = require 'async'
LevelStore = require('./')(connect)

dbPath = path.join __dirname, 'connect-level-test'

yay = (cb) ->
  cb null, "success"

store = new LevelStore {path: dbPath}
store.db.on 'ready', () ->
  async.series
    set: (callback) ->
      store.set '123', {cookie: {maxAge: 2000}, name: 'Dave'}, (err) ->
        assert.ok !err, "set got an error #{err}"
        yay callback
    get: (callback) ->
      store.get '123', (err, data) ->
        assert.ok !err, "get got an error #{err}"
        assert.deepEqual {cookie: {maxAge: 2000}, name: 'Dave'}, data
        yay callback
    getFail: (callback) ->
      store.get 'notfound', (err, data) ->
        assert.ok !err, "notfound got an error #{err}"
        assert.ok !data, "notfound returned data #{data}"
        yay callback
    setExpired: (callback) ->
      store.set 'exptest', {cookie: {maxAge: -1}, name: 'Dave'}, (err) ->
        assert.ok !err, "error setting expiring session #{err}"
        store.get 'exptest', (err, data) ->
          assert.ok !err, "timed out key got an error #{err}"
          assert.strictEqual data, undefined, "key didn't time out"
          yay callback
    teardown: (callback) ->
      store.teardown dbPath, (err) ->
        assert.ok !err, "Error tearing down db #{err}"
        yay callback
  , (err, results) ->
    console.log results
    process.exit()
