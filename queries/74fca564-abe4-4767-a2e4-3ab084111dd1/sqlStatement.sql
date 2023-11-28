select 
    avg(bpm), 
    -- Timestamp %Y-%m-%dT%H:%M where %M is rounded down to the last 5 minute interval
    -- 2023-11-28T13:09:11 --> 2023-11-28T13:05
    -- 2023-11-28T13:11:11 --> 2023-11-28T13:10
    strftime('%Y-%m-%dT%H:', timestamp, 'unixepoch') || 
        printf('%02d', 
                strftime('%M', timestamp, 'unixepoch') - strftime('%M', timestamp, 'unixepoch') % 5
        )
    as five_minute_time 
from heartrate
group by five_minute_time;