// Generated by CoffeeScript 1.8.0

/*
Koba 1.0.8
Koba is a two-way data-binding library for Backbone.js using Knouckout.js. It enables Knockout's data-binding features for Backbone.
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

  koba.utils = {
    isModel: function(obj) {
      return obj && obj.attributes && obj.set && obj.on;
    },
    isCollection: function(obj) {
      return obj.models && obj.on;
    },
    isProperty: function(val) {
      return _.isNull(val) || _.isString(val) || _.isBoolean(val) || _.isNumber(val) || _.isDate(val);
    },
    fnctCall: function(fnct, context, value) {
      try {
        return fnct.call(context, value);
      } catch (_error) {}
    }
  };

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
    var observeArray, observeCollection, observeFunction, observeProperty;

    function _Class(__data) {
      this.__data = __data;
      this.__subscriptions = [];
      _.extend(this, Backbone.Events);
      _.extend(this, this.__constructViewModel(this.__data, new Backbone.Model));
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

    _Class.prototype.__constructViewModel = function(obj, parentModel, property) {
      var attr, res, tbl, value, _i, _j, _len, _len1, _ref, _ref1;
      if (koba.utils.isProperty(obj)) {
        if (koba.utils.isModel(parentModel)) {
          res = observeProperty(this, property, obj, parentModel);
        }
      } else if (koba.utils.isModel(obj)) {
        res = {};
        _ref = obj.attributes;
        for (attr in _ref) {
          value = _ref[attr];
          res[attr] = this.__constructViewModel(value, obj, attr);
        }
      } else if (koba.utils.isCollection(obj)) {
        tbl = [];
        _ref1 = obj.models;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          value = _ref1[_i];
          tbl.push(this.__constructViewModel(value));
        }
        res = observeCollection(this, tbl, obj);
      } else if (_.isFunction(obj)) {
        if (koba.utils.isModel(parentModel)) {
          res = observeFunction(this, obj, parentModel);
        }
      } else if (_.isArray(obj)) {
        tbl = [];
        for (_j = 0, _len1 = obj.length; _j < _len1; _j++) {
          value = obj[_j];
          tbl.push(this.__constructViewModel(value, parentModel));
        }
        res = observeArray(this, tbl, null);
      } else if (_.isObject(obj)) {
        res = {};
        for (attr in obj) {
          value = obj[attr];
          res[attr] = this.__constructViewModel(value, parentModel, attr);
        }
      }
      return res;
    };

    observeProperty = function(viewModel, property, value, model) {
      var observable;
      observable = ko.observable(value);
      observable.__listenCallback = function(model, value) {
        return observable(value);
      };
      observable.__subscribeCallback = function(value) {
        viewModel.stopListening(model, "change:" + property, observable.__listenCallback);
        model.set(property, value);
        return viewModel.listenTo(model, "change:" + property, observable.__listenCallback);
      };
      viewModel.listenTo(model, "change:" + property, observable.__listenCallback);
      viewModel.__subscriptions.push(observable.subscribe(observable.__subscribeCallback));
      return observable;
    };

    observeArray = function(viewModel, array, collection) {
      return ko.observableArray(array);
    };

    observeCollection = function(viewModel, array, collection) {
      var observableCollection;
      observableCollection = ko.observableArray(array);
      viewModel.listenTo(collection, "add", function(model, collection, options) {
        return observableCollection.push(viewModel.__constructViewModel(model, collection, null));
      });
      viewModel.listenTo(collection, "remove", function(model, collection, options) {
        return observableCollection.remove(model);
      });
      viewModel.listenTo(collection, "destroy", function(model, collection, options) {
        return observableCollection.remove(model);
      });
      viewModel.listenTo(collection, "reset", function(collection, options) {
        return observableCollection.removeAll();
      });
      return observableCollection;
    };

    observeFunction = function(viewModel, fnct, model) {
      var newVal, observable;
      newVal = koba.utils.fnctCall(fnct, model);
      observable = ko.observable(newVal);
      observable.__latestValue = newVal;
      observable.__listenCallback = function() {
        newVal = koba.utils.fnctCall(fnct, model);
        if (koba.utils.isProperty(newVal) && newVal !== observable.__latestValue) {
          observable(newVal);
          return observable.__latestValue = newVal;
        }
      };
      observable.__subscribeCallback = function(value) {
        viewModel.stopListening(model, "change", observable.__listenCallback);
        newVal = koba.utils.fnctCall(fnct, model, value);
        if (koba.utils.isProperty(newVal) && newVal !== observable.__latestValue) {
          observable(newVal);
          observable.__latestValue = newVal;
        }
        return viewModel.listenTo(model, "change", observable.__listenCallback);
      };
      viewModel.listenTo(model, "change", observable.__listenCallback);
      viewModel.__subscriptions.push(observable.subscribe(observable.__subscribeCallback));
      return observable;
    };

    return _Class;

  })();

}).call(this);
