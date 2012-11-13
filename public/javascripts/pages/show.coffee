$ ->
  if $("#show_div > ul").length
    totalImages = $("#show_div > ul > li").length
    imageWidth = 252
    totalWidth = imageWidth * totalImages + imageWidth
    visibleImages = Math.round($("#show_div").width() / imageWidth)

    visibleWidth = visibleImages * imageWidth
    stopPosition = visibleWidth - totalWidth

    console.log totalImages + " " + imageWidth + " " + totalWidth + " " + visibleImages + " " + visibleWidth + " " + stopPosition

    $("#show_div > ul").width(totalWidth)
    $("#feed_last").click ()->
      if $("#show_div > ul").position().left < 0 && !$("#show_div > ul").is(":animated")
        $("#show_div > ul").animate({left: "+=" + imageWidth + "px"})
      return false

    $("#feed_next").click ()->
      if $("#show_div > ul").position().left > stopPosition && !$("#show_div > ul").is(":animated")
        $("#show_div > ul").animate({left: "-=" + imageWidth + "px"})
      return false        

