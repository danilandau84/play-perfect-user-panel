
with latest_purchase_date_per_player as (
select player_id, date(max(timestamp_utc)) latest_purchase_date
    from `play-perfect-427411.PLAYPERFECT.raw-data`
    where amount is not null
    group by player_id 

),

dates_per_player as (
select player_id, date(timestamp_utc) as date 
    from `play-perfect-427411.PLAYPERFECT.raw-data`
    group by player_id ,date(timestamp_utc)

),
calc_active_days as (
select a.player_id, 
case when a.date > b.latest_purchase_date then 1 else 0 end as active_day 
from dates_per_player a join latest_purchase_date_per_player b on a.player_id = b.player_id

)

select player_id ,sum(active_day) as active_days_since_last_purchase
from calc_active_days
group by player_id


    