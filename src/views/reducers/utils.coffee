module.exports.jsonClone = (obj) ->
  try
    JSON.parse(JSON.stringify(obj))
  catch e
    obj

module.exports.composeReducer = (reducers) -> (state={}, action) -> 
  for reducer in reducers
    newState = reducer(state, action)
    state = newState ?= state
  state
