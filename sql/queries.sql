SELECT * FROM EPL2025.Matches;

--------------------------------------------------------------
--------------------------------------------------------------
-- Q1: Do certain referees influence match behavior?
-- Which referee officiated the most matches ; and what is the average total number of fouls committed in those matches?

SELECT TOP 10 
    referee,
    COUNT(*) AS matches_officiated,
    ROUND(AVG(CAST(home_fouls + away_fouls AS DECIMAL(10,2))), 2) AS avg_total_fouls,
    ROUND(AVG(CAST(home_yellow_cards + away_yellow_cards + home_red_cards + away_red_cards AS DECIMAL(10,2))), 2) AS avg_cards_per_game,
    ROUND(AVG(CAST(home_yellow_cards + away_yellow_cards AS DECIMAL(10,2))), 2) AS avg_yellow_cards,
    ROUND(AVG(CAST(home_red_cards + away_red_cards AS DECIMAL(10,2))), 2) AS avg_red_cards
FROM 
    EPL2025.Matches
GROUP BY 
    referee
ORDER BY 
    matches_officiated DESC, avg_total_fouls DESC;

-- Follow-up question: Which are the most 'heated' matches?
SELECT TOP 10
    match_id,
    (home_fouls + away_fouls) AS total_fouls,
    (home_yellow_cards + away_yellow_cards + home_red_cards + away_red_cards) AS total_cards,
    home_yellow_cards,
    away_yellow_cards,
    home_red_cards,
    away_red_cards,
    referee
FROM
    EPL2025.Matches
ORDER BY
    total_cards DESC,
    total_fouls DESC;

--------------------------------------------------------------
--------------------------------------------------------------
-- Q2. What predicts a high-scoring match?
SELECT 
    CASE 
        WHEN total_goals >= 3 THEN 'High Scoring'
        ELSE 'Low Scoring'
    END AS match_type,
    COUNT(*) AS match_count,
    ROUND(AVG(CAST(home_shots + away_shots AS DECIMAL(10,2))), 1) AS avg_total_shots,
    ROUND(AVG(CAST(home_corners + away_corners AS DECIMAL(10,2))), 1) AS avg_total_corners,
    ROUND(AVG(CAST(home_yellow_cards + away_yellow_cards AS DECIMAL(10,2))), 1) AS avg_yellow_cards
FROM 
    EPL2025.Matches
GROUP BY 
    CASE 
        WHEN total_goals >= 3 THEN 'High Scoring'
        ELSE 'Low Scoring'
    END;

--------------------------------------------------------------
--------------------------------------------------------------
-- Q3. What role do corners and shots play in determining match results?
SELECT 
    full_time_result,
    AVG(home_shots) AS avg_home_shots,
    AVG(away_shots) AS avg_away_shots,
    AVG(home_corners) AS avg_home_corners,
    AVG(away_corners) AS avg_away_corners
FROM 
    EPL2025.Matches
GROUP BY 
    full_time_result;

--------------------------------------------------------------
--------------------------------------------------------------
-- Q4. How do cards impact match outcomes?
SELECT 
    full_time_result,
    AVG(home_yellow_cards) AS avg_home_yellow,
    AVG(away_yellow_cards) AS avg_away_yellow,
    AVG(home_red_cards) AS avg_home_red,
    AVG(away_red_cards) AS avg_away_red
FROM 
    EPL2025.Matches
GROUP BY 
    full_time_result;

--------------------------------------------------------------
--------------------------------------------------------------
-- Q5: Which team had the highest shot accuracy (shots on target to total shots)?
SELECT TOP 10
    team_name,
    ROUND(SUM(home_shots_on_target) * 1.0 / NULLIF(SUM(home_shots), 0), 3) AS home_accuracy,
    ROUND(SUM(away_shots_on_target) * 1.0 / NULLIF(SUM(away_shots), 0), 3) AS away_accuracy,
    ROUND(
        (SUM(home_shots_on_target) + SUM(away_shots_on_target)) * 1.0 /
        NULLIF(SUM(home_shots) + SUM(away_shots), 0), 3
    ) AS overall_accuracy
FROM (
    SELECT 
        home_team AS team_name,
        home_shots_on_target, home_shots,
        0 AS away_shots_on_target, 0 AS away_shots
    FROM EPL2025.Matches
    UNION ALL
    SELECT 
        away_team AS team_name,
        0 AS home_shots_on_target, 0 AS home_shots,
        away_shots_on_target, away_shots
    FROM EPL2025.Matches
) AS Combined
GROUP BY team_name
ORDER BY overall_accuracy DESC;

--------------------------------------------------------------
--------------------------------------------------------------
-- Shot Accuracy vs. Match Outcome
SELECT
    home_win,
    ROUND(AVG(CAST(home_shots_on_target AS FLOAT) / NULLIF(home_shots, 0)), 2) AS avg_home_accuracy,
    ROUND(AVG(CAST(away_shots_on_target AS FLOAT) / NULLIF(away_shots, 0)), 2) AS avg_away_accuracy
FROM 
    EPL2025.Matches
GROUP BY 
    home_win
ORDER BY 
    home_win DESC;

--------------------------------------------------------------
--------------------------------------------------------------
-- Discipline (Cards) vs. Match Result
-- Do more aggressive teams lose more often?
SELECT
    home_win,
    ROUND(AVG(home_yellow_cards + home_red_cards), 2) AS avg_home_cards,
    ROUND(AVG(away_yellow_cards + away_red_cards), 2) AS avg_away_cards
FROM 
    EPL2025.Matches
GROUP BY 
    home_win
ORDER BY 
    home_win DESC;

--------------------------------------------------------------
--------------------------------------------------------------
-- Top 10 Highest Scoring Matches
SELECT TOP 10
    match_id,
    home_team,
    away_team,
    full_time_home_goals,
    full_time_away_goals,
    total_goals
FROM 
    EPL2025.Matches
ORDER BY 
    total_goals DESC;
--------------------------------------------------------------
--------------------------------------------------------------
-- 🕒 5. Second Half Impact vs. Result
-- Did teams improve or decline after halftime?
SELECT
    second_half_impact,
    COUNT(*) AS match_count,
    ROUND(AVG(CASE WHEN home_win = 1 THEN 1 ELSE 0 END), 2) AS win_rate_decimal
FROM 
    EPL2025.Matches
GROUP BY 
    second_half_impact
ORDER BY 
    second_half_impact DESC;
--------------------------------------------------------------
--------------------------------------------------------------
SELECT 
    home_team AS team,
    COUNT(*) AS matches_played,
    AVG(second_half_impact) AS avg_second_half_impact
FROM 
    EPL2025.Matches
GROUP BY 
    home_team
ORDER BY 
    avg_second_half_impact DESC;

--------------------------------------------------------------
--------------------------------------------------------------
-- Relationship between second_half_impact and home_team_won
SELECT
    second_half_impact,
    COUNT(*) AS match_count,
    ROUND(AVG(CAST(home_team_won AS FLOAT)) * 100, 2) AS home_win_rate_pct
FROM 
    EPL2025.Matches
GROUP BY 
    second_half_impact
ORDER BY 
    second_half_impact DESC;

--------------------------------------------------------------
--------------------------------------------------------------
SELECT 
    COUNT(*) AS home_comeback_wins
FROM 
    EPL2025.Matches
WHERE 
    ht_score_diff < 0     -- home was losing at half-time
    AND ft_score_diff > 0 -- home won at full-time

--------------------------------------------------------------
--------------------------------------------------------------
SELECT 
    COUNT(*) AS away_comeback_wins
FROM 
    EPL2025.Matches
WHERE 
    ht_score_diff > 0     -- away was losing at half-time
    AND ft_score_diff < 0 -- away won at full-time

--------------------------------------------------------------
--------------------------------------------------------------

SELECT *,
    CASE 
        WHEN ht_score_diff < 0 AND ft_score_diff > 0 THEN 'Home Comeback'
        WHEN ht_score_diff > 0 AND ft_score_diff < 0 THEN 'Away Comeback'
        ELSE 'No Comeback'
    END AS comeback_type
FROM 
    EPL2025.Matches
--------------------------------------------------------------
--------------------------------------------------------------
-- Shot Accuracy vs Match Outcome
SELECT 
    CASE 
        WHEN home_win = 1 THEN 'Home Win'
        WHEN away_win = 1 THEN 'Away Win'
        ELSE 'Draw'
    END AS match_outcome,
    ROUND(AVG(home_shots_on_target * 1.0 / NULLIF(home_shots, 0)), 2) AS avg_home_accuracy,
    ROUND(AVG(away_shots_on_target * 1.0 / NULLIF(away_shots, 0)), 2) AS avg_away_accuracy
FROM EPL2025.Matches
GROUP BY 
    CASE 
        WHEN home_win = 1 THEN 'Home Win'
        WHEN away_win = 1 THEN 'Away Win'
        ELSE 'Draw'
    END
--------------------------------------------------------------
--------------------------------------------------------------














