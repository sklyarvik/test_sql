--Создаем 100 случайных чисел от 2 до 7 и добавляем поле ID
WITH TEMP AS
	(SELECT GENERATE_SERIES(1,100) AS ID,
			TRUNC(RANDOM() * (7 - 2 + 1) + 2)::int AS RAND_2_TO_7)

--Выбираем все записи, считаем сумму всех рандомов до текущей ID и прибавляем к заданной дате.
SELECT *
FROM
	(SELECT '2023-01-01'::date AS INCREMENT_DATE --Первая запись должна не меняться
	 UNION 
         SELECT '2023-01-01'::date + (SELECT SUM(B.RAND_2_TO_7) 
                                      FROM TEMP B 
                                      WHERE B.ID <= A.ID)::int AS INCREMENT_DATE 
         FROM TEMP A)
ORDER BY INCREMENT_DATE
LIMIT 100