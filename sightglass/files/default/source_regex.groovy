/*
Expects `_source` to be available from elasticsearch.
Parameters:
    `source_field` param to look up from _source.
    `regex` param to match against.
    `required_field_length` param - null if no requirement, integer to specify required length.
 */
match = _source[source_field] =~ regex
isMatch = match.find()
// TODO(T4024): use match.start() and match.end() to remove false positives.
if (!isMatch || required_field_length == null) {
    return isMatch
}

sourceFieldLength = _source[source_field].size()
// Circular sequences have bases doubled and need to have length divided by 2.
if (_source.circular) {
    sourceFieldLength /= 2
}
return sourceFieldLength == required_field_length
