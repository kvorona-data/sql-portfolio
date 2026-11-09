--рахуємо кількість створених акаунтів
with account as(
SELECT
       (ssc.date) AS date,
       spp.country,
       ac.send_interval,
       ac.is_verified,
       ac.is_unsubscribed,
       count(DISTINCT ac.id) as account_cnt,
       0 as sent_msg,
       0 as open_msg,
       0 as visit_msg
 FROM `data-analytics-mate.DA.account` as ac
 join `data-analytics-mate.DA.account_session` as ss
 on ac.id = ss.account_id
 join `data-analytics-mate.DA.session` as ssc
 on ss.ga_session_id = ssc.ga_session_id
 join `data-analytics-mate.DA.session_params` as spp
 on ss.ga_session_id = spp.ga_session_id
 group by ssc.date, spp.country, ac.send_interval, ac.is_verified, ac.is_unsubscribed
   ),
   -- рахуємо активність за
  email_met as(
  select
      DATE(date_add(ss.date, INTERVAL ess.sent_date DAY)) as date,
      spp.country,
      aa.send_interval,
      aa.is_verified,
      aa.is_unsubscribed,
      0 as account_cnt,
  count(distinct ess.id_message) as sent_msg,
  count(distinct eo.id_message) as open_msg,
  count(distinct ev.id_message) as visit_msg
  from `data-analytics-mate.DA.email_sent` as ess
  join `data-analytics-mate.DA.account` as aa
  on ess.id_account=aa.id
  join `data-analytics-mate.DA.account_session` as ass
  on ess.id_account=ass.account_id
  join `data-analytics-mate.DA.session` as ss
  on ass.ga_session_id = ss.ga_session_id
   join  `data-analytics-mate.DA.session_params` as spp
  on ss.ga_session_id=spp.ga_session_id
  left join `data-analytics-mate.DA.email_open` as eo
  on ess.id_account=eo.id_account
  and ess.id_message = eo.id_message
  left join `data-analytics-mate.DA.email_visit` as ev
  on eo.id_account=ev.id_account
  and eo.id_message = ev.id_message
  group by  DATE(date_add(ss.date, INTERVAL ess.sent_date DAY)),  
      spp.country,
      aa.send_interval,
      aa.is_verified,
      aa.is_unsubscribed
      ),
      -- обєднуємо дані
      combined_met as(
        select *
        from account
        union all
        select *
        from email_met
         ),
         -- рахуємо тотали
         total as(
          select
          date,
          country,
          send_interval,
          is_verified,
          is_unsubscribed,
         SUM(account_cnt) AS account_cnt,
         SUM(sent_msg) AS sent_msg,
         SUM(open_msg) AS open_msg,
         SUM(visit_msg) AS visit_msg,
         SUM(SUM(account_cnt)) OVER (PARTITION BY country) AS total_country_account_cnt,
         SUM(SUM(sent_msg)) OVER (PARTITION BY country) AS total_country_sent_cnt
         FROM combined_met
GROUP BY  date, country,send_interval, is_verified, is_unsubscribed
          ),
          -- визначаємо рейтинг
 country_rank as(
           SELECT *,
           DENSE_RANK() OVER (ORDER BY total_country_account_cnt DESC) AS rank_total_country_account_cnt,
           DENSE_RANK() OVER (ORDER BY total_country_sent_cnt DESC) AS rank_total_country_sent_cnt
FROM total
)
-- фінальний запит 
SELECT
date,
country,
send_interval,
is_verified,
is_unsubscribed,
account_cnt,
sent_msg,
open_msg,
visit_msg,
total_country_account_cnt,
total_country_sent_cnt,
rank_total_country_account_cnt,
rank_total_country_sent_cnt
FROM country_rank
WHERE rank_total_country_account_cnt <= 10
OR rank_total_country_sent_cnt <= 10
ORDER BY country, date;
