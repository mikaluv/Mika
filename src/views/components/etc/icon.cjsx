{ROOT, layout, _, $, $$, React, ReactBootstrap, useSVGIcon} = window
path = require 'path-extra'
classnames = require 'classnames'

EquipIcon = React.createClass
  shouldComponentUpdate: (nextProps, nextState) ->
    !_.isEqual nextProps, @props
  render: ->
    {equipId} = @props
    # Equip base icons are numbered by the id of the high-rank equip
    equipMainId = Math.ceil(equipId/3) * 3
    # Rank: 1 - Low   2 - Mid   3 - High
    equipRankId = 3 - (equipMainId - equipId)
    className = classnames 'equip-icon png',
      @props.className
    <div className={className} >
      <img src="file://#{ROOT}/assets/img/slotitem/#{equipMainId}.png" className='equip-icon-main' />
      <img src="file://#{ROOT}/assets/img/slotitem/rank#{equipRankId}.png" className='equip-icon-rank' />
    </div>

HorseIcon = React.createClass
  shouldComponentUpdate: ->
    false
  render: ->
    className = classnames 'equip-icon png',
      @props.className
    <div className={className} >
      <img src="file://#{ROOT}/assets/img/slotitem/horse.png" className='equip-icon-rank' />
    </div>

ProtectionIcon = React.createClass
  shouldComponentUpdate: ->
    false
  render: ->
    className = classnames 'equip-icon png',
      @props.className
    <div className={className} >
      <img src="file://#{ROOT}/assets/img/slotitem/protect.png" className='equip-icon-rank' />
    </div>


MaterialIcon = React.createClass
  shouldComponentUpdate: (nextProps, nextState) ->
    !_.isEqual nextProps, @props
  render: ->
    <img src="file://#{ROOT}/assets/img/material/0#{@props.materialId}.png" className="#{@props.className} png" />

module.exports = {
  EquipIcon
  HorseIcon
  ProtectionIcon
  MaterialIcon
}
