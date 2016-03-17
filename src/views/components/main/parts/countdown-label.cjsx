{OverlayTrigger, Label} = ReactBootstrap
{connect} = require 'react-redux'

module.exports = CountdownLabel = connect((state) -> 
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
      if (notifyBefore = @props.notifyBefore) < 1 then notifyBefore = 1
      @notify() if 0 < timeRemaining <= notifyBefore
  render: ->
    timeRemaining = @getTimeRemaining @props.completeTime
    style = @getLabelStyle timeRemaining
    contents = 
      <Label className="mission-timer" bsStyle={style}>
      {
        if @props.completeTime?
          <span>{resolveTime timeRemaining}</span>
      }
      </Label>
    if @props.overlay
      <OverlayTrigger placement='left' overlay={@props.overlay}>
        {contents}
      </OverlayTrigger>
    else
      contents
