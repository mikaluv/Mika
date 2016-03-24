{relative, join} = require 'path-extra'
{$, $$, _, React, ReactBootstrap, resolveTime, notify} = window
{Table, ProgressBar, OverlayTrigger, Tooltip, Grid, Col, Alert, Row, Overlay, Label} = ReactBootstrap
{connect} = require 'react-redux'
__ = i18n.main.__.bind(i18n.main)
__n = i18n.main.__n.bind(i18n.main)
StatusLabel = require './statuslabel'
classnames = require 'classnames'
getBackgroundStyle = ->
  if window.isDarkTheme
    backgroundColor: 'rgba(33, 33, 33, 0.7)'
  else
    backgroundColor: 'rgba(256, 256, 256, 0.7)'

{EquipIcon, HorseIcon, ProtectionIcon} = require '../etc/icon'
{getHpStyle, getStatusStyle, getShipStatus, getFatigueNow} = require './utils'
sword_names = require join(ROOT, 'assets/data/sword_names.json')
sword_exp_list = require join(ROOT, 'assets/data/sword_exp_list.json')
equip_names = require join(ROOT, 'assets/data/equip_names.json')
consumable_names = require join(ROOT, 'assets/data/consumable_names.json')

getMaterialStyle = (percent) ->
  if percent <= 50
    'danger'
  else if percent <= 75
    'warning'
  else if percent < 100
    'info'
  else
    'success'

Equip = React.createClass
  shouldComponentUpdate: (nextProps, nextState) ->
    !_.isEqual nextProps, @props

  propTypes:
    name: React.PropTypes.string.isRequired
    equipId: React.PropTypes.number
    soldier: React.PropTypes.number
    iconClass: React.PropTypes.func

  render: ->
    {name, equipId, soldier, iconClass: IconClass} = @props
    itemOverlay = 
      <Tooltip>
        <div>{ name }</div>
        {undefined
          #if _slotitems[itemId]?
          #  datas = getItemData _slotitems[itemId]
          #  for data, index in datas
          #    <div key="Slotitem-#{itemId}-#{index}">{data}</div>
        }
      </Tooltip>

    itemSpan =
      <span>
        <IconClass className='slotitem-img' equipId={equipId} />
        {
          if soldier?
            <span className="slotitem-onslot" style={getBackgroundStyle()}>
              {soldier}
            </span>
        }
      </span>

    <div className="slotitem-container">
    {
      if itemOverlay        # TODO: always exist? empty slot icon?
        <OverlayTrigger placement='left' overlay={itemOverlay}>
          {itemSpan}
        </OverlayTrigger>
      else
        itemSpan
    }
    </div>

ShipRow = connect(
  ({equip: equips, sword: swords, item: items, repairs, tick}, {swordSerialId, deckIndex}) -> 
    sword = swords?[swordSerialId]
    newEquips = [
      sword?.equip_serial_id1
      sword?.equip_serial_id2
      sword?.equip_serial_id3
      sword?.horse_serial_id
    ].map((equipSerialId) -> if equipSerialId? then equips?[equipSerialId])
    item = if sword?.item_id then items?[sword?.item_id]
    {tick, sword, equips: newEquips, item, repairs}
) React.createClass
  render: ->
    {tick, sword, equips, item, repairs} = @props
    return <div /> if !sword?

    status = getShipStatus true, sword
    statusStyle = getStatusStyle status
    {level, exp, sword_id, hp, hp_max} = sword
    nextExp = sword_exp_list[level] - exp
    fatigue = getFatigueNow sword, tick
    name = sword_names[sword_id]

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
        <div className="slotitems">
          {
            for equip, i in equips
              continue if !equip?
              hasEquip = true
              {serial_id, equip_id, soldier} = equip
              isHorse = i == 3
              soldier = if isHorse then undefined else parseInt(soldier)
              <Equip
                key={serial_id}
                name={equip_names[equip_id]}
                equipId={parseInt(equip_id)}
                soldier={soldier}
                iconClass={if isHorse then HorseIcon else EquipIcon} 
                />
          }
          {
            if item?
              hasEquip = true
              <Equip
                key=0
                name={consumable_names[item.consumable_id]}
                iconClass={ProtectionIcon} 
                />
          }
        </div>
      </div>
    </div>


module.exports =
  shipItem: ShipRow
  miniFlag: false
