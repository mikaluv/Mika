actions = require '../actions'

module.exports = refreshTick = (state=Date.now(), action) ->
  if action.type == actions.ON_TIME_TICK
    return Date.now()
  state
