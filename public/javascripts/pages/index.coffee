$ ->
  console.log("hello")
  $("#home_newsfeed_button").bind 'click', () ->
    console.log("clicked")

    $.getJSON '/ajax/gigulate/artist_news?', (data, status) ->
      console.log data
      try
        obj = $.parseJSON(data)
      catch e
        alert('invalid JSON')
      
      console.log obj
      
      if $("#home_feed_div").children().length > 0
        $("#home_feed_div").empty()

      console.log "got past"

      $("#home_feed_div").prepend("<ul id='gallery'></ul>")
      for story in obj['news.stories'].story
        story_div = $('<div id="newsfeed_story_p"></div>')#.appendTo("#home_feed_div")
        story_div.append("<b>" + story.title + "</b>")
        story_div.append("<p><a href=" + story.url + ">" + story.url + "</a></p>")
        story_div.append("<p>" + story["date.published"] + '</p>')
        #Only 1 artist
        if story.artists.artist.constructor != Array
          story_div.append("<img src=" + story.artists.artist.images.image[1]["@attributes"].src + ">")
        #Artist does not have picture
        else if story.artists.artist[0].images != undefined 
          story_div.append("<img src=" + story.artists.artist[0].images.image[1]["@attributes"].src + ">")

        $("#gallery").append(story_div)

      $("#gallery").children().wrap(document.createElement("li"))

      if $("#gallery").length
        totalImages = $("#gallery > li").length
        imageWidth = 357
        totalWidth = imageWidth * totalImages + imageWidth
        visibleImages = Math.round($("#home_feed_div").width() / imageWidth)

        visibleWidth = visibleImages * imageWidth
        stopPosition = visibleWidth - totalWidth

        console.log totalImages + " " + imageWidth + " " + totalWidth + " " + visibleImages + " " + visibleWidth + " " + stopPosition

        $("#gallery").width(totalWidth)
        $("#feed_last").click ()->
          if $("#gallery").position().left < 0 && !$("#gallery").is(":animated")
            $("#gallery").animate({left: "+=" + imageWidth + "px"})
          return false

        $("#feed_next").click ()->
          if $("#gallery").position().left > stopPosition && !$("#gallery").is(":animated")
            $("#gallery").animate({left: "-=" + imageWidth + "px"})
          return false        

