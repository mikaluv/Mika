
exports = {}

exports.ON_GAME_RESPONSE = 'ON_GAME_RESPONSE'

exports.onGameResponseActionCreator = (store) ->
  (path, response, request) ->
    store.dispatch {
      type: exports.ON_GAME_RESPONSE
      path 
      response 
      request
    }
  
module.exports = exports
