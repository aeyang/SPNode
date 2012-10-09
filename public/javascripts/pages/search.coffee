$ ->
  $("form").submit (event) ->
    event.preventDefault()
    band_name = $('form > input[name*="artist_search_field"]').val()
    if !band_name
      alert "No Band Specified!"
    else 
      $.getJSON '/ajax/lastFM/artist_info?', {name: band_name}, (status, data) ->
        alert("hey")
        console.log(data)
        console.log(status)

      # $.ajax
      #   dataType:'json',
      #   data: {name: band_name},
      #   url: '/ajax/lastFM/artist_info'
      #   success: (data) ->
      #     alert(data.me)

    return false
