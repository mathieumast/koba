koba.ViewModel = class

  constructor: (@__data) ->
    @__subscriptions = []
    _.extend @, Backbone.Events
    _.extend @, @__constructViewModel @__data
    
  destroy: () ->
    @stopListening()
    for subscription in @__subscriptions
      subscription.dispose()
    
  __constructViewModel: (obj, parent, property) ->
    unless obj
      res = observe property, null, parent, @
    else if obj.attributes
      res = {}
      for elem, value of obj.attributes
        res[elem] = @__constructViewModel value, obj, elem
    else if obj.models
      tbl = []
      for value in obj.models
        tbl.push @__constructViewModel value, obj, null
      res = observeArray tbl, obj, @
    else if _.isArray obj
      tbl = []
      for value in obj
        tbl.push @__constructViewModel value, obj, null
      res = observeArray tbl, null, @
    else if _.isObject obj
      res = {}
      for elem, value of obj
        res[elem] = @__constructViewModel value, obj, elem
    else
      res = observe property, obj, parent, @
    res
    
  observe = (property, value, model, viewModel) ->
    observable = ko.observable value
    if model and property
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
