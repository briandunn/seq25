Seq25.Router.map ->
  @resource 'songs', path: '/', ->
    @resource 'song', path: '/:song_id', ->
      @resource 'part', path: "/:name", ->
        @route 'instruments'
