SongSerializer = DS.LSSerializer.extend DS.EmbeddedRecordsMixin,
  attrs:
    parts:
      embedded: 'always'

`export default SongSerializer`
