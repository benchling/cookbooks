// Expects `_source` to be available from elasticsearch.
// Expects `source_field` param to look up from _source.
// Expects `regex` param to match against.
(_source[source_field] =~ regex).find()
