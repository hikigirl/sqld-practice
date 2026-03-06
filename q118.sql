create table tbl(id varchar2(10), start_val number, end_val number);

insert into tbl values('A', 14, 15);
insert into tbl values('A', 10, 14);
insert into tbl values('A', 15, 15);
insert into tbl values('A', 15, 18);
insert into tbl values('A', 20, 25);
insert into tbl values('A', 25, null);
commit;

select * from tbl;

select id, start_val, end_val
from (
         select id, start_val, NVL(end_val, 99) end_val,
             (
                 case when start_val =
                           lag(end_val) over (partition by id order by start_val, nvl(end_val, 99))
                          then 1
                      else 0
                     end
             ) flag1,
             (
                 case when end_val = lead(start_val) over (partition by id order by start_val, nvl(end_val, 99)) then 1 else 0 end
             ) flag2
         from tbl
     )
where flag1 = 0 or flag2 = 0;