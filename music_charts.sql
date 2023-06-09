-- CREATE SCHEMA `music_charts`;

USE music_charts;

################################################
-- Add chart_country column to allow comparisons
################################################
-- ALTER TABLE charts
-- ADD chart_country CHAR(2);

-- UPDATE charts
-- SET chart_country = 
--     CASE
--         WHEN chart_name LIKE '%FR%' THEN 'FR'
--         WHEN chart_name LIKE '%Billboard%' THEN 'US'
--         ELSE NULL
--     END
-- WHERE chart_id >= 0;



-- AVERAGE CHART POSITION OF A SONG BY A FEMALE PERFORMER

SELECT AVG(charts.chart_position) AS mean_position
FROM charts
JOIN song_chart ON charts.chart_id = song_chart.chart_id
-- JOIN songs ON song_chart.song_id2 = songs.song_id2
JOIN song_artist ON song_chart.song_id2 = song_artist.song_id2
JOIN artists ON song_artist.artist_id = artists.artist_id
WHERE artists.gender = 'Female';


-- note position #1 is better
-- note that FR charts are Top50 until 1998, then Top100
SELECT charts.chart_country, 
       -- Group by decades:
       CONCAT(YEAR(charts.chart_date) DIV 10 * 10, 's') AS decade,
       -- How many distinct artists in the charts of a known given gender?
       artists.gender, COUNT(DISTINCT(artists.artist_id)) AS artist_count,       
       -- What is the average chart position of a song by an artist of a known given gender?
       ROUND(AVG(charts.chart_position), 0) AS mean_position,
       -- How long does a song by an artist of a given gender stay in the charts on average?
       ROUND(COUNT(charts.chart_id) / COUNT(DISTINCT song_chart.song_id2), 0) AS avg_weeks_on_chart,
       -- How many songs by an artist of a known given gender on an average weekly chart?
       ROUND(COUNT(charts.chart_id) / COUNT(DISTINCT charts.chart_date), 0) AS avg_songs_per_week,
	   -- How many unique songs by gender artist that decade in each chart t
       COUNT(DISTINCT song_chart.song_id2) AS total_songs
FROM charts
JOIN song_chart ON charts.chart_id = song_chart.chart_id
JOIN song_artist ON song_chart.song_id2 = song_artist.song_id2
JOIN artists ON song_artist.artist_id = artists.artist_id
WHERE (artists.gender = 'Female' OR artists.gender = 'Male' OR artists.gender = 'Non-binary') 
-- AND charts.chart_date >= '1998-02-27' -- If we wanted comparable results for France (Top50 before that date)
GROUP BY charts.chart_country, decade, artists.gender
ORDER BY decade, charts.chart_country, artists.gender
;



-- For any artist who was featured in the charts, how many songs did have they had in the charts on average? (detail by decade)
SELECT charts.chart_country,
       CONCAT(YEAR(charts.chart_date) DIV 10 * 10, 's') AS decade, artists.gender,
       ROUND(COUNT(DISTINCT song_chart.song_id2) / COUNT(DISTINCT(artists.artist_id)), 0) AS avg_song_count
FROM charts
JOIN song_chart ON charts.chart_id = song_chart.chart_id
JOIN song_artist ON song_chart.song_id2 = song_artist.song_id2
JOIN artists ON song_artist.artist_id = artists.artist_id
WHERE (artists.gender = 'Female' OR artists.gender = 'Male' OR artists.gender = 'Non-binary')
GROUP BY charts.chart_country, decade, artists.gender
ORDER BY decade, charts.chart_country, artists.gender;


-- Who are the top 10 artists in number of songs that chart, with avg chart position?

SELECT artists.artist,
       charts.chart_country,
       CONCAT(YEAR(charts.chart_date) DIV 10 * 10, 's') AS decade,
       artists.gender,
       COUNT(DISTINCT song_chart.song_id2) AS song_count,
       ROUND(AVG(charts.chart_position), 1) AS avg_chart_position,
       MIN(charts.chart_position) AS best_chart_position
FROM charts
JOIN song_chart ON charts.chart_id = song_chart.chart_id
JOIN song_artist ON song_chart.song_id2 = song_artist.song_id2
JOIN artists ON song_artist.artist_id = artists.artist_id
WHERE artists.gender IN ('Female', 'Male', 'Non-binary')
GROUP BY artists.Artist, charts.chart_country, decade, artists.gender
ORDER BY song_count DESC
LIMIT 10;



-- THIS QUERY CAUSES timeout issue Error Code: 2013. Lost connection to MySQL server during query
-- Who are the artists with the largest number of distinct songs in top 10 of all time?

-- SELECT artists.artist, COUNT(DISTINCT song_chart.song_id2) AS song_count
-- FROM charts
-- JOIN song_chart ON charts.chart_id = song_chart.chart_id
-- JOIN song_artist ON song_chart.song_id2 = song_artist.song_id2
-- JOIN artists ON song_artist.artist_id = artists.artist_id
-- WHERE charts.chart_position <= 10
-- AND charts.chart_country = 'US'
-- GROUP BY artists.artist
-- ORDER BY song_count DESC
-- LIMIT 10;


-- Who are the 10 artists who have remained at #1 for the largest number of weeks in the US?

SELECT artists.artist, artists.gender,
COUNT(charts.chart_id) AS weeks_at_no1
FROM charts
JOIN song_chart ON charts.chart_id = song_chart.chart_id
JOIN song_artist ON song_chart.song_id2 = song_artist.song_id2
JOIN artists ON song_artist.artist_id = artists.artist_id
WHERE charts.chart_country = 'US' AND charts.chart_position = 1
	AND (artists.gender = 'Female' OR artists.gender = 'Male' OR artists.gender = 'Non-binary')
	-- AND artists.gender IN ('Female', 'Male', 'Non-binary')
GROUP BY artists.Artist, artists.gender
ORDER BY weeks_at_no1 DESC -- ORDER BY artists.gender, weeks_at_no1 DESC
LIMIT 10;


-- Who are the 10 Female artists who remained at #1 for the longest in France?

SELECT artists.artist, artists.gender,
COUNT(charts.chart_id) AS weeks_at_no1
FROM charts
JOIN song_chart ON charts.chart_id = song_chart.chart_id
JOIN song_artist ON song_chart.song_id2 = song_artist.song_id2
JOIN artists ON song_artist.artist_id = artists.artist_id
WHERE (charts.chart_country = 'FR') AND (charts.chart_position = 1)
	AND (artists.gender = 'Female' OR artists.gender = 'Non-binary')
GROUP BY artists.artist, artists.gender
ORDER BY weeks_at_no1 DESC
LIMIT 10;


-- How many distinct artists in the charts by gender?
-- (with detail by decade and country of charts)

SELECT charts.chart_country, 
       -- Group by decades:
       CONCAT(YEAR(charts.chart_date) DIV 10 * 10, 's') AS decade,
       artists.gender, COUNT(DISTINCT(artists.artist_id)) AS artist_count,
       -- What is the average chart position of a song by an artist of a known given gender?
       ROUND(AVG(charts.chart_position), 0) AS mean_position,
       -- How long does a song by an artist of a given gender stay in the charts on average?
       ROUND(COUNT(charts.chart_id) / COUNT(DISTINCT song_chart.song_id2), 0) AS avg_weeks_on_chart,
       -- How many songs by an artist by gender on an average weekly chart?
       ROUND(COUNT(charts.chart_id) / COUNT(DISTINCT charts.chart_date), 0) AS avg_songs_per_week,
       COUNT(DISTINCT song_chart.song_id2) AS total_songs
FROM charts
JOIN song_chart ON charts.chart_id = song_chart.chart_id
JOIN song_artist ON song_chart.song_id2 = song_artist.song_id2
JOIN artists ON song_artist.artist_id = artists.artist_id
WHERE (artists.gender = 'Female' OR artists.gender = 'Male' OR artists.gender = 'Non-binary')
	-- AND charts.chart_date >= '1998-02-27' -- ONLY TO COMPARE W/ FRANCE (Starting date of TOP100)
GROUP BY charts.chart_country, decade, artists.gender
ORDER BY decade, charts.chart_country, artists.gender
;