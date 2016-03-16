{combineReducers} = require 'redux'

module.exports = combineReducers
  tick: require './tick'
  repair: require './repair'
  info: require './info'
  conquest: require './conquest'
