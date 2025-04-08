use data_scientist_project;

select * from student_certificates;
select * from student_info;
select * from student_purchases;
select * from student_video_watched;

# 1. Calculating Subscription's End Date

SELECT 
    purchase_id,
    student_id,
    plan_id,
    date_purchased AS start_date,
    CASE
        WHEN plan_id = 0 THEN DATE_ADD(date_purchased, INTERVAL 1 MONTH)
        WHEN plan_id = 1 THEN DATE_ADD(date_purchased, INTERVAL 3 MONTH)
        WHEN plan_id = 2 THEN DATE_ADD(date_purchased, INTERVAL 1 YEAR)
        WHEN plan_id = 3 THEN CURDATE()
    END AS end_date,
    date_refunded
FROM
    student_purchases;
  
# 2. Re-calculating Subscription's End Date
# Here we handle refunds (i.e.,If a refund occurred, the subscription end date should be the refund_date instead of the calculated end_date.)

SELECT 
	purchase_id,
    student_id,
    plan_id,
    start_date,
    IF(date_refunded IS NULL,
       end_date,
	   date_refunded)
	AS end_date
FROM (SELECT 
    purchase_id,
    student_id,
    plan_id,
    date_purchased AS start_date,
    CASE
        WHEN plan_id = 0 THEN DATE_ADD(date_purchased, INTERVAL 1 MONTH)
        WHEN plan_id = 1 THEN DATE_ADD(date_purchased, INTERVAL 3 MONTH)
        WHEN plan_id = 2 THEN DATE_ADD(date_purchased, INTERVAL 1 YEAR)
        WHEN plan_id = 3 THEN CURDATE()
    END AS end_date,
    date_refunded
FROM
    student_purchases)A;

# 3. Creating 2 'paid' columns and a MySQL View
# Identify if a student has an active subscription (i.e.,Check if a subscription period falls inside Q2)

-- If the end date is before April 1, the student will have had a free plan (indicated by 0).
-- If the start date is after June 30, the student will have had a free plan (indicated by 0).
-- In all other cases, the student will have had an active subscription (indicated by 1).

CREATE VIEW purchases_info AS
SELECT
	purchase_id,
    student_id,
    plan_id,
    start_date,
    end_date,
    CASE
		WHEN start_date > '2021-06-30' THEN 0
        WHEN end_date   < '2021-04-01' THEN 0
        ELSE 1
	END AS paid_q2_2021,
    CASE
		WHEN start_date > '2022-06-30' THEN 0
        WHEN end_date   < '2022-04-01' THEN 0
        ELSE 1
	END AS paid_q2_2022
FROM (SELECT 
		purchase_id,
		student_id,
		plan_id,
		start_date,
		IF(date_refunded IS NULL,
		   end_date,
		   date_refunded)
		AS end_date
	FROM (SELECT 
			purchase_id,
			student_id,
			plan_id,
			date_purchased AS start_date,
			CASE
				WHEN plan_id = 0 THEN DATE_ADD(date_purchased, INTERVAL 1 MONTH)
				WHEN plan_id = 1 THEN DATE_ADD(date_purchased, INTERVAL 3 MONTH)
				WHEN plan_id = 2 THEN DATE_ADD(date_purchased, INTERVAL 1 YEAR)
                WHEN plan_id = 3 THEN CURDATE()
			END AS end_date,
			date_refunded
		FROM
			student_purchases)A)B;


select * from purchases_info;