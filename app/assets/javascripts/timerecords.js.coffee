# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

prevDate = ""

jQuery(document).ready ->
  $('#submit_date_search').css('visibility', 'hidden')
  prevDate = $('#date_search').val()
  #alert prevDate

  $('.datePicker').datepicker dateFormat: "yy-mm-dd", showWeek: true, firstDay: 1, onClose: (dateText, inst) ->
      #if dateText isnt "" and dateText isnt prevDate
      #alert prevDate
      $('#submit_date_search').click()
      return false
  ###
  #$('#date_search').datepicker onClose: (dateText, inst) ->
      #if dateText isnt "" and dateText isnt prevDate
      	#$('#submit_date_search').click()
      	#alert(date)
    	#return false
        #this.form.submit()
  ###

  $('.date-increase').click ->
    date = $('#date_search').datepicker("getDate")
    date.setDate(date.getDate()+1)
    $('#date_search').datepicker("setDate", date)
    $('#submit_date_search').click()
    return false

  $('.date-decrease').click ->
    date = $('#date_search').datepicker("getDate")
    date.setDate(date.getDate()-1)
    $('#date_search').datepicker("setDate", date)
    $('#submit_date_search').click()
    return false

  UpdateDuration = ->
    startDate = $('#date_search').datepicker("getDate")
    startDate.setHours($('#start_hour').val())
    startDate.setMinutes($('#start_minute').val())

    endDate = $('#date_search').datepicker("getDate")
    endDate.setHours($('#end_hour').val())
    endDate.setMinutes($('#end_minute').val())

    if endDate < startDate
      # assume endDate is at next day
      endDate.setDate(endDate.getDate()+1)

    duration = new Date(0, 0, 0, 0, 0, 0, endDate - startDate)

    strMinutes = if duration.getMinutes() > 10 then duration.getMinutes() else "0" + duration.getMinutes()

    $('#time_span').val(duration.getHours() + ":" + strMinutes)

  StartTimeChange = ->
    hour = $('#start_hour').val()
    minute = $('#start_minute').val()
    if 0 <= hour <= 23 and 0 <= minute <= 59
      $('#start_hour').parent().removeClass("error")
      UpdateDuration()
      return true
    else
      $('#start_hour').parent().addClass("error")
      return false

  $('#start_hour').change(StartTimeChange)

  $('#start_minute').change(StartTimeChange)

  EndTimeChange = ->
    hour = $('#end_hour').val()
    minute = $('#end_minute').val()
    if 0 <= hour <= 23 and 0 <= minute <= 59
      $('#end_hour').parent().removeClass("error")
      UpdateDuration()
      return true
    else
      $('#end_hour').parent().addClass("error")
      return false

  $('#end_hour').change(EndTimeChange)

  $('#end_minute').change(EndTimeChange)

  $('#timerecord_description').change ->
    if $('#timerecord_description').val() isnt ""
      $('#timerecord_description').parent().removeClass("warning")
    else
      $('#timerecord_description').parent().removeClass("warning")
      $('#timerecord_description').parent().addClass("warning")

  return
