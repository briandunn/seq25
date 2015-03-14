`import Ember from 'ember';`
`import config from './config/environment';`

Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  @resource 'songs', path: '/', ->
    @resource 'song', path: '/:song_id', ->
      @resource 'part', path: "/:name", ->
        @route 'instruments'

`export default Router`
