ShipPane = (i) ->
  ShipPane_ = require('./shippane')(i)
  ShipPane_.defaultProps = require './shipitem'
  ShipPane_

MiniShipPane = (i) ->
  MiniShipPane_ = class extends require('./shippane')(i)
  MiniShipPane_.defaultProps = require './minishipitem'
  MiniShipPane_

module.exports =
  Slotitems: window.hack.ShipViewSlotitems || require './slotitems'
  StatusLabel: require './statuslabel'
  TopAlert: require './topalert'
  PaneBodyMini: window.hack.ShipViewPaneBodyMini || MiniShipPane
  PaneBody: window.hack.ShipViewPaneBody || ShipPane
