const stubAudio = function(container) {
  const stubContext = {
    createGain() {
      return {
        connect() {},
        disconnect() {},
        gain: {}
      };
    }
  };
  return container.register('audioContext:main', stubContext);
};

const configureTestStore = function(container) {
  container.register('adapter:application', DS.LSAdapter.extend({namespace: 'seq25test'}));
  container.register('serializer:application', DS.LSSerializer.extend());
  DS._setupContainer(container);
  return container.lookup('store:main');
};

export {configureTestStore, stubAudio};
