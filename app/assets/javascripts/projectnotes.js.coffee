# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

projectID = 0
lastUpdate = 0

jQuery(document).ready ->
  projectID = $('input#project_id').val()
  #lastUpdate = new Date()
  lastUpdate = new Date("01 01, 2013 12:00:00")

  UpdateProjectnotes = ->
    #alert projectID
    lastUpdate = parseInt($('#projectnotes div:first').attr('last_update')) + 1
    #lastUpdate = lastUpdate.getTime()
    #alert lastUpdate + ", " + (lastUpdate + 1)
    $.ajax
      type: "GET",
      contentType: "application/html; charset=utf-8",
      dataType: "text",
      processData: false,
      url: "/projectnotes?project_id=" + projectID + "&time=" + lastUpdate,
      success: (data) ->
        #alert 'success'
        #$.each data, (k)->
          #alert k
          #$('#rawdata').append printProjectnote(this)

        if data != ' '
          #alert data
          num = $('.projectnote').length
          $('#projectnotes').prepend(data)
          num = $('.projectnote').length - num
          #alert num
          #$('#projectnotes div:first').effect('highlight', 2000);
          $('#projectnotes div').slice(0, num).effect('highlight', 2000);
        return

    setTimeout (()->
      UpdateProjectnotes() if projectID != undefined
      return
    ), 5000
    return

	
  setTimeout (()->
    #alert 'bla'
    UpdateProjectnotes() if projectID != undefined
    return
  ), 5000

  printProjectnote = (note) ->
    return '<div class="projectnote" id="projectnote_' + note.id + '"><p>Von <b>' + note.sender_id + '</b> <small>Sent ' + note.created_at + '</small></p><p>' + note.content + '</p></div>'

  return