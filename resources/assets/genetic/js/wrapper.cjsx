React = require('react')
ReactDOM = require('react-dom')
GeneralStore = require('./store/general.cjsx')
AppDispatcher = require('./store/dispatcher.cjsx')
# TextInput = require('./components/TextInput/index.cjsx')
{ Component } = React


class Wrapper extends Component
	constructor: (props) ->
    super(props)

    @state = {
      form: GeneralStore.form
    }

  componentDidMount: ->
    @listener = GeneralStore.addChangeListener(@_onChange.bind(@)) # this/@ should bind manuallyy

  componentWillUnmount: ->
    @listener.remove()

  _onChange: ->
    # set State every store has changed
    @setState(
      form: GeneralStore.form
    )

  dispatchEvent: (attributes, actionType) =>
    # register action into dispatcher
    AppDispatcher.dispatch(
      actionType: if actionType then actionType else 'route_action'
      attributes: attributes
    )

	render: ->
    <h1>testing</h1>

module.exports = Wrapper
