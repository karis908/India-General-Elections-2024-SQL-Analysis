-- India General Elections 2024 SQL Analysis
-- Advanced SQL Analysis
-- Author: Sunil Nayak

-- 1. Top 10 candidates with the highest EVM votes in each constituency
SELECT TOP 10
    cr.Constituency_Name,
    cd.Constituency_ID,
    cd.Candidate,
    cd.EVM_Votes
FROM constituencywise_details cd
JOIN constituencywise_results cr
    ON cd.Constituency_ID = cr.Constituency_ID
WHERE cd.EVM_Votes = (
    SELECT MAX(cd1.EVM_Votes)
    FROM constituencywise_details cd1
    WHERE cd1.Constituency_ID = cd.Constituency_ID
)
ORDER BY cd.EVM_Votes DESC;
GO

-- 2. Winner and runner-up in each Maharashtra constituency
WITH RankedCandidates AS (
    SELECT
        cd.Constituency_ID,
        cd.Candidate,
        cd.Party,
        cd.EVM_Votes,
        cd.Postal_Votes,
        cd.EVM_Votes + cd.Postal_Votes AS Total_Votes,
        ROW_NUMBER() OVER (
            PARTITION BY cd.Constituency_ID
            ORDER BY cd.EVM_Votes + cd.Postal_Votes DESC
        ) AS VoteRank
    FROM constituencywise_details cd
    JOIN constituencywise_results cr
        ON cd.Constituency_ID = cr.Constituency_ID
    JOIN statewise_results sr
        ON cr.Parliament_Constituency = sr.Parliament_Constituency
    JOIN states s
        ON sr.State_ID = s.State_ID
    WHERE s.State = 'Maharashtra'
)
SELECT
    cr.Constituency_Name,
    MAX(CASE WHEN rc.VoteRank = 1 THEN rc.Candidate END) AS Winning_Candidate,
    MAX(CASE WHEN rc.VoteRank = 2 THEN rc.Candidate END) AS Runnerup_Candidate
FROM RankedCandidates rc
JOIN constituencywise_results cr
    ON rc.Constituency_ID = cr.Constituency_ID
GROUP BY cr.Constituency_Name
ORDER BY cr.Constituency_Name;
GO

-- 3. Total vote analysis for Maharashtra
SELECT
    COUNT(DISTINCT cr.Constituency_ID) AS Total_Seats,
    COUNT(DISTINCT cd.Candidate) AS Total_Candidates,
    COUNT(DISTINCT p.Party) AS Total_Parties,
    SUM(cd.EVM_Votes + cd.Postal_Votes) AS Total_Votes,
    SUM(cd.EVM_Votes) AS Total_EVM_Votes,
    SUM(cd.Postal_Votes) AS Total_Postal_Votes
FROM constituencywise_results cr
JOIN constituencywise_details cd
    ON cr.Constituency_ID = cd.Constituency_ID
JOIN statewise_results sr
    ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s
    ON sr.State_ID = s.State_ID
JOIN partywise_results p
    ON cr.Party_ID = p.Party_ID
WHERE s.State = 'Maharashtra';
GO

-- The CTE above uses:
--   ROW_NUMBER()
--   PARTITION BY
--   ORDER BY
--   CASE WHEN
--   Aggregate functions
--   Multiple JOINs
-- These demonstrate advanced SQL analysis techniques.
