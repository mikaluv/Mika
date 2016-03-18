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
  for i, {serial_id} of party when serial_id
    sword = swords[serial_id]
    continue if !sword?
    totalLv += parseInt(sword.level)
    totalShip += 1
    recoverTime.push fatigueRecoverTime(sword, tick)

  totalLv: totalLv
  avgLv: if totalShip then totalLv/totalShip else 0
  recoverTime: Math.max.apply(this, recoverTime)/1000

TopAlert = connect((state) -> 
  swords: state.sword
  tick: state.tick
) React.createClass
  render: ->
    messages = getDeckMessage @props.party.slot, @props.swords, @props.tick
    totalLv = messages.totalLv
    avgLv = messages.avgLv.toFixed(1)
    fatigue = (resolveTime messages.recoverTime).slice(3) # [HH:]MM:SS
    <div style={width: '100%'}>
    {
      if @props.mini
        <div style={display: "flex", justifyContent: "space-around", width: '100%'}>
          <span style={flex: "none"}>Lv. {totalLv} </span>
          <span style={flex: "none", marginLeft: 5}>{__ 'Avg Lv'}: {avgLv}</span>
          <span style={flex: "none", marginLeft: 5}>{__ 'Fatigue'}: {fatigue}</span>
        </div>
      else
        <Alert style={getFontStyle window.theme}>
          <div style={display: "flex"}>
            <span style={flex: 1}>{__ 'Total Lv'}. {totalLv}</span>
            <span style={flex: 1}>
              <span>{__ 'Avg Lv'}: {avgLv}</span>
            </span>
            <span style={flex: 1.5}>
              Fatigue:
              <span id={"deck-condition-countdown-#{@props.deckIndex}-#{@componentId}"}>
                {fatigue}
              </span>
            </span>
          </div>
        </Alert>
    }
    </div>
module.exports = TopAlert

