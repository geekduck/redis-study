assert = require 'assert'
redis = require 'redis'
host = "192.168.59.103"
port = 6379
options =
  max_attempts: 2

redisClient = redis.createClient port, host, options
redisClient.on "ready", =>
  redisClient.info (err, info) =>
    return if err
    #console.dir info

    # set hello world => "OK"
    redisClient.set("hello", "world", (err, resp)=>
      console.log resp
      assert.strictEqual resp, "OK"
    )

    # get hello => "world"
    redisClient.get("hello", (err, resp)=>
      console.log resp
      assert.strictEqual resp, "world"
    )

    # del hello => "OK"
    redisClient.del("hello", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 1
    )

    # get hello => null
    redisClient.get("hello", (err, resp)=>
      console.log resp
      assert.strictEqual resp, null
    )

redisClient.on "error", (err) =>
  console.dir err
  process.exit 1
