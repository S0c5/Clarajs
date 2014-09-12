app = do require 'express'
ClaraDoc = require '../../index'
ClaraDoc.bindApp(app);



app.set('views', __dirname + '/views');
app.set('view engine', 'jade');


#
# Routue Enroute
#

app.route '/'
.get (req, res)->
  res.json {msg: "welcome to API TEST"}



app.get '/docs', ClaraDoc.generate(app)


app.listen(3000, ()->
  console.log("App listen in port: 3000")
)