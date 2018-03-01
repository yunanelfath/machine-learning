Dispatcher = require('flux').Dispatcher
GeneralStore = require('./general.cjsx')
AppDispatcher = new Dispatcher()

AppDispatcher.register((action) ->
  switch(action.actionType)
    when 'route_action'
      GeneralStore.routeAction(action.attributes)
)
module.exports = AppDispatcher
