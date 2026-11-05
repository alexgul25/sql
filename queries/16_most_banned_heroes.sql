-- 16. Десятка самых банимых героев.
-- bans — строки match_bans, picks — строки match_players, bans_per_pick =
-- round(bans::numeric / picks, 2); первые десять берутся после сортировки.
--
-- Колонки: hero, bans, picks, bans_per_pick
-- Порядок: bans по убыванию, при равенстве hero по возрастанию
-- Строк:   10
WITH bans_count AS (
    SELECT 
        hero_id,
        count(hero_id) AS bans
    FROM match_bans
    GROUP BY hero_id
), picks_count AS (
    SELECT
        hero_id,
        count(hero_id) AS picks
    FROM match_players
    GROUP BY hero_id
)
SELECT 
    h.name AS hero,
    coalesce(bc.bans, 0) AS bans,
    coalesce(pc.picks, 0) AS picks,
    round(bc.bans::numeric / pc.picks, 2) AS bans_per_pick
FROM heroes h
LEFT JOIN bans_count bc ON bc.hero_id = h.hero_id
LEFT JOIN picks_count pc ON pc.hero_id = h.hero_id
ORDER BY bans DESC, hero ASC
LIMIT 10;
