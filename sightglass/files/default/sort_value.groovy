def value = null

if (sort_field.contains('.')) {
  // For top-level fields, use the value from _source.
  // Using doc[sort_field] results in a faster search since _source is not loaded into memory,
  // but unfortunately does not work for analyzed fields.
  value = _source[sort_field]
} else {
  // For nested fields, apply the nested_filter and use the value from the field that matches
  // the nested filter.
  // Ideally, ES would apply this filter through `nested_path` and `nested_filter` params in the
  // sort spec. Setting `nested_path` causes script not to be run; `nested_filter` doesn't
  // properly filter all documents. A future version of ES may support this.
  (nested_path, nested_field) = sort_field.tokenize('.')
  for (nested_source in _source[nested_path]) {
   if (nested_source[nested_filter_field] == nested_filter_value) {
     value = nested_source[nested_field]
     break
   }
  }
}
// If no value is set, return a value such that the document is sorted last.
// This achieves {'missing': '_last'}, which isn't currently supported for script-based sorting.
if (value == null) {
  if (order == 'asc') {
    return Character.MAX_VALUE.toString()
  } else {
    return ''
  }
}
// Transform to lowercase (for case-insensitive sorting).
def lower_case_value = value.toLowerCase()
// 0-pad consecutive digits to 20 (for natural sorting).
return lower_case_value.replaceAll(/\d+/, { number -> number.padLeft(20, '0') })
