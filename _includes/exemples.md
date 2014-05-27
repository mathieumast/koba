## Live exemples

### <a name='demo-model'></a> Working with koba.View and Backbone model

<script type='text/html' id='tmpl-demo-model'>
    <p>First name: <input data-bind='value: firstName, valueUpdate: "keyup"' /></p>
    <p>Last name: <input data-bind='value: lastName, valueUpdate: "keyup"' /></p>
    <h2 data-bind='text: fullName'></h2>
</script>
<div id='content-demo-model' class='demo'></div>

<script type="text/javascript">
/*<![CDATA[*/
function demoModel() {
var Person = Backbone.Model.extend({
    defaults: {
        firstName: "",
        lastName: "",
        fullName: function() { 
            return this.get("firstName") + " " + this.get("lastName");
        }
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
        return this;
    }
});
var myView = new MyView({data: person});
myView.render().bindData();
};
/*]]>*/
</script>

  > HTML:

{% highlight html %}
<script type='text/html' id='tmpl-demo-model'>
    <p>First name: <input data-bind='value: firstName, valueUpdate: "keyup"' /></p>
    <p>Last name: <input data-bind='value: lastName, valueUpdate: "keyup"' /></p>
    <h2 data-bind='text: fullName'></h2>
</script>
<div id='content-demo-model' class='demo'></div>
{% endhighlight %}

  > Javascript:

{% highlight javascript %}
var Person = Backbone.Model.extend({
    defaults: {
        firstName: "",
        lastName: "",
        fullName: function() { 
            return this.get("firstName") + " " + this.get("lastName");
        }
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
        return this;
    }
});
var myView = new MyView({data: person});
myView.render().bindData();
{% endhighlight %}

### <a name='demo-collection'></a> Working with koba.View and Backbone model & collection

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
        return this;
    },
    add: function(e) {
        e.preventDefault()
        todos.add(this.data.todo.toJSON());
        this.data.todo.clear();
    }
});
var myView = new MyView({data: data});
myView.render().bindData();
};
/*]]>*/
</script>

  > HTML:

{% highlight html %}
<script type='text/html' id='tmpl-demo-collection'>
    <div data-bind="foreach: todos">
        <p><input data-bind='value: val, valueUpdate: "keyup"' /> <span data-bind='text: val()'></span></p>
    </div>
    <div>
        <form><input data-bind='value: todo.val' /> <button id='add' type='submit'>Add</button></form>
    </div>
</script>
<div id='content-demo-collection' class='demo'></div>
{% endhighlight %}

  > Javascript:

{% highlight javascript %}
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
        return this;
    },
    add: function(e) {
        e.preventDefault()
        todos.add(this.data.todo.toJSON());
        this.data.todo.clear();
    }
});
var myView = new MyView({data: data});
myView.render().bindData();
{% endhighlight %}

### <a name='demo-nested'></a> Working with koba.View and Backbone nested model & collection

<script type='text/html' id='tmpl-demo-nested'>
    <p>First name: <input data-bind='value: firstName, valueUpdate: "keyup"' /></p>
    <p>Last name: <input data-bind='value: lastName, valueUpdate: "keyup"' /></p>
    <h2 data-bind='text: fullName'></h2>
    <p style='padding-left: 1rem;'>Address:</p>
    <p style='padding-left: 3rem;'><input data-bind='value: address.number, valueUpdate: "keyup"' /> <input data-bind='value: address.street, valueUpdate: "keyup"' /></p>
    <p style='padding-left: 3rem;'><input data-bind='value: address.zipCode, valueUpdate: "keyup"' /> <input data-bind='value: address.city, valueUpdate: "keyup"' /></p>
    <h2 data-bind='text: address.fullAddress'></h2>
    <p style='padding-left: 1rem;'>Phones:</p>
    <div data-bind="foreach: phones">
        <p style='padding-left: 3rem;'><input data-bind='value: number, valueUpdate: "keyup"' /> <span data-bind='text: number()'></span></p>
    </div>
</script>
<div id='content-demo-nested' class='demo'></div>

<script type="text/javascript">
/*<![CDATA[*/
function demoNested() {
var Address = Backbone.Model.extend({
    defaults: {
        number: "",
        street: "",
        zipCode: "",
        city: "",
        fullAddress: function() { 
            return this.get("number") + " " + this.get("street") + " " + this.get("zipCode") + " " + this.get("city");
        }
    }
});
var Phone = Backbone.Model.extend({
    defaults: {
        number: ""
    }
});
var Phones = Backbone.Collection.extend({model: Phone});
var Person = Backbone.Model.extend({
    defaults: {
        firstName: "",
        lastName: "",
        fullName: function() { 
            return this.get("firstName") + " " + this.get("lastName");
        },
        address: new Address(),
        phones: new Phones()
    }
});
var person = new Person({
    firstName: "John",
    lastName: "Smith",
    address: new Address({
        number: "41",
        street: "rue de la République",
        zipCode: "69002",
        city: "Lyon"
    }),
    phones: new Phones([
        {number: "12345678"},
        {number: "87654321"}
    ])
});
var MyView = koba.View.extend({
    el: "#content-demo-nested",
    render: function() {
        this.$el.html("<div data-bind='template: {name: \"tmpl-demo-nested\"}'></div>");
        return this;
    }
});
var myView = new MyView({data: person});
myView.render().bindData();
};
/*]]>*/
</script>

  > HTML:

{% highlight html %}
<script type='text/html' id='tmpl-demo-nested'>
    <p>First name: <input data-bind='value: firstName, valueUpdate: "keyup"' /></p>
    <p>Last name: <input data-bind='value: lastName, valueUpdate: "keyup"' /></p>
    <h2 data-bind='text: fullName'></h2>
    <p style='padding-left: 1rem;'>Address:</p>
    <p style='padding-left: 3rem;'><input data-bind='value: address.number, valueUpdate: "keyup"' /> <input data-bind='value: address.street, valueUpdate: "keyup"' /></p>
    <p style='padding-left: 3rem;'><input data-bind='value: address.zipCode, valueUpdate: "keyup"' /> <input data-bind='value: address.city, valueUpdate: "keyup"' /></p>
    <h2 data-bind='text: address.fullAddress'></h2>
    <p style='padding-left: 1rem;'>Phones:</p>
    <div data-bind="foreach: phones">
        <p style='padding-left: 3rem;'><input data-bind='value: number, valueUpdate: "keyup"' /> <span data-bind='text: number()'></span></p>
    </div>
</script>
<div id='content-demo-nested' class='demo'></div>
{% endhighlight %}

  > Javascript:

{% highlight javascript %}
var Address = Backbone.Model.extend({
    defaults: {
        number: "",
        street: "",
        zipCode: "",
        city: "",
        fullAddress: function() { 
            return this.get("number") + " " + this.get("street") + " " + this.get("zipCode") + " " + this.get("city");
        }
    }
});
var Phone = Backbone.Model.extend({
    defaults: {
        number: ""
    }
});
var Phones = Backbone.Collection.extend({model: Phone});
var Person = Backbone.Model.extend({
    defaults: {
        firstName: "",
        lastName: "",
        fullName: function() { 
            return this.get("firstName") + " " + this.get("lastName");
        },
        address: new Address(),
        phones: new Phones()
    }
});
var person = new Person({
    firstName: "John",
    lastName: "Smith",
    address: new Address({
        number: "41",
        street: "rue de la République",
        zipCode: "69002",
        city: "Lyon"
    }),
    phones: new Phones([
        {number: "12345678"},
        {number: "87654321"}
    ])
});
var MyView = koba.View.extend({
    el: "#content-demo-nested",
    render: function() {
        this.$el.html("<div data-bind='template: {name: \"tmpl-demo-nested\"}'></div>");
        return this;
    }
});
var myView = new MyView({data: person});
myView.render().bindData();
{% endhighlight %}

### <a name="demo-viewmodel"></a> Working directly with koba.ViewModel and Backbone.View

<script type='text/html' id='tmpl-demo-viewmodel'>
    <p>First name: <input data-bind='value: firstName, valueUpdate: "keyup"' /></p>
    <p>Last name: <input data-bind='value: lastName, valueUpdate: "keyup"' /></p>
    <h2 data-bind='text: fullName'></h2>
</script>
<div id='content-demo-viewmodel' class='demo'></div>

<script type="text/javascript">
/*<![CDATA[*/
function demoViewModel() {
var Person = Backbone.Model.extend({
    defaults: {
        firstName: "",
        lastName: "",
        fullName: function() { 
            return this.get("firstName") + " " + this.get("lastName");
        }
    }
});
var person = new Person({
    firstName: "John",
    lastName: "Smith"
});
var myViewModel = new koba.ViewModel(person);
var MyView = Backbone.View.extend({
    el: "#content-demo-viewmodel",
    initialize: function(params) {
        this.data = params.data;
    },
    render: function() {
        if (this.viewModel) {
            ko.cleanNode(this.$el[0]);
            this.viewModel.destroy();
        }  
        this.$el.html("<div data-bind='template: {name: \"tmpl-demo-viewmodel\"}'></div>");
        this.viewModel = new koba.ViewModel(this.data);
        ko.applyBindings(this.viewModel, this.$el[0]);
        return this;
    }
});
var myView = new MyView({data: person});
myView.render();
};
/*]]>*/
</script>

  > HTML:

{% highlight html %}
<script type='text/html' id='tmpl-demo-viewmodel'>
    <p>First name: <input data-bind='value: firstName, valueUpdate: "keyup"' /></p>
    <p>Last name: <input data-bind='value: lastName, valueUpdate: "keyup"' /></p>
    <h2 data-bind='text: fullName'></h2>
</script>
<div id='content-demo-viewmodel' class='demo'></div>
{% endhighlight %}

  > Javascript:

{% highlight javascript %}
var Person = Backbone.Model.extend({
    defaults: {
        firstName: "",
        lastName: "",
        fullName: function() { 
            return this.get("firstName") + " " + this.get("lastName");
        }
    }
});
var person = new Person({
    firstName: "John",
    lastName: "Smith"
});
var myViewModel = new koba.ViewModel(person);
var MyView = Backbone.View.extend({
    el: "#content-demo-viewmodel",
    initialize: function(params) {
        this.data = params.data;
    },
    render: function() {
        if (this.viewModel) {
            ko.cleanNode(this.$el[0]);
            this.viewModel.destroy();
        }  
        this.$el.html("<div data-bind='template: {name: \"tmpl-demo-viewmodel\"}'></div>");
        this.viewModel = new koba.ViewModel(this.data);
        ko.applyBindings(this.viewModel, this.$el[0]);
        return this;
    }
});
var myView = new MyView({data: person});
myView.render();
{% endhighlight %}




<script type="text/javascript">
/*<![CDATA[*/
window.onload = function() {
    demoModel();
    demoCollection();
    demoNested();
    demoViewModel();
}
/*]]>*/
</script>