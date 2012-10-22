$ ->
  $("form").submit (event) ->
    event.preventDefault()
    band_name = $('form > input[name*="amazon_search_form"]').val()
    if !band_name
      alert "No Band Specified!"
    else
	    $.getJSON '/ajax/amazon/album_info?', {name: band_name}, (data, status) ->

        try
          #parseJSON turns the given JSON string into the javascript object
          obj = $.parseJSON(data)
        catch e
          alert('invalid JSON')

        console.log obj
        show_results = $('#amazon_results_div')
        if show_results.children().length > 0
          show_results.empty()

        for album in obj.Items.Item
          cont = $('<div></div>').appendTo show_results
          cont.append('<img src=' + album.MediumImage.URL+'></img>')
          cont.append('<p><b> Album Title: ' + album.ItemAttributes.Title + '</b></p>')
          cont.append('<p><b> Artist: ' + album.ItemAttributes.Artist + '</b></p>')
          cont.append('<p><a href=' + album.DetailPageURL + '>Amazon Product Page</a></p>')
          cont.append('<p> Price: ' + album.ItemAttributes.ListPrice.FormattedPrice + '</p>')

     
      