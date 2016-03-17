actions = require '../actions'
{composeReducer, jsonClone} = require './utils'

getForge = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    if (forge = response.forge)?
      # We store resource consumption from /forge/start.res into state, which 
      # does not exist in /forge.res. So we can not directly return /forge.res
      state_copy = {}
      for i in [1..4]
        if forge[i]?
          state_copy[i] = Object.assign {}, state[i], forge[i]
      return state_copy
  state

forgeStart = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    if path == '/forge/start'
      state_copy = jsonClone state
      state_copy[response.slot_no] = Object.assign(
        _.pick response, 'slot_no', 'finished_at'
        _.pick request, 'use_assist', 'file', 'coolant', 'steel', 'charcoal')
      return state_copy
  state

forgeComplete = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    if path == '/forge/complete'
      state_copy = jsonClone state
      try
        delete state_copy[request.slot_no]
      catch e
      return state_copy
  state

module.exports = composeReducer [
  getForge,
  forgeStart,
  forgeComplete,
]
