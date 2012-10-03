http = require 'http'
api_key = 'f5d61ca601bcc9956237b6377f70abf6'

module.exports.getArtistInfo = getArtistInfo = (artist, callback) ->
  options =
     host: 'ws.audioscrobbler.com'
     path: '/2.0/?method=artist.getInfo&artist='+artist+'&autocorrect=1&format=json&api_key='+api_key
     method: 'GET'
     headers:
      'User-Agent':'Mozilla/5.0 (X11; Linux i686) AppleWebKit/536.11 (KHTML, like Gecko) Ubuntu/12.04 Chromium/20.0.1132.47 Chrome/20.0.1132.47 Safari/536.11'

  req = http.request options, (res) ->
    output = ''

    res.on 'data', (chunk) ->
      output += chunk

    res.on 'end', () ->
      callback(res.statusCode, output)

  req.end()

getArtistInfo 'cher', (status, obj) ->
  console.log(status)