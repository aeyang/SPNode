#Controllers
users = require '../DB/users'
lastFM = require '../DB/lastFM'
Amazon = require '../DB/amazon'
gigulate = require '../DB/gigulate'
async = require 'async'

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
  console.log "in search"
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

#GET users/show
exports.showUser = (req, res) ->
  users.find req.session.user, (err, user) ->
    if user
      images = []
      do (images) ->
        async.forEach user.bands, (band, callback)->
          lastFM.getArtistInfo(band.name, (data, status) ->
            data = JSON.parse(data)
            images.push {name: band.name, url: data.artist.image[3]["#text"]}
            callback(null)
          )
        ,(err) ->
          if err 
            res.locals.flash = err 
            res.render('users/show', {title: 'Profile'})
          else
            res.render('users/show', {title: 'Profile', images: images})

#DELETE session
exports.deleteSession = (req, res) ->
  req.session.destroy()
  res.redirect('/')

#GET users/new
exports.newUser = (req, res) ->
  res.render('users/new', {title: 'New User'})

#POST users/new
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

#GET 
exports.avatars = (req, res) ->
  users.find req.session.user, (err, user) ->
    if user
      res.writeHead('200', {'Content-Type': 'image/png'})
      res.end(user.avatar.data, 'binary')
    else
      res.locals.flash = err
      res.render('index', {title: 'Home'})


exports.lastFM_artist_info = (req, res) ->
  #Somehow this magically sends the value to the right callback. 
  lastFM.getArtistInfo req.query.name, (data, status) ->
    console.log("calling res.json")
    res.json(data, status)

exports.save_artist_info = (req, res) ->
  band = req.body.name
  console.log(band)
  users.add_band req.session.user, band, (status) ->
    console.log(status)
    res.send(status)


exports.gigulate_artist_news = (req, res) ->
  console.log("in ajax gigulate")
  gigulate.getArtistNews req.session.user, (data, err) ->
    res.json(data, err)


exports.amazon_album_info = (req, res) ->
  Amazon.getAlbumInfo req.query.name, (data, status) ->
    console.log("Calling amazon")
    console.log(loadXML(data))
    console.log(status)

