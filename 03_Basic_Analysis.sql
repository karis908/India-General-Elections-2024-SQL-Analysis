-- India General Elections 2024 SQL Analysis
-- Basic Analysis Queries
-- Author: Sunil Nayak


-- 1. Total number of seats
SELECT DISTINCT COUNT(Parliament_Constituency) AS Total_Seats
FROM constituencywise_results;
GO

-- 2. Total number of seats available for elections in each state
SELECT
    s.State AS State_Name,
    COUNT(cr.Constituency_ID) AS Total_Seats_Available
FROM constituencywise_results cr
JOIN statewise_results sr
    ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s
    ON sr.State_ID = s.State_ID
GROUP BY s.State
ORDER BY s.State;
GO

-- 3. Winning candidate, party, votes and victory margin
-- Example: Uttar Pradesh - AMETHI
SELECT
    cr.Winning_Candidate,
    p.Party,
    p.party,
    cr.Total_Votes,
    cr.Margin,
    cr.Constituency_Name,
    s.State
FROM constituencywise_results cr
JOIN partywise_results p
    ON cr.Party_ID = p.Party_ID
JOIN statewise_results sr
    ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s
    ON sr.State_ID = s.State_ID
WHERE s.State = 'Uttar Pradesh'
  AND cr.Constituency_Name = 'AMETHI';
GO

-- 4. EVM votes vs Postal votes
-- Example: MATHURA
SELECT
    cd.Candidate,
    cd.Party,
    cd.EVM_Votes,
    cd.Postal_Votes,
    cd.Total_Votes,
    cr.Constituency_Name
FROM constituencywise_details cd
JOIN constituencywise_results cr
    ON cd.Constituency_ID = cr.Constituency_ID
WHERE cr.Constituency_Name = 'MATHURA'
ORDER BY cd.Total_Votes DESC;
GO

-- 5. Parties with the most seats in Andhra Pradesh
SELECT
    p.Party,
    COUNT(cr.Constituency_ID) AS Seats_Won
FROM constituencywise_results cr
JOIN partywise_results p
    ON cr.Party_ID = p.Party_ID
JOIN statewise_results sr
    ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s
    ON sr.State_ID = s.State_ID
WHERE s.State = 'Andhra Pradesh'
GROUP BY p.Party
ORDER BY Seats_Won DESC;
GO

-- 6. Maharashtra election summary
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
