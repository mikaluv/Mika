
exports = {}

exports.ON_TIME_TICK = 'ON_TIME_TICK'
exports.onTimeTick = (store) ->
  () ->
    store.dispatch {
      type: exports.ON_TIME_TICK
    }

exports.ON_GAME_RESPONSE = 'ON_GAME_RESPONSE'
exports.onGameResponse = (store) ->
  (path, response, request) ->
    store.dispatch {
      type: exports.ON_GAME_RESPONSE
      path 
      response 
      request
    }

module.exports = exports
