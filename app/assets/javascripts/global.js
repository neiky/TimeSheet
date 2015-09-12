jQuery(document).ready(function() {
  $(".toggleVisibility").hide();

  $('#img_ajax_loader').css('visibility', 'visible');
  $("#img_ajax_loader").hide();

  $( ".buttonToggle" ).click(function() {
    target_id = $(this).attr("data-toggle-this");

  $("#"+target_id).toggle( 'blind', {}, 250 );
    return false;
  });

  $(document).ajaxStart(function() {
    $("#img_ajax_loader").show();
  });
  $(document).ajaxStop(function() {
    $("#img_ajax_loader").hide();
  });
});
