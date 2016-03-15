path = require 'path-extra'
{ROOT, layout, _, $, $$, React, ReactBootstrap} = window
{Panel, Label, OverlayTrigger, Tooltip} = ReactBootstrap
{join} = require 'path-extra'
{connect} = require 'react-redux'
moment = require 'moment'
__ = i18n.main.__.bind(i18n.main)
__n = i18n.main.__n.bind(i18n.main)

conquest_names = require path.join(ROOT, 'assets/data/conquest_names.json')

CountdownTimer = require './countdown-timer'

CountdownLabel = connect((state) -> 
  tick: state.tick
) React.createClass
  getLabelStyle: (timeRemaining) ->
    switch
      when timeRemaining > 600 then 'primary'
      when timeRemaining > 60  then 'warning'
      when timeRemaining >= 0  then 'success'
      else 'default'
  getTimeRemaining: (completeTime) ->
    if !completeTime?
      -1
    else if completeTime <= @props.tick
      0
    else
      Math.round((completeTime - @props.tick) / 1000)
  componentWillReceiveProps: (nextProps) ->
    if nextProps.completeTime isnt @props.completeTime
      @notify = _.once nextProps.notify
    if nextProps.completeTime?
      timeRemaining = @getTimeRemaining nextProps.completeTime
      if (notifyBefore = window.notify.expedition) < 1 then notifyBefore = 1
      @notify() if 0 < timeRemaining <= notifyBefore
  render: ->
    timeRemaining = @getTimeRemaining @props.completeTime
    style = @getLabelStyle timeRemaining
    <OverlayTrigger placement='left' overlay={
      if @props.completeTime > 0
        <Tooltip id="mission-return-by-#{@props.dockIndex}">
          <strong>{__ "Return by : "}</strong>{timeToString @props.completeTime}
        </Tooltip>
      else
        <span />
    }>
      <Label className="mission-timer" bsStyle={style}>
      {
        if @props.completeTime?
          <span>{resolveTime timeRemaining}</span>
      }
      </Label>
    </OverlayTrigger>

MissionPanel = connect((state) -> 
  conquest: state.conquest
) React.createClass
  notify: (deckName) ->
    notify "#{deckName} #{__ 'mission complete'}",
      type: 'expedition'
      title: __ 'Expedition'
      icon: join(ROOT, 'assets', 'img', 'operation', 'expedition.png')
  render: ->
    <Panel bsStyle="default">
    {
      for i in [2..4]
        party = @props.conquest?[i]
        if party?
          debugger;
          name = switch party.status.toString()
            when '0'
              'Locked'
            when '1'
              'Idle'
            when '2'
              if party.field_id?[i]?
                conquest_names[party.field_id - 1]
              else
                'Sally party '+i
        else
          name = 'Idle'
        finishAt = party?.finish_at
        if finishAt
          finishAt = +moment(finishAt + '+0900')
        <div className="panel-item mission-item" key={i} >
          <span className="mission-name">{name}</span>
          <CountdownLabel dockIndex={i}
                          completeTime={finishAt}
                          notify={@notify.bind @, (party?.party_name || 'Party')}/>
        </div>
    }
    </Panel>

module.exports = MissionPanel
