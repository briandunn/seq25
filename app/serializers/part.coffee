PartSerializer = DS.JSONSerializer.extend DS.EmbeddedRecordsMixin,
  attrs:
    notes:
      embedded: 'always'
    synthesizers:
      embedded: 'always'
    midiInstruments:
      embedded: 'always'

`export default PartSerializer`
