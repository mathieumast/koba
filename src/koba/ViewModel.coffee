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
      res = observable property, null, parent, @
    else if obj.attributes
      res = {}
      for elem, value of obj.attributes
        res[elem] = @__constructViewModel value, obj, elem
    else if obj.models
      tbl = []
      for elem, value of obj.models
        tbl.push @__constructViewModel value, obj, elem
      res = observableArray property, tbl, obj, @
    else if _.isArray obj
      res = observableArray property, obj, parent, @
    else
      res = observable property, obj, parent, @
    res
    
  observable = (property, value, model, viewModel) ->
    obs = ko.observable value
    listenTo viewModel, model, property
    subscribe viewModel, model, obs, property
    obs

  observableArray = (property, array, collection, viewModel) ->
    ko.observableArray array
    
  listenTo = (viewModel, model, property) ->
    viewModel.listenTo model, "change:#{property}", (model, value, options) ->
      if typeof viewModel[property] is 'function'
        viewModel[property](value)
        
  subscribe = (viewModel, model, obs, property) ->
    viewModel.__subscriptions.push obs.subscribe (value) ->
      model.set(property, value)
     