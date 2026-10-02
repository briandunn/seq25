import {test} from 'qunit';
import {helpers, feature} from '../helpers/helper';

feature('Acceptance: user creates part');

test('add new part', () => andThen(() => equal(find('section#piano-roll #keyboard li').eq(0).text().trim(), 'C8', "fantastic")));

test('add new note', function() {
  press("c");
  return assertNotesLength(1);
});

test('move note', function() {
  press("c");
  assertLeft("0%");
  press("right");
  return assertLeft("6.25%");
});

test('extend note', function() {
  press("c");
  assertWidth("6.25%");
  press("shift+right");
  return assertWidth("12.5%");
});
