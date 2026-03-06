

-- 보기 1
-- where절이 누락되어 부서의 모든 데이터가 업데이트 대상이 된다..
update 부서 A set 담당자 = (
    select C.부서코드
    from
        (
            select 부서코드, max(변경일자) as 변경일자
            from 부서임시
            group by 부서코드
        ) B,
        부서임시 C
    where
        B.부서코드 = C.부서코드
        and B.변경일자 = C.변경일자
        and A.부서코드 = C.부서코드
);

-- 보기 2

update 부서 A set 담당자 = (
    select C.부서코드
    from
        (
            select 부서코드, max(변경일자) as 변경일자
            from 부서임시
            group by 부서코드
        ) B,
        부서임시 C
    where
        B.부서코드 = C.부서코드
        and B.변경일자 = C.변경일자
        and A.부서코드 = C.부서코드
)
where exists (
    select 1 from 부서 X
    where A.부서코드 = X.부서코드
);

-- 보기3
update 부서 A set 담당자 = (
    select B.담당자
    from 부서임시 B
    where
        B.부서코드 = A.부서코드
        and B.변경일자 = (
            select max(C.변경일자) from 부서임시 C
            where C.부서코드 = B.부서코드
        )
)
where 부서코드 in (select 부서코드 from 부서임시);

-- 보기4
update 부서 A set 담당자 = (
    select B.담당자
    from 부서임시 B
    where
        B.부서코드 = A.부서코드
        and B.변경일자 = '2015.01.25.'
);