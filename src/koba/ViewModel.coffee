koba.ViewModel = class

  constructor: (@__data) ->
    @__subscriptions = []
    _.extend @, Backbone.Events
    _.extend @, @__constructViewModel @__data, null, null
  
  # destroy viewModel
  destroy: ->
    @stopListening()
    for subscription in @__subscriptions
      subscription.dispose()
    @__subscriptions = null
    @__data = null
    
  __constructViewModel: (obj, parentBackboneModel, property) ->
    # is null
    unless obj
      res = observe property, null, parentBackboneModel, @
    # is a Backbone model
    else if obj.attributes and obj.set and obj.on
      res = {}
      for attr, value of obj.attributes
        res[attr] = @__constructViewModel value, obj, attr
    # is a Backbone collection
    else if obj.models and obj.on
      tbl = []
      for value in obj.models
        tbl.push @__constructViewModel value, parentBackboneModel, null
      res = observeArray tbl, obj, @
    # is a function
    else if _.isFunction obj
      res = observeFunction obj, parentBackboneModel, @
    # is an array
    else if _.isArray obj
      tbl = []
      for value in obj
        tbl.push @__constructViewModel value, parentBackboneModel, null
      res = observeArray tbl, null, @
    # is an object
    else if _.isObject obj
      res = {}
      for attr, value of obj
        res[attr] = @__constructViewModel value, parentBackboneModel, attr
    # is a property
    else
      res = observe property, obj, parentBackboneModel, @
    res
    
  observe = (property, value, model, viewModel) ->
    observable = ko.observable value
    if model and model.attributes and model.set and model.on and property
      listenTo viewModel, model, observable, property
      subscribe viewModel, model, observable, property
    observable
    
  listenTo = (viewModel, model, observable, property) ->
    viewModel.listenTo model, "change:#{property}", (model, value, options) ->
      observable(value)
        
  subscribe = (viewModel, model, observable, property) ->
    viewModel.__subscriptions.push observable.subscribe (value) ->
      model.set(property, value)

  observeArray = (array, collection, viewModel) ->
    observableArray = ko.observableArray array
    if collection
      listenCollectionTo viewModel, collection, observableArray
    observableArray

  listenCollectionTo = (viewModel, collection, observableArray) ->
    viewModel.listenTo collection, "add", (model, collection, options) ->
      observableArray.push viewModel.__constructViewModel model, collection, null
    viewModel.listenTo collection, "remove", (model, collection, options) ->
      observableArray.remove model
    viewModel.listenTo collection, "destroy", (model, collection, options) ->
      observableArray.remove model
    viewModel.listenTo collection, "reset", (collection, options) ->
      observableArray.removeAll()

  observeFunction = (fnct, model, viewModel) ->
    newVal = fnctCall fnct, model
    observable = ko.observable newVal
    observable.__latestValue = newVal
    if model and model.attributes and model.set and model.on
      listenFunctionTo viewModel, model, observable, fnct
    observable
    
  listenFunctionTo = (viewModel, model, observable, fnct) ->
    viewModel.listenTo model, "change", (model, value, options) ->
      newVal = fnctCall fnct, model
      if newVal isnt observable.__latestValue
        observable fnctCall fnct, model
        observable.__latestValue = newVal
      
  fnctCall = (fnct, model) ->
    try
      fnct.call model
    finally
      null
