React = require('react')
ReactDOM = require('react-dom')
ReactBootstrap = require('react-bootstrap')
{ FormGroup, FormControl, Grid, Row, Button } = ReactBootstrap
styles = require('bootstrap-css')
{ Component } = React

knapsackItems = [
	{weight: 2, value: 12}
	{weight: 11, value: 20}
	{weight: 4, value: 5}
	{weight: 5, value: 11}
	{weight: 3, value: 50}
	{weight: 3, value: 15}
	{weight: 2, value: 6}
	{weight: 2, value: 4}
	{weight: 2, value: 5}
	{weight: 3, value: 25}
	{weight: 1, value: 30}
	{weight: 7, value: 10}
]

class Wrapper extends Component
	constructor: (props) ->
		super(props)
		@state = {
		  items: knapsackItems
			chromosomItems: []
		}

	componentDidMount: ->
		@randomingChromosom()

	resetChromosomItem: =>
		@setState(
			chromosomItems: []
		)

	randomingChromosom: =>
		{ items, chromosomItems } = @state
		@resetChromosomItem()
		i = 1
		while i <= 100
			ale = []
			k = 0
			while k <= items.length-1
				min = 0
				max = 1
				randomValue = Math.floor(Math.random() * (max - min + 1))+min
				ale.push(randomValue)
				k++
			chromosomItems.push(ale)
			i++
		console.log chromosomItems.length
		@setState(
			chromosomItems: chromosomItems
		)

	fitnessingValue: =>
		# i = 0
		# while i

	componentWillUnmount: ->
		# @listener.remove()

	_onChange: ->
		# set State every store has changed
		# @setState(
		#   form: GeneralStore.form
		# )

	onSubmit: =>
		@randomingChromosom()

	render: ->
		{ items } = @state

		<Grid>
			<FormGroup>
				Chromosom = <input type="text" name="ga[chromosom]"/><br/>
				Population = <input type="text" name="ga[population]"/><br/>
				Generation = <input type="text" name="ga[generation]"/><br/>
				CrossOver = <input type="text" name="ga[crossover]"/><br/>
				Mutation = <input type="text" name="ga[mutation]"/><br/>
			</FormGroup>
			<FormGroup>
				<Button onClick={@onSubmit.bind(@)}>Submit</Button>
			</FormGroup>
		</Grid>

Wrapper.defaultProps = {
	items: []
}

module.exports = Wrapper
