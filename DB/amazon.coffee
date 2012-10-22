apa = require('apa-client')

key = 'AKIAITDQ43M6CV7CVTMA'
secret = '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'
tag = 'musiexplsenip-20'

client = apa.createClient {
  "awsAccessKeyId" : key
  "awsSecretKey" : secret 
  "associateTag" : tag
}

module.exports.getAlbumInfo = getAlbumInfo = (artist, callback) ->
  client.execute 'ItemSearch',
    {
      Service: 'AWSECommerceService',
      Artist: artist,
      ResponseGroup: 'ItemAttributes,Images',
      SearchIndex: 'Music',
      Keywords: 'album'
    },
    (err, data) ->
      if(err)
        callback(null, err)
      else
        #JSON.stringify() converts an object to JSON notation representing it.(String)
        callback(JSON.stringify(data), err)