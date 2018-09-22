-- Updating last modified by for reopstatus bug 
update tbl_FollowUp
set LastUpdatedBy = 'cidmu'
where FUId in
(
select fuid from tbl_FollowUp f
inner join tbl_Patient p on p.PatId = f.PatientId
inner join tbl_User tu on tu.UserId = p.PriSurgId
inner join aspnet_Users u on u.UserId = tu.UId
where f.LastUpdatedDateTime > '2016-01-22' 
and  u.UserName <> f.LastUpdatedBy
 and f.LastUpdatedBy not in('cidmu','CIDMU_SP','BSR_BATCH')
 and f.LastUpdatedBy not like '%bsradmin%' 
)