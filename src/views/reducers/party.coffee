actions = require '../actions'
{composeReducer, jsonClone} = require './utils'

getParty = (state={}, action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    {party} = response
    # /home returns response.party === [], while normally it's an object
    if party? && !Array.isArray(party)
      return party
  state

module.exports = composeReducer [
  getParty,
]
