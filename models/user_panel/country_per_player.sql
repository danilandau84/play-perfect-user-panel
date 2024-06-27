WITH ranked_player_by_timestamp AS (
    SELECT
        player_id,
        country,
        ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY timestamp_utc DESC) AS rn
    FROM
         `play-perfect-427411.PLAYPERFECT.raw-data`
)
SELECT 
    player_id,
        country
FROM
    ranked_player_by_timestamp
 WHERE
 rn = 1
