express = require 'express'
routes = require './routes/harmony'
#initialize model schemas
require('./DB/models').initialize()
app = module.exports = express()


# Attaching Req/Res Middleware (Or functions that do stuff to the request)
app.configure(() -> 
  #I think this makes /views the root when referencing paths from the jades.
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.use(express.bodyParser())
  #This explicitly tells jade to handle .jade files. I could tell it to handle .html files. 
  #app.engine('.jade', require('jade').__express)
  app.use(express.methodOverride())
  app.use(express.cookieParser())
  app.use(express.session({ store: new express.session.MemoryStore({reapInterval: 50000 * 10}), secret: 'chubby bunny' }))
  #Sets public directory as web root.
  app.use(express.static(__dirname + '/public'))

  app.locals.flash = null
  # My middleware to save session info. Used by header to check if still signed in. 
  app.use((req, res, next) ->
    res.locals.session = req.session
    #console.log(req.session.flash)
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

#This is how you use app.locals
app.locals({config: { 
  lala: 'My App'}
})

#Creating route middleware (Or functions that do stuff before the response gets routed)
requiresLogin = (req, res, next) ->
  if req.session.user
    next()
  else
    res.redirect('/sessions/new?redir=' + req.url)

# Routes
app.get('/', routes.index)
app.get('/about', routes.about)
app.get('/amazon', routes.amazon)
app.get('/lastFM', routes.lastFM)
app.get('/search', requiresLogin, routes.search)
app.get('/sessions/new', routes.newSession)
app.post('/sessions/new', routes.postSession)
app.get('/users/profile', requiresLogin, routes.showUser)
app.get('/users/signout', routes.deleteSession)
app.get('/users/new', routes.newUser)
app.post('/users/new', routes.postUser)
app.get('/avatars', routes.avatars)
app.get('/ajax/lastFM/artist_info', routes.lastFM_artist_info)

app.listen(3000, () ->
  console.log("Express server listening on port: 3000" + " environment: " + app.settings.env)
)
