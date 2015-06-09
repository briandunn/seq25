module.exports = function(app) {
  var express = require('express');
  var songsRouter = express.Router();

  songsRouter.get('/', function(req, res) {
    res.send({
      'songs': []
    });
  });

  songsRouter.post('/', function(req, res) {
    res.status(201).end();
  });

  songsRouter.get('/:id', function(req, res) {
    res.send({
      'songs': {
        id: req.params.id
      }
    });
  });

  songsRouter.put('/:id', function(req, res) {
    res.send({
      'songs': {
        id: req.params.id
      }
    });
  });

  songsRouter.delete('/:id', function(req, res) {
    res.status(204).end();
  });

  app.use('/songs', songsRouter);
};
