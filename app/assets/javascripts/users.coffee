# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  $('.image-preview').click ->
    $('#user_avatar').click()
    return
  $('#user_avatar').on 'change', (input) ->
    evt = input.target
    if evt.files and evt.files[0]
      reader = new FileReader
      reader.onload = (e) ->
        $('.image-preview').attr('src', e.target.result).width 100
        return
      reader.readAsDataURL evt.files[0]
    return
  return