
WITH RECURSIVE generate_series(value) AS (
  select(select min(timestamp) - min(timestamp) % (5 * 60) from heartrate)
  UNION ALL
  SELECT value + 60 * 5 FROM generate_series
   WHERE value + 60 * 5 <= (select max(timestamp) - max(timestamp) % (5 * 60) from heartrate)
)
select 
    round(h.bpm) as bpm,
    s.value as timestamp,
    strftime('%Y-%m-%d %H:%M', s.value, 'unixepoch')
from (
    select 
        avg(bpm) as bpm, 
        -- Timestamp %Y-%m-%dT%H:%M where %M is rounded down to the last 5 minute interval
        -- 2023-11-28T13:09:11 --> 2023-11-28T13:05
        -- 2023-11-28T13:11:11 --> 2023-11-28T13:10
        timestamp - timestamp % (5 * 60) as five_minute_time

    from heartrate h
    group by five_minute_time
) as h
right join generate_series s on s.value = h.five_minute_time
        
order by s.value






