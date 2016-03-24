{$, $$, _, React} = window
{connect} = require 'react-redux'
TopAlert = require './topalert'

{getShipStatus} = require './utils'

ShipPane = connect(({party: parties}, {miniFlag, deckIndex}) ->
  {party: parties?[deckIndex], miniFlag, deckIndex}
) React.createClass
  propTypes:
    miniFlag: React.PropTypes.bool
    shipItem: React.PropTypes.func.isRequired
    deckIndex: React.PropTypes.number.isRequired
  childContextTypes:
    miniFlag: React.PropTypes.bool
    deckIndex: React.PropTypes.number
  getChildContext: ->
    miniFlag: @props.miniFlag || false
    deckIndex: @props.deckIndex
  render: ->
    {deckIndex, party, miniFlag, shipItem: ShipItem} = @props
    <div>
      <div className='fleet-name'>
        <TopAlert deckIndex={deckIndex} />
      </div>
      <div className="ship-details#{if miniFlag then '-mini' else ''}">
        {
          for j, {serial_id} of party?.slot when serial_id?
            <ShipItem
              key={"#{j}.#{serial_id}"}
              swordSerialId={serial_id}
              shipIndex={j-1}
              deckIndex={deckIndex}
              />
        }
      </div>
    </div>

module.exports = ShipPane
