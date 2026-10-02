import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType});

Router.map(function() {
  return this.resource('songs', {path: '/'}, function() {
    return this.resource('song', {path: '/:song_id'}, function() {
      return this.resource('part', {path: "/:name"}, function() {
        return this.route('instruments');
      });
    });
  });
});

export default Router;
