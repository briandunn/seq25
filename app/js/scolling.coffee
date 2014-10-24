$ ->
  fixDiv = ->
    $div = $("#status-bar")
    if $(window).scrollTop() > $div.data("top")
        $('#status-bar').css {'position': 'fixed', 'top': '0', 'width': '100%'}
    else
        $('#status-bar').css {'position': 'static', 'top': 'auto', 'width': '100%'}

  $(window).scroll(fixDiv)
