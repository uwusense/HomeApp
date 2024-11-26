$ ->
  setTimeout ->
    $('.flash').fadeOut 500, ->
      $(this).remove()
  , 4000
