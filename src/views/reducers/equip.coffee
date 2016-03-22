actions = require '../actions'
{composeReducer, jsonClone} = require './utils'

# These responses.equip only contains the target equip
pathsOnlyTarget = [
  '/equip/removeequip',
  '/equip/setequip',
]

getEquip = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    {equip} = response
    if !(path in pathsOnlyTarget)
      return jsonClone equip
  state

updateEquipTarget = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    {equip} = response
    if path in pathsOnlyTarget
      state_copy = jsonClone state
      state_copy[equip.serial_id] = jsonClone equip
      return state_copy
  state

module.exports = composeReducer [
  getEquip,
  updateEquipTarget,
]
