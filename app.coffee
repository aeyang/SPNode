express = require 'express'
routes = require './routes/harmony'
app = module.exports = express()
#MemStore = require 'express/node_modules/connect/lib/middleware/session/memory'

# Attaching Req/Res Middleware (Or functions that do stuff to the request)
app.configure(() -> 
  #I think this makes /views the root when referencing paths from the jades.
  app.set('views', __dirname + '/views')
  #app.set is still valid.
  app.set('view engine', 'jade')
  app.use(express.bodyParser())
  #This explicitly tells jade to handle .jade files. I could tell it to handle .html files. 
  #app.engine('.jade', require('jade').__express)
  app.use(express.methodOverride())
  app.use(express.cookieParser())
  app.use(express.session({ store: new express.session.MemoryStore({reapInterval: 50000 * 10}), secret: 'chubby bunny' }))
  #app.use(app.router)
  #app.use(express.compiler({src:__dirname + '/public', enable: ["coffeescript"]}))
  #Sets public directory as web root.
  app.use(express.static(__dirname + '/public'))
  app.use((req, res, next) ->
    #console.log("In Middleware. Request is for " + req.path)
    res.locals.session = req.session
    next()
  )
  app.use(app.router)
)

app.configure('development', () ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))
)

app.configure('production', () ->
  app.use(express.errorHandler())
)

#Creating route middleware (Or functions that do stuff before the response gets routed)
requiresLogin = (req, res, next) ->
  #console.log("In requiresLogin. req.session.user is " + req.session.user)
  if req.session.user
    next()
  else
    res.redirect('/sessions/new?redir=' + req.url)

# Routes
app.get('/', requiresLogin, routes.index)
app.get('/about', routes.about)
app.get('/amazon', routes.amazon)
app.get('/lastFM', routes.lastFM)
app.get('/search', routes.search)
app.get('/sessions/new', routes.newSession)
app.post('/sessions/new', routes.postSession)

app.listen(3000, () ->
  console.log("Express server listening on port: 3000" + " environment: " + app.settings.env)
)

### Someone smarter's server config

app.configure(function(){
  var pub_dir = __dirname + '/public';
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  app.use(express.session({ secret: nconf.get("site:secret") }));
  app.use(everyauth.middleware());  
  app.use(require('less-middleware')({ src: pub_dir, force:true }));
  app.use(express.static(pub_dir)); 
  app.use(app.router);
  app.use(logErrors);
  app.use(clientErrorHandler);
  app.use(errorHandler);
});
###