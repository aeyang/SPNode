$ ->
  $("form").submit (event) ->
    event.preventDefault()
	  $.get 'http://free.apisigning.com/onca/xml', 
      {
        WSAccessKeyId: 'AKIAITDQ43M6CV7CVTMA'
        AssociateTag: 'musiexplsenip-20'
        Service: 'AWSECommerceService'
        Operation: 'ItemSearch' 
        Artist: 'Muse'
        search_index: 'Music'  
        Keywords:'album'
        ResponseGroup:'ItemAttributes'
        Datatype:'jsonp'
      } 
      ,(data, textStatus, jqXHR) ->
        console.log(data)
        console.log(textStatus)
        console.log(jqXHR)     
      ,"XML"     