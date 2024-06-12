/* 1.Find the 5 oldest users.
 2.What day of the week do most users register on? We need to figure out when to schedule an ad campaign.
3.We want to target our inactive users with an email campaign.Find the users who have never posted a photo
4.We're running a new contest to see who can get the most likes on a single photo.WHO WON??!!
5.Our Investors want to know… How many times does the average user post?HINT - *total number of photos/total number of users*
6.user ranking by postings higher to lower
7.total numbers of users who have posted at least one time.
8.A brand wants to know which hashtags to use in a post
9.What are the top 5 most commonly used hashtags?
10.We have a small problem with bots on our site...Find users who have liked every single photo on the site.
11.Find users who have never commented on a photo.*/

select * from comments;
select * from follows;
select * from likes;
select * from photo_tags;
select * from photos;
select * from tags;
select * from users;

desc comments;
desc follows;
desc likes;
desc photo_tags;
desc photos;
desc tags;
desc users;

-- 1.Find the 5 oldest users.
select username
from users
order by created_at
limit 5;

-- 2.What day of the week do most users register on? We need to figure out when to schedule an ad campaign.
select dayname(created_at) as day_name,count(username) as count_of_users
from users
group by day_name
order by count_of_users desc
;

-- 3.We want to target our inactive users with an email campaign.Find the users who have never posted a photo 

select u.username,u.id
from users u
left join photos p
on u.id = p.id
where p.id not in (select p.user_id from photos p)
;

select u.username,u.id
from users u
left join photos p
on u.id = p.user_id
where p.user_id is null
;
-- 4.We're running a new contest to see who can get the most likes on a single photo.WHO WON??!!

select u.username,p.user_id,l.photo_id,count(l.photo_id) as likes
from likes l 
left join photos p
on l.photo_id = p.id
left join users u
on p.user_id = u.id
group by p.user_id,l.photo_id
order by likes desc
limit 1;	

-- 5.Our Investors want to know… How many times does the average user post?HINT - *total number of photos/total number of users*

select count(p.id)/count(distinct u.id) as avg_user_post
from photos p
left join users u
on p.id = u.id
order by avg_user_post desc
;

-- 6.user ranking by postings higher to lower

select u.id,u.username,count(p.id) as posts
from users u
left join photos p
on u.id = p.user_id
group by u.id,u.username
order by posts desc
;

-- 7.total numbers of users who have posted at least one time.

with num_users as (
select u.username,count(p.user_id) as number_of_posts
from users u
left join photos p
on u.id = p.user_id
group by user_id,username
order by number_of_posts
)

select count(*)
from num_users
where number_of_posts >= 1;


-- 8.A brand wants to know which hashtags to use in a post

select distinct t.tag_name
from tags t
left join photo_tags pt
on t.id = pt.tag_id
;

-- 9.What are the top 5 most commonly used hashtags?

select t.tag_name,count(pt.tag_id) as hashtags
from photo_tags pt
left join tags t
on pt.tag_id = t.id
group by tag_id,tag_name
order by hashtags desc
limit 5;

-- 10.We have a small problem with bots on our site...Find users who have liked every single photo on the site.

select l.user_id,u.username,count(distinct p.id) as liked_photo_count
from likes l 
join photos p 
on l.photo_id = p.id
join users u  
on l.user_id = u.id
group by u.username,l.user_id
having liked_photo_count = (select count(distinct id) from photos);

-- 11.Find users who have never commented on a photo.

select distinct u.username, c.user_id
from users u
left join photos p
on u.id = p.user_id
left join comments c
on p.id = c.user_id
where c.user_id is null
group by u.username,c.user_id
;
select u.username,count(c.comment_text) as count_of_comments
from users u 
left join comments c 
on u.id = c.user_id
where comment_text is null
group by username
;