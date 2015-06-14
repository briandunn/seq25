# SEQ25

A sequencer inspired by [SEQ24][s].

[s]: http://www.filter24.org/seq24/

## Prerequisites

You will need the following things properly installed on your computer.

* [Git](http://git-scm.com/)
* [Node.js](http://nodejs.org/) (with NPM)
* [Bower](http://bower.io/)
* [Ember CLI](http://www.ember-cli.com/)
* [PhantomJS](http://phantomjs.org/)

## Installation

* `git clone https://github.com/briandunn/seq25.git` this repository
* change into the new directory
* `npm install`
* `bower install`

## Running / Development

* `ember server`
* Visit your app at [http://localhost:4200](http://localhost:4200).

To integrate over the ruby API bit:

* `ember server --proxy http://127.0.0.1:3000`

* create a database and load the schema from the spec file
* `CORS_ORIGIN='http://localhost:4200' DATABASE_URL='/seq25' bundle exec thin start`

### Running Tests

* `ember test`
* `ember test --server`

### Building

* `ember build` (development)
* `ember build --environment production` (production)

### Deploying

The Ember app

`deploy-frontend.sh`

The Rack API

`deploy-server.sh`

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

## Further Reading / Useful Links

* [ember.js](http://emberjs.com/)
* [ember-cli](http://www.ember-cli.com/)
* Development Browser Extensions
  * [ember inspector for chrome](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi)
  * [ember inspector for firefox](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/)

