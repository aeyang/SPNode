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
      for story in obj['news.stories'].story
        story_div = $('<div id="newsfeed_story_p"></div>').appendTo("#home_feed_div")
        story_div.append("<b>" + story.title + "</b>")
        story_div.append("<p><a href=" + story.url + ">" + story.url + "</a></p>")
        story_div.append("<p>" + story["date.published"] + '</p>')

      console.log $("#home_feed_div").children()

