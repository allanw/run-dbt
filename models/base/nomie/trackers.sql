select
    note,
    substring(note, '#\w*') as tracker_type,
    substring(note, '#\w*?\((\d+[.]?\d+)\)') as tracker_value,
    TIMESTAMP 'epoch' + start * INTERVAL '1 millisecond' as started_on
from tap_nomie.books
limit 100