-- 09. Кто из стримеров за какую команду выступает сейчас.
-- Только действующие составы; стримеры без player_id не выводятся.
--
-- Колонки: streamer, platform, player, team, tag, followers
-- Порядок: followers по убыванию, при равенстве streamer по возрастанию
-- Строк:   16

SELECT
    s.nickname AS streamer,
    pf.name AS platform,
    p.nickname AS player,
    t.name AS team,
    t.tag,
    s.followers
FROM streamers s
JOIN team_members tm ON s.player_id = tm.player_id AND tm.left_at IS NULL
JOIN teams t ON t.team_id = tm.team_id
JOIN players p ON p.player_id = tm.player_id
JOIN platforms pf ON pf.platform_id = s.platform_id
ORDER BY followers DESC, streamer ASC
LIMIT 16;
