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
    render: ->
      <div>
        <div className='fleet-name'>
        </div>
        <div className="ship-details#{if @miniFlag then '-mini' else ''}">
          {
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
    party: state.party?[deckIndex]
    swords: state.sword
  ) ShipPane_

module.exports = ShipPane
