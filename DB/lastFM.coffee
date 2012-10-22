http = require 'http'
api_key = 'f5d61ca601bcc9956237b6377f70abf6'

module.exports.getArtistInfo = getArtistInfo = (artist, callback) ->
  options = {
    host: 'ws.audioscrobbler.com',
    path: '/2.0/?method=artist.getInfo' + 
      '&artist=' + encodeURIComponent(artist) +
      '&autocorrect=1' + 
      '&format=json' +
      '&api_key=' + api_key,
    method: 'GET',
    headers:
      'User-Agent':'Mozilla/5.0 (X11; Linux i686) AppleWebKit/536.11 (KHTML, like Gecko) Ubuntu/12.04 Chromium/20.0.1132.47 Chrome/20.0.1132.47 Safari/536.11'
  }

  req = http.request options, (response) ->
    Data = ''

    response.on('data', (data) -> 
      Data += data
    )

    response.on('end', () -> 
      callback(Data, response.statusCode)
    )

  req.end()

module.exports.getArtistEvents = getArtistEvents = (artist, callback) ->
  options = {
    host: 'ws.audioscrobbler.com',
    path: '/2.0/?method=artist.getEvents' + 
      '&format=json' + 
      '&api_key=' + api_key + 
      '&artist=' + encodeURIComponent(artist) +
      '&festivalsonly=1' + 
      '&autocorrect=1',
    method: 'GET',
    headers: 
      'User-Agent':'Mozilla/5.0 (X11; Linux i686) AppleWebKit/536.11 (KHTML, like Gecko) Ubuntu/12.04 Chromium/20.0.1132.47 Chrome/20.0.1132.47 Safari/536.11'
  }

  console.log options.host + options.path
  req = http.request options, (response) ->
    Data = ''

    response.on 'data', (data) ->
      Data += data 

    response.on 'end', () ->
      callback(Data, response.statusCode)

    response.on 'error', (error) ->
      console.log 'Error: ' + error

  req.on 'error', (error) ->
    console.log 'Error: ' + error

  req.end()

 # getArtistEvents 'Linkin Park', (obj, status) ->
 #   console.log(status)
 #   console.log(obj)