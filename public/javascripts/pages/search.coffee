$ ->
  $("form").submit (event) ->
    event.preventDefault()
    band_name = $('form > input[name*="artist_search_field"]').val()
    if !band_name
      alert "No Band Specified!"
    else 
      $.getJSON '/ajax/lastFM/artist_info?', {name: band_name}, (data, status) ->
        console.log(data)
        try
          obj = $.parseJSON(data)
        catch e
          alert('invalid JSON')
        
        if $('search_info_div').children().length > 0
          $('#search_info_div').empty()

        $('#search_info_div').append('<h3>'+obj.artist.name+'</h3>')
        $('#search_info_div').append('<img src='+obj.artist.image[3]["#text"]+'></img>')
        $('#search_info_div').append('<p>' + obj.artist.bio.summary + '</p>')
        $("<button id='search_save_button'> Save? </button>").appendTo('#search_info_div').bind 'click', ()->
          button = this
          console.log(this)
          $.post 'ajax/lastFM/artist_info', {name: band_name}, (status) ->
            console.log("In callback")
            if status is 'Success'
              $(button).fadeOut 'slow'
              $('#search_info_div').append("<div id='search_success_div'> Band Saved Successfully! </div>")



        #$('#search_info_div').append('<h3>'+data["artist"]["name"]+'</h3>')
      # $.ajax
      #   dataType:'json',
      #   data: {name: band_name},
      #   url: '/ajax/lastFM/artist_info'
      #   success: (data) ->
      #     alert(data.me)

