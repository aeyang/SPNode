
#GET home page

exports.index = (req, res) ->
  console.log "in index"
  res.render('index', { title: 'Express' })


#  GET about page

exports.about = (req, res) ->
  console.log "in about"
  res.render('about', { title: 'My Senior Project'}) 
