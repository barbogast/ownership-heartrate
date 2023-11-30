-- Average bpm values in 5 minute intervals

--select * from heartrate order by timestamp
-- Generate a temporary table containing timestamps in a 5 minute interval.
-- This table gets joined to the actual data and will fill gaps in the 
-- measurement, so we have a continuous time series.
WITH RECURSIVE generate_series(value) AS (
  SELECT unixepoch('2023-11-06T17:50:00')
  UNION ALL
  SELECT value + 60 * 5 FROM generate_series
   WHERE value + 60 * 5 <= unixepoch('2023-11-15T23:00:00')
)
select 
    round(h.bpm) as bpm,
    s.value as timestamp,
    strftime('%Y-%m-%dT%H:%M', s.value, 'unixepoch')
from (
    select 
        avg(bpm) as bpm, 
        -- Timestamp %Y-%m-%dT%H:%M where %M is rounded down to the last 5 minute interval
        -- 2023-11-28T13:09:11 --> 2023-11-28T13:05
        -- 2023-11-28T13:11:11 --> 2023-11-28T13:10
        unixepoch(strftime('%Y-%m-%dT%H:', timestamp, 'unixepoch') || 
            printf('%02d', 
                    strftime('%M', timestamp, 'unixepoch') - strftime('%M', timestamp, 'unixepoch') % 5
            ) || ':00')
        as five_minute_time

    from heartrate h
    group by five_minute_time
) as h
right join generate_series s on s.value = h.five_minute_time
        
order by s.value;