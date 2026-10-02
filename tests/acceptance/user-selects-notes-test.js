import {test} from 'qunit';
import {helpers, feature} from '../helpers/helper';

feature('Feature: selects notes');

test('selected note changes color', function() {
  expect(4);
  andThen(() => clickPosition('.notes'));
  andThen(() => equal(find('.notes li.selected').length, 1));
  clickPosition('.notes li');
  andThen(function() {
    const notes = find('.notes');
    equal(notes.length, 1);
    return equal(notes.filter('.selected').length, 0);
  });
  clickPosition('.notes li');
  return andThen(() => equal(find('.notes li.selected').length, 1));
});

test('clicking the next note selects it only', function() {
  andThen(() => clickPosition('.notes'));
  andThen(() => clickPosition('.notes', {x: 100, y: 100}));
  andThen(() => equal(find('.notes li').length, 2));
  clickPosition('.notes li:eq(0)');
  andThen(function() {});
  andThen(function() {
    const notes = find('.notes li');
    equal(notes.length, 2);
    ok(notes.first().is('.selected'));
    return ok(notes.last().is(':not(.selected)'));
  });
  clickPosition('.notes li:eq(1)');
  andThen(function() {});
  return andThen(function() {
    const notes = find('.notes li');
    equal(notes.length, 2);
    ok(notes.first().is(':not(.selected)'));
    return ok(notes.last().is('.selected'));
  });
});

test('shift+clicking the next note selects it too', function() {
  andThen(() => clickPosition('.notes'));
  andThen(() => clickPosition('.notes', {x: 100, y: 100}));
  andThen(() => clickPosition('.notes li:eq(0)', {shift: true}));
  return andThen(function() {
    const notes = find('.notes li');
    equal(notes.length, 2);
    ok(notes.first().is('.selected'));
    return ok(notes.last().is('.selected'));
  });
});
