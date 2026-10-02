import {test} from 'qunit';
import {helpers, feature} from '../helpers/helper';

feature('Feature: user note actions must be constrained');

test('cannot shorten note to 0', function() {
  press("c");
  assertWidth("6.25%");
  press("shift+left");
  return assertWidth("6.25%");
});

test('cannot move note to < 0', function() {
  press("c");
  assertLeft("0%");
  press("left");
  return assertLeft("0%");
});
