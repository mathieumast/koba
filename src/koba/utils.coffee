koba.utils =

  isModel: (obj) ->
    return obj and obj.attributes and obj.set and obj.on
    
  isCollection: (obj) ->
    return obj.models and obj.on
  
  fnctCall: (fnct, context, value) ->
    try
      fnct.call context, value
