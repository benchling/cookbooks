/*
Expects `_source` to be available from elasticsearch.
Parameters:
    `source_field` param to look up from _source.
    `regex` param to match against.
    `required_field_length` param - null if no requirement, integer to specify required length.
 */
match = _source[source_field] =~ regex
isMatch = match.find()
if (!isMatch) {
    return false
}

sourceFieldLength = _source[source_field].size()
// Circular sequences have bases doubled and need to have length divided by 2.
if (_source.circular) {
    sourceFieldLength /= 2
}

if ((match.end() - match.start()) > sourceFieldLength) {
    // If the match exceeds our field length, then this is a false positive on circular sequences.
    return false
}

return required_field_length == null || sourceFieldLength == required_field_length
