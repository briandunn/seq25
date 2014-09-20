Seq25.Router.map ->
  @resource 'parts', path: '/', ->
    @resource 'part', path: "/:name", ->
      @route 'instrument'
