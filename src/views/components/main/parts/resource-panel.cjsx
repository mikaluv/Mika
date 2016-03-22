path = require 'path-extra'
{ROOT, layout, _, $, $$, React, ReactBootstrap, toggleModal} = window
{log, warn, error} = window
{Panel, Grid, Col} = ReactBootstrap
{connect} = require 'react-redux'
classnames = require 'classnames'
__ = i18n.main.__.bind(i18n.main)
__n = i18n.main.__n.bind(i18n.main)
{MaterialIcon} = require '../../etc/icon'

order = [1..6]

HELP_TOKEN_ID = 8

ResourcePanel = connect((state) -> 
  resource: state.info.resource
  helpToken: state.item?[HELP_TOKEN_ID]
  hasItems: !Array.isArray(state.item)
) React.createClass
  handleVisibleResponse: (e) ->
    {visible} = e.detail
    @setState
      show: visible
  render: ->
    {resource, helpToken, hasItems} = @props
    data = [
      '',
      resource?.charcoal,
      resource?.steel,
      resource?.coolant,
      resource?.file,
      if hasItems then (helpToken?.num || 0) else undefined,
      resource?.bill,
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
