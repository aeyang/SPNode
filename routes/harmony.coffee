#Controllers

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
exports.search= (req, res) ->
  res.render('search', {title: 'Search'})

#GET session/new
exports.newSession = (req, res) ->
  res.render('sessions/new', {title: 'New', redirect: req.query.redir})

#POST session/new
exports.postSession = (req, res) ->
  users = require '../DB/users'
  users.authenticate(req.body.login, req.body.password, (user) ->
    if(user)
      req.session.user = user
      res.redirect(req.body.redirect || '/')
    else
      res.redirect('sessions/new', {title:'New', redirect: req.body.redirect})
  )
