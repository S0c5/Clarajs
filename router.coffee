methods = require('methods')
express = require('express')

class Router
  _route: null
  _router_: null
  _routeMiddleWare : {}
  bindRoute: (m) ->
    self = @
    (fn, doc) ->
      console.log "dispatch: #{m} fn #{fn}"
      self._route["_meta_"+m] = doc
      self._route[m](fn)
      return self._routeMiddleWare

  bindMethod : (m) ->
    console.log "binded " + m

    self = @

    (route, fn, doc) ->

      self._router_["_meta_"+m] = doc
      self._router_[m](route, fn)

      return self._router_


  constructor: (router = (require('express').Router()))->

    self = @

    @_router_ = router

    for method in methods
      @_routeMiddleWare[method] = @bindRoute(method)
      @[method] = @bindMethod(method)

    console.log "here"


  route: (path) ->
    @_route = @_router_.route path
    return @_routeMiddleWare


  router:()->
    @_router_


module.exports  = Router