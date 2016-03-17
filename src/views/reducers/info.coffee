actions = require '../actions'
{composeReducer, jsonClone} = require './utils'

module.exports = mergeInfo = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    if path.indexOf '/battle' != 0
      return Object.assign {}, state, jsonClone(response)
  state

