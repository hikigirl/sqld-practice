create table users(id int, name varchar(255));
rename users to users_new;
select * from users_new;
drop table users_new;

--1번
select svc_id, count(*) as cnt
from svc_join
where svc_end_date >= to_date('20150101000000', 'YYYYMMDDHH24MISS')
    and svc_end_date <= to_date('20150131235959', 'YYYYMMDDHH24MISS')
    and concat(join_ymd, join_hh) = '2014120100'
group by svc_id;

--2번
select svc_id, count(*) as cnt
from svc_join
where svc_end_date >= to_date('20150101', 'YYYYMMDD')
    and svc_end_date < to_date('20150201', 'YYYYMMDD')
    and (join_ymd, join_hh) IN (('20141201', '00'))
group by svc_id;

--3번
select svc_id, count(*) as cnt
from svc_join
where '201501' = to_char(svc_end_date, 'YYYYMM')
  and join_ymd = '20141201'
  and join_hh ='00'
group by svc_id;

--4번
select svc_id, count(*) as cnt
from svc_join
where to_date('201501', 'YYYYMM') = svc_end_date
  and join_ymd || join_hh = '2014120100'
group by svc_id;

create table TAB1 (ROW_NUMBER NUMBER, C1 VARCHAR2(10));
truncate table tab1;
select * from tab1;

INSERT INTO TAB1 VALUES (1, 'A' || chr(10) || 'A');
INSERT INTO TAB1 VALUES (2, 'A' || chr(10) || 'A' || chr(10) || 'A');

select sum(cc)
from (
    select(
        length(c1) -- 문자열 전체 길이
            - length( -- 줄바꿈 제거한 후의 길이
                replace(c1, chr(10)) -- c1 컬럼에서 줄바꿈을 제거
              )
            + 1 -- -> 원래 길이 - 줄바꿈 제거한 후의 길이 + 1
    ) cc
    from tab1
);

select to_char(
    TO_DATE('2015.01.10 10', 'YYYY.MM.DD HH24')
        + 1/24/(60/10), -- 얘 뭐냐고.. 하루/24 = 1시간, 1시간/6 = 10분.. ㅋㅋㅋ이거때문에틀림
    'YYYY.MM.DD HH24:MI:SS'
) from dual;

--1번(SQL Server 환경)
SELECT
    TEAM_ID,
    ISNULL(SUM(CASE WHEN POSITION='FW' THEN 1 END), 0) FW,
    ISNULL(SUM(CASE WHEN POSITION='MF' THEN 1 END), 0) MF,
    ISNULL(SUM(CASE WHEN POSITION='DF' THEN 1 END), 0) DF,
    ISNULL(SUM(CASE WHEN POSITION='GK' THEN 1 END), 0) GK,
    COUNT(*) SUM
FROM PLAYER
GROUP BY TEAM_ID;

--2번(Oracle 환경)
SELECT
    TEAM_ID,
    NVL(SUM(CASE POSITION WHEN 'FW' THEN 1 END), 0) FW,
    NVL(SUM(CASE POSITION WHEN 'MF' THEN 1 END), 0) MF,
    NVL(SUM(CASE POSITION WHEN 'DF' THEN 1 END), 0) DF,
    NVL(SUM(CASE POSITION WHEN 'GK' THEN 1 END), 0) GK,
    COUNT(*) SUM
FROM PLAYER
GROUP BY TEAM_ID;

--3번(Oracle 환경)
SELECT
    TEAM_ID,
    NVL(SUM(CASE WHEN POSITION='FW' THEN 1 END), 0) FW,
    NVL(SUM(CASE WHEN POSITION='MF' THEN 1 END), 0) MF,
    NVL(SUM(CASE WHEN POSITION='DF' THEN 1 END), 0) DF,
    NVL(SUM(CASE WHEN POSITION='GK' THEN 1 END), 0) GK,
    COUNT(*) SUM
FROM PLAYER
GROUP BY TEAM_ID;

--4번(Oracle 환경)
SELECT
    TEAM_ID,
    NVL(SUM(CASE POSITION WHEN 'FW' THEN 1 ELSE 1 END), 0) FW,
    NVL(SUM(CASE POSITION WHEN 'MF' THEN 1 ELSE 1 END), 0) MF,
    NVL(SUM(CASE POSITION WHEN 'DF' THEN 1 ELSE 1 END), 0) DF,
    NVL(SUM(CASE POSITION WHEN 'GK' THEN 1 ELSE 1 END), 0) GK,
    COUNT(*) SUM
FROM PLAYER
GROUP BY TEAM_ID;


-- 52번
SELECT C.광고매체명, B.광고명, A.광고시작일자
FROM
    광고게시 A,
    광고 B,
    광고매체 C,
    (
        SELECT D.광고매체ID, MIN(D.광고시작일자) AS 광고시작일자
        FROM 광고게시 D
        WHERE D.광고매체ID = C.광고매체ID
        GROUP BY D.광고매체ID
    ) D
WHERE
    A.광고시작일자 = D.광고시작일자
    AND A.광고매체ID = D.광고매체ID
    AND A.광고ID = B.광고ID
    AND A.광고매체ID = C.광고매체ID
ORDER BY C.광고매체명;


SELECT C.광고매체명, B.광고명, A.광고시작일자
FROM
    광고게시 A,
    광고 B,
    광고매체 C,
    (
        SELECT 광고매체ID, MIN(광고시작일자) AS 광고시작일자
        FROM 광고게시
        GROUP BY 광고매체ID
    ) D
WHERE
    A.광고시작일자 = D.광고시작일자
  AND A.광고매체ID = D.광고매체ID
  AND A.광고ID = B.광고ID
  AND A.광고매체ID = C.광고매체ID
ORDER BY C.광고매체명;


SELECT C.광고매체명, B.광고명, A.광고시작일자
FROM
    광고게시 A,
    광고 B,
    광고매체 C,
    (
        SELECT MIN(광고매체ID) AS 광고매체ID, MIN(광고시작일자) AS 광고시작일자
        FROM 광고게시
        GROUP BY 광고ID
    ) D
WHERE
    A.광고시작일자 = D.광고시작일자
  AND A.광고매체ID = D.광고매체ID
  AND A.광고ID = B.광고ID
  AND A.광고매체ID = C.광고매체ID
ORDER BY C.광고매체명;


SELECT C.광고매체명, B.광고명, A.광고시작일자
FROM
    광고게시 A,
    광고 B,
    광고매체 C,
    (
        SELECT MIN(광고매체ID) AS 광고매체ID, MIN(광고시작일자) AS 광고시작일자
        FROM 광고게시
    ) D
WHERE
    A.광고시작일자 = D.광고시작일자
  AND A.광고매체ID = D.광고매체ID
  AND A.광고ID = B.광고ID
  AND A.광고매체ID = C.광고매체ID
ORDER BY C.광고매체명;


select 메뉴id, 사용유형코드, avg(count(*)) as avgcnt
from 시스템사용이력
group by 메뉴id, 사용유형코드;


-- 팀별성적 테이블에서 승리건수가 높은 순으로 3위까지 출력하되 3위의 승리건수가 동일한 팀이 있다면 함께 출력하기 위한 SQL 문장으로 올바른 것은?
SELECT TOP(3) 팀명, 승리건수
FROM 팀별성적
ORDER BY 승리건수 DESC;

SELECT TOP(3) 팀명, 승리건수
FROM 팀별성적;

SELECT 팀명, 승리건수
FROM 팀별성적
WHERE ROWNUM <= 3
ORDER BY 승리건수 DESC;

SELECT TOP(3) WITH TIES 팀명, 승리건수
FROM 팀별성적
ORDER BY 승리건수 DESC;

-- 출연료가 8888 이상인 영화명, 배우명, 출연료를 구하는 sql로 가장 적절한 것은?
-- 배우(배우번호(PK), 배우명, 성별)
-- 영화(영화번호(PK), 영화명, 제작년도)
-- 출연(배우번호(PK), 영화번호(PK), 출연료

-- 1.
select 출연.영화명, 영화.배우명, 출연.출연료
from 배우, 영화, 출연
where 출연료 >= 8888
    and 출연.영화번호 = 영화.영화번호
    and 출연.배우번호 = 배우.배우번호;

-- 2.
select 영화.영화명, 배우.배우명, 출연료
from 영화, 배우, 출연
where 출연.출연료 > 8888
  and 출연.영화번호 = 영화.영화번호
  and 영화.영화번호 = 배우.배우번호;

-- 3.
select 영화명, 배우명, 출연료
from 배우, 영화, 출연
where 출연료 >= 8888
    and 영화번호 = 영화.영화번호
    and 배우번호 = 배우.배우번호;

-- 4.
select 영화.영화명, 배우.배우명, 출연료
from 배우, 영화, 출연
where 출연료 >= 8888
    and 출연.영화번호 = 영화.영화번호
    and 출연.배우번호 = 배우.배우번호;