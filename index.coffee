methods = require 'methods'
jade = require 'jade'
path = require 'path'
Object.prototype.getName = ()->
  funcNameRegex = /function (.{1,})\(/;
  results = (funcNameRegex).exec((this).constructor.toString());
  return if (results && results.length > 1) then results[1] else "";


class ClaraDoc

  # Router Class for add functions for documentation to Express Router

  @Router =  require('./router')

  # Bind methods to app

  @bindApp = (app)->
    delete app.route

    _router_ = new @Router(app)



    app.route = _router_.route

    for m in methods
      delete app[m]
      app[m] = _router_[m]



  #method to Generate path from regular expression

  @rexToPath =  (rex, keys)->
    arrayPaths = rex.toString().split('\\/') # split rex

    subPath = ""
    i = j = 0;
    completePath = "/"

    while (i < arrayPaths.length)
      subPath = arrayPaths[i]

      if i == 0 || i >= arrayPaths.length - 2
        i++
        continue

      if subPath[0] == '('
        completePath += ':' + keys[j].name + "/"
        i++ ; j++;
      else
        completePath += subPath + "/"
      i++

    completePath[completePath.length]=''

    return completePath


  #  recursive search  in primary router for generate paths

  @document = (router) ->
    paths = []

    for route  in router
      if route.route?

        methods = Object.keys(route.route.methods)
        for m in methods
          metadata = route.route["_meta_"+m]
          endpoint =

            path: route.route.path
            method: m.toUpperCase().replace('_','')
            documentation : if metadata? then metadata else null
          paths.push( endpoint)

        continue

      if route.name == 'router'
        rootPath = @rexToPath(route.regexp, route.keys)
        endPoints = @document(route.handle.stack)

        for endPoint in endPoints
          endPoint.path = (rootPath+endPoint.path).replace('//','/')
          paths.push(endpoint)

    return paths

  @fn = (docs)->
    (req, res)->
      res.send jade.renderFile(__dirname+'/view/API.jade', {endPoints: docs})

  # generate from app
  @generate = (router)->

    if  !router.stack?
      unless router._router?
        throw new Error("You need specify ExpressJS App or Router")

      router = router._router.stack
    else
      router = router.stack
    unless router?
      throw new Error("You need specify ExpressJS App or router")

    @fn(@document(router))





module.exports = ClaraDoc
