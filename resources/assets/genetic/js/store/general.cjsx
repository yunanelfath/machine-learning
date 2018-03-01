EventEmitter = require('events').EventEmitter
KeyGenerator = require('./../../../components/keygenerator.cjsx')
KeyGenerator = new KeyGenerator()
_ = require('lodash')
CHANGE_EVENT = 'change'
CHANGE_ITEM_EVENT = 'change:item'

GeneralStore = _.assign({}, EventEmitter.prototype,
  form: {
    title: ''
  }

  routeAction: (attributes) ->
    if attributes.toDO == 'add_new_item'
      @newItem(attributes.attributes)
    else
      @newItem(attributes.attributes)

  cloneItem: (attributes) ->
    items = @form.items
    cloneItem = _.cloneDeep(attributes.item)
    cloneItem.name = items.length + 1
    cloneItem.id = KeyGenerator.getUniqueKey()
    items.push(cloneItem)
    @emitChange()
    @toggleActiveItem(cloneItem)

  newItem: (item) ->
    items = @form.items
    newItem = newItemForm(item.type, false, item.name, item?.id)
    items.push(newItem)
    @emitChange()
    @toggleActiveItem(newItem)

  emitChange: -> @emit(CHANGE_EVENT)
  addChangeListener: (callback) -> @addListener(CHANGE_EVENT, callback)

  emitItemChange: -> @emit(CHANGE_ITEM_EVENT)
  addItemChangeListener: (callback) -> @addListener(CHANGE_ITEM_EVENT, callback)
)

module.exports = GeneralStore
