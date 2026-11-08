-- 10. Все роли героев, которые умеют быть керри.
-- Только герои с ролью 'carry'; у каждого выводятся все его роли, по строке на роль.
--
-- Колонки: name, primary_attr, attack_type, role
-- Порядок: name по возрастанию, внутри героя role по возрастанию
-- Строк:   47

SELECT
    h.name,
    h.primary_attr,
    h.attack_type,
    hr2.role
FROM heroes h
JOIN hero_roles hr ON h.hero_id = hr.hero_id AND hr.role = 'carry'
JOIN hero_roles hr2 ON hr2.hero_id = hr.hero_id
ORDER BY h.name ASC, hr2.role ASC;
