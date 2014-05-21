## Live exemples

### Backbone model

<script type='text/html' id='tmpl-demo-model'>
    <p>First name: <input data-bind='value: firstName, valueUpdate: "keyup"' /></p>
    <p>Last name: <input data-bind='value: lastName, valueUpdate: "keyup"' /></p>
    <h2>Hello, <span data-bind='text: firstName() + " " + lastName()'></span>!</h2>
</script>
<div id='content-demo-model' class='demo'></div>

<script type="text/javascript">
/*<![CDATA[*/
function demoModel() {
var Person = Backbone.Model.extend({
    defaults: {
        firstName: "",
        lastName: ""
    }
});
var person = new Person({
    firstName: "John",
    lastName: "Smith"
});
var MyView = koba.View.extend({
    el: "#content-demo-model",
    render: function() {
        this.$el.html("<div data-bind='template: {name: \"tmpl-demo-model\"}'></div>");
        myView.bindData();
    }
});
var myView = new MyView({data: person});
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
var Person = Backbone.Model.extend({
    defaults: {
        firstName: "",
        lastName: ""
    }
});
var person = new Person({
    firstName: "John",
    lastName: "Smith"
});
var MyView = koba.View.extend({
    el: "#content-demo-model",
    render: function() {
        this.$el.html("<div id='my-view' data-bind='template: {name: \"tmpl-demo-model\"}'></div>");
        myView.bindData();
    }
});
var myView = new MyView({data: person});
myView.render();
~~~

### Backbone model & collection

<script type='text/html' id='tmpl-demo-collection'>
    <div data-bind="foreach: todos">
        <p><input data-bind='value: val, valueUpdate: "keyup"' /> <span data-bind='text: val()'></span></p>
    </div>
    <div>
        <form><input data-bind='value: todo.val' /> <button id='add' type='submit'>Add</button></form>
    </div>
</script>
<div id='content-demo-collection' class='demo'></div>

<script type="text/javascript">
/*<![CDATA[*/
function demoCollection() {
var Todo = Backbone.Model.extend({
    defaults: {val: ""}
});
var Todos = Backbone.Collection.extend({model: Todo});
var todos = new Todos([
    {val: "Try Koba"},
    {val: "Read Knockout documentation"}
]);
var todo = new Todo();
var data = {todo: todo, todos: todos};
var MyView = koba.View.extend({
    events: {"submit form": "add"},
    el: "#content-demo-collection",
    render: function() {
        this.$el.html("<div data-bind='template: {name: \"tmpl-demo-collection\"}'></div>");
        myView.bindData();
    },
    add: function(e) {
        e.preventDefault()
        todos.add(this.data.todo.toJSON());
        this.data.todo.clear();
    }
});
var myView = new MyView({data: data});
myView.render();
};
/*]]>*/
</script>

  > HTML:

~~~ html
<script type='text/html' id='tmpl-demo-collection'>
    <div data-bind="foreach: todos">
        <p><input data-bind='value: val, valueUpdate: "keyup"' /> <span data-bind='text: val()'></span></p>
    </div>
    <div>
        <form><input data-bind='value: todo.val' /> <button id='add' type='submit'>Add</button></form>
    </div>
</script>
<div id='content-demo-collection' class='demo'></div>
~~~

  > Javascript:

~~~ javascript
var Todo = Backbone.Model.extend({
    defaults: {val: ""}
});
var Todos = Backbone.Collection.extend({model: Todo});
var todos = new Todos([
    {val: "Try Koba"},
    {val: "Read Knockout documentation"}
]);
var todo = new Todo();
var data = {todo: todo, todos: todos};
var MyView = koba.View.extend({
    events: {"submit form": "add"},
    el: "#content-demo-collection",
    render: function() {
        this.$el.html("<div data-bind='template: {name: \"tmpl-demo-collection\"}'></div>");
        myView.bindData();
    },
    add: function(e) {
        e.preventDefault()
        todos.add(this.data.todo.toJSON());
        this.data.todo.clear();
    }
});
var myView = new MyView({data: data});
myView.render();
~~~



<script type="text/javascript">
/*<![CDATA[*/
window.onload = function() {
    demoModel();
    demoCollection();
}
/*]]>*/
</script>