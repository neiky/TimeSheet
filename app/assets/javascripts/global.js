jQuery(document).ready(function() {
  $(".toggleVisibility").hide();

  $( ".buttonToggle" ).click(function() {
    target_id = $(this).attr("data-toggle-this");

		$("#"+target_id).toggle( 'blind', {}, 250 );
		return false;
	});
	
	$(document).ajaxStart(function() {
		$("#ajax_loading_dialog").modal('show');
	});
  $(document).ajaxStop(function() {
  	$("#ajax_loading_dialog").modal('hide');
  });
	
});
