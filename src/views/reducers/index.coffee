{combineReducers} = require 'redux'

module.exports = combineReducers
  tick: require './tick'
  info: require './info'
  conquest: require './conquest'
