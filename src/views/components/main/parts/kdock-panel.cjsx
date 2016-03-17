{ROOT, layout, _, $, $$, React, ReactBootstrap, success, warn} = window
{OverlayTrigger, Tooltip, Label} = ReactBootstrap
{join} = require 'path-extra'
{connect} = require 'react-redux'
moment = require 'moment'
__ = i18n.main.__.bind(i18n.main)
__n = i18n.main.__n.bind(i18n.main)
{MaterialIcon} = require '../../etc/icon'

CountdownLabel = require './countdown-label.cjsx'

showItemDevResultDelay = if window.config.get('poi.delayItemDevResult', false) then 6200 else 500

sword_names = require join(ROOT, 'assets/data/sword_names.json')

KdockPanel = connect((state) -> 
  forge: state.forge,
  forge_slot: state.info.forge_slot
) React.createClass
  getMaterialImage: (idx) ->
    <MaterialIcon materialId={idx} className="material-icon" />
  constructionIcon: join(ROOT, 'assets', 'img', 'operation', 'build.png')
  notify: ->
    # Notify all completed ships
    completedShips = @props.forge.values().map(
      (forge) -> sword_names[forge.sword_id?] || "Forge slot ##{forge.slot_no}")
    .join(', ')
    notify "#{completedShips} #{__ 'built'}",
      type: 'construction'
      title: __ "Construction"
      icon: @constructionIcon
  render: ->
    <div>
    {
      for i in [1..4]
        forge = @props.forge?[i]
        finishAt = undefined
        dockName = if i > @props.forge_slot
          'Locked'
        else if forge?
          finishAt = +moment(forge.finished_at + '+0900')
          id = forge.sword_id
          if id?
            sword_names[id] || 'Unknown sword #'+id
          else
            'Unrefreshed'
        else
          'Empty'
        <OverlayTrigger key={i} placement='top' overlay={
          if forge?.file?        # Any one of the 4 kind of resources
            <Tooltip id="kdock-material-#{i}">
              {
                <span>{dockName}<br /></span>
              }
              {@getMaterialImage 1} {forge.charcoal}
              {@getMaterialImage 2} {forge.steel}
              {@getMaterialImage 3} {forge.coolant}
              {@getMaterialImage 4} {forge.file}
            </Tooltip>
          else
            <span />
        }>
          <div className="panel-item kdock-item" key={i}>
            <span className="kdock-name">{dockName}</span>
            <CountdownLabel
              completeTime={finishAt}
              notifyBefore={1}
              notify={@notify.bind @, dockName} />
          </div>
        </OverlayTrigger>
    }
    </div>

module.exports = KdockPanel
