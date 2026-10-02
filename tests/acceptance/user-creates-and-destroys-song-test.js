import {test} from 'qunit';
import {helpers, feature} from '../helpers/helper';
feature('Feature: user creates and destroys song spec');

test('create song and then delete song', function() {
  press('c');
  visitRoute("songs");
  andThen(() => equal(find("li.song").length, 1));
  // delete song
  click('#songs ul li.song:first-child .actions:first-child button:first-child');
  return andThen(() => equal(find("li.song").length, 0));
});
