modified_time = null

// Sort entries by their entry days instead of their modified_at
// Also handle old entries that don't have entry days
if (doc['_type'][0] == 'entry' && doc.containsKey('entry_day_dates')) {
    if (order == 'asc') {
        modified_time = doc['entry_day_dates'].values.min()
    } else {
        modified_time = doc['entry_day_dates'].values.max()
    }
} else {
    modified_time = doc['modified_at'].value
}

if (order == 'asc') {
    return modified_time
} else {
    return -modified_time
}
