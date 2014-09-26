app = do require 'express'
ClaraDoc = require '../../index'
#ClaraDoc.bindApp(app);



app.set('views', __dirname + '/views');
app.set('view engine', 'jade');


#
# Routue Enroute
#


router = require('express').Router()

router.route '/bind'
.get (req, res, next)->
      req.user = "David barinas"
      next()
    ,(req, res)->
      res.json {msg: req.user}

app.use router
app.get '/docs', ClaraDoc.generate(router)


app.listen(3000, ()->
  console.log("App listen in port: 3000")
)