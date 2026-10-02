import {test} from 'qunit';
import {helpers, feature} from '../helpers/helper';
feature('user changes note velocity');

test('user increases velocity of selected note', function() {
  andThen(() => clickPosition('.notes'));
  andThen(() => equal(find('.notes li.selected').css('opacity'), '0.75'));
  press('10,v');
  return andThen(() => equal(find('.notes li.selected').css('opacity'), '1'));
});
