$.get('/feeds', function(data){
  $("h3").html(data).hide()
  $("h3").slideDown("slow");
});
