{$, $$, _, React} = window
{connect} = require 'react-redux'
TopAlert = require './topalert'

{getShipStatus} = require './utils'

ShipPane = (deckIndex) -> 
  class ShipPane_ extends React.Component
    constructor: (props) ->
      super props
      @miniFlag = props.miniFlag
      @ShipItem = props.shipItem
    render: ->
      totalLevel = 
      <div>
        <div className='fleet-name'>
          <TopAlert
            party={@props.party}
            mini={@miniFlag}
            />
        </div>
        <div className="ship-details#{if @miniFlag then '-mini' else ''}">
          {
            for j, {serial_id} of @props.party.slot when serial_id?
              React.createElement @ShipItem,
                key: "#{j}.#{serial_id}"
                deckIndex: @props.deckIndex
                swordSerialId: serial_id
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
    party: defaultTo(state.party?[deckIndex], {})
    swords: state.sword
  ) ShipPane_

module.exports = ShipPane
