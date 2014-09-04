// Generated by CoffeeScript 1.7.1
(function() {
  var ClaraDoc, app;

  app = require('express')();

  ClaraDoc = require('../../index');

  app.set('views', __dirname + '/views');

  app.set('view engine', 'jade');

  app.route('/').get(function(req, res) {
    return res.json({
      msg: "welcome to API TEST"
    });
  });

  app.route('/user').get(function(req, res) {
    return res.json({
      msg: "you wanna to get all users"
    });
  }).post(function(req, res) {
    return res.json({
      msg: "you wanna to create a new user"
    });
  });

  app.route('/user/:id').get(function(req, res) {
    return res.json({
      msg: "you get a user with id: " + req.params.id
    });
  })["delete"](function(req, res) {
    return res.json({
      msg: "you wanna to  delete a user "
    });
  });

  app.get('/docs', ClaraDoc.generate(app));

  app.listen(3000, function() {
    return console.log("App listen in port: 3000");
  });

}).call(this);

//# sourceMappingURL=app.map
