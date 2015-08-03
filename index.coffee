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
    exec()
redisClient.on "error", (err) =>
  console.dir err
  process.exit 1

exec = () =>
  args = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split(/\s+/)
  console.log args
  args.push (err, resp) =>
    if err
      console.dir err
      process.exit 1
    resp = JSON.stringify resp
    console.log resp
    process.exit 0
  method = args.shift()
  redisClient[method].apply redisClient, args
