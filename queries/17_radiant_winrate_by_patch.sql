-- 17. Доля побед светлой стороны по патчам.
-- Патч без единого матча не выводится; radiant_winrate — процент,
-- round(100.0 * radiant_wins / matches, 2).
--
-- Колонки: version, matches, radiant_wins, radiant_winrate
-- Порядок: radiant_winrate (округлённое) по убыванию, при равенстве version по возрастанию
-- Строк:   12

SELECT 
    p.version,
    count(m.match_id) AS matches,
    count(m.match_id) FILTER (WHERE m.winner = 'radiant') AS radiant_wins,
    round(100.0 * count(m.match_id) FILTER (WHERE m.winner = 'radiant') / count(m.match_id), 2) AS radiant_winrate
FROM patches p
JOIN matches m ON m.patch_id = p.patch_id
GROUP BY p.patch_id
ORDER BY radiant_winrate DESC, version ASC
Limit 12;
