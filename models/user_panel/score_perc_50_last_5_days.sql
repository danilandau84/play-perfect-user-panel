WITH player_rank_dates AS (
    select player_id,
           date_utc, 
           ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY date_utc DESC) AS day_number
    from (
        SELECT distinct player_id,date_utc from `play-perfect-427411.PLAYPERFECT.raw-data` 
    )         
),
all_days_per_player as (
SELECT 
player_id,
date_utc,
day_number,
max(day_number) OVER (PARTITION BY player_id) AS days_per_player
FROM
    player_rank_dates
),
five_days_score as (
    select a.player_id,
       b.tournament_score 
from all_days_per_player a join `play-perfect-427411.PLAYPERFECT.raw-data` b  
     on a.player_id = b.player_id and a.date_utc =  b.date_utc
where a.day_number <= 5 and  a.days_per_player >= 5   
),
player_median_score as (
        select player_id,
        APPROX_QUANTILES(tournament_score, 2)[OFFSET(1)]   AS score_perc_50_last_5_days
        from  five_days_score      
        group by player_id
)
select player_list.player_id, m.score_perc_50_last_5_days from 
( SELECT distinct player_id from `play-perfect-427411.PLAYPERFECT.raw-data`) player_list left join 
 player_median_score m on player_list.player_id = m.player_id

