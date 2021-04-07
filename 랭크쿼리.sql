WITH t AS
(



  SELECT (CASE
              WHEN LAST_WEEK - ON_WEEK > 0 THEN '▲'
              WHEN LAST_WEEK - ON_WEEK = 0 THEN '-'
              ELSE '▼'
          END)                  AS "P",
         LAST_WEEK - ON_WEEK    AS GAP,
         ON_WEEK                AS RANK_INFO,
         BRAND,
         SEASON,
         PARTCODE,
         QTY,
         AMT
    FROM (  SELECT BRAND,
                   SEASON,
                   PARTCODE,
                   --당월 RANK
                   RANK ()
                       OVER (ORDER BY
                                 SUM ((CASE
                                           WHEN TO_CHAR (TO_DATE (SALEDATE), 'iw') = TO_CHAR (SYSDATE, 'iw') THEN SELLPRICE
                                           ELSE 0
                                       END)) DESC)    AS "ON_WEEK",
                   --전월 RANK
                   RANK ()
                       OVER (ORDER BY
                                 SUM ((CASE
                                           WHEN TO_CHAR (TO_DATE (SALEDATE), 'iw') = TO_CHAR (SYSDATE - 7, 'iw') THEN SELLPRICE
                                           ELSE 0
                                       END)) DESC)    AS "LAST_WEEK",
                   SUM ((CASE
                             WHEN TO_CHAR (TO_DATE (SALEDATE), 'iw') = TO_CHAR (SYSDATE, 'iw') THEN QTY
                             ELSE 0
                         END))                        AS QTY,
                   SUM ((CASE
                             WHEN TO_CHAR (TO_DATE (SALEDATE), 'iw') = TO_CHAR (SYSDATE, 'iw') THEN SELLPRICE
                             ELSE 0
                         END))                        AS AMT
              FROM FNF.SALEITEMS
             WHERE 1 = 1
               AND BRAND = 'M'
               AND SALEDATE BETWEEN '2021-03-01' AND '2021-03-31'
          GROUP BY BRAND, SEASON, PARTCODE) TT
ORDER BY ON_WEEK

)  

SELECT * FROM T;