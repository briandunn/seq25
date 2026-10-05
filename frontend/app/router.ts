import EmberRouter from '@embroider/router';
import config from 'seq25/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  // `/` lists songs (the index route).
  this.route('song', { path: '/:song_id' }, function () {
    this.route('part', { path: '/:name' }, function () {
      this.route('instruments');
    });
  });
});
