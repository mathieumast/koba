var myModel = new Backbone.Model({
    firstName: "Planet",
    lastName: "Earth"
});
var MyView = koba.View.extend({
    el: '#content',
    render: function() {
        this.$el.html("<div id='my-view' data-bind='template: {name: \"tmpl\"}'></div>");
        myView.bindData();
    }
});
var myView = new MyView({data: myModel});
myView.render();
