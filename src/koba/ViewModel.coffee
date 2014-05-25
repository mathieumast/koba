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
    
  __constructViewModel: (obj, parentObserved, parentModel, property) ->
    unless obj
      res = observe property, null, parentModel, @
    else if obj.attributes and obj.set and obj.on
      res = {}
      for attr, value of obj.attributes
        res[attr] = @__constructViewModel value, res, obj, attr
    else if obj.models and obj.on
      tbl = []
      for value in obj.models
        tbl.push @__constructViewModel value, null, obj, null
      res = observeArray tbl, obj, @
    else if _.isFunction obj
      if parentObserved
        res = compute obj, parentObserved
    else if _.isArray obj
      tbl = []
      for value in obj
        tbl.push @__constructViewModel value, null, obj, null
      res = observeArray tbl, null, @
    else if _.isObject obj
      res = {}
      for attr, value of obj
        res[attr] = @__constructViewModel value, obj, attr
    else
      res = observe property, obj, parentModel, @
    res
    
  observe = (property, value, model, viewModel) ->
    observable = ko.observable value
    if model.attributes and model.set and model.on and property
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

  compute = (fnct, context) ->
    ko.computed fnct, context
    