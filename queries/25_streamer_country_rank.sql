-- 25. Место стримера-профессионала в рейтинге своей страны.
-- Только стримеры с player_id и действующей записью в team_members; место по mmr
-- по убыванию и country_players считаются по всей players; player — ник из players.
--
-- Колонки: player, country, mmr, country_rank, country_players, team_tag, platform
-- Порядок: country по возрастанию, внутри страны country_rank по возрастанию
-- Строк:   16

WITH country_mmr_rank AS (
    SELECT 
        player_id,
        nickname,
        country,
        mmr,
        rank() OVER (PARTITION BY country ORDER BY mmr DESC) AS country_rank,
        count(player_id) OVER (PARTITION BY country) AS country_players
    FROM players
)
SELECT 
    cr.nickname AS player,
    cr.country,
    cr.mmr,
    cr.country_rank,
    cr.country_players,
    t.tag AS team_tag,
    p.name AS platform
FROM streamers s
JOIN country_mmr_rank cr ON cr.player_id = s.player_id
JOIN team_members tm ON tm.player_id = s.player_id AND tm.left_at IS NULL
JOIN teams t ON t.team_id = tm.team_id
JOIN platforms p ON p.platform_id = s.platform_id
ORDER BY country ASC, country_rank ASC
LIMIT 16;
