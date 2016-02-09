// Expects `_source` to be available from elasticsearch.
// Expects `regex` param to match against.
def m = _source.bases =~ regex
m.find()
