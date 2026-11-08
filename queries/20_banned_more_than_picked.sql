-- 20. Герои, которых на патче банили чаще, чем брали.
-- Патч — matches.patch_id; в ответе пары с bans строго больше picks, diff = bans - picks.
--
-- Колонки: version, hero, bans, picks, diff
-- Порядок: diff по убыванию, затем hero по возрастанию, затем version по возрастанию
-- Строк:   99

WITH hero_bans_by_patch AS (
    SELECT
        mb.hero_id,
        m.patch_id,
        count(mb.hero_id) AS bans
    FROM match_bans mb
    JOIN matches m ON m.match_id = mb.match_id
    GROUP BY mb.hero_id, m.patch_id
), hero_picks_by_patch AS (
    SELECT
        mp.hero_id,
        m.patch_id,
        count(mp.hero_id) AS picks
    FROM match_players mp
    JOIN matches m ON m.match_id = mp.match_id
    GROUP BY mp.hero_id, m.patch_id
)
SELECT 
    p.version,
    h.name AS hero,
    hb.bans,
    coalesce(hp.picks, 0) AS picks,
    hb.bans - coalesce(hp.picks, 0) AS diff
FROM hero_bans_by_patch hb
JOIN heroes h ON h.hero_id = hb.hero_id
JOIN patches p ON p.patch_id = hb.patch_id
LEFT JOIN hero_picks_by_patch hp ON hp.hero_id = hb.hero_id AND hp.patch_id = hb.patch_id
WHERE hb.bans > coalesce(hp.picks, 0)
ORDER BY diff DESC, hero ASC, version ASC;
