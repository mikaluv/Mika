{relative, join} = require 'path-extra'
path =  require 'path-extra'
{_, $, $$, React, ReactBootstrap, ROOT, FontAwesome, toggleModal} = window
{$ships, $shipTypes, _ships} = window
{Button, ButtonGroup} = ReactBootstrap
{ProgressBar, OverlayTrigger, Tooltip, Alert, Overlay, Label, Panel, Popover} = ReactBootstrap
classnames = require 'classnames'
{connect} = require 'react-redux'
__ = i18n.main.__.bind(i18n.main)
__n = i18n.main.__n.bind(i18n.main)
StatusLabel = require './statuslabel'
{SlotitemIcon} = require '../etc/icon'

{getHpStyle, getShipStatus, getStatusStyle, getFatigueNow} = require './utils'
equip_names = require path.join(ROOT, 'assets/data/equip_names.json')
sword_names = require path.join(ROOT, 'assets/data/sword_names.json')
sword_exp_list = require path.join(ROOT, 'assets/data/sword_exp_list.json')

getFontStyle = (theme)  ->
  if window.isDarkTheme then color: '#FFF' else color: '#000'

Slotitems = connect((state) -> 
  equips: state.equip
) React.createClass
  render: ->
    <div className="slotitems-mini" style={display: "flex", flexFlow: "column"}>
    {
      for equip_serial_id, i in @props.data
        continue if !equip_serial_id? || equip_serial_id == -1
        continue if !(equip = @props.equips[equip_serial_id])?
        {equip_id, soldier} = equip
        onSlotClassName = classnames 'slotitem-onslot-mini',
          hide: equip_id > 10000        # Horse.id > 10000
        <div key={i} className="slotitem-container-mini">
          {undefined
            #<SlotitemIcon key={itemId} className='slotitem-img' slotitemId={item.slotitemId} />
            #<span className="slotitem-name-mini">
            #  {i18n.resources.__ item.name}
            #    {if item.level > 0 then <strong style={color: '#45A9A5'}> ★{item.level}</strong> else ''}
            #    &nbsp;&nbsp;{
            #      if item.alv? and 1 <= item.alv <= 7
            #        <img className='alv-img' src={join('assets', 'img', 'airplane', "alv#{item.alv}.png")} />
            #      else ''
            #    }
            #</span>
            #<Label className="slotitem-onslot-mini
            #                #{if (item.slotitemId >= 6 && item.slotitemId <= 10) || (item.slotitemId >= 21 && item.slotitemId <= 22) || item.slotitemId == 33 then 'show' else 'hide'}"
            #                bsStyle="#{if item.onslot < item.maxeq then 'warning' else 'default'}">
          }
          <span className="slotitem-name-mini">
            {equip_names[equip_id]}
          </span>
          <Label className={onSlotClassName}>
            {soldier}
          </Label>
        </div>
    }
    </div>

MiniShipRow = connect((state) -> 
  equips: state.info?.equip
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
    overlayPlacement = if (!window.doubleTabbed) && (window.layout == 'vertical')
        'left'
      else
        'right'
    overlayClassName = classnames 'ship-pop',
      'hidden': !equipData.length
    overlay = 
      <Tooltip id="ship-pop-#{@props.key}-#{@props.shipIndex}" className={overlayClassName}>
        <div className="item-name">
          <Slotitems data={equipData} />
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
