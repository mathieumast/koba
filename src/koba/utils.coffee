koba.utils =

  isModel: (obj) ->
    return obj and obj.attributes and obj.set and obj.on
    
  isCollection: (obj) ->
    return obj.models and obj.on
    
  isProperty: (val) ->
    return _.isNull(val) or _.isString(val) or _.isBoolean(val) or _.isNumber(val) or _.isDate(val)
  
  fnctCall: (fnct, context, value) ->
    try
      fnct.call context, value
