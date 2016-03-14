actions = require '../actions'

onGameResponse = (state, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    if path.indexOf '/battle' != 0
      Object.assign {}, state, action.response

composeActionsFactory = (state, action) -> (reducers) ->
  for reducer in reducers
    newState = reducer(state, action)
    state = newState ?= state
  state

module.exports = (state, action) ->
  compose = composeActionsFactory state, action
  compose [
    onGameResponse
  ]
