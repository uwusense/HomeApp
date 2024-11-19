$ ->
  $('.sort-select').select2
    minimumResultsForSearch: Infinity
  
  $('.sort-select').on 'change', ->
    $(this).closest('form').submit()
