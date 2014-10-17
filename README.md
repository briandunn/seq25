# SEQ25

A sequencer inspired by [SEQ24][s].

[s]: http://www.filter24.org/seq24/

## Setup

If you already have [lineman][l] installed, then just clone the app and run:

[l]: http://linemanjs.com

```
$ npm install
$ lineman run
```

Now go to http://localhost:8000 and you should see the app running.

## Running the tests

Lineman must be running to run the spec.

```
lineman spec
```

## Keyboard actions

### While viewing summary or part

g q - goes to part q, where q can be one of the part names, q w e r a s d f
m q - mutes part q, where q can be any part name
n q - bumps volume of part q
shift+n - lowers volume of part q

### While viewing a part

c - creates note in upper corner
click a note to select it
shift+click a note to select multiple notes

### Once a note or notes are selected

left - moves a note left
right - moves a note right
shift+left - shortens a note
shift+right - extends a note

## TODO

[] piano keys trigger midi
[] clear part
[] note velocity adjustment
[] performance issue on note add
[] handle localStorage quota exceeded event
