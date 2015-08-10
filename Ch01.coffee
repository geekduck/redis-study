assert = require 'assert'
redis = require 'redis'
host = "192.168.0.111"
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

    # rpush list-key item => 1
    redisClient.rpush("list-key", "item", (err, resp)=>
      console.log resp
      assert.strictEqual typeof resp, "number"
    )

    # rpush list-key item2 => 2
    redisClient.rpush("list-key", "item", (err, resp)=>
      console.log resp
      assert.strictEqual typeof resp, "number"
    )

    # rpush list-key item => 3
    redisClient.rpush("list-key", "item", (err, resp)=>
      console.log resp
      assert.strictEqual typeof resp, "number"
    )

    # lrange list-key 0 -1 => array
    redisClient.lrange("list-key", 0, -1, (err, resp)=>
      console.log resp
      assert.strictEqual getType(resp), "Array"
    )

    # lindex list-key 1 => item
    redisClient.lindex("list-key", 1, (err, resp)=>
      console.log resp
      assert.strictEqual resp, "item"
    )

    # lpop list-key => item
    redisClient.lpop("list-key", (err, resp)=>
      console.log resp
      assert.strictEqual resp, "item"
    )

    # del list-key => "OK"
    redisClient.del("list-key", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 1
    )

    # sadd set-key item => 1
    redisClient.sadd("set-key", "item", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 1
    )

    # sadd set-key item2 => 2
    redisClient.sadd("set-key", "item2", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 1
    )

    # sadd set-key item3 => 3
    redisClient.sadd("set-key", "item3", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 1
    )

    # sadd set-key item => 3
    redisClient.sadd("set-key", "item", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 0
    )

    # smembers set-key =>
    redisClient.smembers("set-key", (err, resp)=>
      console.log resp
      assert.strictEqual getType(resp), "Array"
    )

    # sismember set-key item4 =>
    redisClient.sismember("set-key", "item4", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 0
    )

    # sismember set-key item =>
    redisClient.sismember("set-key", "item", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 1
    )

    # srem set-key item2 =>
    redisClient.srem("set-key", "item2", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 1
    )

    # srem set-key item2 =>
    redisClient.srem("set-key", "item2", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 0
    )

    # smembers set-key =>
    redisClient.smembers("set-key", (err, resp)=>
      console.log resp
      assert.strictEqual getType(resp), "Array"
    )

    # del set-key => 1
    redisClient.del("set-key", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 1
    )

    # hset hash-key sub-key1 value1 =>
    redisClient.hset("hash-key", "sub-key1", "value1", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 1
    )

    # hset hash-key sub-key2 value2 =>
    redisClient.hset("hash-key", "sub-key2", "value2", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 1
    )

    # hset hash-key sub-key1 value1 =>
    redisClient.hset("hash-key", "sub-key1", "value1", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 0
    )

    # hgetall hash-key =>
    redisClient.hgetall("hash-key", (err, resp)=>
      console.log resp
      assert.strictEqual resp["sub-key1"], "value1"
      assert.strictEqual resp["sub-key2"], "value2"
    )

    # hdel hash-key sub-key2 =>
    redisClient.hdel("hash-key", "sub-key2", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 1
    )

    # hdel hash-key sub-key2 =>
    redisClient.hdel("hash-key", "sub-key2", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 0
    )

    # hgetall hash-key =>
    redisClient.hgetall("hash-key", (err, resp)=>
      console.log resp
      assert.strictEqual resp["sub-key1"], "value1"
      assert.strictEqual resp["sub-key2"], undefined
    )

    # del set-key => 1
    redisClient.del("hash-key", (err, resp)=>
      console.log resp
      assert.strictEqual resp, 1
    )

redisClient.on "error", (err) =>
  console.dir err
  process.exit 1

getType = (obj) ->
  Object::toString.call(obj).slice 8, -1