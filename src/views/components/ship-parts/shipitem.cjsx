{relative, join} = require 'path-extra'
path =  require 'path-extra'
{$, $$, _, React, ReactBootstrap, resolveTime, notify} = window
{Table, ProgressBar, OverlayTrigger, Tooltip, Grid, Col, Alert, Row, Overlay, Label} = ReactBootstrap
{connect} = require 'react-redux'
__ = i18n.main.__.bind(i18n.main)
__n = i18n.main.__n.bind(i18n.main)
Slotitems = require './slotitems'
StatusLabel = require './statuslabel'

{getHpStyle, getStatusStyle, getShipStatus, getFatigueNow} = require './utils'
sword_names = require path.join(ROOT, 'assets/data/sword_names.json')
sword_exp_list = require path.join(ROOT, 'assets/data/sword_exp_list.json')

getMaterialStyle = (percent) ->
  if percent <= 50
    'danger'
  else if percent <= 75
    'warning'
  else if percent < 100
    'info'
  else
    'success'

ShipRow = connect((state) -> 
  equips: state.info?.equip
  repairs: state.repair
  tick: state.tick
) React.createClass
  render: ->
    status = getShipStatus true, @props.shipData
    statusStyle = getStatusStyle status
    {level, exp, sword_id, hp, hp_max} = @props.shipData
    nextExp = sword_exp_list[level] - exp
    fatigue = getFatigueNow @props.shipData, @props.tick
    name = sword_names[sword_id]

    equipData = [
      @props.shipData.equip_serial_id1
      @props.shipData.equip_serial_id2
      @props.shipData.equip_serial_id3
      @props.shipData.horse_serial_id
    ].filter(Boolean)
    <div className="ship-item">
      <div className="ship-tile">
        <div className="ship-basic-item">
          <div className="ship-info" style={statusStyle}>
            <div className="ship-basic">
              <span className="ship-lv">
                Lv. {level}
              </span>
              <span className='ship-type'>
                {'T'}
              </span>
            </div>
            <span className="ship-name">
              {name}
            </span>
            <span className="ship-exp">
              Next. {nextExp}
            </span>
          </div>
          {
            shipStat =
              <div className="ship-stat">
                <div className="div-row">
                  <span className="ship-hp" style={statusStyle}>
                    {hp} / {hp_max}
                  </span>
                  <div className="status-label">
                    <StatusLabel label={status}/>
                  </div>
                  <div style={statusStyle}>
                    <span className={"ship-cond " + window.getCondStyle(fatigue)}>
                      ★{fatigue}
                    </span>
                  </div>
                </div>
                <span className="hp-progress top-space" style={statusStyle}>
                  <ProgressBar bsStyle={getHpStyle hp / hp_max * 100}
                               now={hp / hp_max * 100} />
                </span>
              </div>
            if false            # TODO: repair time formula
              <OverlayTrigger show = {@props.shipData.ndockTime} placement='right' overlay={
                              <Tooltip id="panebody-repair-time-#{@props.key}-#{@props.shipIndex}">
                                {__ 'Repair Time'}: {resolveTime @props.shipData.ndockTime / 1000}
                              </Tooltip>}>
                {shipStat}
              </OverlayTrigger>
            else
              shipStat
          }
        </div>
      </div>
      <div className="ship-slot" style={statusStyle}>
      </div>
    </div>

#<Slotitems key={@props.shipIndex} fleet={@props.deckIndex} slots={@props.shipData.slotItems}/>

module.exports =
  shipItem: ShipRow
  miniFlag: false
