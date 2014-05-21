## Live examples

### Backbone model live example

<script type='text/html' id='tmpl-demo-model'>
    <p>First name: <input data-bind='value: firstName, valueUpdate: "keyup"' /></p>
    <p>Last name: <input data-bind='value: lastName, valueUpdate: "keyup"' /></p>
    <h2>Hello, <span data-bind='text: firstName() + " " + lastName()'></span>!</h2>
</script>
<div id='content-demo-model' class='demo'></div>
<script type="text/javascript">
/*<![CDATA[*/
window.onload = function() {
var myModel = new Backbone.Model({
    firstName: "John",
    lastName: "Smith"
});
var MyView = koba.View.extend({
    el: '#content-demo-model',
    render: function() {
        this.$el.html("<div id='my-view' data-bind='template: {name: \"tmpl-demo-model\"}'></div>");
        myView.bindData();
    }
});
var myView = new MyView({data: myModel});
myView.render();
};
/*]]>*/
</script>


  > HTML:

~~~ html
<script type='text/html' id='tmpl-demo-model'>
    <p>First name: <input data-bind='value: firstName, valueUpdate: "keyup"' /></p>
    <p>Last name: <input data-bind='value: lastName, valueUpdate: "keyup"' /></p>
    <h2>Hello, <span data-bind='text: firstName() + " " + lastName()'></span>!</h2>
</script>
<div id='content-demo-model' class='demo'></div>
~~~

  > Javascript:

~~~ javascript
var myModel = new Backbone.Model({
    firstName: "John",
    lastName: "Smith"
});
var MyView = koba.View.extend({
    el: '#content-demo-model',
    render: function() {
        this.$el.html("<div id='my-view' data-bind='template: {name: \"tmpl-demo-model\"}'></div>");
        myView.bindData();
    }
});
var myView = new MyView({data: myModel});
myView.render();
~~~
