koba.ViewModel = class

  constructor: (@__data) ->
    @__subscriptions = []
    _.extend @, Backbone.Events
    _.extend @, @__constructViewModel @__data, new Backbone.Model
  
  # destroy viewModel
  destroy: ->
    @stopListening()
    for subscription in @__subscriptions
      subscription.dispose()
    @__subscriptions = null
    @__data = null
    
  __constructViewModel: (obj, parentModel, property) ->
    # is a property
    if koba.utils.isProperty obj
      if koba.utils.isModel parentModel
        res = observeProperty @, property, obj, parentModel
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
    res
    
  observeProperty = (viewModel, property, value, model) ->
    observable = ko.observable value
    observable.__listenCallback = (model, value) ->
      observable(value)
    observable.__subscribeCallback = (value) ->
      viewModel.stopListening model, "change:#{property}", observable.__listenCallback
      model.set(property, value)
      viewModel.listenTo model, "change:#{property}", observable.__listenCallback
    viewModel.listenTo model, "change:#{property}", observable.__listenCallback
    viewModel.__subscriptions.push observable.subscribe observable.__subscribeCallback
    observable
    
  observeArray = (viewModel, array, collection) ->
    ko.observableArray array

  observeCollection = (viewModel, array, collection) ->
    observableCollection = ko.observableArray array
    viewModel.listenTo collection, "add", (model, collection, options) ->
      observableCollection.push viewModel.__constructViewModel model, collection, null
    viewModel.listenTo collection, "remove", (model, collection, options) ->
      observableCollection.remove model
    viewModel.listenTo collection, "destroy", (model, collection, options) ->
      observableCollection.remove model
    viewModel.listenTo collection, "reset", (collection, options) ->
      observableCollection.removeAll()
    observableCollection
    
  observeFunction = (viewModel, fnct, model) ->
    newVal = koba.utils.fnctCall fnct, model
    observable = ko.observable newVal
    observable.__latestValue = newVal
    observable.__listenCallback = () ->
      newVal = koba.utils.fnctCall fnct, model
      if koba.utils.isProperty(newVal) and newVal isnt observable.__latestValue
        observable newVal
        observable.__latestValue = newVal
    observable.__subscribeCallback = (value) ->
      viewModel.stopListening model, "change", observable.__listenCallback
      newVal = koba.utils.fnctCall fnct, model, value
      if koba.utils.isProperty(newVal) and newVal isnt observable.__latestValue
        observable newVal
        observable.__latestValue = newVal
      viewModel.listenTo model, "change", observable.__listenCallback
    viewModel.listenTo model, "change", observable.__listenCallback
    viewModel.__subscriptions.push observable.subscribe observable.__subscribeCallback
    observable
