http = require 'http'
api_key = 'c86eaed8df220647'
users = require './users'


module.exports.getArtistNews = getArtistNews = (user, callback) ->
  users.find user, (err, user) ->
    if err
      callback(null, err)
    else
      bands = []
      for band in user.bands
        bands.push band.name
      bands = bands.join(',')

      options = {
        host: 'api.gigulate.com',
        path: '/1.0/news.stories?&key='+api_key+
              '&artists='+encodeURIComponent(bands)+
              '&authority=featured'+
              '&order=date.desc'+
              '&response=json'
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


# this.getArtistNews 'alan', (data, err) ->
#   console.log err
#   console.log JSON.parse(data)