import {test} from 'qunit';
import {helpers, feature} from '../helpers/helper';

feature('Feature: user moves note');

test('move note when is quant is 0', function() {

  press("2, 0, b");
  press("c");
  press("0, x");

  andThen(() => equal(find("input#quant").val(), "0"));

  assertLeft("0%");

  press("right");

  return andThen(function() {
    const value = left(".notes li");
    return equal(value.slice(0, 5), "0.052");
  });
});
