{relative, join} = require 'path-extra'
{_, $, $$, React, ReactBootstrap, ROOT, FontAwesome, toggleModal} = window
{$ships, $shipTypes, _ships} = window
{Button, ButtonGroup} = ReactBootstrap
{ProgressBar, OverlayTrigger, Tooltip, Alert, Overlay, Label, Panel, Popover} = ReactBootstrap
classnames = require 'classnames'
{connect} = require 'react-redux'
__ = i18n.main.__.bind(i18n.main)
__n = i18n.main.__n.bind(i18n.main)
StatusLabel = require './statuslabel'
{EquipIcon, HorseIcon, ProtectionIcon} = require '../etc/icon'

{getHpStyle, getShipStatus, getStatusStyle, getFatigueNow} = require './utils'
consumable_names = require join(ROOT, 'assets/data/consumable_names.json')
equip_names = require join(ROOT, 'assets/data/equip_names.json')
sword_names = require join(ROOT, 'assets/data/sword_names.json')
sword_exp_list = require join(ROOT, 'assets/data/sword_exp_list.json')

getFontStyle = (theme)  ->
  if window.isDarkTheme then color: '#FFF' else color: '#000'

MiniEquip = React.createClass
  shouldComponentUpdate: (nextProps, nextState) ->
    !_.isEqual nextProps, @props

  propTypes:
    name: React.PropTypes.string.isRequired
    equipId: React.PropTypes.number
    soldier: React.PropTypes.number
    iconClass: React.PropTypes.func

  render: ->
    {name, equipId, soldier, iconClass: IconClass} = @props
    <div className="slotitem-container-mini">
      <IconClass className='slotitem-img' equipId={equipId} />
      <span className="slotitem-name-mini">
        { name }
      </span>
      {
        if soldier?
          <Label className='slotitem-onslot-mini'>
            { soldier }
          </Label>
      }
    </div>

MiniShipRow = connect(
  ({equip: equips, sword: swords, item: items, tick}, {swordSerialId, deckIndex}) -> 
    sword = swords?[swordSerialId]
    newEquips = [
      sword?.equip_serial_id1
      sword?.equip_serial_id2
      sword?.equip_serial_id3
      sword?.horse_serial_id
    ].map((equipSerialId) -> if equipSerialId? then equips?[equipSerialId])
    item = if sword?.item_id then items?[sword?.item_id]
    {tick, sword, equips: newEquips, item}
) React.createClass
  render: ->
    {tick, sword, equips, item} = @props
    return <div /> if !sword?

    status = getShipStatus true, sword
    statusStyle = getStatusStyle status
    {level, exp, sword_id, hp, hp_max} = sword
    nextExp = sword_exp_list[level] - exp
    fatigue = getFatigueNow sword, tick
    name = sword_names[sword_id]

    overlayPlacement = if (!window.doubleTabbed) && (window.layout == 'vertical')
        'left'
      else
        'right'
    hasEquip = false
    overlay = 
      <Tooltip id="ship-pop-#{@props.key}-#{@props.shipIndex}" className='ship-pop'>
        <div className="item-name">
          {
            for equip, i in equips
              continue if !equip?
              hasEquip = true
              {serial_id, equip_id, soldier} = equip
              isHorse = i == 3
              soldier = if isHorse then undefined else parseInt(soldier)
              <MiniEquip
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
              <MiniEquip
                key=0
                name={consumable_names[item.consumable_id]}
                iconClass={ProtectionIcon} 
                />
          }
          {
            if !hasEquip
              <em>No equipment</em>
          }
        </div>
      </Tooltip>

    <div className="ship-tile">
      <OverlayTrigger placement={overlayPlacement} overlay={overlay}>
        <div className="ship-item">
          <OverlayTrigger placement='top' overlay={
            <Tooltip id="miniship-exp-#{@props.key}-#{@props.shipIndex}">
              Next. {nextExp}
            </Tooltip>
          }>
            <div className="ship-info">
              <span className="ship-name" style={statusStyle}>
                {name}
              </span>
              <span className="ship-lv-text top-space" style={statusStyle}>
                Lv. {level}
              </span>
            </div>
          </OverlayTrigger>
          <div className="ship-stat">
            <div className="div-row">
              <span className="ship-hp" style={statusStyle}>
                {hp} / {hp_max}
              </span>
              <div className="status-label">
                <StatusLabel label={status} />
              </div>
              <div style={statusStyle}>
                <span className={"ship-cond " + window.getCondStyle(fatigue)}>
                  ★{fatigue}
                </span>
              </div>
            </div>
            <span className="hp-progress top-space" style={statusStyle}>
              <ProgressBar bsStyle={getHpStyle hp / hp_max * 100} now={hp / hp_max * 100} />
            </span>
          </div>
        </div>
      </OverlayTrigger>
    </div>

module.exports =
  shipItem: MiniShipRow
  miniFlag: true
