actions = require '../actions'
{composeReducer, jsonClone} = require './utils'

# These responses.sword only contains swords within this party
pathsOnlyParty = [
  '/conquest/complete',
]

# These responses.sword only contains the target sword
pathsOnlyTarget = [
  '/equip/removeitem',
  '/equip/setitem',
  '/equip/removeequip',
  '/equip/setequip',
  '/composition/compose',
]

# These responses.sword contains object useless for us
pathsOther = [
  '/album/list',
]

getSword = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    {sword} = response
    if !(path in pathsOnlyParty) && 
       !(path in pathsOnlyTarget) &&
       !(path in pathsOther)
      return jsonClone sword
  state

updateSwordParty = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    {sword} = response
    if path in pathsOnlyParty
      state_copy = jsonClone state
      for serial_id, this_sword of sword
        if state_copy[serial_id]?
          state_copy[serial_id] = jsonClone this_sword
      return state_copy
  state

updateSwordTarget = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    {sword} = response
    if path in pathsOnlyTarget
      state_copy = jsonClone state
      state_copy[sword.serial_id] = jsonClone sword
      return state_copy
  state

forgeComplete = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    if path == '/forge/complete'
      state_copy = jsonClone state
      # Although we don't have detailed information yet..
      state_copy[response.serial_id] = _.pick response, 'serial_id', 'sword_id'
      return state_copy
  state

module.exports = composeReducer [
  getSword,
  updateSwordParty,
  updateSwordTarget,
  forgeComplete,
]
