koba.ViewModel = class

  constructor: (@__data) ->
    @__subscriptions = []
    _.extend @, Backbone.Events
    _.extend @, @__constructViewModel @__data
  
  # destroy viewModel
  destroy: ->
    @stopListening()
    for subscription in @__subscriptions
      subscription.dispose()
    @__subscriptions = null
    @__data = null
    
  __constructViewModel: (obj, parentModel, property) ->
    # is null
    unless obj
      if koba.utils.isModel parentModel
        res = observe @, property, null, parentModel
    # is a Backbone model
    else if koba.utils.isModel obj
      res = {}
      for attr, value of obj.attributes
        res[attr] = @__constructViewModel value, obj, attr
    # is a Backbone collection
    else if koba.utils.isCollection obj
      tbl = []
      for value in obj.models
        tbl.push @__constructViewModel value
      res = observeCollection @, tbl, obj
    # is a function
    else if _.isFunction obj
      if koba.utils.isModel parentModel
        res = observeFunction @, obj, parentModel
    # is an array
    else if _.isArray obj
      tbl = []
      for value in obj
        tbl.push @__constructViewModel value, parentModel
      res = observeArray @, tbl, null
    # is an object
    else if _.isObject obj
      res = {}
      for attr, value of obj
        res[attr] = @__constructViewModel value, parentModel, attr
    # is a property
    else
      if koba.utils.isModel parentModel
        res = observe @, property, obj, parentModel
    res
    
  observe = (viewModel, property, value, model) ->
    observable = ko.observable value
    listenTo viewModel, model, observable, property
    subscribe viewModel, model, observable, property
    observable
    
  listenTo = (viewModel, model, observable, property) ->
    viewModel.listenTo model, "change:#{property}", (model, value, options) ->
      observable(value)
      
  stopListening = (viewModel, model, observable, property) ->
    viewModel.stopListening model, "change:#{property}"
        
  subscribe = (viewModel, model, observable, property) ->
    viewModel.__subscriptions.push observable.subscribe (value) ->
      stopListening viewModel, model, observable, property
      model.set(property, value)
      listenTo viewModel, model, observable, property
    
  observeArray = (viewModel, array, collection) ->
    ko.observableArray array

  observeCollection = (viewModel, array, collection) ->
    observableCollection = ko.observableArray array
    listenCollectionTo viewModel, collection, observableCollection
    observableCollection
    
  listenCollectionTo = (viewModel, collection, observableArray) ->
    viewModel.listenTo collection, "add", (model, collection, options) ->
      observableArray.push viewModel.__constructViewModel model, collection, null
    viewModel.listenTo collection, "remove", (model, collection, options) ->
      observableArray.remove model
    viewModel.listenTo collection, "destroy", (model, collection, options) ->
      observableArray.remove model
    viewModel.listenTo collection, "reset", (collection, options) ->
      observableArray.removeAll()

  observeFunction = (viewModel, fnct, model) ->
    newVal = koba.utils.fnctCall fnct, model
    observable = ko.observable newVal
    observable.__latestValue = newVal
    listenFunctionTo viewModel, model, observable, fnct
    observable
    
  listenFunctionTo = (viewModel, model, observable, fnct) ->
    viewModel.listenTo model, "change", (model, value, options) ->
      newVal = koba.utils.fnctCall fnct, model
      if newVal isnt observable.__latestValue
        observable koba.utils.fnctCall fnct, model
        observable.__latestValue = newVal
