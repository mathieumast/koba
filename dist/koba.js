
/*
Koba 1.0.5
Bridge between Knockout and Backbone.
Copyright (c) 2014, Mathieu MAST https://github.com/mathieumast/koba
Licensed under the MIT license
 */

(function() {
  var koba, root,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  if (!koba) {
    koba = {};
  }

  if (typeof define === 'function' && define.amd) {
    define('koba', [], function() {
      return koba;
    });
  }

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = koba;
  }

  root.koba = koba;

  koba.View = (function(_super) {
    __extends(_Class, _super);

    function _Class(params) {
      if (params == null) {
        params = {};
      }
      _Class.__super__.constructor.apply(this, arguments);
      if (params.data) {
        this.data = params.data;
      }
    }

    _Class.prototype.bindData = function(data) {
      if (data) {
        this.data = data;
      }
      this.unbindData();
      this.viewModel = new koba.ViewModel(this.data);
      ko.applyBindings(this.viewModel, this.$el[0]);
      return this;
    };

    _Class.prototype.unbindData = function() {
      if (this.viewModel) {
        ko.cleanNode(this.$el[0]);
        this.viewModel.destroy();
      }
      return this;
    };

    _Class.prototype.remove = function() {
      this.unbindData();
      this.data = null;
      _Class.__super__.remove.apply(this, arguments);
      return this;
    };

    return _Class;

  })(Backbone.View);

  koba.ViewModel = (function() {
    var fnctCall, listenCollectionTo, listenFunctionTo, listenTo, observe, observeArray, observeFunction, stopListening, subscribe;

    function _Class(__data) {
      this.__data = __data;
      this.__subscriptions = [];
      _.extend(this, Backbone.Events);
      _.extend(this, this.__constructViewModel(this.__data, null, null));
    }

    _Class.prototype.destroy = function() {
      var subscription, _i, _len, _ref;
      this.stopListening();
      _ref = this.__subscriptions;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        subscription = _ref[_i];
        subscription.dispose();
      }
      this.__subscriptions = null;
      return this.__data = null;
    };

    _Class.prototype.__constructViewModel = function(obj, parentBackboneModel, property) {
      var attr, res, tbl, value, _i, _j, _len, _len1, _ref, _ref1;
      if (!obj) {
        res = observe(property, null, parentBackboneModel, this);
      } else if (obj.attributes && obj.set && obj.on) {
        res = {};
        _ref = obj.attributes;
        for (attr in _ref) {
          value = _ref[attr];
          res[attr] = this.__constructViewModel(value, obj, attr);
        }
      } else if (obj.models && obj.on) {
        tbl = [];
        _ref1 = obj.models;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          value = _ref1[_i];
          tbl.push(this.__constructViewModel(value, parentBackboneModel, null));
        }
        res = observeArray(tbl, obj, this);
      } else if (_.isFunction(obj)) {
        res = observeFunction(obj, parentBackboneModel, this);
      } else if (_.isArray(obj)) {
        tbl = [];
        for (_j = 0, _len1 = obj.length; _j < _len1; _j++) {
          value = obj[_j];
          tbl.push(this.__constructViewModel(value, parentBackboneModel, null));
        }
        res = observeArray(tbl, null, this);
      } else if (_.isObject(obj)) {
        res = {};
        for (attr in obj) {
          value = obj[attr];
          res[attr] = this.__constructViewModel(value, parentBackboneModel, attr);
        }
      } else {
        res = observe(property, obj, parentBackboneModel, this);
      }
      return res;
    };

    observe = function(property, value, model, viewModel) {
      var observable;
      observable = ko.observable(value);
      if (model && model.attributes && model.set && model.on && property) {
        listenTo(viewModel, model, observable, property);
        subscribe(viewModel, model, observable, property);
      }
      return observable;
    };

    listenTo = function(viewModel, model, observable, property) {
      return viewModel.listenTo(model, "change:" + property, function(model, value, options) {
        return observable(value);
      });
    };

    stopListening = function(viewModel, model, observable, property) {
      return viewModel.stopListening(model, "change:" + property);
    };

    subscribe = function(viewModel, model, observable, property) {
      return viewModel.__subscriptions.push(observable.subscribe(function(value) {
        stopListening(viewModel, model, observable, property);
        model.set(property, value);
        return listenTo(viewModel, model, observable, property);
      }));
    };

    observeArray = function(array, collection, viewModel) {
      var observableArray;
      observableArray = ko.observableArray(array);
      if (collection) {
        listenCollectionTo(viewModel, collection, observableArray);
      }
      return observableArray;
    };

    listenCollectionTo = function(viewModel, collection, observableArray) {
      viewModel.listenTo(collection, "add", function(model, collection, options) {
        return observableArray.push(viewModel.__constructViewModel(model, collection, null));
      });
      viewModel.listenTo(collection, "remove", function(model, collection, options) {
        return observableArray.remove(model);
      });
      viewModel.listenTo(collection, "destroy", function(model, collection, options) {
        return observableArray.remove(model);
      });
      return viewModel.listenTo(collection, "reset", function(collection, options) {
        return observableArray.removeAll();
      });
    };

    observeFunction = function(fnct, model, viewModel) {
      var newVal, observable;
      newVal = fnctCall(fnct, model);
      observable = ko.observable(newVal);
      observable.__latestValue = newVal;
      if (model && model.attributes && model.set && model.on) {
        listenFunctionTo(viewModel, model, observable, fnct);
      }
      return observable;
    };

    listenFunctionTo = function(viewModel, model, observable, fnct) {
      return viewModel.listenTo(model, "change", function(model, value, options) {
        var newVal;
        newVal = fnctCall(fnct, model);
        if (newVal !== observable.__latestValue) {
          observable(fnctCall(fnct, model));
          return observable.__latestValue = newVal;
        }
      });
    };

    fnctCall = function(fnct, model) {
      try {
        return fnct.call(model);
      } finally {
        null;
      }
    };

    return _Class;

  })();

}).call(this);
