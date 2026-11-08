-- 26. Нарастающая сумма донатов внутри каждого стрима Вжлинка за 2021 год.
-- Стримы Вжлинка, начавшиеся в 2021 году по UTC, строка на каждый донат; running_total —
-- нарастающая сумма донатов своего стрима по sent_at_sec.
--
-- Колонки: stream_id, title, sent_at_sec, donor, amount, running_total
-- Порядок: stream_id по возрастанию, внутри стрима sent_at_sec по возрастанию
-- Строк:   192

WITH vjlink_streams AS (
    SELECT
        s.stream_id,
        s.title
    FROM streams s
    JOIN streamers ss ON ss.streamer_id = s.streamer_id
    WHERE ss.nickname = 'Вжлинк' AND extract(year FROM s.started_at) = 2021 
)
SELECT
    sd.stream_id,
    vs.title,
    sd.sent_at_sec,
    sd.nickname AS donor,
    sd.amount,
    sum(sd.amount) OVER (
        PARTITION BY sd.stream_id
        ORDER BY sd.sent_at_sec, sd.donation_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM stream_donations sd
JOIN vjlink_streams vs ON vs.stream_id = sd.stream_id
ORDER BY stream_id ASC, sent_at_sec ASC, sd.donation_id ASC;
