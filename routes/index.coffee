
#GET home page

exports.index = (req, res) ->
  res.render('index', { title: 'Home' })


#  GET about page

exports.about = (req, res) ->
  res.render('about', { title: 'About'}) 
