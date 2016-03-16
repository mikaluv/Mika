path = require 'path-extra'
{ROOT, layout, _, $, $$, React, ReactBootstrap} = window
{Panel, Tooltip} = ReactBootstrap
path = require 'path-extra'
{connect} = require 'react-redux'
moment = require 'moment'
__ = i18n.main.__.bind(i18n.main)
__n = i18n.main.__n.bind(i18n.main)

CountdownLabel = require './countdown-label.cjsx'

conquest_names = require path.join(ROOT, 'assets/data/conquest_names.json')

MissionPanel = connect((state) -> 
  conquest: state.conquest
) React.createClass
  notify: (deckName) ->
    notify "#{deckName} #{__ 'mission complete'}",
      type: 'expedition'
      title: __ 'Expedition'
      icon: path.join(ROOT, 'assets', 'img', 'operation', 'expedition.png')
  render: ->
    <Panel bsStyle="default">
    {
      for i in [2..4]
        party = @props.conquest?[i]
        if party?
          name = switch party.status.toString()
            when '0'
              'Locked'
            when '1'
              'Idle'
            when '2'
              if party.field_id?
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
          <CountdownLabel 
            overlay={
              if finishAt?
                <Tooltip id="mission-return-by-#{i}">
                  <strong>{__ "Return by : "}</strong>{timeToString finishAt}
                </Tooltip>
              else
                <div />
            }
            completeTime={finishAt}
            notifyBefore={window.notify.expedition}
            notify={@notify.bind @, (party?.party_name || 'Party')}/>
        </div>
    }
    </Panel>

module.exports = MissionPanel
