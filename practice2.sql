-- 조건1: 추천컨텐츠 테이블의 추천대상일자에 해당하는 날에만 추천
-- 조건2: 비선호컨텐츠 테이블에 고객별로 등록된 컨텐츠는 추천하지 않음

-- 보기 1번
SELECT C.컨텐츠ID, C.컨텐츠명
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
        WHERE X.고객ID = B.고객ID --컨텐츠ID 조건이 없음. 이 고객이 비선호 컨텐츠를 하나라도 가지고 있으면 추천컨텐츠를 전부 제거하게 됨
);

-- 보기 2번
SELECT C.컨텐츠ID, C.컨텐츠명
FROM 고객 A 
INNER JOIN 추천컨텐츠 B
    ON (A.고객ID = #custId# AND A.고객ID = B.고객ID)
INNER JOIN 컨텐츠 C
    ON (B.컨텐츠ID = C.컨텐츠ID) 
RIGHT OUTER JOIN 비선호컨텐츠 D -- RIGHT OUTER JOIN을 하면 결과가 비선호컨텐츠 기준이 된다. 즉, 비선호컨텐츠를 찾게 됨.. 그래서 조건과 부합하지 않음
    ON (B.고객ID = D.고객ID AND B.컨텐츠ID = D.컨텐츠ID)
WHERE B.추천대상일자 = TO_CHAR(SYSDATE, 'YYYY.MM.DD')
    AND B.컨텐츠ID IS NOT NULL;

-- 보기 3번(anti-join 패턴: 어떤 테이블에는 있지만 다른 테이블에는 없는 데이터를 찾는 방식)
SELECT C.컨텐츠ID, C.컨텐츠명
FROM 고객 A
INNER JOIN 추천컨텐츠 B
    ON (A.고객ID = B.고객ID)
INNER JOIN 컨텐츠 C
    ON (B.컨텐츠ID = C.컨텐츠ID)
LEFT OUTER JOIN 비선호컨텐츠 D -- LEFT OUTER JOIN을 하면, 특정 컨텐츠가 비선호컨텐츠 테이블에 없는 경우, NULL로 표시되게 된다. outer join은 합집합 느낌..
    ON (B.고객ID = D.고객ID AND B.컨텐츠ID = D.컨텐츠ID)
WHERE A.고객ID = #custId#
    AND B.추천대상일자 = TO_CHAR(SYSDATE, 'YYYY.MM.DD')
    AND B.컨텐츠ID IS NULL;

-- 보기 4번 (추천컨텐츠 결과 생성 후, 비선호컨텐츠를 제거하는 방식)
SELECT C.컨텐츠ID, C.컨텐츠명
FROM 고객 A
INNER JOIN 추천컨텐츠 B
    ON (A.고객ID = #custId# AND A.고객ID = B.고객ID)
INNER JOIN 컨텐츠 C
    ON (B.컨텐츠ID = C.컨텐츠ID) -- 추천 컨텐츠 전체(조인 결과)를 선택
WHERE B.추천대상일자 = TO_CHAR(SYSDATE, 'YYYY.MM.DD')
    AND NOT EXISTS ( --비선호컨텐츠에 추천 컨텐츠가 있는지 확인 후 제외
        SELECT X.컨텐츠ID 
        FROM 비선호컨텐츠 X
            WHERE X.고객ID = B.고객ID
            AND X.컨텐츠ID = B.컨텐츠ID
);