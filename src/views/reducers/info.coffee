actions = require '../actions'

module.exports = mergeInfo = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    if path.indexOf '/battle' != 0
      return Object.assign {}, state, response
  state

