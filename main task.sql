Task 1:
SELECT p.name AS name, COUNT(pit.id) AS count
FROM Pass_in_trip AS pit INNER JOIN Passenger AS p
ON pit.passenger = p.id
GROUP BY pit.passenger
ORDER BY count DESC, name ASC;


Task 2:
SELECT TIMEDIFF((SELECT end_pair FROM Timepair WHERE id = 4), (SELECT start_pair FROM Timepair WHERE id = 2)) AS time
FROM Timepair LIMIT 1;


Task 3:
SELECT Rooms.*
FROM Rooms
         JOIN Reservations ON Rooms.id = Reservations.room_id
WHERE WEEK(start_date, 1) = 12 AND YEAR (start_date)=2020;


Task 4:
SELECT classroom
FROM (SELECT classroom, COUNT(id) as val FROM Schedule GROUP BY classroom ORDER BY val DESC) t
WHERE t.val = (SELECT COUNT(id) as val FROM Schedule GROUP BY classroom ORDER BY val DESC LIMIT 1);


Task 5:
SELECT isnull((SELECT sum(o.out) AS qty
               FROM Outcome_o o
               WHERE o.date > i.date AND o.date <=
                                         (SELECT min(date) FROM Income_o WHERE date > i.date)),0) AS qty, i.date AS dt1,
       (SELECT min(date) FROM Income_o WHERE date > i.date) AS dt2
FROM Income_o i
WHERE (SELECT min (date) FROM Income_o WHERE date > i.date) IS NOT NULL
GROUP BY i.date;


Task 6:
WITH tmp AS (SELECT *, ROW_NUMBER() OVER(PARTITION BY scol ORDER BY rownum) rownum2
            FROM (SELECT ntile(2) OVER( ORDER BY date) scol,
                ROW_NUMBER() OVER( ORDER BY date) rownum, name, date FROM Battles) b)
SELECT MIN(iif(scol = 1, rownum, NULL)) rn_1,
       MIN(iif(scol = 1, name, NULL))   name_1,
       MIN(iif(scol = 1, date, NULL))   date_1,
       MIN(iif(scol = 2, rownum, NULL)) rn_2,
       MIN(iif(scol = 2, name, NULL))   name_2,
       MIN(iif(scol = 2, date, NULL))   date_2
FROM tmp
GROUP BY rownum2;
