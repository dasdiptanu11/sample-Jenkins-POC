with tmp as (
select *, ROW_NUMBER() over (PARTITION By fa.fuid order by fa.AuditDate desc) as rnk  from tbl_FollowUp_Audit fa
where  fa.FUId in (
select distinct fuid from tbl_FollowUp f 
inner join tbl_Patient p on p.PatId = f.PatientId
inner join tbl_User tu on tu.UserId = p.PriSurgId
inner join aspnet_Users u on u.UserId = tu.UId
where f.LastUpdatedDateTime > '2016-01-22' 
and  u.UserName <> f.LastUpdatedBy
and f.LastUpdatedBy not in('cidmu','CIDMU_SP','BSR_BATCH'))
)
 
update tbl_FollowUp
set  LastUpdatedBy ='cidmu'
where FUId in (
select  distinct t.fuid from tmp  t --t.ReOpStatId,*
inner  join tbl_FollowUp f on t.FUId = f.FUId
where rnk=1  and  AuditUserName like '%MONASH\praveenb%' 
)
