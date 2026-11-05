-- 28. Три самых дорогих предмета в каждой категории лавки.
-- Категория: 'recipe' при is_recipe, иначе 'assembled' при строках в item_recipe.item_id,
-- иначе 'basic'; place 1-3 по cost убыв., при равной цене по name; purchases — строк match_items, иначе 0.
--
-- Колонки: category, place, name, cost, purchases
-- Порядок: category по возрастанию, затем place по возрастанию
-- Строк:   9

WITH item_categories AS (
    SELECT
        i.item_id,
        i.name,
        i.cost,
        CASE
            WHEN i.is_recipe THEN 'recipe'
            WHEN EXISTS (
                SELECT 1
                FROM item_recipe ir
                WHERE ir.item_id = i.item_id
            ) THEN 'assembled'
            ELSE 'basic'
        END AS category
    FROM items i
), category_places AS (
    SELECT
        item_id,
        name,
        cost,
        category,
        row_number() OVER (
            PARTITION BY category
            ORDER BY cost DESC, name ASC
        ) AS place
    FROM item_categories
), item_purchases AS (
    SELECT
        item_id,
        count(item_id) AS purchases
    FROM match_items
    GROUP BY item_id
)
SELECT
    cp.category,
    cp.place,
    cp.name,
    cp.cost,
    coalesce(ip.purchases, 0) AS purchases
FROM category_places cp
LEFT JOIN item_purchases ip ON ip.item_id = cp.item_id
WHERE cp.place <= 3
ORDER BY category ASC, place ASC
LIMIT 9;
