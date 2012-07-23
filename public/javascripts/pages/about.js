/*$ ->
  if $("#about").length != 0
    alert("The About Page.")
    $("#about_map_button").click loadScript

  loadscript(callback) ->
    print "hey"
    $('<script>', {src: 'http://maps.google.com/maps/api/js?sensor=false&callback=loadMaps', id: 'lala'}).appendTo('<body>')###
    */
var map;

$(function(){
  if($("#about").length != 0){
    alert("The About Page");
    $("#about_map_button").click(loadScript);
  }

});

function loadScript(callback) {
  $('<script>', {
    src: 'http://maps.google.com/maps/api/js?sensor=false&callback=loadMaps',
    id: 'lala'
  }).appendTo('<body>');
}

function loadMaps() {
  if(navigator.geolocation){
    navigator.geolocation.getCurrentPosition(displayLocation, displayError);
  }
  else{
    alert("No Geolocation support");
  }
  //var myLatlng = new google.maps.LatLng(-34.397, 150.644);
   // var myOptions = {
   //   zoom: 8,
    //  center: myLatlng,
   //   mapTypeId: google.maps.MapTypeId.ROADMAP
    //}
   // var map = new google.maps.Map($("#about_map_div")[0], myOptions);

}

function displayLocation(positionObject){
  var latitude = positionObject.coords.latitude;
  var longitude = positionObject.coords.longitude;

  $("#about_msg_div").html("These are my coordinates: " + latitude + ", " + longitude);

  showMap(positionObject.coords);
}

function showMap(coords){
  alert("in showMap");

  var googleLatAndLong = new google.maps.LatLng(coords.latitude, coords.longitude);

  var mapOptions = {
    zoom: 15,
    center: googleLatAndLong, 
    mapTypeId: google.maps.MapTypeId.ROADMAP//This is type of map. Also try Hybrid and Satellite
  };

  map = new google.maps.Map($("#about_map_div")[0], mapOptions);  
    
    
  addMarker(map, googleLatAndLong, "Your Location", "You are here: " + coords.latitude + "," + coords.longitude);
}

function addMarker(map, latlong, title, content){
  console.log("in addMarker");

  var markerOptions = {
    position: latlong,
    map: map,
    title: title,
    clickable: true
  };

  var marker = new google.maps.Marker(markerOptions);
  var infoWindowOptions = {
    content: content, //getting content?
    position: latlong  //and position?
  }

  var infoWindow = new google.maps.InfoWindow(infoWindowOptions);
    
  google.maps.event.addListener(marker, "click", function(){
    infoWindow.open(map);
  });
}

function displayError(error){
  console.log("in displayError");
  var errorTypes = {
    0: "Unknown Error",
    1: "Permission Denied by User",
    2: "Position is not Available",
    3: "Request Timed Out"
  };

  if(error.code == 0 || error.code == 2){
    errorMessage = errorMessage + " " + error.message;
  }

  $("#about_msg_div").html(errorMessage);
}

function holler(){
  alert("up in the holler");
}