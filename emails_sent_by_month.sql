SELECT DISTINCT
ess.id_account,
date_trunc(date_add(ses.date, INTERVAL ess.sent_date DAY), MONTH) AS sent_month,
count(ess.id_message) over(PARTITION BY ess.id_account, DATE_TRUNC(date_add(ses.date, INTERVAL ess.sent_date DAY), MONTH)) / count(ess.id_message) over(PARTITION BY DATE_TRUNC(date_add(ses.date, INTERVAL ess.sent_date DAY), MONTH)) *100 as sent_msg_percent_from_this_month,
min(date_add(ses.date, INTERVAL ess.sent_date DAY)) over(PARTITION BY ess.id_account, DATE_TRUNC(date_add(ses.date, INTERVAL ess.sent_date DAY), MONTH)) as first_sent_date,
max(date_add(ses.date, INTERVAL ess.sent_date DAY)) over(PARTITION BY ess.id_account, DATE_TRUNC(date_add(ses.date, INTERVAL ess.sent_date DAY), MONTH)) as last_send_date
FROM `data-analytics-mate.DA.email_sent` as ess
JOIN `data-analytics-mate.DA.account_session` as ass
on ess.id_account = ass.account_id
JOIN  `data-analytics-mate.DA.session` as ses
on ass.ga_session_id = ses.ga_session_id