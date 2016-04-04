{combineReducers} = require 'redux'

module.exports = combineReducers
  tick: require './tick'
  repair: require './repair'
  info: require './info'
  conquest: require './conquest'
  party: require './party'
  sword: require './sword'
  equip: require './equip'
  forge: require './forge'
  item: require './item'
  battle: require './battle'
