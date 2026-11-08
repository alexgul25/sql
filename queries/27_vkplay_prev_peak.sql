-- 27. Пик онлайна против пика предыдущего эфира того же стримера.
-- Только площадка 'VK Play Live'; prev_peak — пик предыдущего по started_at эфира того
-- же стримера, delta — их разность; первый эфир каждого стримера не выводится.
--
-- Колонки: streamer, followers, started_at, title, peak_viewers, prev_peak, delta
-- Порядок: followers по убыванию, внутри стримера started_at по возрастанию
-- Строк:   592

WITH vk_prev_peaks AS (
    SELECT
        ss.nickname AS streamer,
        ss.followers,
        s.started_at,
        s.title,
        s.peak_viewers,
        lag(s.peak_viewers) OVER (
            PARTITION BY ss.streamer_id
            ORDER BY s.started_at, s.stream_id
        ) AS prev_peak
    FROM streamers ss
    JOIN platforms p ON p.platform_id = ss.platform_id AND p.name = 'VK Play Live'
    JOIN streams s ON s.streamer_id = ss.streamer_id
)
SELECT 
    streamer,
    followers,
    started_at,
    title,
    peak_viewers,
    prev_peak,
    peak_viewers - prev_peak AS delta
FROM vk_prev_peaks
WHERE prev_peak IS NOT NULL
ORDER BY followers DESC, started_at ASC;
