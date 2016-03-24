{$, $$, _, React, ReactBootstrap, resolveTime, notify} = window
{OverlayTrigger, Tooltip,  Alert} = ReactBootstrap
__ = i18n.main.__.bind(i18n.main)
__n = i18n.main.__n.bind(i18n.main)
{connect} = require 'react-redux'
{join} = require 'path-extra'

{fatigueRecoverTime} = require './utils'

getFontStyle = (theme)  ->
  if window.isDarkTheme then color: '#FFF' else color: '#000'

getDeckMessage = (party, swords, tick) ->
  totalLv = totalShip = 0
  recoverTime = [0]         # default value when empty
  for sword in swords when sword?
    totalLv += parseInt(sword.level)
    totalShip += 1
    recoverTime.push fatigueRecoverTime(sword, tick)

  totalLv: totalLv
  avgLv: if totalShip then totalLv/totalShip else 0
  recoverTime: Math.max.apply(this, recoverTime)/1000

TopAlert = connect(({tick, sword: swords, party: parties}, {deckIndex}) ->
  party = parties?[deckIndex] || {}
  newSwords = _.values(party.slot || {}).map(({serial_id}) -> swords?[serial_id])
  {party, swords: newSwords, tick}
) React.createClass
  contextTypes:
    miniFlag: React.PropTypes.bool
  render: ->
    {tick, swords, party} = @props
    {miniFlag, deckIndex} = @context
    messages = getDeckMessage party.slot, swords, tick
    totalLv = messages.totalLv
    avgLv = messages.avgLv.toFixed(1)
    fatigue = (resolveTime messages.recoverTime).slice(3) # [HH:]MM:SS
    <div style={width: '100%'}>
    {
      if miniFlag
        <div style={display: "flex", justifyContent: "space-around", width: '100%'}>
          <span style={flex: "none"}>Lv. {totalLv}</span>
          <span style={flex: "none", marginLeft: 5}>{__ 'Avg Lv'}: {avgLv}</span>
          <span style={flex: "none", marginLeft: 5}>{__ 'Fatigue'}: {fatigue}</span>
        </div>
      else
        <Alert style={getFontStyle window.theme}>
          <div style={display: "flex"}>
            <span style={flex: 1}>{__ 'Total Lv'}: {totalLv}</span>
            <span style={flex: 1}>{__ 'Avg Lv'}: {avgLv}</span>
            <span style={flex: 1.5}>{__ 'Fatigue'}: {fatigue}</span>
          </div>
        </Alert>
    }
    </div>
module.exports = TopAlert

