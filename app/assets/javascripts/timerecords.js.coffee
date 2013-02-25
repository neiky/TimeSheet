# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

prevDate = ""


jQuery(document).ready ->
  anchor = $(document)
  $('#submit_date_search').css('visibility', 'hidden')
  prevDate = $('#date_search').val()
  #alert prevDate

  $('.datePicker').datepicker dateFormat: "yy-mm-dd", showWeek: true, firstDay: 1, onClose: (dateText, inst) ->
      #if dateText isnt "" and dateText isnt prevDate
      #alert prevDate
      return false

  #$('.dateSearch').datepicker dateFormat: "yy-mm-dd", showWeek: true, firstDay: 1, onClose: (dateText, inst) ->
      #if dateText isnt "" and dateText isnt prevDate
      #alert prevDate
  #    $('#submit_date_search').click()
  #   return false
  $("[data-behaviour~='datepicker']").datepicker({
    "format": "yyyy-mm-dd",
    "weekStart": 1,
    "autoclose": true
  });

  $('.dateSearch').datepicker()
    .on('changeDate', (ev) ->
      $('#submit_date_search').click()
  );
  $('#date_selector').datepicker({
    "format": "yyyy-mm-dd",
    "weekStart": 1,
    "autoclose": true
  })
    .on('changeDate', (ev) ->
      $('#date_search').val($('#date_selector').data('date'))
      $('#date_selector').datepicker('hide')
      $('#date_text').text($('#date_search').val())
      $('#submit_date_search').click()
      return
  );

  $('.date-increase').click (event) ->
    event.preventDefault()
    date = new Date($('#date_selector').data("date"))
    date.setDate(date.getDate()+1)
    #$('#date_search').datepicker("update", date)
    $('#date_selector').datepicker("update", date)
    $('#date_search').val($('#date_selector').data('date'))
    $('#date_text').text($('#date_search').val())
    $('#submit_date_search').click()
    return false

  $('.date-decrease').click (event) ->
    event.preventDefault()
    date = new Date($('#date_selector').data("date"))
    date.setDate(date.getDate()-1)
    #$('#date_search').datepicker("update", date)
    $('#date_selector').datepicker("update", date)
    $('#date_search').val($('#date_selector').data('date'))
    $('#date_text').text($('#date_search').val())
    $('#submit_date_search').click()
    return false

  UpdateDuration = ->
    startDate = new Date(anchor.find('#date_search').val())
    startDate.setHours(anchor.find('#start_hour').val())
    startDate.setMinutes(anchor.find('#start_minute').val())

    #endDate = $('#date_search').datepicker("getDate")
    endDate = new Date(anchor.find('#date_search').val())
    endDate.setHours(anchor.find('#end_hour').val())
    endDate.setMinutes(anchor.find('#end_minute').val())

    if endDate < startDate
      # assume endDate is at next day
      endDate.setDate(endDate.getDate()+1)

    duration = new Date(0, 0, 0, 0, 0, 0, endDate - startDate)
    strMinutes = if duration.getMinutes() > 10 then duration.getMinutes() else "0" + duration.getMinutes()
    anchor.find('#time_span_hour').val(duration.getHours())
    anchor.find('#time_span_minute').val(duration.format("%M"))
    return

  StartTimeChange = ->
    hour = anchor.find('#start_hour').val()
    minute = anchor.find('#start_minute').val()
    if 0 <= hour <= 23 and 0 <= minute <= 59
      anchor.find('#start_hour').parent().removeClass("error")
      UpdateDuration()
      return true
    else
      anchor.find('#start_hour').parent().addClass("error")
      return false

  $('#start_hour').change(StartTimeChange)

  $('#start_minute').change(StartTimeChange)

  EndTimeChange = ->
    hour = anchor.find('#end_hour').val()
    minute = anchor.find('#end_minute').val()
    if 0 <= hour <= 23 and 0 <= minute <= 59
      anchor.find('#end_hour').parent().removeClass("error")
      UpdateDuration()
      return true
    else
      anchor.find('#end_hour').parent().addClass("error")
      return false

  $('#end_hour').change(EndTimeChange)

  $('#end_minute').change(EndTimeChange)

  UpdateEndTime = ->
    startDate = Date.parse(anchor.find('#date_search').val())
    #startDate = $('#date_search').datepicker("getDate")
    startDate.setHours(anchor.find('#start_hour').val())
    startDate.setMinutes(anchor.find('#start_minute').val())

    if anchor.find('#time_span_hour').val() > 24
      anchor.find('#time_span_hour').val('24')

    if anchor.find('#time_span_minute').val() > 60
      anchor.find('#time_span_minute').val(60)

    #endDate = $('#date_search').datepicker("getDate")
    endDate = Date.parse(anchor.find('#date_search').val())
    endDate.setHours(startDate.getHours()+anchor.find('#time_span_hour').val())
    endDate.setMinutes(startDate.getMinutes()+anchor.find('#time_span_minute').val())

    anchor.find('#end_hour').val(endDate.getHours())
    anchor.find('#end_minute').val(endDate.format("%M"))

    anchor.find('#start_hour').val(startDate.getHours())
    anchor.find('#start_minute').val(startDate.format("%M"))
    return

  $('#time_span_hour').change(UpdateEndTime)

  $('#time_span_minute').change(UpdateEndTime)

  $('#timerecord_description').change ->
    if $('#timerecord_description').val() isnt ""
      $('#timerecord_description').parent().removeClass("warning")
    else
      $('#timerecord_description').parent().removeClass("warning")
      $('#timerecord_description').parent().addClass("warning")

  $('#modal-dialog').bind 'hidden', ->
    anchor = $(document)
    return

  # for timerecords analyze
  $('#submit_filter').css('visibility', 'hidden')
  #$('#img_ajax_loader').css('visibility', 'visible')
  #$("#img_ajax_loader").hide()

  #$(document).ajaxStart( -> $("#ajax_loading_dialog").modal('show') )
  #$(document).ajaxStop( -> $("#img_ajax_loader").hide() )
  #$(document).ajaxStop( -> $("#ajax_loading_dialog").modal('hide') )

  $('#filter_user').change ->
    $('#submit_filter').click()
    #toggleLoading()
    return false

  $('#filter_project').change ->
    $('#submit_filter').click()
    #toggleLoading()
    return false

  $('#date_start').change ->
    dateStart = $('#date_start').datepicker("getDate")
    dateEnd = $('#date_end').datepicker("getDate")
    if dateStart > dateEnd
      dateEnd.setDate(dateStart.getDate()+1)
      $('#date_end').datepicker("setDate", dateEnd)
    $('#submit_filter').click()
    #toggleLoading()
    return false

  $('#date_end').change ->
    dateStart = $('#date_start').datepicker("getDate")
    dateEnd = $('#date_end').datepicker("getDate")
    if dateStart > dateEnd
      dateStart.setDate(dateEnd.getDate()-1)
      $('#date_start').datepicker("setDate", dateStart)
    $('#submit_filter').click()
    #toggleLoading()
    return false


  return
