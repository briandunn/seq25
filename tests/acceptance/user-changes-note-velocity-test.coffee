`import {test} from 'qunit'`
`import {helpers, feature} from '../helpers/helper'`
feature 'user changes note velocity'

test 'user increases velocity of selected note', ->
  clickPosition '.notes'
  andThen ->
    equal(find('.notes li.selected').css('opacity'), '0.75')
  press '10,v'
  andThen ->
    equal(find('.notes li.selected').css('opacity'), '1')
