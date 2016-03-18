actions = require '../actions'
{composeReducer, jsonClone} = require './utils'

getParty = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    {party} = response
    # /home returns response.party === [], while normally it's an object
    if party? && !Array.isArray(party)
      return jsonClone party
  state

updateParty = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    if path in ['/party/setsword', '/party/removesword']
      state_copy = {}
      for i in [1..4]
        state_copy[i] = response[i]
      return state_copy
  state

module.exports = composeReducer [
  getParty,
  updateParty,
]
