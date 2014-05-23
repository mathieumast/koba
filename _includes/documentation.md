## Documentation

### Live exemples

Learn the easy way with [many live exemples]({{ site.url}}/exemples/).

### API

#### koba.ViewModel

The object ViewModel is the glue between Backbone and Knockout.
You can use it in your view implementation instead of koba.View (for exemple, if you use a framework like [ChaplinJS](http://chaplinjs.org/) or [MarionetteJS](http://marionettejs.com/)).

See exemple [Working directly with koba.ViewModel and Backbone.View]({{ site.url}}/exemples/#demo-viewmodel).

##### constructor

Initialize a new ViewModel from data.

{% highlight javascript %}
var myData = {}; // define your data
var myViewModel = new koba.ViewModel(myData);
{% endhighlight %}

##### destroy

Destroy the ViewModel (remove data-binding).

{% highlight javascript %}
myViewModel.destroy();
{% endhighlight %}

#### koba.View

koba.View manages a koba.ViewModel to bind data to DOM with Knockout.
The ViewModel livecycle is managed by the View to prevent memory leak.

koba.View extends directly from Backbone.View.

See [many exemples]({{ site.url}}/exemples/).

##### extend

Extends koba.View (see [http://backbonejs.org/#View-extend](http://backbonejs.org/#View-extend)).

{% highlight javascript %}
var MyView = koba.View.extend({
    // define your view (events, render function...)
});
{% endhighlight %}

##### constructor

With data:

{% highlight javascript %}
var myData = {}; // define your data
var myView = new MyView({data: myData}); // Create view with data
{% endhighlight %}

Without data:

{% highlight javascript %}
var myView = new MyView(); // Create view without data
{% endhighlight %}

##### render

Render the view (see [http://backbonejs.org/#View-render](http://backbonejs.org/#View-render)).

The HTML produced can use declarative bindings from Knockout (see [http://knockoutjs.com/documentation/introduction.html](http://knockoutjs.com/documentation/introduction.html)).

{% highlight javascript %}
myView.render();
{% endhighlight %}

##### bindData

Bind data with existing data in view:

{% highlight javascript %}
myView.bindData();
{% endhighlight %}

Bind data with new data (data in view is changed by the new data):

{% highlight javascript %}
var myData = {}; // define your data
myView.bindData(myData);
{% endhighlight %}

##### remove

Remove the view (see [http://backbonejs.org/#View-remove](http://backbonejs.org/#View-remove)), remove data-binding and remove data in view.

{% highlight javascript %}
myView.remove();
{% endhighlight %}

##### unbindData

Remove data-binding. Data in view is not removed.

{% highlight javascript %}
myView.unbindData();
{% endhighlight %}
