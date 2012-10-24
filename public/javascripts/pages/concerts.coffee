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
        list = $("#lastFM_left_div")

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
                '</div>'
              )
          else
            items.push '<li class="clickable">' + '<img src='  + obj.events.event.image[3]["#text"] + ' alt="eventPic"/>' +
                       obj.events.event.title + '</li>'

        list.append items.join(' ')
        $(".lastFM_info_span").css('cursor', 'pointer').click(eventClick)
        $(".lastFM_panel_front").hover(infobox)


eventClick = () ->
  #We do the same as above, check if there is only one event object, or an array of event objects.
  if($.isArray(globalData.events.event))
    # A Fix. This will display the right times for concerts with the same name. Can work for one event too
    temp = globalData.events.event[$(this).index()]
    eventOfInterest = temp
    dynamicLoad()
  else
    if(globalData.events.event.title == $(this).text())
      eventOfInterest = globalData.events.event;
      dynamicLoad();
    
  
dynamicLoad = () ->
  if($("#lastFM_googleMaps_script").length == 0)
    console.log("about to insert")
    $('<script>', {
      src: 'http://maps.google.com/maps/api/js?' +
        'key=AIzaSyClnt9-I5FJqcRJK35GxFMsY-vRTc7N8N8' + '&sensor=false&callback=showConcertMap',
      id: 'lastFM_googleMaps_script'
    }).appendTo('<body>')


showConcertMap = () ->
  googleLatAndLong = new google.maps.LatLng(eventOfInterest.venue.location["geo:point"]["geo:lat"],eventOInterest.venue.location["geo:point"]["geo:long"])

  mapOptions = {
    zoom: 15,
    center: googleLatAndLong,
    mapTypeId: google.maps.MapTypeId.ROADMAP #This is a type of map. Also try Hybrid and Satellite
  }

  map = new google.maps.Map($("#lastFM_map_div")[0], mapOptions)

  addMarker(map, googleLatAndLong, "Concert Location", 
    eventOfInterest.venue.location["city"] + ',' + eventOfInterest.venue.location["country"])


infobox = () ->
  $(".sub_panel").hover \
  ()->
    $(this).find('div.lastFM_panel_front').hide()
    $(this).find('span').show() 
  ,()->
    $(this).find('span').hide('fast')
    $(this).find('div.lastFM_panel_front').show('fast')

        