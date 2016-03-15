{combineReducers} = require 'redux'
actions = require '../actions'

mergeInfo = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    if path.indexOf '/battle' != 0
      return Object.assign {}, state, action.response
  state

refreshTick = (state=Date.now(), action) ->
  if action.type == actions.ON_TIME_TICK
    Date.now()
  state

composeActionsFactory = (state, action) -> (reducers) ->
  for reducer in reducers
    newState = reducer(state, action)
    state = newState ?= state
  state

module.exports = combineReducers
  tick: refreshTick
  info: mergeInfo
