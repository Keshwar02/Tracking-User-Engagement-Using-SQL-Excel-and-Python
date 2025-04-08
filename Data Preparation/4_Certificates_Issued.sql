use data_scientist_project;

select * from student_certificates;
select * from student_info;
select * from student_purchases;
select * from student_video_watched;


select * from purchases_info;

# 1. Studying Minutes and Certificates Issued

-- For this task, consider only the students who’ve been issued a certificate.


select 
	w.student_id,
    round(sum(seconds_watched)/60,2) as minutes_watched,
    certificates_issued
from(
	SELECT 
		student_id, 
		COUNT(*) AS certificates_issued
	FROM
		student_certificates
	GROUP BY student_id)A
left join student_video_watched w
on A.student_id = w.student_id
group by A.student_id;


