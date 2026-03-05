SELECT
FROM 고객 A
INNER JOIN 추천컨텐츠 B
    ON (A.고객ID = B.고객ID)
INNER JOIN 컨텐츠 C
    ON (B.컨텐츠ID = C.컨텐츠ID)
WHERE A.고객ID = #custId#
    AND B.추천대상일자 = TO_CHAR(SYSDATE, 'YYYY.MM.DD')
    AND NOT EXISTS(
        SELECT X.컨텐츠ID
        FROM 비선호컨텐츠 X
        WHERE X.고객ID = B.고객ID
);