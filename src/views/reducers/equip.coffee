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
    if !(path in pathsOnlyTarget) && !Array.isArray(equip)
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

equipDestroy = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    {equip} = response
    if path == '/equip/destroy'
      state_copy = jsonClone state
      for serial_id in request.serial_ids.split ','
        try
          delete state_copy[serial_id]
        catch e
      return state_copy
  state

# One new equip
produceStart = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    if path == '/produce/start'
      {success, equip_id, serial_id} = response
      if success.toString == '1'
        state_copy = jsonClone state
        state_copy[serial_id] = {serial_id, equip_id}
        return state_copy
  state

# Ten new equip
produceContinue = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    if path == '/produce/continue'
      {equip} = response
      state_copy = jsonClone state
      for newEquip in equip
        state_copy[newEquip.serial_id] = newEquip
        return state_copy
  state

module.exports = composeReducer [
  getEquip,
  updateEquipTarget,
  equipDestroy,
  produceStart,
  produceContinue,
]
