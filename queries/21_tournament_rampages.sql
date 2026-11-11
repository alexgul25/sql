-- 21. Турнирные выступления с KDA выше шестикратного среднего.
-- KDA = (kills + assists)::numeric / GREATEST(deaths, 1); порог — строго больше шести
-- средних KDA по всей match_players; только матчи турниров; kda округлить до 2 знаков.
--
-- Колонки: match_id, tournament, player, hero, kda
-- Порядок: kda по убыванию, при равенстве match_id, затем slot
-- Строк:   60

WITH match_players_kda AS (
    SELECT 
        match_id,
        slot,
        player_id,
        hero_id,
        (kills + assists)::numeric / greatest(deaths, 1) AS kda
    FROM match_players
)
SELECT
    mpk.match_id,
    t.name AS tournament,
    p.nickname AS player,
    h.name AS hero,
    round(mpk.kda, 2) AS kda
FROM match_players_kda mpk
JOIN matches m ON mpk.match_id = m.match_id
JOIN tournaments t ON t.tournament_id = m.tournament_id
JOIN players p ON p.player_id = mpk.player_id
JOIN heroes h ON h.hero_id = mpk.hero_id
WHERE mpk.kda > 6 * (SELECT avg(kda) FROM match_players_kda)
ORDER BY kda DESC, match_id ASC, mpk.slot ASC;
