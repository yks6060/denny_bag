SELECT *
  FROM FNF.SC_IMAGE
 WHERE (BRAND, SEASON, PARTCODE, COLOR, SEQ) IN (SELECT BRAND, SEASON, PARTCODE, COLOR, 1
                                                   FROM (SELECT BRAND, SEASON, PARTCODE, COLOR, RANK () OVER (PARTITION BY BRAND, SEASON, PARTCODE ORDER BY SELLPRICE_SUM DESC) AS "COLOR_RANK"
                                                           FROM (  SELECT BRAND, SEASON, PARTCODE, COLOR, SUM (SELLPRICE) AS SELLPRICE_SUM
                                                                     FROM FNF.SALEITEMS
                                                                    WHERE 1 = 1
                                                                      AND BRAND = 'M'
                                                                      AND SALEDATE BETWEEN '2021-03-01' AND '2021-03-31'
                                                                 --AND PARTCODE = '31DJ02961'
                                                                 GROUP BY BRAND, SEASON, PARTCODE, COLOR) TT) TTT
                                                  WHERE COLOR_RANK = 1)