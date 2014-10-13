Seq25.Router.map ->
  @route 'loadSong', path: '/r/:id'
  @resource 'songs', path: '/', ->
    @resource 'song', path: '/:song_id', ->
      @resource 'part', path: "/:name", ->
        @route 'instruments'
