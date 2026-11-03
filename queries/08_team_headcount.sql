-- 08. Сколько в команде игроков и сколько среди них стримеров.
-- Считаются только незакрытые периоды; команда без состава остаётся
-- в ответе с нулями, стримеры без player_id не учитываются.
--
-- Колонки: name, tag, players_now, streamers_now
-- Порядок: players_now по убыванию, при равенстве name по возрастанию
-- Строк:   24

SELECT 
    t.name,
    t.tag,
    count(p.player_id) AS players_now,
    count(s.streamer_id) AS streamers_now
FROM teams t
LEFT JOIN team_members tm ON t.team_id = tm.team_id AND tm.left_at IS NULL
LEFT JOIN players p ON p.player_id = tm.player_id
LEFT JOIN streamers s ON s.player_id = p.player_id
GROUP BY t.team_id
ORDER BY players_now DESC, t.name ASC
LIMIT 24;
