with revenue_device as (
SELECT ssp.continent, sum(prod.price) as revenue,
SUM(CASE WHEN device = 'mobile' then prod.price end) as Revenue_from_Mobile,
SUM(CASE WHEN device = 'desktop' then prod.price end) as Revenue_from_Desktop
FROM `data-analytics-mate.DA.order`  as ord
join `data-analytics-mate.DA.product` as prod
on ord.item_id = prod.item_id
join `data-analytics-mate.DA.session_params` as ssp
on ord.ga_session_id=ssp.ga_session_id
group by ssp.continent
 ) ,
total_r as(
 select
 sum(revenue)  as total_revenue
 from revenue_device
 ),


counte_acc as(
select sss.continent,
count(distinct aa.id) as account_count,
count(distinct case when aa.is_verified =1 then aa.id end) as verified_account,
count (distinct sss.ga_session_id) as session_cnt
from `data-analytics-mate.DA.account` as aa
join `data-analytics-mate.DA.account_session` as ass
on aa.id = ass.account_id
join `data-analytics-mate.DA.session_params` as sss
on ass.ga_session_id = sss.ga_session_id
group by sss.continent
)
select
       rd.continent,
       rd.revenue,
       rd.Revenue_from_Mobile,
       rd.Revenue_from_Desktop,
       round(rd.revenue/total_r.total_revenue *100, 2)as Revenue_from_Total,
       ca.account_count,
       ca.verified_account,
       ca.session_cnt
       from revenue_device as rd
       left join counte_acc as ca
       on rd.continent = ca.continent
       CROSS JOIN total_r