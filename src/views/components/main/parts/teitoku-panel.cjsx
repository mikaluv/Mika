path = require 'path-extra'
{ROOT, layout, _, $, $$, React, ReactBootstrap, toggleModal} = window
{log, warn, error} = window
{Panel, Grid, Col, OverlayTrigger, Tooltip} = ReactBootstrap
{connect} = require 'react-redux'
__ = i18n.main.__.bind(i18n.main)
__n = i18n.main.__n.bind(i18n.main)
order = if layout == 'horizontal' or window.doubleTabbed then [1, 3, 5, 7, 2, 4, 6, 8] else [1..8]

totalExpList = require path.join ROOT, 'assets/data/player_exp_list.json'

TeitokuPanel = connect((state) -> 
  Object.assign {},
    _.pick(state.info, 'name', 'level', 'exp', 'max_sword', 'max_equip')
    sword: state.sword
    equip: state.equip
) React.createClass
  render: ->
    styleCommon =
      minWidth: '60px'
      padding: '2px'
      float: 'left'
    styleL = Object.assign {}, styleCommon, {textAlign: 'right'}
    styleR = Object.assign {}, styleCommon, {textAlign: 'left'}
    totalExp = defaultTo @props.exp, '??'
    nextExp = if @props.exp? && @props.level? then totalExpList[@props.level]-@props.exp else '??'
    swordNum = if @props.sword? then Object.keys(@props.sword).length else '??'
    swordMax = defaultTo @props.max_sword, '??'
    equipNum = if @props.equip? then Object.keys(@props.equip).length else '??'
    equipMax = defaultTo @props.max_equip, '??'
    <Panel bsStyle="default" className="teitoku-panel">
      <div>
        <OverlayTrigger placement="bottom" overlay={
          <Tooltip id='teitoku-exp'>
            <div style={display: 'table'}>
              <div>
                <span style={styleL}>Next.</span><span style={styleR}>{nextExp}</span>
              </div>
              <div>
                <span style={styleL}>Total Exp.</span><span style={styleR}>{totalExp}</span>
              </div>
            </div>
          </Tooltip>
          }>
          <span>{"Lv. #{@props.level || '??'}　#{@props.name || __('Admiral [Not logged in]')}　"}</span>
        </OverlayTrigger>
        {__ 'Ships'}: {swordNum} / {swordMax}　{__ 'Equipment'}: {equipNum} / {equipMax}
      </div>
    </Panel>

module.exports = TeitokuPanel
