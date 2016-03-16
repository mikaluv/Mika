{$, $$, _, React} = window
{connect} = require 'react-redux'
TopAlert = require './topalert'

{getShipStatus} = require './utils'

ShipPane = (deckIndex) -> 
  class ShipPane_ extends React.Component
    constructor: (props) ->
      super props
      @miniFlag = props.miniFlag
      @ShipData = props.shipData
      @ShipItem = props.shipItem
      @condDynamicUpdateFlag = false
    onCondChange: (cond) ->
      condDynamicUpdateFlag = true
      ships = Object.clone @state.ships
      for shipData, j in ships
        ships[j].cond = cond[j]
        window._ships[shipData.id].api_cond = cond[j]
      @setState
        ships: ships
    handleResponse: (e) ->
      {method, path, body, postBody} = e.detail
      label = Object.clone @state.label
      updateflag = false
      switch path
        when '/kcsapi/api_port/port', '/kcsapi/api_req_hensei/change', '/kcsapi/api_req_nyukyo/speedchange', '/kcsapi/api_req_hensei/preset_select'
          updateflag = true
          label = @getLabels()
        when '/kcsapi/api_req_hokyu/charge'
          if @miniFlag
            updateflag = true
            label = @getLabels()
        when '/kcsapi/api_req_nyukyo/start'
          if (postBody.api_highspeed == 1)
            updateflag = true
        when '/kcsapi/api_get_member/ndock'
          for shipId in _ndocks
            i = @props.deck.api_ship.indexOf shipId
            if i isnt -1
              label[i] = 1
              updateflag = true
      if updateflag
        @setState
          label: label
    setShipData: (props) ->
      if @condDynamicUpdateFlag
        @condDynamicUpdateFlag = not @condDynamicUpdateFlag
      else
        ships = []
        for shipId, i in props.deck.api_ship
          continue if shipId is -1
          ships.push new @ShipData(shipId)
        @setState
          ships: ships
    componentWillMount_: ->
      @handleResponseWithThis = @handleResponse.bind(@)
    render: ->
      <div>
        <div className='fleet-name'>
          { <div />
            #<TopAlert
            #  updateCond={@onCondChange.bind(@)}
            #  messages={@props.messages}
            #  deckIndex={@props.deckIndex}
            #  deckName={@props.deckName}
            #  mini={@miniFlag}
            #/>
          }
        </div>
        <div className="ship-details#{if @miniFlag then '-mini' else ''}">
          {
            debugger;
            for j, {serial_id} of (@props.party?.slot || {}) when serial_id?
              if (sword = @props.swords?[serial_id])?
                React.createElement @ShipItem,
                  key: "#{j}.#{serial_id}"
                  deckIndex: @props.deckIndex
                  shipData: sword
                  shipIndex: j-1
          }
        </div>
      </div>
  ShipPane_.propTypes =
    miniFlag: React.PropTypes.bool
    shipData: React.PropTypes.func
    shipItem: React.PropTypes.func
  connect((state) -> 
    deckIndex: deckIndex
    party: state.info?.party?[deckIndex]
    swords: state.info?.sword
  ) ShipPane_

module.exports = ShipPane
