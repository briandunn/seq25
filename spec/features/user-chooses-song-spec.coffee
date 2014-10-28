module 'Feature: chooses song',

test 'see song preview', ->
  localStorage.setItem 'seq25test', JSON.stringify
    song:
      records:
        s:
          id: 's'
          parts: ['p']
    part:
      records:
        p:
          id: 'p'
          name: 'Q'
          beat_count: 16
          song: 's'
          notes: ['n']
    note:
      records:
        n:
          id: 'n'
          part: 'p'


  visit('/')
  andThen ->
    equal find('#songs .song ul.notes li.Q').length, 1
