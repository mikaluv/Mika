{ROOT, layout, _, $, $$, React, ReactBootstrap} = window
{Label, OverlayTrigger, Tooltip} = ReactBootstrap
{connect} = require 'react-redux'
path = require 'path-extra'
moment = require 'moment'
__ = i18n.main.__.bind(i18n.main)
__n = i18n.main.__n.bind(i18n.main)

CountdownLabel = require './countdown-label.cjsx'

sword_names = require path.join(ROOT, 'assets/data/sword_names.json')

NdockPanel = connect((state) -> 
  repair: state.repair
  repair_slot: state.info.repair_slot
  sword: state.info.sword
  party: state.info.party
) React.createClass
  repairIcon: path.join(ROOT, 'assets', 'img', 'operation', 'repair.png')
  notify: (dockName) ->
    notify "#{i18n.resources.__ dockName} #{__ 'repair completed'}",
      type: 'repair'
      title: __ 'Docking'
      icon: @repairIcon
  render: ->
    debugger;
    <div>
    {
      for i in [1..4]
        finishAt = null
        name = if i > @props.repair_slot
          'Locked'
        else if (repair = @props.repair?[i])?
          serial_id = repair.sword_serial_id
          id = @props.sword[serial_id]?.sword_id
          finishAt = +moment(repair.finished_at + '+0900')
          sword_names[id] || 'Unknown sword #'+id
        else
          'Empty'
        <div key={i} className="panel-item ndock-item">
          <span className="ndock-name">{name}</span>
          <CountdownLabel
            overlay={
              if finishAt?
                <Tooltip id="ndock-finish-by-#{i}">
                  <strong>{__ "Finish by : "}</strong>{timeToString finishAt}
                </Tooltip>
              else
                <div />
            }
            completeTime={finishAt}
            notifyBefore={60}
            notify={@notify.bind @, @props.party?[i]?.party_name}/>
        </div>
    }
    </div>

module.exports = NdockPanel
