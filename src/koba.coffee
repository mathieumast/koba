###
Koba 1.0.8
Koba is a two-way data-binding library for Backbone.js using Knouckout.js. It enables Knockout's data-binding features for Backbone.
Copyright (c) 2014, Mathieu MAST https://github.com/mathieumast/koba
Licensed under the MIT license
###
koba = {} unless koba

if typeof define is 'function' and define.amd
  define 'koba', [], () ->
    koba

root = exports ? @
module.exports = koba if typeof module isnt 'undefined' and module.exports
root.koba = koba
