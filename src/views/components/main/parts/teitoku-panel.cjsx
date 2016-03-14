path = require 'path-extra'
{ROOT, layout, _, $, $$, React, ReactBootstrap, toggleModal} = window
{log, warn, error} = window
{Panel, Grid, Col, OverlayTrigger, Tooltip} = ReactBootstrap
{connect} = require 'react-redux'
__ = i18n.main.__.bind(i18n.main)
__n = i18n.main.__n.bind(i18n.main)
order = if layout == 'horizontal' or window.doubleTabbed then [1, 3, 5, 7, 2, 4, 6, 8] else [1..8]

totalExpList = [
  # 10 per row
  0,50,125,225,375,575,825,1125,1525,2025,
  2725,3625,4725,6025,7525,9225,11125,13225,15525,18025,
  20825,23925,27325,31025,35025,39325,43925,48825,54025,59525,
  65325,71425,77825,84525,91525,98825,106425,114325,122525,131025,
  139925,149225,158925,169025,179525,190425,201725,213425,225525,238025,
  250925,264225,277925,292025,306525,321425,336725,352425,368525,385025,
  402025,419525,437525,456025,475025,494525,514525,535025,556025,577525,
  599625,622325,645625,669525,694025,719125,744825,771125,798025,825525,
  853775,882775,912525,943025,974275,1006275,1039025,1072525,1106775,1141775,
  1177525,1214025,1251275,1289275,1328025,1367525,1407775,1448775,1490525,1533025,
  1576285,1620316,1665129,1710735,1757145,1804370,1852421,1901309,1951046,2001643,
  2053112,2105465,2158714,2212871,2267948,2323957,2380910,2438820,2497699,2557560,
  2618416,2680280,2743164,2807082,2872047,2938072,3005170,3073355,3142640,3213039,
  3284566,3357235,3431060]

getMaterialImage = (idx) ->
  return "file://#{ROOT}/assets/img/material/0#{idx}.png"

TeitokuPanel = connect((state) -> 
  _.pick state, 'name', 'level', 'exp', 'sword', 'equip', 'max_sword', 'max_equip'
) React.createClass
  getInitialState: ->
    show: true
  shouldComponentUpdate: (nextProps, nextState) ->
    nextState.show
  handleVisibleResponse: (e) ->
    {visible} = e.detail
    @setState
      show: visible
  render: ->
    styleCommon =
      minWidth: '60px'
      padding: '2px'
      float: 'left'
    styleL = Object.assign {}, styleCommon, {textAlign: 'right'}
    styleR = Object.assign {}, styleCommon, {textAlign: 'left'}
    totalExp = defaultTo @props.exp, '??'
    nextExp = if @props.exp? && @props.level? then totalExpList[@props.level]-@props.exp else '??'
    debugger;
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
