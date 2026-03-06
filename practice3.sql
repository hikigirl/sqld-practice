SELECT 
    CASE WHEN GROUPING(A.서비스ID) = 0
    THEN A.서비스ID
    ELSE '합계'
    END AS 서비스ID,
    CASE WHEN GROUPING(B.가입일자) = 0
    THEN NVL(B.가입일자, '-')
    ELSE '소계'
    END AS 가입일자,
    COUNT(B.회원번호) AS 가입건수
FROM 서비스 A
LEFT OUTER JOIN 서비스가입 B
    ON (
        A.서비스ID = B.서비스ID
        AND B.가입일자 BETWEEN  '2013-01-01' AND '2013-01-31'
    )
GROUP BY ROLLUP(A.서비스ID, B.가입일자);

create table sales(month varchar2(20), amount number);
insert into sales values('01', 1000);
insert into sales values('02', 2000);
insert into sales values('02', 3000);
insert into sales values('03', 1500);
insert into sales values('03', 2500);
commit;

select * from sales;
select month, sum(amount) from sales group by rollup(month);

drop table sales;
