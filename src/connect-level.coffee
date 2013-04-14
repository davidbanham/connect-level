levelup = require 'levelup'
path = require 'path'

isExpired = (data) ->
  now = new Date().getTime()
  return true if data.expires < now
  return false

module.exports = (connect) ->
  class LevelStore extends connect.session.Store
    constructor: (@options = {}) ->
      __parentDir = path.dirname module.parent.filename
      @options.path ?= path.join (path.dirname module.parent.filename), 'connect-level-sessionstore'
      @options.interval ?= 3600000 # 1 hour
    
      @db = levelup @options.path
      
      setInterval =>
        @db.createReadStream()
          .on 'data', (data) =>
            @db.del data.key if isExpired JSON.parse data.value
      , @options.interval

      @db.on 'ready', () =>
        @emit 'ready'
    
    get: (sid, cb) ->
      @db.get sid, (err, data) ->
        return cb() if err?.name == "NotFoundError"
        return cb err if err?
        try
          parsed = JSON.parse data
        catch err
          return cb err
        return cb() if isExpired parsed
        return cb null, parsed.sess
      
    set: (sid, sess, cb) ->
      expires = new Date().getTime() + sess.cookie.maxAge if sess.cookie.maxAge?
      expires = sess.cookie.expires if sess.cookie.expires?
      @db.put sid, JSON.stringify({expires: expires, sess: sess}), (err, data) ->
        return cb err
    
    destroy: (sid, cb) ->
      @db.del sid, (err) ->
        return cb err
    
    teardown: (path, cb) ->
      @db.close () ->
        levelup.destroy path, (err) ->
          return cb err
