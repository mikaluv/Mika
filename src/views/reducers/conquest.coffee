actions = require '../actions'
{composeReducer, jsonClone} = require './utils'

updateParty = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    if response.party != []
      state_copy = jsonClone state
      for i in [2..4] when (party = response.party?[i])?
        state_copy[i] ?= {}
        state_copy[i].status = party.status
        state_copy[i].finish_at = party.finished_at
        state_copy[i].party_name = party.party_name
      return state_copy
  state

updateFieldId = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    if path.indexOf('/conquest') == 0
      state_copy = jsonClone state 
      for i in [2..4] when (summary = response.summary?[i])?
        state_copy[i] ?= {}
        state_copy[i].field_id = summary.field_id
      return state_copy
  state

module.exports = composeReducer [
  updateParty,
  updateFieldId,
]
