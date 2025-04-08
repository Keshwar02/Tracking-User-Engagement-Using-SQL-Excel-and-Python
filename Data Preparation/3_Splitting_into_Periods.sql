use data_scientist_project;

select * from student_certificates;
select * from student_info;
select * from student_purchases;
select * from student_video_watched;

select * from purchases_info; # we'll utilize this view to classify students as free-plan and paying in Q2 2021 and Q2 2022

# 1. Calculating Total Minutes Watched in Q2 2021 and Q2 2022

-- seperately
-- Additionally, we want to identify which users were paid subscribers during each of these periods

SELECT 
    student_id,
    ROUND(SUM(seconds_watched) / 60, 2) AS minutes_watched
FROM
    student_video_watched
where date_watched between '2021-04-01' and '2021-06-30'
GROUP BY student_id;

SELECT 
    student_id,
    ROUND(SUM(seconds_watched) / 60, 2) AS minutes_watched
FROM
    student_video_watched
where date_watched between '2022-04-01' and '2022-06-30'
GROUP BY student_id;

# 2. Creating a paid column

-- The last column indicates whether a student had an active subscription in Q2 (represented by 1) or not (represented by 0).


# 2.1
SELECT 
	A.student_id,
    A.minutes_watched,
    IF(max(paid_q2_2021) = 1,1,0) as paid_in_q2_2021
from
(SELECT 
    student_id,
    ROUND(SUM(seconds_watched) / 60, 2) AS minutes_watched
FROM
    student_video_watched
WHERE
    date_watched BETWEEN '2021-04-01' AND '2021-06-30'
GROUP BY student_id)A
Left join purchases_info i 
on A.student_id = i.student_id
group by A.student_id,a.minutes_watched
having paid_in_q2_2021 = 0;


#2.2
SELECT 
	A.student_id,
    A.minutes_watched,
    IF(max(paid_q2_2022) = 1,1,0) as paid_in_q2_2022
from
(SELECT 
    student_id,
    ROUND(SUM(seconds_watched) / 60, 2) AS minutes_watched
FROM
    student_video_watched
WHERE
    date_watched BETWEEN '2022-04-01' AND '2022-06-30'
GROUP BY student_id)A
Left join purchases_info i 
on A.student_id = i.student_id
group by A.student_id,a.minutes_watched
having paid_in_q2_2022 = 0;


# 2.3
SELECT 
	A.student_id,
    A.minutes_watched,
    IF(max(paid_q2_2021) = 1,1,0) as paid_in_q2_2021
from
(SELECT 
    student_id,
    ROUND(SUM(seconds_watched) / 60, 2) AS minutes_watched
FROM
    student_video_watched
WHERE
    date_watched BETWEEN '2021-04-01' AND '2021-06-30'
GROUP BY student_id)A
Left join purchases_info i 
on A.student_id = i.student_id
group by A.student_id,a.minutes_watched
having paid_in_q2_2021 = 1;


# 2.4
SELECT 
	A.student_id,
    A.minutes_watched,
    IF(max(paid_q2_2022) = 1,1,0) as paid_in_q2_2022
from
(SELECT 
    student_id,
    ROUND(SUM(seconds_watched) / 60, 2) AS minutes_watched
FROM
    student_video_watched
WHERE
    date_watched BETWEEN '2022-04-01' AND '2022-06-30'
GROUP BY student_id)A
Left join purchases_info i 
on A.student_id = i.student_id
group by A.student_id,a.minutes_watched
having paid_in_q2_2022 = 1;