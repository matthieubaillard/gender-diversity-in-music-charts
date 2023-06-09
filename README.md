# Gender Diversity in Pop Music Charts
## and Machine learning recommender of Female artist

## Ironhack Data Analysis bootcamp final project

Project presentation 
https://github.com/matthieubaillard/gender-diversity-in-music-charts/blob/main/Gender_Diversity_in_pop_music_charts.pdf


## Data sources and data collection:

### 1) Billboard Hot 100 - USA, 1958-2022
Existing CSV downloaded from github.com/HipsterVizNinja/random-data/tree/main/Music/hot-100

### 2) France’s Top 50 (1984-1998) & Top 100 (1998-2020)
Web scraped via Python from chartsinfrance.net/charts/8444/singles.php
Official publisher of the official charts for singles sales in France, compiled by GFK Music for the SNEP (Syndicat National de l'Edition Phonographique)
cf. Jupyter Notebook projet.ipynb for the scraping code
top50.csv

### 3) MusicBrainz API
Artist metadata fetched from their API for artists in either of above charts (not all artists are perfect matches, and we couldn't manually picerrors in the project's limited time; e.g. Japanese post-rock band Boris obviously isn't the French one-hit novelty that charted in the 90'sthough I wish Boris from Japan had hits on the radio :-))
cf. Jupyter Notebook projet.ipynb for the fetching code

### 4) Last.fm API
Artist bios fetched through their API. Bios which we use for the machine learning.
cf. Jupyter Notebook projet.ipynb for the fetching code

## Data Cleaning
cf. Jupyter Notebook projet.ipynb

## EDA and visualization
Data viz using Matplotlib, Seaborn and Tableau.
cf. Jupyter Notebook projet.ipynb and PDF presentation

## MySQL
Data exported from Dataframes to MySql (see projet.ipynb for the code)
Entity Relationship Model: see charts_mysql_db_ERM
Examples of queries: see music_charts.sql

## Machine Learning
cf projet_2_ML.ipynb