-- 29. Полное дерево сборки Guardian Greaves, Bloodthorn, Harpoon и Hurricane Pike.
-- Строка на каждый путь вниз, сам корень не выводится; lvl с 1, qty — quantity последнего
-- шага, qty_total — произведение quantity по пути, path — имена от корня через ' > '.
--
-- Колонки: root_item, lvl, component, qty, qty_total, path
-- Порядок: root_item по возрастанию, затем path по возрастанию
-- Строк:   34

WITH RECURSIVE component_tree AS (
    SELECT
        root.name AS root_item,
        1 AS lvl,
        ir.component_id,
        c.name AS component,
        ir.quantity AS qty,
        ir.quantity AS qty_total,
        root.name || ' > ' || c.name AS path
    FROM items root
    JOIN item_recipe ir ON ir.item_id = root.item_id
    JOIN items c ON c.item_id = ir.component_id
    WHERE root.name IN ('Guardian Greaves', 'Bloodthorn', 'Harpoon', 'Hurricane Pike')
  UNION ALL
    SELECT
        ct.root_item,
        ct.lvl + 1,
        ir.component_id,
        c.name,
        ir.quantity,
        ct.qty_total * ir.quantity,
        ct.path || ' > ' || c.name
    FROM component_tree ct
    JOIN item_recipe ir ON ir.item_id = ct.component_id
    JOIN items c ON c.item_id = ir.component_id
)
SELECT
    root_item,
    lvl,
    component,
    qty,
    qty_total,
    path
FROM component_tree
ORDER BY root_item ASC, path ASC
LIMIT 34;
