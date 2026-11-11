-- 24. Турниры, чей призовой фонд больше суммы призовых всех предыдущих.
-- Предыдущие — со строго меньшим started_at, сравнение строгое; у первого турнира
-- prev_total и prev_count нули, не NULL; matches_played — число матчей турнира.
--
-- Колонки: tournament, started_at, prize_pool, prev_total, prev_count, matches_played
-- Порядок: started_at по возрастанию
-- Строк:   2

WITH tournament_prevs AS (
    SELECT
        tournament_id,
        name,
        started_at,
        prize_pool,
        coalesce(sum(prize_pool) OVER prev, 0) AS prev_total,
        count(tournament_id) OVER prev AS prev_count
    FROM tournaments
    WINDOW prev AS (
        ORDER BY started_at
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW EXCLUDE GROUP
    )
)
SELECT 
    tp.name AS tournament,
    tp.started_at,
    tp.prize_pool,
    tp.prev_total,
    tp.prev_count,
    (SELECT count(match_id) FROM matches WHERE tournament_id = tp.tournament_id) AS matches_played
FROM tournament_prevs tp
WHERE tp.prize_pool > tp.prev_total
ORDER BY started_at;
