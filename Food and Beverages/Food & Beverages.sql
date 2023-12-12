-- Active: 1696644192745@@127.0.0.1@3306@survey_response

-- In order to solve our adhoc questions, I have created the view by joining all the tables for our convinience --
CREATE VIEW Total_Survey_Report AS 
SELECT r.Respondent_ID, r.Name, r.Age, r.Gender, r.City_ID, c.City, c.Tier, m.Response_ID,
m.Consume_frequency, m.Consume_time, m.Consume_reason, m.Heard_before, m.Brand_perception, m.General_perception, m.Tried_before, m.Taste_experience, 
m.Reasons_preventing_trying, Current_brands,  m.Reasons_for_choosing_brands, m.Improvements_desired, m.Ingredients_expected, m.Health_concerns, m.Interest_in_natural_or_organic,
m.Marketing_channels, m.Packaging_preference, m.Limited_edition_packaging, m.Price_range, m.Purchase_location, m.Typical_consumption_situations
    FROM dim_repondents r
        CROSS JOIN dim_cities c
            ON r.City_ID = c.City_ID
        CROSS JOIN fact_survey_responses m
            ON r.Respondent_ID = m.Respondent_ID;

-- Finding who are the frequent drinker of energy drink --
SELECT Gender, COUNT(Current_brands) as Number_of_drinks  
    FROM total_survey_report
        GROUP BY Gender
        ORDER BY Number_of_drinks DESC;

--  Which age group prefers energy drinks more? --
SELECT Age, COUNT(Current_brands) as Number_of_drinks
    FROM total_survey_report
        GROUP BY Age
        ORDER BY Number_of_drinks DESC;

-- Which type of marketing reaches the most Youth (15-30)
SELECT Marketing_channels FROM total_survey_report
    WHERE Age IN ("15-30", "19-30")

-- What are the preferred ingredients of energy drinks among respondents?
SELECT Ingredients_expected, count(Name) as prefered_ingredient
    FROM total_survey_report
    GROUP BY Ingredients_expected
    ORDER BY Ingredients_expected DESC;

-- What packaging preferences do respondents have for energy drinks?
SELECT Packaging_preference, COUNT(Name) as preference_count
    FROM total_survey_report
    GROUP BY Packaging_preference
    ORDER BY preference_count DESC;

-- Who are the current market leaders?
SELECT Current_brands, COUNT(Name) as sold_quantity
    FROM total_survey_report
    GROUP BY Current_brands
    ORDER BY sold_quantity DESC;

-- What are the primary reasons consumers prefer those brands over ours?
SELECT Reasons_for_choosing_brands 
    FROM total_survey_report
    GROUP BY Reasons_for_choosing_brands;

-- Which marketing channel can be used to reach more customers?
SELECT Marketing_channels, COUNT(Name) as Sold_quantity
    FROM total_survey_report
    GROUP BY Marketing_channels
    ORDER BY Sold_quantity DESC;

 --  Which cities do we need to focus more on?
SELECT City, COUNT(Name) as Sold_quantity
    FROM total_survey_report
    GROUP BY City
    ORDER BY Sold_quantity DESC;

--  Where do respondents prefer to purchase energy drinks?
SELECT Purchase_location, COUNT(Name) as sold_quantity 
    FROM total_survey_report
    GROUP BY Purchase_location
    ORDER BY sold_quantity DESC; 

--  What are the typical consumption situations for energy drinks among respondents?
SELECT Consume_reason, COUNT(Name) as reasons
    FROM total_survey_report
    GROUP BY Consume_reason
    ORDER BY reasons DESC;

-- Which area of business should we focus more on our product development? (Branding/taste/availability)
SELECT Reasons_for_choosing_brands, COUNT(Name) as Total_count
    FROM total_survey_report
    GROUP BY Reasons_for_choosing_brands
    ORDER BY Total_count DESC;

-- How often people consume drinks?
SELECT Consume_frequency, COUNT(Name) as count 
    FROM total_survey_report
    GROUP BY Consume_frequency
    ORDER BY count DESC;

-- How many people think that the energy drink is dangerous?
SELECT General_perception, COUNT(General_perception) as count 
    FROM total_survey_report
    GROUP BY General_perception
    ORDER BY count DESC;

-- Average taste experience of each brand
SELECT Current_brands, AVG(Taste_experience) as average_rating
    FROM total_survey_report
    GROUP BY Current_brands
    ORDER BY average_rating DESC;

-- At waht situation energy drinks are consumed more?
SELECT Typical_consumption_situations, COUNT(Name) as count 
    FROM total_survey_report
    GROUP BY Typical_consumption_situations
    ORDER BY count DESC;

-- What price range is considered best for the selling of energy drinkS?
SELECT Price_range, COUNT(Name) as count
    FROM total_survey_report
    GROUP BY Price_range
    ORDER BY count DESC;
