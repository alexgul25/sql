-- 18. Призовые турниров, до которых добрались игроки команды.
-- Турнир в зачёт один раз, если игрок сыграл его матч в составе: joined_at <=
-- started_at::date < left_at (пустой left_at — сейчас); команды без турниров не выводятся.
--
-- Колонки: team, tag, tournaments, prize_total
-- Порядок: prize_total по убыванию, при равенстве team по возрастанию
-- Строк:   22

WITH team_tournaments AS (
    SELECT DISTINCT
        tmm.team_id,
        m.tournament_id
    FROM team_members tmm
    JOIN match_players mp ON mp.player_id = tmm.player_id
    JOIN matches m ON m.match_id = mp.match_id 
    WHERE tmm.joined_at <= m.started_at::date
        AND (tmm.left_at IS NULL OR m.started_at::date < tmm.left_at)
        AND m.tournament_id IS NOT NULL
)
SELECT 
    tm.name AS team,
    tm.tag,
    count(t.tournament_id) AS tournaments,
    sum(t.prize_pool) AS prize_total
FROM teams tm
JOIN team_tournaments tt ON tt.team_id = tm.team_id
JOIN tournaments t ON t.tournament_id = tt.tournament_id
GROUP BY tm.team_id
ORDER BY prize_total DESC, team ASC
LIMIT 22;
