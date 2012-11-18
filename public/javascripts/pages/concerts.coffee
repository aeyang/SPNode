window.globalData
window.eventOfInterest

$ ->
  $("form").submit (event) ->
    event.preventDefault()
    band_name = $('form > input[name*="lastFM_search_form"]').val()
    if !band_name
      alert "No Band Specified!"
    else
      $.getJSON '/ajax/lastFM/artist_events', {name: band_name}, (data, status) ->

        try
          #parseJSON turns the given JSON string into the javascript object
          obj = $.parseJSON(data)
        catch e
          alert('invalid JSON')

        console.log obj
        list = $("#lastFM_events_list")

        if(list.children().length != 0)
          list.empty()

        window.globalData = obj
        items = [];
        if(obj.events.event == null)
          items.push "<strong> Sorry, no events to show for " + band_name + "</strong>"
        else
          console.log "got here"
          if($.isArray obj.events["event"])
            for evt in obj.events["event"]
              console.log "in loop"
              items.push(
                '<li>' +
                  '<div class="sub_panel">' + 
                   '<div class="lastFM_panel_front">' + 
                    '<img src=' + evt.image[2]["#text"] + ' alt="eventPic"/>' + 
                    '<h2>' + evt.title + '</h2>' +
                   '<div>' +

                   '<span class="lastFM_info_span">' +
                    '<img src=' + evt.image[3]["#text"] + ' alt="eventPic"/>' +
                    '<h3' + evt.title + '</h3>' +
                    '<p> Location: ' + evt.venue.name + " @ " + evt.venue.location["city"] + ", " + evt.venue.location["country"] + "</p>" +
                    '<p>' + "First day: " + evt.startDate + '</p>' +
                   '</span>' + 
                  '</div>' +
                '</li>'
              )
          else
            items.push '<li class="clickable">' + '<img src='  + obj.events.event.image[3]["#text"] + ' alt="eventPic"/>' +
                       obj.events.event.title + '</li>'

        list.append items.join(' ')
        $(".lastFM_panel_front").css('cursor', 'pointer').click(eventClick)

showConcertMap = () ->
  console.log("in showConcertMap")
  console.log window.eventOfInterest

  googleLatAndLong = new google.maps.LatLng(window.eventOfInterest.venue.location["geo:point"]["geo:lat"],window.eventOfInterest.venue.location["geo:point"]["geo:long"])

  mapOptions = {
    zoom: 15,
    center: googleLatAndLong,
    mapTypeId: google.maps.MapTypeId.HYBRID #This is a type of map. Also try Hybrid and Satellite
  }

  map = new google.maps.Map($("#lastFM_map_div")[0], mapOptions)

  addMarker(map, googleLatAndLong, "Concert Location", window.eventOfInterest.venue.location["city"] + ',' + window.eventOfInterest.venue.location["country"])

eventClick = () ->
  console.log("in eventClick\n")
  #We do the same as above, check if there is only one event object, or an array of event objects.
  if($.isArray(window.globalData.events.event))
    # A Fix. This will display the right times for concerts with the same name. Can work for one event too
    temp = window.globalData.events.event[$(this).parent().parent().index()]
    window.eventOfInterest = temp

    if $('#lastFM_middle_div').children().length != 0
      $('#lastFM_middle_div').empty()

    $('#lastFM_middle_div').append($(this).find('.lastFM_info_span'))
    showConcertMap()
  else
    if(window.globalData.events.event.title == $(this).text())
      window.eventOfInterest = window.globalData.events.event
      showConcertMap()

addMarker = (map, latlong, title, content) ->
  console.log("in addMarker")

  markerOptions = {
    position: latlong,
    map: map,
    title: title,
    clickable: true
  }

  marker = new google.maps.Marker(markerOptions)
  infoWindowOptions = {
    content: content, 
    position: latlong  
  }

  infoWindow = new google.maps.InfoWindow(infoWindowOptions)
    
  google.maps.event.addListener marker, "click", () ->
    infoWindow.open(map)




        