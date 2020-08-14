with sleeps as (
    select
        summary_date,
        bedtime_start,
        bedtime_end,
        bedtime_end - bedtime_start as time_in_bed,
        round((duration - awake) / 60.0 / 60, 2) as time_asleep
    from tap_oura.sleeps
)

select * from sleeps
