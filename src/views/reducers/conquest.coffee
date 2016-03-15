actions = require '../actions'

module.exports = updateConquest = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    state_copy = JSON.parse(JSON.stringify(state)); 
    if response.party != []
      for i in [2..4] when (party = response.party?[i])?
        state_copy[i] ?= {}
        state_copy[i].status = party.status
        state_copy[i].finish_at = party.finished_at
        state_copy[i].party_name = party.party_name
      return state_copy
    if path.indexOf '/conquest' == 0
      for i in [2..4] when (summary = response.summary)?
        state_copy[i].field_id = summary.field_id
      return state_copy
  state
