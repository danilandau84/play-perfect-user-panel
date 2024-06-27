-- SELECT player_id, country  FROM `play-perfect-427411.PLAYPERFECT.raw-data` 
WITH ranked_player_by_timestamp AS (
    SELECT
        player_id,
        amount,
        timestamp_utc,
        ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY timestamp_utc DESC) AS rn
    FROM
         `play-perfect-427411.PLAYPERFECT.raw-data` 
    WHERE amount is not null
),
player_avg_amount as (


SELECT 
player_id,
avg(amount) avg_amount
FROM
    ranked_player_by_timestamp
where rn <=10    
group by player_id    
)

select player_id, avg_amount  
from player_avg_amount