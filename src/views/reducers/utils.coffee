module.exports.jsonClone = (obj) ->
  JSON.parse(JSON.stringify(obj))

module.exports.composeReducer = (reducers) -> (state={}, action) -> 
  for reducer in reducers
    newState = reducer(state, action)
    state = newState ?= state
  state
