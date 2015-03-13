PartSerializer = DS.LSSerializer.extend DS.EmbeddedRecordsMixin,
  attrs:
    notes:
      embedded: 'always'
    synthesizers:
      embedded: 'always'
    midiInstruments:
      embedded: 'always'

`export default PartSerializer`
