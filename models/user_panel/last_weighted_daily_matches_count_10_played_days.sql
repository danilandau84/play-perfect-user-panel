WITH aggragate_by_date as (
    select player_id, DATE(timestamp_utc) as day, count(1) as match_count      
    from `play-perfect-427411.PLAYPERFECT.raw-data`
    group by player_id, DATE(timestamp_utc) 
),
days_per_player as (

    select player_id,count(day) as days
    from aggragate_by_date
    group by player_id
 ), 

rank_day_by_recency as(
select player_id,
       day,
       11 - (ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY day DESC)) AS day_rank,
       match_count 
       from aggragate_by_date
),

last_maximum_ten as(
select a.player_id,
        a.day,
        b.days,
        a.day_rank - (10 - least(10,b.days)) as new_day_rank ,
        a.match_count
       from rank_day_by_recency a join days_per_player b on a.player_id = b.player_id  
 where day_rank > 0
),
calculate_avg as (
    select player_id, sum(new_day_rank * match_count) / sum(match_count) as last_weighted_daily_matches_count_10_played_days
    from last_maximum_ten
    group by player_id
)

select * from calculate_avg
