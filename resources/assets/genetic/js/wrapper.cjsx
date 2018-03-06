React = require('react')
ReactDOM = require('react-dom')
ReactBootstrap = require('react-bootstrap')
_ = require('lodash')
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
		  knapsackItems: knapsackItems
			chromosomItems: []
		}

	componentDidMount: ->
		@randomingChromosom()

	randomingChromosom: =>
		{ knapsackItems, chromosomItems } = @state
		chromosomItems = []
		i = 1
		while i <= 20
			ale = []
			k = 0
			while k < knapsackItems.length
				min = 0
				max = 1
				randomValue = Math.floor(Math.random() * (max - min + 1))+min
				ale.push(randomValue)
				k++
			chromosomItems.push(ale)
			i++
		# console.log chromosomItems
		@setState(
			chromosomItems: chromosomItems
		)

	fitnessingFormula: =>
		{ chromosomItems, knapsackItems } = @state
		fitnessValue = []
		i = 0
		while i <= chromosomItems.length-1
			k = 0
			sumFitnessItems = {}
			sumFitnessItems.weight = 0
			sumFitnessItems.value = 0
			while k <= chromosomItems[i].length-1
				if chromosomItems[i][k] != 0
					sumFitnessItems.weight += knapsackItems[k]['weight']
					sumFitnessItems.value += knapsackItems[k]['value']
					sumFitnessItems.key = i
				k++
			if sumFitnessItems.weight > 20
				sumFitnessItems = null
			fitnessValue.push(sumFitnessItems)
			i++
		sortNFilter = _.filter(_.orderBy(fitnessValue, ['value'], ['desc']), (e) => e != null )

		return sortNFilter



	componentWillUnmount: ->
		# @listener.remove()

	_onChange: ->
		# set State every store has changed
		# @setState(
		#   form: GeneralStore.form
		# )

	coupleingItems: (rouletteWheelItems) =>
		items = []
		singleItems = []
		excludeItems = []
		i = 0
		while i < rouletteWheelItems.length
			if !_.includes(excludeItems, rouletteWheelItems[i]['key'])
				nextKeyIndex = i+1
				if rouletteWheelItems[nextKeyIndex]
					nextIndex = rouletteWheelItems[nextKeyIndex]
					fillWith = first: rouletteWheelItems[i], second: nextIndex
					items.push(fillWith)
					excludeItems.push(nextIndex['key'])
				else
					singleItems.push(rouletteWheelItems[i])
			i++

		return items

	crossOvering: (items) =>
		{ chromosomItems } = @state
		resultItems = []
		i = 0
		while i < items.length
			induk1 = chromosomItems[items[i].first.key]
			induk2 = chromosomItems[items[i].second.key]
			maxRand = induk1.length-1
			singlePointCrossOver = Math.floor(Math.random() * (maxRand - 0 + 1))+0
			startpoint = if maxRand-singlePointCrossOver > singlePointCrossOver then maxRand else 0

			k = startpoint
			anak1 = []
			anak2 = []
			fulled = false
			debugger
			while anak1.length-1 != induk1.length-1
				if anak1.length >= 4
					anak1.push(key: k, value: induk1[k])
					anak2.push(key: k, value: induk2[k])
				else
					anak1.push(key: k, value: induk2[k])
					anak2.push(key: k, value: induk1[k])
				if startpoint == 0
					k++
				else
					k--
			anak1 = _.orderBy(anak1, ['key'], ['desc'])
			anak2 = _.orderBy(anak2, ['key'], ['desc'])
			anak = first: anak1, second: anak2
			attributes = childrens: anak, first: items[i].first, second: items[i].second
			debugger
			resultItems.push(attributes)

		return resultItems

	onSubmit: =>
		@randomingChromosom() #generate chromosom
		rouletteWheel = @fitnessingFormula() # fitness value & roulette wheel selection
		# debugger
		# next step cross over & mutation
		couples = @coupleingItems(rouletteWheel)
		crossOver = @crossOvering(couples)
		console.log rouletteWheel
		console.log crossOver
		debugger

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
