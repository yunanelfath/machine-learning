React = require('react')
ReactDOM = require('react-dom')
ReactBootstrap = require('react-bootstrap')
_ = require('lodash')
{ FormGroup, FormControl, Grid, Row, Button, Label } = ReactBootstrap
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
			chromosomItemsLength: 100
			chromosomItems: []
			rouletteWheelItems: []
			crossOverItems: []
		}

	componentDidMount: ->
		# @randomingChromosom()

	randomingChromosom: =>
		{ knapsackItems, chromosomItemsLength } = @state
		chromosomItems = []
		i = 1
		while i <= chromosomItemsLength
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
		return chromosomItems

	knapsackValue: (ales, i=null) =>
		k = 0
		sumFitnessItems = {}
		sumFitnessItems.weight = 0
		sumFitnessItems.value = 0
		while k <= ales.length-1
			if ales[k] != 0
				sumFitnessItems.weight += knapsackItems[k]['weight']
				sumFitnessItems.value += knapsackItems[k]['value']
				sumFitnessItems.key = i
			k++
		if sumFitnessItems.weight > 20
			sumFitnessItems = null

		return sumFitnessItems

	fitnessingFormula: (chromosomItems) =>
		{ knapsackItems } = @state
		fitnessValue = []
		i = 0
		while i <= chromosomItems.length-1
			sumFitnessItems = @knapsackValue(chromosomItems[i], i)
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

	mutationRateValue: (child1, child2) =>
		i = 0
		mutation1 = []
		mutation2 = []
		filled = false
		while mutation1.length != child1.length
			if child1[i] != child2[i] && !filled
				mutation1.push(key: i, value: child2[i])
				mutation2.push(key: i, value: child1[i])
				filled = true
			else
				mutation1.push(key: i, value: child1[i])
				mutation2.push(key: i, value: child2[i])
			i++
		j = 0
		mutation1 = _.orderBy(mutation1, ['key'], ['asc'])
		mutation2 = _.orderBy(mutation2, ['key'], ['asc'])
		resultMutation1 = []
		resultMutation2 = []
		while j < mutation1.length
			resultMutation1.push(mutation1[j].value)
			resultMutation2.push(mutation2[j].value)
			j++
		resultKnapsack1 = @knapsackValue(resultMutation1)
		resultKnapsack2 = @knapsackValue(resultMutation2)
		return [{knapsack: resultKnapsack1, value: resultMutation1}, {knapsack: resultKnapsack2, value: resultMutation2}]

	crossOverLoop: (induk1, induk2, childrenNumber=0, finalChildren=[]) =>
		maxRand = induk1.length-1
		singlePointCrossOver = Math.floor(Math.random() * (maxRand - 0 + 1))+0
		lengthPointCrossOver = 8
		startpoint = if maxRand-singlePointCrossOver > singlePointCrossOver then maxRand else 0

		k = startpoint
		anak1 = []
		anak2 = []
		while anak1.length-1 != induk1.length-1
			if anak1.length >= lengthPointCrossOver
				anak1.push(key: k, value: induk1[k])
				anak2.push(key: k, value: induk2[k])
			else
				anak1.push(key: k, value: induk2[k])
				anak2.push(key: k, value: induk1[k])
			if startpoint == 0
				k++
			else
				k--
		anak1 = _.orderBy(anak1, ['key'], ['asc'])
		anak2 = _.orderBy(anak2, ['key'], ['asc'])
		childrens = [anak1, anak2]

		j = 0
		resultChildrens = []
		while j < childrens.length
			l = 0
			childrenAle = []
			knapsackItem = {}
			while l < childrens[j].length
				childrenAle.push(childrens[j][l].value)
				l++
			knapsackValue = @knapsackValue(childrenAle)
			knapsackItem = ale: childrenAle, value: knapsackValue, key: childrenNumber
			if knapsackValue != null
				resultChildrens.push(knapsackItem)
			j++
		if resultChildrens.length == 2
			mutationRate = @mutationRateValue(resultChildrens[0].ale, resultChildrens[1].ale)
			resultChildrens.push(mutation: mutationRate)
			childrenNumber += 1
			if childrenNumber < 40
				@crossOverLoop(resultChildrens[0].ale, resultChildrens[1].ale, childrenNumber, finalChildren)
		finalChildren.push(resultChildrens)

		return finalChildren

	crossOvering: (items, chromosomItems) =>
		resultItems = []
		i = 0
		while i < items.length
			induk1 = chromosomItems[items[i].first.key]
			induk2 = chromosomItems[items[i].second.key]
			crossOver = @crossOverLoop(induk1, induk2)
			attributes = childrens: crossOver, first: items[i].first, second: items[i].second
			resultItems.push(attributes)
			i++

		return resultItems

	onSubmit: =>
		chromosomItems = @randomingChromosom() #generate chromosom
		rouletteWheel = @fitnessingFormula(chromosomItems) # fitness value & roulette wheel selection
		# debugger
		# next step cross over & mutation
		couples = @coupleingItems(rouletteWheel)
		crossOver = @crossOvering(couples, chromosomItems)
		@setState(
			rouletteWheelItems: rouletteWheel
			crossOverItems: crossOver
			chromosomItems: chromosomItems
		)

	render: ->
		{ items, chromosomItems, rouletteWheelItems, crossOverItems, chromosomItemsLength } = @state

		chromosomRowItem = (item, index) =>
			tdItem = (i, k) =>
				<td key={k} style={width: '30px', textAlign: 'center'}>{i}</td>
			<tr key={index} style={borderBottom: '1px solid #ebebeb'}>
				{
					<td style={borderRight: '1px solid #ebebeb', width: '130px'}>Chromosom {index}</td>
				}
				{
					item.map(tdItem)
				}
			</tr>
		historyRowItem = (item, index) =>
			<tr key={index} style={borderBottom: '1px solid #ebebeb'}>
				{
					<td>chromosom {item.first.key}x{item.second.key};{item.childrens.length} childrens+mutation</td>
				}
			</tr>

		<Grid>
			<FormGroup>
				Chromosom = <input type="text" name="ga[chromosom]" value={chromosomItemsLength} disabled={true}/><br/>
				CrossOver = <input type="text" name="ga[crossover]" value={'40%'} disabled={true}/><br/>
				Mutation = <input type="text" name="ga[mutation]" value={'40%'} disabled={true}/><br/>
			</FormGroup>
			<FormGroup>
				<Button onClick={@onSubmit.bind(@)}>Submit</Button>
			</FormGroup>
			{
				if chromosomItems
					<div>
						<FormGroup style={height: '300px', overflowY: 'scroll', width: '470px', margin: 0, float: 'left'}>
							<Label style={background: '#dadade'}>Chromosom Set</Label>
							<table>
								<tbody>
									{
										chromosomItems.map(chromosomRowItem)
									}
								</tbody>
							</table>
						</FormGroup>
						<FormGroup style={height: '300px', overflowY: 'scroll', width: '470px', margin: 0, float: 'left'}>
							<Label style={background: '#dadade'}>History</Label>
							<table>
								<tbody>
									{
										crossOverItems.map(historyRowItem)
									}
								</tbody>
							</table>
						</FormGroup>
						{
							if rouletteWheelItems.length > 0
								<div>
									<div style={background: '#dadade', display: 'inline-block'}>
										Best Fitness,chromosom {rouletteWheelItems[0].key}, value {rouletteWheelItems[0].value}, weight {rouletteWheelItems[0].weight}
									</div>
									<br/>
								</div>
						}
						{
							if crossOverItems.length > 0
								capacity = _.orderBy(crossOverItems, ['childrens'], ['desc'])
								<div style={background: '#dadade', display: 'inline-block'}>
									Best result to capacity,chromosom {capacity[0].first.key}, value {capacity[0].first.value}, weight {capacity[0].first.weight}
								</div>
						}
					</div>
			}
		</Grid>

Wrapper.defaultProps = {
	items: []
}

module.exports = Wrapper
