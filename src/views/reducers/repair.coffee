actions = require '../actions'
{composeReducer, jsonClone} = require './utils'

getRepair = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    if response.repair?
      return jsonClone response.repair
  state

repairComplete = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    switch path
      when '/repair/fast', '/repair/complete'
        state_copy = jsonClone state
        try
          delete state_copy[response.slot_no]
        catch e
        return state_copy
  state

module.exports = composeReducer [
  getRepair,
  repairComplete,
]
