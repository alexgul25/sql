-- 19. Стримеры, которые ни разу не брали Pudge.
-- Только стримеры с непустым player_id и без единой игры за 'Pudge'; team — тег
-- команды с left_at IS NULL, иначе пусто; games — все строки match_players игрока.
--
-- Колонки: streamer, platform, team, followers, games
-- Порядок: followers по убыванию, при равенстве streamer по возрастанию
-- Строк:   8

WITH player_games_count AS (
    SELECT
        mp.player_id,
        count(mp.player_id) AS games,
        count(mp.player_id) FILTER (WHERE h.name = 'Pudge') AS pudge_games
    FROM match_players mp
    JOIN heroes h ON h.hero_id = mp.hero_id
    GROUP BY mp.player_id
)
SELECT
    s.nickname AS streamer,
    p.name AS platform,
    t.tag AS team,
    s.followers,
    coalesce(pgc.games, 0) AS games
FROM streamers s
JOIN platforms p ON p.platform_id = s.platform_id
LEFT JOIN team_members tm ON tm.player_id = s.player_id AND tm.left_at IS NULL
LEFT JOIN teams t ON t.team_id = tm.team_id
LEFT JOIN player_games_count pgc ON pgc.player_id = s.player_id
WHERE coalesce(pgc.pudge_games, 0) = 0 AND s.player_id IS NOT NULL 
ORDER BY followers DESC, streamer ASC
LIMIT 8;
