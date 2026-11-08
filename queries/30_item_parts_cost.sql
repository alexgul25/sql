-- 30. Стоимость сборки из базовых составляющих против собственной цены предмета.
-- Берутся предметы со строками в item_recipe, сборка раскрывается до базовых (тех, у кого
-- строк в item_recipe нет, свитки тоже), количества по пути перемножаются; diff = parts_cost - cost.
--
-- Колонки: name, cost, parts_cost, base_parts, diff
-- Порядок: diff по убыванию, при равенстве name по возрастанию
-- Строк:   77

WITH RECURSIVE assembly_tree AS (
    SELECT
        ir.item_id AS root_id,
        ir.component_id,
        ir.quantity AS qty_total
    FROM item_recipe ir
  UNION ALL
    SELECT
        tr.root_id,
        ir.component_id,
        tr.qty_total * ir.quantity
    FROM assembly_tree tr
    JOIN item_recipe ir ON ir.item_id = tr.component_id
), leaf_totals AS (
    SELECT
        tr.root_id,
        sum(tr.qty_total * c.cost) AS parts_cost,
        sum(tr.qty_total) AS base_parts
    FROM assembly_tree tr
    JOIN items c ON c.item_id = tr.component_id
    WHERE NOT EXISTS (
        SELECT 1
        FROM item_recipe ir
        WHERE ir.item_id = tr.component_id
    )
    GROUP BY tr.root_id
)
SELECT
    i.name,
    i.cost,
    lt.parts_cost,
    lt.base_parts,
    lt.parts_cost - i.cost AS diff
FROM leaf_totals lt
JOIN items i ON i.item_id = lt.root_id
ORDER BY diff DESC, name ASC;
