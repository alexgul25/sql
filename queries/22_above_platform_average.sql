-- 22. Стримеры с подписчиками выше среднего по своей площадке.
-- Строго больше среднего по всем стримерам площадки, сам стример в среднее входит;
-- platform_avg до 2 знаков; team — тег действующей команды, иначе NULL.
--
-- Колонки: streamer, platform, followers, platform_avg, team
-- Порядок: followers по убыванию, при равенстве streamer по возрастанию
-- Строк:   16

WITH platform_avg_followers AS (
    SELECT
        platform_id,
        avg(followers) AS avg_followers
    FROM streamers 
    GROUP BY platform_id
)
SELECT 
    s.nickname AS streamer,
    p.name AS platform,
    s.followers,
    round(paf.avg_followers, 2) AS platform_avg,
    t.tag AS team
FROM streamers s
JOIN platforms p ON p.platform_id = s.platform_id
JOIN platform_avg_followers paf ON paf.platform_id = p.platform_id
LEFT JOIN team_members tm ON tm.player_id = s.player_id AND tm.left_at IS NULL
LEFT JOIN teams t ON t.team_id = tm.team_id
WHERE s.followers > paf.avg_followers
ORDER BY followers DESC, streamer ASC
LIMIT 16;
