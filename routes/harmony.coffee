#Controllers

users = require '../DB/users'

#GET home page
exports.index = (req, res) ->
  res.render('index', { title: 'Home' })

#  GET about page
exports.about = (req, res) ->
  res.render('about', { title: 'About'}) 

# GET amazon page
exports.amazon = (req, res) ->
  res.render('amazon', {title: 'Amazon'})

# GET lastFM page
exports.lastFM = (req, res) ->
  res.render('lastFM', {title: 'LastFM'})

#GET search page
exports.search = (req, res) ->
  res.render('search', {title: 'Search'})

#GET session/new
exports.newSession = (req, res) ->
  res.render('sessions/new', {title: 'New', redirect: req.query.redir})

#POST session/new
exports.postSession = (req, res) ->
  users.authenticate(req.body.login, req.body.password, (err, user) ->
    if(user)
      req.session.user = user
      res.redirect(req.body.redirect || '/')
    else
      res.locals.flash = err
      res.render('sessions/new', {title: 'Try Again!', redirect: req.body.redirect})
  )

exports.showUser = (req, res) ->
  res.render('users/show', {title: 'Profile')

exports.deleteSession = (req, res) ->
  req.session.destroy()
  res.redirect('/')

exports.newUser = (req, res) ->
  res.render('users/new', {title: 'New User'})

exports.postUser = (req, res) ->
  console.log req.files
  users.save req.body.username, req.body.password, req.files.avatar, (err) ->
    if(err)
      console.log(err)
      res.locals.flash = err
      res.render('users/new', {title: 'Try Again!'})
    else
      users.authenticate(req.body.username, req.body.password, (error, user) ->
        if(user)
          req.session.user = user
          console.log("Successfully made new user and authenticated. setting flash now")
          res.locals.flash = 'Successfully Created New Profile!'
          res.render('index', {title: 'Welcome!'})
        else
          res.locals.flash = error
          res.render('users/new', {title: 'Try Again!'})
      )

exports.avatars = (req, res) ->
  users.find req.session.user, (err, user) ->
    if user
      res.writeHead('200', {'Content-Type': 'image/png'})
      res.end(user.avatar.data, 'binary')
    else
      res.locals.flash = err
      res.render('index', {title: 'Home'})