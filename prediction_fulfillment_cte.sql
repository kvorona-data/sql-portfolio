with combined as (
SELECT ses.date,
sum(pp.price) as revenue,  
0 as predict
FROM `data-analytics-mate.DA.order` as oo
join `data-analytics-mate.DA.product` as pp
on oo.item_id = pp.item_id
join `data-analytics-mate.DA.session` as ses
on oo.ga_session_id = ses.ga_session_id
group by ses.date
union all
SELECT date,
0 as revenue,
predict,
from `data-analytics-mate.DA.revenue_predict`
),
by_date as (
SELECT
  date,
  sum(revenue) as revenue,
 sum(predict) as predict
 from combined
 group by date
)
SELECT date,
sum(predict) over(order by date) as comulative_predict,
sum(revenue) over(order by date) as comulative_revenue,
sum(revenue) over(order by date) / sum(predict) over(order by date) *100 as full_pct
from by_date
