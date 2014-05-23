koba.View = class extends Backbone.View

  constructor: (params = {}) ->
    super
    @data = params.data if params.data

  # bind data.
  bindData: (data) ->
    @data = data if data
    @unbindData()
    @viewModel = new koba.ViewModel @data
    ko.applyBindings @viewModel, @$el[0]
    @
    
  # unbind data.
  unbindData: ->
    if @viewModel
      ko.cleanNode @$el[0]
      @viewModel.destroy()
    @

  # Remove
  remove: ->
    @unbindData()
    @data = null
    super
    @
