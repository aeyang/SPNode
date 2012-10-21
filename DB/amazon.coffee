apa = require('apa-client')
# http = require 'http'
# crypto = require 'crypto'
key = 'AKIAITDQ43M6CV7CVTMA'
secret = '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'
tag = 'musiexplsenip-20'

# module.exports.getAlbumInfo = get_album_info = (artist, callback)->
#   options = {
#     host: 'free.apisigning.com',
#     path: '/onca/xml?AWSAccessKeyId='+ key +
#           '&AssociateTag='+ tag +
#           '&Service=AWSECommerceService'+
#           '&Operation=ItemSearch' +
#           '&Artist=' + encodeURIComponent(artist) +
#           '&search_index=Music' + 
#           '&Keywords=album'+
#           '&ResponseGroup=ItemAttributes',
#     method: 'GET'
#   }

#   req = http.request options, (response) ->
#     Data = ''

#     response.on('data', (data) -> 
#       console.log("got data: " + data)
#       Data += data
#     )

#     response.on('end', () -> 
#       callback(Data, response.statusCode)
#     )

#   req.end()


# get_album_info 'Linkin Park', (obj, status) ->
#    console.log(status)
#    console.log(obj.length)


client = apa.createClient {
  "awsAccessKeyId" : key
  "awsSecretKey" : secret 
  "associateTag" : tag
}


client.execute 'ItemSearch' 
  Service: 'AWSECommerceService'
  Artist: 'Muse'
  ResponseGroup: 'ItemAttributes,Images'
  Search_Index: 'Music'
  Keywords: 'album'
  , (err, data) ->
    if(err)
      console.log(err)
    else
      console.log(err)
      console.log(JSON.stringify(data))