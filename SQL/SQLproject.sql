	
	CREATE VIEW Hotel AS
	(
	SELECT * FROM ['2018']
	UNION
	SELECT * FROM ['2019']
	UNION
	SELECT * FROM ['2020'])

SELECT * FROM Hotel;

Select  is_canceled,lead_time,hotel  from Hotel

---------------- Question one : What is the profit percentage for each month across all years---------------------------

-- total revenues
SELECT 
ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr),0) AS total
FROM Hotel

-- the profit for each month

SELECT arrival_date_month,
Round((ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr),0))/ 36075004 *100,0) AS Revenue -- rounded to the nearest integer
FROM Hotel
GROUP BY arrival_date_month


--------------------------------------------------------------------------------
-- Question two: Which meals and market segments (e.g., families, corporate clients, etc.) contribute the most to the total revenue for each hotel annually?

CREATE VIEW Hotel_TOTAL AS
SELECT 
    adr,
    stays_in_week_nights,
    stays_in_weekend_nights,
    Hotel.meal,
    Hotel.market_segment,Cost
FROM 
    Hotel
LEFT JOIN 
    dbo.meal_cost ON Hotel.meal = dbo.meal_cost.meal
LEFT JOIN 
    dbo.market_segment ON Hotel.market_segment = dbo.market_segment.market_segment;

	SELECT meal,cost,market_segment FROM Hotel_TOTAL

--------best meals-----------
SELECT meal,cost,
(ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr),0))*cost AS profit
FROM Hotel_TOTAL
GROUP BY meal,cost
order by profit desc;

----------  best segment--------
SELECT market_segment,
(ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr),0)) AS profit
FROM Hotel_TOTAL
GROUP BY market_segment
order by profit desc;


-------------------------------------

-- Question four: What are the key factors (e.g., hotel type, market type, meals offered, number of nights booked) significantly impact hotel revenue annually?

-- city hotel
SELECT hotel,
ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr),0) AS Revenue
FROM Hotel
GROUP BY hotel

-- the online TA
SELECT market_segment,
(ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr),0)) AS profit
FROM Hotel_TOTAL
GROUP BY market_segment
order by profit desc;

--the meal
SELECT meal,cost,
(ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr),0))*cost AS profit
FROM Hotel_TOTAL
GROUP BY meal,cost
order by profit desc;

---------------------------------------
-- Question five: Based on stay data, what are the yearly trends in customer preferences for room types (e.g., family rooms vs. single rooms), and how do these preferences influence revenue?

SELECT assigned_room_type,
(ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr),0)) AS profit
FROM Hotel
GROUP BY assigned_room_type
order by profit desc;


------------------------------


-- the least countries with revenues is Madagascar,American Samoa
SELECT country,
(ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr),0)) AS Revenue -- rounded to the nearest integer
FROM Hotel
GROUP BY country
order by Revenue