path = require 'path-extra'
{ROOT, layout, _, $, $$, React, ReactBootstrap, toggleModal} = window
{log, warn, error} = window
{Panel, Grid, Col} = ReactBootstrap
{connect} = require 'react-redux'
classnames = require 'classnames'
__ = i18n.main.__.bind(i18n.main)
__n = i18n.main.__n.bind(i18n.main)
{MaterialIcon} = require '../../etc/icon'

order = [1..4]

ResourcePanel = connect((state) -> 
  _.pick state.info, 'resource'
) React.createClass
  getInitialState: ->
    material: ['??', '??', '??', '??', '??', '??', '??', '??', '??']
    limit: 30750   # material limit of level 120
    show: true
  shouldComponentUpdate: (nextProps, nextState) ->
    nextState.show
  handleVisibleResponse: (e) ->
    {visible} = e.detail
    @setState
      show: visible
  render: ->
    resource = @props.resource
    data = [
      '',
      resource?.charcoal,
      resource?.steel,
      resource?.coolant,
      resource?.file,
    ]
    testLimit = (n) ->
      limit = resource?.max_resource
      if limit? && n?
        n < limit
      else
        false
    <Panel bsStyle="default">
      <Grid>
      {
        for i in order
          className = classnames 'material-icon',
            'glow': i <= 4 && testLimit(data[i])
          <Col key={i} xs={6} style={marginBottom: 2, marginTop: 2}>
            <MaterialIcon materialId={i} className={className} />
            <span className="material-value">{defaultTo data[i], '??'}</span>
          </Col>
      }
      </Grid>
    </Panel>

module.exports = ResourcePanel
