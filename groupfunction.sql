select
    case when grouping (A.serviceID) = 0
        then A.serviceID
        else '합계'
        end as serviceID,
    case when grouping (B.regdate) = 0
             then nvl(B.regdate, '-')
         else '소계'
        end as regdate,
    count(B.userID) as userCount
from service
left outer join serviceReg B
    on (A.serviceID = B.serviceID
        and B.regdate between '2013-01-01' and '2013-01-31')
group by rollup(A.serviceID, B.regdate);