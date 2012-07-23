
express = require 'express'
routes = require './routes/harmony'
app = module.exports = express.createServer();

# Configuration

app.configure(() -> 
  app.set('views', __dirname + '/views')
  #Specifying which layout file to use
  app.set('view options', {layout: __dirname + '/views/layouts/layout.jade'})
  app.set('view engine', 'jade')
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(express.cookieParser())
  app.use(express.session({ secret: 'your secret here' }))
  app.use(app.router)
  app.use(express.compiler({src:__dirname + '/public', enable: ["coffeescript"]}))
  #Sets public directory as web root.
  app.use(express.static(__dirname + '/public'))
)

app.configure('development', () ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))
)

app.configure('production', () ->
  app.use(express.errorHandler())
)

# Routes
app.get('/', routes.index)
app.get('/about', routes.about)
app.get('/amazon', routes.amazon)
app.get('/lastFM', routes.lastFM)
app.get('/search', routes.search)

app.listen(3000, () ->
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
);
