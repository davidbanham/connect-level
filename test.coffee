assert = require 'assert'
connect = require 'connect'
path = require 'path'
LevelStore = require('./')(connect)

dbPath = path.join __dirname, 'connect-level-test'

describe 'LevelStore', ->
  store = ''
  before (done) ->
    store = new LevelStore {path: dbPath}
    store.on 'ready', done
  after (done) ->
    store.teardown dbPath, done

  describe '#set()', ->
    it "Shouldn't return an error when I set a key", (done) ->
      cookie =
        cookie:
          maxAge: 2000
        name: 'Dave'
      store.set '123', cookie, done
    it "Should expire the key properly", (done) ->
      store.set 'exptest', {cookie: {maxAge: -1}, name: 'Dave'}, (err) ->
        assert.ok !err, "error setting expiring session #{err}"
        store.get 'exptest', (err, data) ->
          assert.ok !err, "timed out key got an error #{err}"
          assert.strictEqual data, undefined, "key didn't time out"
          done()

  describe '#get()', ->
    it "Should correctly get the cookie it sets", (done) ->
      cookie =
        cookie:
          maxAge: 2000
        name: 'Dave'
      store.set '456', cookie, (err) ->
        return done err if err?
        store.get '123', (err, data) ->
          assert.ok !err, "get got an error #{err}"
          assert.deepEqual cookie, data
          done()
    it "Should fail appropriately on a non-existent key", (done) ->
      store.get 'notfound', (err, data) ->
        assert.ok !err, "notfound got an error #{err}"
        assert.ok !data, "notfound returned data #{data}"
        done()
