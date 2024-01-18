--Создаем если не существует
CREATE TEMPORARY TABLE IF NOT EXISTS TRANSFERS
(
    "from"	    int,
    "to"	    int,
    "amount"	int,
    "tdate"	    date
);
--Чистим
TRUNCATE TABLE TRANSFERS;
--Наполняем
INSERT INTO TRANSFERS VALUES (1,2,500,'2023-02-23');
INSERT INTO TRANSFERS VALUES (2,3,300,'2023-03-01');
INSERT INTO TRANSFERS VALUES (3,1,200,'2023-03-05');
INSERT INTO TRANSFERS VALUES (1,3,400,'2023-04-05');

--Результат

--1.Формируем временный набор данных. Исходная таблица (расходы) + перевернутая таблица (приходы)
-- и сортируем по дате операции
WITH temp as (SELECT t.* FROM (
SELECT "from", "to", amount * (-1) as amount, tdate
FROM TRANSFERS minus
UNION 
SELECT "to" as "from", "from" as "to", amount as amount, tdate 
FROM TRANSFERS plus
) t
ORDER BY t."from", t."tdate")
--2. Формируем задание
SELECT 
t."from" as "acc"
,t.tdate as dt_from
,COALESCE((SELECT MIN(z.tdate) FROM TEMP as z WHERE z.tdate > t.tdate and z."from" = t."from"), '3000-01-01') as dt_to --ищем первую транзакцию после текущей
,(SELECT SUM(z.amount) FROM TEMP as z WHERE z.tdate <= t.tdate and z."from" = t."from") as balance --суммируем все операции до текущей транзакции по счету
FROM TEMP t
WHERE t.tdate <= '3000-01-01'