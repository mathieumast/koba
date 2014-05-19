koba.View = class extends Backbone.View

  initialize: (params = {}) ->
    super
    @data = params?.data

  # Render.
  render: (params = {}) ->
    super
    @data = params?.data
    bindData() if @data
  
  # bind data.
  bindData: () ->
    @unbindData()
    @viewModel = new koba.ViewModel @data
    ko.applyBindings @viewModel, @$el[0]
    
  # unbind data.
  unbindData: () ->
    if @viewModel
      ko.cleanNode @$el[0]
      @viewModel.destroy()

  # Remove
  remove: ->
    @unbindData()
    super
