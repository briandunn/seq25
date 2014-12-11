feature 'Feature: user changes note velocity'

test 'user decreases velocity of selected note', ->
  visit '/'
  click 'button'
  click 'li.empty'
  clickPosition '.notes'
  press '10,v'
  andThen ->
    equal(parseInt($('.notes li').css('opacity')), '1')
