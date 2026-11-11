-- 23. Игроки, поигравшие больше чем за одну команду.
-- Считаются различные team_id по всем периодам, строго больше одного; current_team —
-- название команды с пустым left_at, current_team и streamer могут быть NULL.
--
-- Колонки: player, country, teams_count, current_team, streamer
-- Порядок: teams_count по убыванию, при равенстве player по возрастанию
-- Строк:   25

WITH player_teams_count AS (
    SELECT 
        player_id,
        count(DISTINCT team_id) AS teams_count
    FROM team_members
    GROUP BY player_id
)
SELECT
    p.nickname AS player,
    p.country,
    ptc.teams_count,
    t.name AS current_team,
    s.nickname AS streamer
FROM players p
JOIN player_teams_count ptc ON ptc.player_id = p.player_id
LEFT JOIN team_members tm ON tm.player_id = p.player_id AND tm.left_at IS NULL
LEFT JOIN teams t ON t.team_id = tm.team_id
LEFT JOIN streamers s ON s.player_id = p.player_id
WHERE ptc.teams_count > 1
ORDER BY teams_count DESC, player ASC;
