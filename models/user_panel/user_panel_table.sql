select a.player_id, a.country, b.avg_amount as avg_price_10, c.last_weighted_daily_matches_count_10_played_days,
     d.active_days_since_last_purchase, e.score_perc_50_last_5_days
from {{ref('country_per_player') }} a join {{ref('avg_10_amount') }} b  on a.player_id = b.player_id
     join {{ref('last_weighted_daily_matches_count_10_played_days') }} c on b.player_id = c.player_id 
     join {{ref('active_days_since_last_purchase') }} d on c.player_id = d.player_id
     join {{ref('score_perc_50_last_5_days') }} e on d.player_id = e.player_id