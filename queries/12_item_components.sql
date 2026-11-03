-- 12. Сборные предметы внутри сборных предметов.
-- Пары «предмет — непосредственный компонент», где компонент сам встречается
-- в item_recipe.item_id; каждая пара один раз, component_cost — цена штуки.
--
-- Колонки: item_name, component_name, quantity, component_cost
-- Порядок: item_name по возрастанию, внутри предмета component_name по возрастанию
-- Строк:   36

SELECT
    i.name AS item_name,
    i2.name AS component_name,
    ir.quantity,
    i2.cost AS component_cost
FROM items i
JOIN item_recipe ir ON i.item_id = ir.item_id
JOIN items i2 ON ir.component_id = i2.item_id
WHERE EXISTS (
    SELECT 1
    FROM item_recipe ir2
    WHERE ir2.item_id = ir.component_id
)
ORDER BY item_name ASC, component_name ASC
LIMIT 36; 
