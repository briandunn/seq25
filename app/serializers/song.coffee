SongSerializer = DS.JSONSerializer.extend DS.EmbeddedRecordsMixin,
  attrs:
    parts:
      embedded: 'always'

`export default SongSerializer`
