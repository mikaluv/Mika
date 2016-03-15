composeReducer = (reducers) -> (state, action) -> 
  for reducer in reducers
    newState = reducer(state, action)
    state = newState ?= state
  state
