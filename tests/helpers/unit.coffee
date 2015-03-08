stubAudio = (container) ->
  stubContext =
    createGain: ->
      connect: ->
      disconnect: ->
      gain: {}
  container.register 'audioContext:main', stubContext

configureTestStore = (container) ->
  container.register 'adapter:application', DS.LSAdapter.extend(namespace: 'seq25test')
  container.register 'serializer:application', DS.LSSerializer.extend()
  DS._setupContainer container
  container.lookup 'store:main'

`export {configureTestStore, stubAudio}`
