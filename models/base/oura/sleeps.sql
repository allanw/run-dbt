with sleeps as (
    select
        summary_date,
        bedtime_start,
        bedtime_end,
        bedtime_end - bedtime_start as time_in_bed,
        to_char((duration - awake) * '1 second'::interval, 'HH24:MI:SS') as time_asleep
    from tap_oura.sleeps
)

select * from sleeps
