{relative, join} = require 'path-extra'
path =  require 'path-extra'
{_, $, $$, React, ReactBootstrap, ROOT, FontAwesome, toggleModal} = window
{$ships, $shipTypes, _ships} = window
{Button, ButtonGroup} = ReactBootstrap
{ProgressBar, OverlayTrigger, Tooltip, Alert, Overlay, Label, Panel, Popover} = ReactBootstrap
__ = i18n.main.__.bind(i18n.main)
__n = i18n.main.__n.bind(i18n.main)
StatusLabel = require './statuslabel'
{SlotitemIcon} = require '../etc/icon'

{getHpStyle, getShipStatus, getStatusStyle, getShipStatus, BaseShipData} = require './utils'
sword_names = require path.join(ROOT, 'assets/data/sword_names.json')
sword_exp_list = require path.join(ROOT, 'assets/data/sword_exp_list.json')

getFontStyle = (theme)  ->
  if window.isDarkTheme then color: '#FFF' else color: '#000'

Slotitems = React.createClass
  shouldComponentUpdate: (nextProps, nextState) ->
    not _.isEqual nextProps, @props
  render: ->
    <div className="slotitems-mini" style={display: "flex", flexFlow: "column"}>
    {
      for item, i in @props.data
        continue if !item? || item.id == -1
        itemId = item.id
        <div key={i} className="slotitem-container-mini">
          <SlotitemIcon key={itemId} className='slotitem-img' slotitemId={item.slotitemId} />
          <span className="slotitem-name-mini">
            {i18n.resources.__ item.name}
              {if item.level > 0 then <strong style={color: '#45A9A5'}> ★{item.level}</strong> else ''}
              &nbsp;&nbsp;{
                if item.alv? and 1 <= item.alv <= 7
                  <img className='alv-img' src={join('assets', 'img', 'airplane', "alv#{item.alv}.png")} />
                else ''
              }
          </span>
          <Label className="slotitem-onslot-mini
                          #{if (item.slotitemId >= 6 && item.slotitemId <= 10) || (item.slotitemId >= 21 && item.slotitemId <= 22) || item.slotitemId == 33 then 'show' else 'hide'}"
                          bsStyle="#{if item.onslot < item.maxeq then 'warning' else 'default'}">
            {item.onslot}
          </Label>
        </div>
    }
    </div>

MiniShipRow = React.createClass
  shouldComponentUpdate: (nextProps, nextState) ->
    not _.isEqual nextProps, @props
  render: ->
    status = getShipStatus true, @props.shipData
    statusStyle = getStatusStyle status
    {level, exp, sword_id, hp, hp_max, fatigue} = @props.shipData
    nextExp = sword_exp_list[level] - exp
    <div className="ship-tile">
      <OverlayTrigger placement={if (!window.doubleTabbed) && (window.layout == 'vertical') then 'left' else 'right'} overlay={
        <Tooltip id="ship-pop-#{@props.key}-#{@props.shipIndex}" className="ship-pop #{if @props.shipData.slotItemExist then '' else 'hidden'}">
          <div className="item-name">
            <Slotitems data={@props.shipData?.slotItems} />
          </div>
        </Tooltip>
      }>
        <div className="ship-item">
          <OverlayTrigger placement='top' overlay={
            <Tooltip id="miniship-exp-#{@props.key}-#{@props.shipIndex}">
              Next. {nextExp}
            </Tooltip>
          }>
            <div className="ship-info">
              <span className="ship-name" style={statusStyle}>
                {sword_names[sword_id]}
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
  shipData: BaseShipData
  miniFlag: true
