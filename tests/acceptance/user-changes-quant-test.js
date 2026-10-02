import {test} from 'qunit';
import {helpers, feature} from '../helpers/helper';

feature('Feature: User changes quant');

test('change quant with keyboard', function() {
  press("2, x");
  press("c");
  assertLeft("0%");

  press("2, 0, b");

  assertLeft("0%");

  press("right");

  return assertLeft("2.5%");
});
