actions = require '../actions'
{composeReducer, jsonClone} = require './utils'

getSword = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    {sword} = response
    # Reason for this exception: See updateSword
    if path != '/conquest/complete'
      return jsonClone sword
  state

updateSword = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    {sword} = response
    # This response only contains swords within this party
    if path == '/conquest/complete'
      state_copy = jsonClone state
      for serial_id, this_sword of sword
        if state_copy[serial_id]?
          state_copy[serial_id] = jsonClone this_sword
      return state_copy
  state

forgeComplete = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    if path == '/forge/complete'
      state_copy = jsonClone state
      state_copy[response.serial_id] = _.pick response, 'serial_id', 'sword_id'
      return state_copy
  state

module.exports = composeReducer [
  getSword,
  updateSword,
  forgeComplete,
]
