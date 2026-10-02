import {test} from 'qunit';
import {helpers, feature} from '../helpers/helper';

feature('Feature: user note actions must be constrained');

test('change beats with keyboard', function() {

  assertMeasureWidth("6.25%");
  press("2, 0, b");
  return assertMeasureWidth("5%");
});

test('change beats with keyboard should change note width', function() {

  press("c");
  assertWidth("6.25%");
  press("2, 0, b");
  return assertWidth("5%");
});

var assertMeasureWidth = w => andThen(() => equal(width(".measure"), w));
