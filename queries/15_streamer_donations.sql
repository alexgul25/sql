-- 15. Сколько донатов собрал каждый стример.
-- В ответе все стримеры: без донатов donations = 0 и total_amount = 0.00;
-- team — команда с left_at IS NULL, иначе пусто.
--
-- Колонки: streamer, platform, team, donations, total_amount
-- Порядок: total_amount по убыванию, при равенстве streamer по возрастанию
-- Строк:   40

WITH d AS (
    SELECT
        s.streamer_id,
        count(sd.donation_id) AS donations,
        sum(sd.amount) AS total_amount
    FROM streams s
    LEFT JOIN stream_donations sd ON s.stream_id = sd.stream_id
    GROUP BY s.streamer_id
)
SELECT 
    st.nickname AS streamer,
    p.name AS platform,
    t.name AS team,
    coalesce(d.donations, 0) AS donations,
    coalesce(d.total_amount, 0.00) AS total_amount
FROM streamers st
JOIN platforms p ON st.platform_id = p.platform_id
LEFT JOIN team_members tm ON st.player_id = tm.player_id AND tm.left_at IS NULL
LEFT JOIN teams t ON tm.team_id = t.team_id
LEFT JOIN d ON d.streamer_id = st.streamer_id
ORDER BY total_amount DESC, streamer ASC;
