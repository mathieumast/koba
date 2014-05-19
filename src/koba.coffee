###
koba 1.0.0
Allow two-way data-binding from Knockout for Backbone
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
