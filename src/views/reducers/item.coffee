actions = require '../actions'
{composeReducer, jsonClone} = require './utils'

getItem = (state=[], action) ->
  if action.type == actions.ON_GAME_RESPONSE
    {path, response, request} = action
    {item, consumable} = response
    # /mission/reward returns .item:Array as the increment
    if item? && !Array.isArray(item)
      return item
    if consumable?
      return consumable
  state

module.exports = getItem
