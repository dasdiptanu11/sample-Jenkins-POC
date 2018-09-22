

/*Original tables*/

select * from [Bariatric_Procedures3] where [Pt Id] =910
--[Bariatric_Procedures3]
select * from [Site for Loading]
select * from [Surgeon for Loading]

select * from [Bariatric_Procedures3] where [Pt Id] =910


-- Run to preserve original : duplicate will be updated
select * into dbo.SiteNames   from [Site for Loading]
select * into dbo.SurgeonNames   from [Surgeon for Loading]
select * into dbo.[Bariatric Procedures] from [Bariatric_Procedures3] 

sp_help [Bariatric_Procedures] 
--Date of Mortality	nvarchar
--drop table [Bariatric Procedures] 

--Tables 
select * from SiteNames  
select * from SurgeonNames
select * from dbo.[Bariatric Procedures] 

/*-----------------------Creating Basic Data------------------*/

select * from  aspnet_Applications

insert into  aspnet_Applications (ApplicationName,LoweredApplicationName)
values ('/', '/')


select * from [aspnet_Roles] 

INSERT [dbo].[aspnet_Roles] ([ApplicationId], [RoleName], [LoweredRoleName], [Description]) 
select ApplicationID , N'SURGEON', N'Surgeon', NULL from aspnet_Applications

INSERT [dbo].[aspnet_Roles] ([ApplicationId], [RoleName], [LoweredRoleName], [Description]) 
select ApplicationID , N'ADMINCENTRAL', N'admincentral', NULL from aspnet_Applications

INSERT [dbo].[aspnet_Roles] ([ApplicationId], [RoleName], [LoweredRoleName], [Description]) 
select ApplicationID , N'ADMINREGISTRY', N'adminregistry', NULL from aspnet_Applications

INSERT [dbo].[aspnet_Roles] ([ApplicationId], [RoleName], [LoweredRoleName], [Description]) 
select ApplicationID , N'DATACOLLECTOR', N'datacollector', NULL from aspnet_Applications


--Creating cidmu 
select * from aspnet_Users

--Use only if above returns 0 rows 
INSERT INTO aspnet_Users (ApplicationId,UserName,LoweredUserName, LastActivityDate)
SELECT ApplicationId, 'cidmu', lower('cidmu'), '01/01/1940' 
FROM  aspnet_Applications 


insert into aspnet_Membership (ApplicationId,UserId,Password,PasswordFormat,PasswordSalt,MobilePIN,Email,LoweredEmail,
PasswordQuestion,PasswordAnswer,IsApproved,IsLockedOut,LastLoginDate,LastPasswordChangedDate,LastLockoutDate,FailedPasswordAttemptCount,
FailedPasswordAttemptWindowStart,FailedPasswordAnswerAttemptCount,FailedPasswordAnswerAttemptWindowStart,Comment, CreateDate)
select ApplicationId, UserId, '', 1, '', NULL, 'jigyasa.sharma@monash.edu' , LOWER('jigyasa.sharma@monash.edu'), 
'First pet''s name?', '35X2UX3JRr24Wrd13D97XyBBFEk=',1,0, '01/01/1940', '01/01/1940', '01/01/1940', 0,
'01/01/1940',0,'01/01/1940', 'Data_Mig', GETDATE()  from aspnet_Users 
 where UserId not in 
(SELECT UserId from aspnet_Membership)
--Answer: name

select * from aspnet_UsersInRoles
select * from aspnet_Users
select * from aspnet_Roles

SELECT ur.UserId, r.RoleName , u.UserName   FROM aspnet_UsersInRoles ur 
left outer join aspnet_Users u on ur.UserId = u.UserId 
left outer join aspnet_Roles r on r.RoleId = ur.RoleId 
where u.UserId is not null

/*Creating cidmu as ADMINREGISTRY*/
insert into aspnet_UsersInRoles(UserId,RoleId)
select UserId , r.RoleId from aspnet_Users inner join  aspnet_Roles r on 'a' = 'a'
where RoleName ='ADMINREGISTRY' and UserName  = 'cidmu' 
and UserId not in (select UserId from aspnet_UsersInRoles) --To avoid duplicate insertion


update aspnet_Membership set [Password] = 'ZWCOjHgw9FM2oHN8vuysz/RTrBA=', PasswordFormat=1 , PasswordSalt = 'CiufP0GGlZesCY1AO+ju0w==',
IsLockedOut = 0 , IsApproved = 1, FailedPasswordAnswerAttemptCount =0, FailedPasswordAttemptCount =0
 where UserId in 
(SELECT m.UserId from aspnet_Membership m inner join aspnet_Users u 
on u.UserId = m.UserId   where UserName = 'cidmu' )

/*---------------------- Creating sites ----------------------*/

update [Bariatric Procedures] set [Hospital State (1)_] = 'QLD' where [Hospital State (1)_] ='Q''LAND'

update [Bariatric Procedures] set [Hospital State (2)_]  = 'QLD' where [Hospital State (2)_] ='Q''LAND'

update [Bariatric Procedures] set [Hospital State (3)_]  = 'QLD' where [Hospital State (3)_] ='Q''LAND'

update [Bariatric Procedures] set [Hospital State (4)_]  = 'QLD' where [Hospital State (4)_] ='Q''LAND'

update [Bariatric Procedures] set [Hospital State (5)_]  = 'QLD' where [Hospital State (5)_] ='Q''LAND'

update SiteNames set SiteState = 'QLD' where SiteState ='Q''LAND'

/*Checking if hospital names in dbo.[Bariatric Procedures] match with SiteNames XL sheet*/
With T1( SiteName_BSR, SiteState_BSR, no_) as
(select distinct [Hospital (1)_],[Hospital State (1)_], 1 from  [Bariatric Procedures] where [Hospital (1)_] is not null
union 
select distinct [Hospital (2)_],[Hospital State (2)_], 2 from  [Bariatric Procedures] where [Hospital (2)_] is not null 
union 
select distinct [Hospital (3)_] ,[Hospital State (3)_], 3  from  [Bariatric Procedures] where [Hospital (3)_] is not null 
union 
select distinct [Hospital (4)_] , [Hospital State (4)_], 4 from  [Bariatric Procedures] where [Hospital (4)_] is not null 
union 
select distinct cast([Hospital (5)_] as CHAR(250)) ,[Hospital State (5)_], 5 from  [Bariatric Procedures] where [Hospital (5)_] is not null )

select no_, SiteName_BSR , snXL.SiteName SiteName_XL,  SiteState_BSR , snXL.SiteState  SiteState_XL 
       from T1 left outer join SiteNames snXL on SiteName_BSR = snXL.SiteName and SiteState_BSR = snXL.SiteState 
where snXL.SiteName is null 

/*Check for states perfectly matching with look up tables*/
select distinct sn.SiteState from SiteNames sn left outer join tlkp_State st on sn.SiteState = st.Description where st.Id is null

/*Check for country*/
select distinct Country from SiteNames sn left outer join tlkp_country c on sn.Country = c.Description where c.Id is null

/*Check for site type*/
select distinct [Site type (Public/Private)] from SiteNames sn 
       left outer join tlkp_SiteType sy on sn.[Site type (Public/Private)] = sy.Description where sy.Id is null

/*checking duplicate site names*/
select sn.SiteName , COUNT(*) from SiteNames sn group by sn.SiteName having COUNT(*) > 1

/*inserting into tbl_Site*/

/*To be used incase something goes wrong 
delete from tbl_site
DBCC CHECKIDENT (tbl_site, RESEED, 0)
*/

begin tran 

--SiteRoleName : Not inserted, will be updated later - has to be taken from aspnet_role table
insert into tbl_site
(SiteName,SitePrimaryContact,SitePh1,SiteSecondaryContact,SitePh2,SiteAddr,SiteSuburb,SiteStateId,
SitePcode,SiteCountryId,SiteTypeId,SiteStatusId,CreatedBy,CreatedByDateTime)
select SiteName, '' SitePrimaryContact, '' SitePh1, '' SiteSecondaryContact, '' SitePh2,
[Street number and name] SiteAddr,Suburb SiteSuburb, st.Id SiteStateId, postcode SitePcode, 
c.Id SiteCountryId, sy.Id SiteTypeId, 1 SiteStatusId_Active, 'ADMINISTRATOR', GETDATE()
from SiteNames sn
inner join tlkp_State st on sn.SiteState = st.Description 
inner join tlkp_country c on sn.Country = c.Description 
inner join tlkp_SiteType sy on sn.[Site type (Public/Private)] = sy.Description 


/*Match counts*/
select COUNT(*) from tbl_site 
select COUNT(*) from SiteNames

select * from tbl_site 


alter table  [Bariatric Procedures]  add  Hospital_ID_1 int, Hospital_ID_2 int, Hospital_ID_3 int, Hospital_ID_4 int, Hospital_ID_5 int 


update  [Bariatric Procedures]  set Hospital_ID_1 = 
 (select ts.SiteId from tbl_Site ts inner join tlkp_State st on st.Id = ts.SiteStateId 
         where [Hospital (1)_] = ts.SiteName and [Hospital State (1)_] = st.Description)
         where  [Hospital (1)_] is not null

update  [Bariatric Procedures]  set Hospital_ID_2  = 
 (select ts.SiteId from tbl_Site ts inner join tlkp_State st on st.Id = ts.SiteStateId 
         where [Hospital (2)_]  = ts.SiteName and [Hospital State (2)_]  = st.Description)
         where  [Hospital (2)_]  is not null


update  [Bariatric Procedures]  set Hospital_ID_3   = 
 (select ts.SiteId from tbl_Site ts inner join tlkp_State st on st.Id = ts.SiteStateId 
         where [Hospital (3)_]   = ts.SiteName and [Hospital State (3)_]   = st.Description)
         where  [Hospital (3)_]   is not null
         

update  [Bariatric Procedures]  set Hospital_ID_4    = 
 (select ts.SiteId from tbl_Site ts inner join tlkp_State st on st.Id = ts.SiteStateId 
         where [Hospital (4)_]   = ts.SiteName and [Hospital State (4)_]    = st.Description)
         where  [Hospital (4)_]    is not null


update  [Bariatric Procedures]  set Hospital_ID_5     = 
 (select ts.SiteId from tbl_Site ts inner join tlkp_State st on st.Id = ts.SiteStateId 
         where [Hospital (5)_]    = ts.SiteName and [Hospital State (5)_]     = st.Description)
         where  [Hospital (5)_]     is not null


--Updating SiteRoleName 
update tbl_Site set SiteRoleName =   case when SiteCountryId =1 then 'S_' else 'SN_' end + rtrim(CAST(SiteId  as CHAR(2)))

--Updating details
update tbl_Site set LastUpdatedBy = 'ADMINISTRATOR', CreatedBy ='ADMINISTRATOR'


 /*Duplicate sites */
 select * from SiteNames where SiteName in 
 ( select SiteName from tbl_Site 
 group by SiteName 
 having COUNT(*) > 1)
 order by SiteName
  
/*Creating roles for the hospitals*/
INSERT [dbo].[aspnet_Roles] ([ApplicationId], [RoleName], [LoweredRoleName], [Description]) 
select ApplicationID ,SiteRoleName, SiteRoleName, 'Site/Hospital' from aspnet_Applications inner join tbl_Site on 'a' = 'a' 
where SiteRoleName not in (SELECt [RoleName] from [aspnet_Roles])

select * from [aspnet_Roles] 


/*---------------------- Creating Users----------------------*/

/*Identifying if surgeons missing in XL list wrt BSR database */
select * from SurgeonNames sn		

/*Checking if surgeons in BSR reg match with XL provided*/
With Surgeon(User_, No_) as
(select distinct [Surgeon (1)_], 1  from  [Bariatric Procedures] 
union  
select distinct [Surgeon (2)_],  2     from  [Bariatric Procedures]
union 
select distinct cast([Surgeon (3)_] as CHAR(200)), 3  from  [Bariatric Procedures] 
union 
select distinct [Surgeon (4)_], 4  from  [Bariatric Procedures] 
union 
select distinct cast([Surgeon (5)_] as CHAR(200)), 5   from  [Bariatric Procedures])
SELECT User_, [Surgeon (1)_],* from Surgeon left outer join SurgeonNames on [Surgeon (1)_] = User_ 
where User_ is not null and [Surgeon (1)_]  is null


/*Check for titles*/
select [Surgeon (1)_], Title from SurgeonNames left outer join tlkp_Title tt on tt.description = Title where tt.id is null 
select * from tlkp_Title --A/Prof
update SurgeonNames set Title ='A/Prof' where Title ='Assoc/Prof'


select * from tbl_User

/*Inserting into aspnet_Users*/
INSERT INTO aspnet_Users (ApplicationId,UserName,LoweredUserName, LastActivityDate)
SELECT ApplicationId, [Surgeon (1)_], lower([Surgeon (1)_]), '01/01/1940' 
FROM  SurgeonNames INNER JOIN aspnet_Applications ON 'A' = 'A'     
where [Surgeon (1)_] not in 
(select UserName from aspnet_Users)

/*Checking titles*/
select  tt.description , Title ,[Given Name],[Family Name], 1, null, Email
    from SurgeonNames  left outer join tlkp_Title tt on tt.description = Title
    where tt.Id is null


select * from aspnet_Users
select * from tbl_User
select * from SurgeonNames
SELECT * from aspnet_Membership

/*Inserting into table User*/
insert into tbl_User
( UId, TitleId,FName,LastName, RoleId,  CountryId,StateId,Email, AccountStatusActive, CreatedBy,CreatedDateTime)
select UserID, tt.Id ,[Given Name],[Family Name],null,  1, null, Email, 0, 'ADMINISTRATOR', GETDATE()
    from SurgeonNames 
    inner join tlkp_Title tt on tt.description = Title
    inner join aspnet_Users on [Surgeon (1)_] = UserName
    inner join aspnet_Roles r on RoleName ='SURGEON'
    
/*Creating memberships - passwords emails everything has to be matched */
insert into aspnet_Membership (ApplicationId,UserId,Password,PasswordFormat,PasswordSalt,MobilePIN,Email,LoweredEmail,
PasswordQuestion,PasswordAnswer,IsApproved,IsLockedOut,LastLoginDate,LastPasswordChangedDate,LastLockoutDate,FailedPasswordAttemptCount,
FailedPasswordAttemptWindowStart,FailedPasswordAnswerAttemptCount,FailedPasswordAnswerAttemptWindowStart,Comment, CreateDate)
select ApplicationId, UserId, '', 1, '', NULL, Email , LOWER(Email), 
'Answer is yes', 'IDG67qW4DJlCm1QIMSNes1esf3g=',0,0, '01/01/1940', '01/01/1940', '01/01/1940', 0,
'01/01/1940',0,'01/01/1940', 'ADMINISTRATOR', GETDATE()  from aspnet_Users 
inner join SurgeonNames on [Surgeon (1)_] = UserName  where UserId not in 
(SELECT UserId from aspnet_Membership)

--Checking if all doctors are in registry now 
With Surgeon(Surgeon_BSR,  No_) as
(select distinct [Surgeon (1)_], 1  from  [Bariatric Procedures] group by [Surgeon (1)_] 
union  
select distinct [Surgeon (2)_], 2     from  [Bariatric Procedures] group by [Surgeon (2)_] 
union 
select distinct cast([Surgeon (3)_] as char(200)), 3  from  [Bariatric Procedures] group by [Surgeon (3)_] 
union 
select distinct [Surgeon (4)_], 4  from  [Bariatric Procedures] group by [Surgeon (4)_] 
union 
select distinct cast([Surgeon (5)_] as char(200)), 5   from  [Bariatric Procedures] group by [Surgeon (5)_] )
SELECT * from Surgeon left outer join SurgeonNames on [Surgeon (1)_] = Surgeon_BSR 
where Surgeon_BSR is not null and [Surgeon (1)_] is null


--updating Surgeon IDs in BSR table 
alter table  [Bariatric Procedures]  add  Surgeon_ID_1 int, Surgeon_ID_2 int, Surgeon_ID_3 int, Surgeon_ID_4 int, Surgeon_ID_5 int 

update  [Bariatric Procedures]  set Surgeon_ID_1 = 
 (select u.UserId  from SurgeonNames sn inner join aspnet_Users au on sn.[Surgeon (1)_]  = au.UserName inner join 
         tbl_User u on au.UserId = u.UId where au.UserName = [Bariatric Procedures].[Surgeon (1)_])
         where  [Surgeon (1)_] is not null


update  [Bariatric Procedures]  set Surgeon_ID_2 = 
 (select u.UserId  from SurgeonNames sn inner join aspnet_Users au on sn.[Surgeon (1)_]  = au.UserName inner join 
         tbl_User u on au.UserId = u.UId where au.UserName = [Surgeon (2)_])
         where  [Surgeon (2)_] is not null
         
         
         
 update  [Bariatric Procedures]  set Surgeon_ID_3 = 
 (select u.UserId  from SurgeonNames sn inner join aspnet_Users au on sn.[Surgeon (1)_]  = au.UserName inner join 
         tbl_User u on au.UserId = u.UId where au.UserName = [Surgeon (3)_] )
         where  [Surgeon (3)_] is not null        
         
        
 update  [Bariatric Procedures]  set Surgeon_ID_4 = 
 (select u.UserId  from SurgeonNames sn inner join aspnet_Users au on sn.[Surgeon (1)_]  = au.UserName inner join 
         tbl_User u on au.UserId = u.UId where au.UserName = [Surgeon (4)_]  )
         where  [Surgeon (4)_] is not null          
         
         
 update  [Bariatric Procedures]  set Surgeon_ID_5 = 
 (select u.UserId  from SurgeonNames sn inner join aspnet_Users au on sn.[Surgeon (1)_]  = au.UserName inner join 
         tbl_User u on au.UserId = u.UId where au.UserName = [Surgeon (5)_]   )
         where  [Surgeon (5)_]  is not null                     


/*Checking surgeons*/

select * from [Bariatric_Procedures3]  where ([Surgeon (4)_]  is null and [Surgeon (5)_] is not null)

select * from [Bariatric_Procedures3]  where ([Surgeon (3)_]  is null and [Surgeon (4)_] is not null)

select * from [Bariatric_Procedures3]  where ([Surgeon (2)_]  is null and [Surgeon (3)_] is not null)

select * from [Bariatric_Procedures3]  where ([Surgeon (1)_]  is null and [Surgeon (2)_] is not null)


/*Checking for records that have doctors but no hospitals*/         
With Surgeon(Doctor, Hospital, SurgeonID, HospitalID, no_) as
(
select distinct [Surgeon (1)_],[Hospital (1)_], Surgeon_ID_1, Hospital_ID_1 , 1  from  [Bariatric Procedures]
union  
select distinct [Surgeon (2)_],[Hospital (2)_] , Surgeon_ID_2, Hospital_ID_2, 2     from  [Bariatric Procedures] 
union 
select distinct [Surgeon (3)_],[Hospital (3)_] , Surgeon_ID_3, Hospital_ID_3, 3     from  [Bariatric Procedures] 
union 
select distinct [Surgeon (4)_],[Hospital (4)_] , Surgeon_ID_4, Hospital_ID_4, 4    from  [Bariatric Procedures] 
union 
select distinct [Surgeon (5)_],[Hospital (5)_] , Surgeon_ID_5, Hospital_ID_5 , 5  from  [Bariatric Procedures] 
)
select Doctor, Hospital, SurgeonID, HospitalID, no_ from Surgeon 
where Doctor is not null and Hospital is null

/*Checking for records that have doctors but no SurgeonIDs or hospitalIDs*/         
With Surgeon(Doctor, Hospital, SurgeonID, HospitalID, no_) as
(
select distinct [Surgeon (1)_],[Hospital (1)_], Surgeon_ID_1, Hospital_ID_1 , 1  from  [Bariatric Procedures]
union  
select distinct [Surgeon (2)_],[Hospital (2)_] , Surgeon_ID_2, Hospital_ID_2, 2     from  [Bariatric Procedures] 
union 
select distinct [Surgeon (3)_],[Hospital (3)_] , Surgeon_ID_3, Hospital_ID_3, 3     from  [Bariatric Procedures] 
union 
select distinct [Surgeon (4)_],[Hospital (4)_] , Surgeon_ID_4, Hospital_ID_4, 4    from  [Bariatric Procedures] 
union 
select distinct [Surgeon (5)_],[Hospital (5)_] , Surgeon_ID_5, Hospital_ID_5 , 5  from  [Bariatric Procedures] 
)
select Doctor, Hospital, SurgeonID, HospitalID, no_ from Surgeon 
where Doctor is not null and (SurgeonID is null or HospitalID is null)



/*Check data*/
With Surgeon(Doctor, Hospital, SurgeonID, HospitalID, no_) as
(
select distinct [Surgeon (1)_],[Hospital (1)_], Surgeon_ID_1, Hospital_ID_1 , 1  from  [Bariatric Procedures]
union  
select distinct [Surgeon (2)_],[Hospital (2)_] , Surgeon_ID_2, Hospital_ID_2, 2     from  [Bariatric Procedures] 
union 
select distinct [Surgeon (3)_],[Hospital (3)_] , Surgeon_ID_3, Hospital_ID_3, 3     from  [Bariatric Procedures] 
union 
select distinct [Surgeon (4)_],[Hospital (4)_] , Surgeon_ID_4, Hospital_ID_4, 4    from  [Bariatric Procedures] 
union 
select distinct [Surgeon (5)_],[Hospital (5)_] , Surgeon_ID_5, Hospital_ID_5 , 5  from  [Bariatric Procedures] 
)
select SurgeonID, r.RoleId , SiteRoleName, SiteName ,  Hospital, u.UID 
      --COUNT(*)    --Check counts before inner join and after inner joins
from Surgeon --where Doctor is not null
inner join tbl_Site ts on ts.SiteId  = HospitalID 
inner join aspnet_Roles r on RoleName = ts.SiteRoleName 
inner join tbl_User u on SurgeonID = u.UserId 

/*---------------------- Creating Users Roles ----------------------*/

With Surgeon(Doctor, Hospital, SurgeonID, HospitalID, no_) as
(
select distinct [Surgeon (1)_],[Hospital (1)_], Surgeon_ID_1, Hospital_ID_1 , 1  from  [Bariatric Procedures]
union  
select distinct [Surgeon (2)_],[Hospital (2)_] , Surgeon_ID_2, Hospital_ID_2, 2     from  [Bariatric Procedures] 
union 
select distinct [Surgeon (3)_],[Hospital (3)_] , Surgeon_ID_3, Hospital_ID_3, 3     from  [Bariatric Procedures] 
union 
select distinct [Surgeon (4)_],[Hospital (4)_] , Surgeon_ID_4, Hospital_ID_4, 4    from  [Bariatric Procedures] 
union 
select distinct [Surgeon (5)_],[Hospital (5)_] , Surgeon_ID_5, Hospital_ID_5 , 5  from  [Bariatric Procedures] 
)
select distinct SurgeonID, HospitalID
from Surgeon where SurgeonID is not null 

select * from aspnet_UsersInRoles 

/*Inserting roles*/
select Uid, u.FName , r.RoleId from tbl_User u inner join  aspnet_Roles r on 'a' = 'a'
where RoleName ='SURGEON' and Uid not in 
(SELECT distinct  UserId FROM aspnet_UsersInRoles)


insert into aspnet_UsersInRoles(UserId,RoleId)
select Uid, r.RoleId from tbl_User inner join  aspnet_Roles r on 'a' = 'a'
where RoleName ='SURGEON' and (cast(Uid as CHAR(255))+ cast(r.RoleId as CHAR(255))) not in 
(SELECT (cast(UserId as CHAR(255))+ cast(RoleId as CHAR(255)))  FROM aspnet_UsersInRoles)


/*If alright insert roles(s_1) or associate hospitals for doctors*/
With Surgeon(Doctor, Hospital, SurgeonID, HospitalID, no_) as
(
select distinct [Surgeon (1)_],[Hospital (1)_], Surgeon_ID_1, Hospital_ID_1 , 1  from  [Bariatric Procedures]
union  
select distinct [Surgeon (2)_],[Hospital (2)_] , Surgeon_ID_2, Hospital_ID_2, 2     from  [Bariatric Procedures] 
union 
select distinct [Surgeon (3)_],[Hospital (3)_] , Surgeon_ID_3, Hospital_ID_3, 3     from  [Bariatric Procedures] 
union 
select distinct [Surgeon (4)_],[Hospital (4)_] , Surgeon_ID_4, Hospital_ID_4, 4    from  [Bariatric Procedures] 
union 
select distinct [Surgeon (5)_],[Hospital (5)_] , Surgeon_ID_5, Hospital_ID_5 , 5  from  [Bariatric Procedures] 
)
insert into  aspnet_UsersInRoles(UserId,RoleId)
select distinct u.UID , r.RoleId from Surgeon 
inner join tbl_Site ts on ts.SiteId  = HospitalID 
inner join aspnet_Roles r on RoleName = ts.SiteRoleName 
inner join tbl_User u on SurgeonID = u.UserId 
where (cast(Uid as CHAR(255))+ cast(r.RoleId as CHAR(255))) not in 
(SELECT (cast(UserId as CHAR(255))+ cast(RoleId as CHAR(255)))  FROM aspnet_UsersInRoles)

select rolename, UserName , * from aspnet_UsersInRoles uir inner join 
aspnet_Users u on u.UserId = uir.UserId 
inner join aspnet_Roles r on r.RoleId = uir.RoleId  


select u.UserId , u.FName , u.LastName , r.Rolename, * from tbl_User u inner join aspnet_UsersInRoles  ur on ur.UserId = u.UId 
inner join aspnet_Roles r on r.RoleId = ur.RoleId
--where u.LastName ='Bowden'
order by  u.UserId 


/*---------------------- Creating Patients ----------------------*/

--Removing patients with 'Patient' as first name 
select * from [Bariatric Procedures] where [First name] like '%Patient%'

delete from [Bariatric Procedures] where [First name] like '%Patient%'
delete from [Bariatric Procedures] where [Pt Id] is null

--Checking Title
select Title, * from  [Bariatric Procedures] left outer join tlkp_title title on 
title.Description = Title 
where title.Id is null and title is not null and [First name] not like 'OPT OFF%'

--Update the wrong titles     
update  [Bariatric Procedures] set Title ='Mr'  where  Title in('Fr', 'Mr  Mr','Mstr', 'M') 
update  [Bariatric Procedures] set Title ='Mrs'  where  [Pt Id]= 4126 --Title in('Mrs  Mrs') 
update  [Bariatric Procedures] set Title ='Ms'  where  [Pt Id]= 3636


--Checking gender
select distinct Gender from  [Bariatric Procedures]

select Gender, * from  [Bariatric Procedures] left outer join tlkp_Gender gender on 
gender.Description = gender 
where  gender.Id is null 

--Checking primary surgeons and hospitals
select * from  [Bariatric Procedures] where [Surgeon (1)_] is not null and [Hospital (1)_] is null
select * from  [Bariatric Procedures] where [Surgeon (2)_]  is not null and [Hospital (2)_]  is null
select * from  [Bariatric Procedures] where [Surgeon (3)_]  is not null and [Hospital (3)_]  is null
select * from  [Bariatric Procedures] where [Surgeon (4)_] is not null and [Hospital (4)_] is null
select * from  [Bariatric Procedures] where [Surgeon (5)_] is not null and [Hospital (5)_] is null

--Checking state of patients 
select * from tlkp_State 

select [state], * from  [Bariatric Procedures]
left outer join tlkp_State st on st.Description = [state] 
where st.Description  is null and [state] is not null

--[First name] not like '%OFF%'

update [Bariatric Procedures] set [state] = 'QLD' where [state] = 'Q''LAND'
update [Bariatric Procedures] set [state] = 'VIC' where [Pt Id] = 3997


/*Length checks*/

--Postcode
select [Postcode], * from  [Bariatric Procedures] where LEN(rtrim([Postcode]))> 4 and [First name] not like '%OFF%'
update [Bariatric Procedures] set [Postcode]=null where [First name] like '%OFF%'
-- Medicare 
 select  ([Medicare no]), LEN([Medicare no]), * from [Bariatric Procedures] where len([Medicare no]) > 11
 select ([Medicare no]), * from [Bariatric Procedures] where [Medicare no] like '%e%'
 update [Bariatric Procedures] set [Medicare no] = '60574318640' where len([Medicare no]) > 11 and [Pt Id] = 3607  
 update [Bariatric Procedures] set [Medicare no] = '30236661919' where len([Medicare no]) > 11 and [Pt Id] = 2174
  
select [Address], * from [Bariatric Procedures] where len([Address]) > 100
select [city], * from [Bariatric Procedures] where len([city]) > 100
select [Home ph], * from [Bariatric Procedures] where len([Home ph]) >= 30
select [Mobile ph], * from [Bariatric Procedures] where len([Mobile ph]) >= 30

select [Mortality details], * from [Bariatric Procedures] where len([Mortality details]) >= 200

select [Pt Id] , 
UPPER(case when  [First name] like '%PARTIAL OPT OFF%' 
             then SUBSTRING([Last name], LEN('PARTIAL OPT OFF (') + 1 , CHARINDEX(',', [Last name]) - 18  )
      else case when  [First name] like '%OPT%' 
                then  
                case when len (SUBSTRING([Last name], LEN('OPT OFF (') + 1,  CHARINDEX(',', [Last name]))) < 10  
                   then SUBSTRING([Last name], LEN('OPT OFF (') + 1, CHARINDEX(',', [Last name])) else 
                        SUBSTRING([Last name], LEN('OPT OFF (') + 1, CHARINDEX(',', [Last name]) - 10  ) end 
                
                --len([Last name]) -  CHARINDEX(',', [Last name]) + 1  )
      else [First name] end end) LastName ,
upper(case when  [First name] like '%PARTIAL OPT OFF%' then SUBSTRING([Last name], CHARINDEX(',', [Last name]) + 2 , LEN([Last name]) - CHARINDEX(',', [Last name]) -2)
      else case when  [First name] like '%OPT%' then SUBSTRING([Last name], CHARINDEX(',', [Last name]) +2, LEN([Last name]) - CHARINDEX(',', [Last name]) -2 )      
      else [Last name] end end) FirstName
      from [Bariatric Procedures]
where len(case when  [First name] like '%PARTIAL OPT OFF%' 
             then SUBSTRING([Last name], LEN('PARTIAL OPT OFF (') + 1 , CHARINDEX(',', [Last name]) - 18  )
      else case when  [First name] like '%OPT%' 
                then  
                case when len (SUBSTRING([Last name], LEN('OPT OFF (') + 1,  CHARINDEX(',', [Last name]))) < 10  
                   then SUBSTRING([Last name], LEN('OPT OFF (') + 1, CHARINDEX(',', [Last name])) else 
                        SUBSTRING([Last name], LEN('OPT OFF (') + 1, CHARINDEX(',', [Last name]) - 10  ) end 
                
                --len([Last name]) -  CHARINDEX(',', [Last name]) + 1  )
      else [First name] end end) > 40       
 ---LastNAme    
 select [Pt Id] , 
UPPER(case when  [First name] like '%PARTIAL OPT OFF%' 
             then SUBSTRING([Last name], LEN('PARTIAL OPT OFF (') + 1 , CHARINDEX(',', [Last name]) - 18  )
      else case when  [First name] like '%OPT%' 
                then  
                case when len (SUBSTRING([Last name], LEN('OPT OFF (') + 1,  CHARINDEX(',', [Last name]))) < 10  
                   then SUBSTRING([Last name], LEN('OPT OFF (') + 1, CHARINDEX(',', [Last name])) else 
                        SUBSTRING([Last name], LEN('OPT OFF (') + 1, CHARINDEX(',', [Last name]) - 10  ) end 
                
                --len([Last name]) -  CHARINDEX(',', [Last name]) + 1  )
      else [First name] end end) LastName ,
upper(case when  [First name] like '%PARTIAL OPT OFF%' then SUBSTRING([Last name], CHARINDEX(',', [Last name]) + 2 , LEN([Last name]) - CHARINDEX(',', [Last name]) -2)
      else case when  [First name] like '%OPT%' then SUBSTRING([Last name], CHARINDEX(',', [Last name]) +2, LEN([Last name]) - CHARINDEX(',', [Last name]) -2 )      
      else [Last name] end end) FirstName
      from [Bariatric Procedures]
where len(case when  [First name] like '%PARTIAL OPT OFF%' then SUBSTRING([Last name], CHARINDEX(',', [Last name]) + 2 , LEN([Last name]) - CHARINDEX(',', [Last name]) -2)
      else case when  [First name] like '%OPT%' then SUBSTRING([Last name], CHARINDEX(',', [Last name]) +2, LEN([Last name]) - CHARINDEX(',', [Last name]) -2 )      
      else [Last name] end end) > 40       
     

    


/*Checking dates */
select DOB, CAST(DOB as datetime) ,CAST([Sent Exp Statement] as datetime),   convert(datetime, [Date of Mortality], 103) 
       --CAST([Date of Mortality] as datetime)
from  [Bariatric Procedures] 

select [Pt Id], DOB, CAST(DOB as datetime) ,CAST([Sent Exp Statement] as datetime), ([Date of Mortality])
from  [Bariatric Procedures] where [Date of Mortality] is not null

-- Duplicate patients
select [Pt Id], COUNT(*) from [Bariatric Procedures]  
group by [Pt Id]
having COUNT(*) > 1


/*Check counts*/
select COUNT(*) from  [Bariatric Procedures] --4025

select COUNT(*) from  [Bariatric Procedures] 
	left outer join tlkp_title title on title.Description = Title 
	left outer join tlkp_Gender gender on gender.Description = gender 
	left outer join tlkp_State st on st.Description = case when [state] = 'Q''LAND' then 'QLD' else [state] end  --this is for patient
	left outer join tlkp_State st1 on st1.Description = case when [Hospital State (1)_] = 'Q''LAND' then 'QLD' else [Hospital State (1)_] end --this is for site
	left outer join tbl_Site ts on ts.SiteName = [Hospital (1)_]  and ts.SiteStateId  = st1.Id 
	left outer join tbl_User us on (us.FName + case when us.FName = '' then '' else '.' end +us.LastName )  = [Surgeon (1)_] --4025


/*Check details */

select [State] , [Pt Id] PatID, 
UPPER(case when  [First name] like '%PARTIAL OPT OFF%' 
             then SUBSTRING([Last name], LEN('PARTIAL OPT OFF (') + 1 , CHARINDEX(',', [Last name]) - 18  )
      else case when  [First name] like '%OPT%' 
                then  
                case when len (SUBSTRING([Last name], LEN('OPT OFF (') + 1,  CHARINDEX(',', [Last name]))) < 10  
                   then SUBSTRING([Last name], LEN('OPT OFF (') + 1, CHARINDEX(',', [Last name])) else 
                        SUBSTRING([Last name], LEN('OPT OFF (') + 1, CHARINDEX(',', [Last name]) - 10  ) end 
                
                --len([Last name]) -  CHARINDEX(',', [Last name]) + 1  )
      else [First name] end end) LastName ,
upper(case when  [First name] like '%PARTIAL OPT OFF%' then SUBSTRING([Last name], CHARINDEX(',', [Last name]) + 2 , LEN([Last name]) - CHARINDEX(',', [Last name]) -2)
      else case when  [First name] like '%OPT%' then SUBSTRING([Last name], CHARINDEX(',', [Last name]) +2, LEN([Last name]) - CHARINDEX(',', [Last name]) -2 )      
      else [Last name] end end) FirstName ,
     
title.id, CAST(DOB as datetime), case when DOB IS null then 1 else 0 end DOBNotKnown, gender.Id GenderId, 
[Medicare no] McareNo, case when ([Medicare no] IS null or [Medicare no] = '' )  then 1 else 0 end NoMcareNo , 
null DVANo, 1 NoDVANo, Null IHI, 1 AborStatusId , Null IndiStatusId, 
Null NhiNo, 1 NoNhiNo, Hospital_ID_1 PriSiteId, Surgeon_ID_1  PriSurgId, [Address] Addr, 
case when [Address] IS null then 1 else 0 end AddrNotKnown, 
[city] Sub, st.id StateId, rtrim([Postcode]) Pcode, case when [Postcode] IS null then 1 else 0 end NoPcode, 1 CountryId,
[Home ph] HomePh, 
case when [Home ph] IS null then 1 else 0 end NoHomePh, 
[Mobile ph] MobPh, 
case when [Mobile ph] IS null then 1 else 0 end NoMobPh, 
case when (([First name] Not Like 'OPT%' AND Mortality = 1) OR ([30d Mort(1)_] = 1)) then 1 else 0 end HStatId, 
convert(datetime, [Date of Mortality], 103) DateDeath, case when [Date of Mortality] IS null then 1 else 0 end DateDeathNotKnown , 
[Mortality details] CauseOfDeath, 
case when [Death related to bariatric procedure]='Yes' then 1 else 0 end DeathRelSurgId, 
[Sent Exp Statement] DateESSent, [Letter returned] Undel, 
 case when [First name] like 'PARTIAL OPT OFF%' then 2 else case when [First name] like 'OPT%' then 1 
      else 0 end end OptOffStatId, null OptOffDate , 
 case when [Procedure status (1)_] like '%revision%'  then 1 else 0 end Legacy, 'Data mig' CreatedBy, GETDATE()CreatedDateTime
 from  [Bariatric Procedures] 
 left outer join tlkp_title title on title.Description = Title 
 left outer join tlkp_Gender gender on gender.Description = gender 
 left outer join tlkp_State st on st.Description = [State] 
 
where st.Description is null and [State]  is not null


--Turn on forceful insertion of identity
SET IDENTITY_INSERT [dbo].[tbl_Patient] ON



--Inserting
insert into tbl_patient
(PatId,LastName,FName,TitleId,DOB,DOBNotKnown,GenderId,McareNo,NoMcareNo,DvaNo,NoDvaNo,IHI
,AborStatusId,IndiStatusId,NhiNo,NoNhiNo,PriSiteId,PriSurgId,Addr,AddrNotKnown,Sub,StateId,Pcode,
NoPcode,CountryId,HomePh,NoHomePh, MobPh,NoMobPh,HStatId,DateDeath,DateDeathNotKnown,CauseOfDeath,
DeathRelSurgId,DateESSent,Undel,OptOffStatId,OptOffDate,Legacy,CreatedBy,CreatedDateTime
)
select [Pt Id] PatID, 
UPPER(case when  [First name] like '%PARTIAL OPT OFF%' 
             then SUBSTRING([Last name], LEN('PARTIAL OPT OFF (') + 1 , CHARINDEX(',', [Last name]) - 18  )
      else case when  [First name] like '%OPT%' 
                then  
                case when len (SUBSTRING([Last name], LEN('OPT OFF (') + 1,  CHARINDEX(',', [Last name]))) < 10  
                   then SUBSTRING([Last name], LEN('OPT OFF (') + 1, CHARINDEX(',', [Last name])) else 
                        SUBSTRING([Last name], LEN('OPT OFF (') + 1, CHARINDEX(',', [Last name]) - 10  ) end 
                
                --len([Last name]) -  CHARINDEX(',', [Last name]) + 1  )
      else [First name] end end) LastName ,
upper(case when  [First name] like '%PARTIAL OPT OFF%' then SUBSTRING([Last name], CHARINDEX(',', [Last name]) + 2 , LEN([Last name]) - CHARINDEX(',', [Last name]) -2)
      else case when  [First name] like '%OPT%' then SUBSTRING([Last name], CHARINDEX(',', [Last name]) +2, LEN([Last name]) - CHARINDEX(',', [Last name]) -2 )      
      else [Last name] end end) FirstName ,
     
title.id, CAST(DOB as datetime), case when DOB IS null then 1 else 0 end DOBNotKnown, gender.Id GenderId, 
[Medicare no] McareNo, case when ([Medicare no] IS null or [Medicare no] = '' )  then 1 else 0 end NoMcareNo , 
null DVANo, 1 NoDVANo, Null IHI
, 1 AborStatusId , Null IndiStatusId, 
Null NhiNo, 1 NoNhiNo, Hospital_ID_1 PriSiteId, Surgeon_ID_1  PriSurgId, [Address] Addr, 
case when [Address] IS null then 1 else 0 end AddrNotKnown, 
[city] Sub, st.id StateId, rtrim([Postcode]) Pcode, case when [Postcode] IS null then 1 else 0 end NoPcode, 1 CountryId,
[Home ph] HomePh, 
case when [Home ph] IS null then 1 else 0 end NoHomePh, 
[Mobile ph] MobPh, 
case when [Mobile ph] IS null then 1 else 0 end NoMobPh, 
case when (([First name] Not Like 'OPT%' AND Mortality = 1) OR ([30d Mort(1)_] = 1)) then 1 else 0 end HStatId, 
convert(datetime, [Date of Mortality], 103) DateDeath, case when [Date of Mortality] IS null then 1 else 0 end DateDeathNotKnown , 
[Mortality details] CauseOfDeath, 
case when [Death related to bariatric procedure]='Yes' then 1 else 0 end DeathRelSurgId, 
[Sent Exp Statement] DateESSent, [Letter returned] Undel, 
 case when [First name] like 'PARTIAL OPT OFF%' then 2 else case when [First name] like 'OPT%' then 1 
      else 0 end end OptOffStatId, null OptOffDate , 
 case when [Procedure status (1)_] like '%revision%'  then 1 else 0 end Legacy, 
 'ADMINSTRATOR' CreatedBy, GETDATE()CreatedDateTime
 from  [Bariatric Procedures] 
 left outer join tlkp_title title on title.Description = Title 
 left outer join tlkp_Gender gender on gender.Description = gender 
 left outer join tlkp_State st on st.Description = [State] 
 

--commit
SET IDENTITY_INSERT [dbo].[tbl_Patient] OFF



/*-------------------- Creating URNs ----------------------*/


 
select * from  [Bariatric Procedures] 

--Checking missing URNo
With Hospital_URNo_Dtls(PatientID, HospitalID, HospitalName, URNo,  no_) as
(
select distinct [Pt Id] , Hospital_ID_1 , [Hospital (1)_], [Medical record no (1)_], 1  from  [Bariatric Procedures]
union  
select distinct [Pt Id] , Hospital_ID_2  , [Hospital (2)_] , [Medical record no (2)_] , 2  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_3 ,  [Hospital (3)_] ,[Medical record no (3)_], 3  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_4 ,  [Hospital (4)_] ,'', 4  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_5 ,  [Hospital (5)_] ,'' , 5  from  [Bariatric Procedures]
)
select * from Hospital_URNo_Dtls where HospitalID is not null and URNo is null 

 

--Checking for multiple URNs for same Pat and hospital
With Hospital_URNo_Dtls(PatientID, HospitalID, HospitalName, URNo) as
(
select distinct [Pt Id] , Hospital_ID_1 , [Hospital (1)_], [Medical record no (1)_]  from  [Bariatric Procedures]
union  
select distinct [Pt Id] , Hospital_ID_2  , [Hospital (2)_] , [Medical record no (2)_]  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_3 ,  [Hospital (3)_] ,[Medical record no (3)_]  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_4 ,  [Hospital (4)_] ,''  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_5 ,  [Hospital (5)_] ,''  from  [Bariatric Procedures]
)
select PatientID,HospitalID, HospitalName, COUNT(*) from Hospital_URNo_Dtls where HospitalID is not null  
group by PatientID,HospitalID,
HospitalName having COUNT(*) > 1


/*Check if above duplicates are blanks or nulls - if yes then does taking max help?*/
With Hospital_URNo_Dtls(PatientID, HospitalID, HospitalName, URNo) as
(
select distinct [Pt Id] , Hospital_ID_1 , [Hospital (1)_], [Medical record no (1)_]  from  [Bariatric Procedures]
union  
select distinct [Pt Id] , Hospital_ID_2  , [Hospital (2)_] , [Medical record no (2)_]  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_3 ,  [Hospital (3)_] ,[Medical record no (3)_]  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_4 ,  [Hospital (4)_] ,''  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_5 ,  [Hospital (5)_] ,''  from  [Bariatric Procedures]
)
select PatientID, HospitalID, HospitalName, max(URNo) from Hospital_URNo_Dtls where HospitalID is not null  and PatientID in 
(select PatientID from Hospital_URNo_Dtls where HospitalID is not null  group by PatientID,HospitalID,
HospitalName having COUNT(*) > 1)
group by PatientID, HospitalID, HospitalName


/*Inserting*/

With Hospital_URNo_Dtls(PatientID, HospitalID, HospitalName, URNo) as
(
select distinct [Pt Id] , Hospital_ID_1 , [Hospital (1)_], [Medical record no (1)_]  from  [Bariatric Procedures]
union  
select distinct [Pt Id] , Hospital_ID_2  , [Hospital (2)_] , [Medical record no (2)_]  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_3 ,  [Hospital (3)_] ,[Medical record no (3)_]  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_4 ,  [Hospital (4)_] ,''  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_5 ,  [Hospital (5)_] ,''  from  [Bariatric Procedures]
)
insert into tbl_urn (PatientID,HospitalID,URNo)
select distinct PatientID, HospitalID, URNo from Hospital_URNo_Dtls 
where HospitalID is not null 
      and URNo is not null
      and URNo <> '' 
      
      
/*Checking for blanks / nulls*/      
select * from tbl_URN where URNo is null or URNo = ''
      
/*Checking now for missing UR details */      
With Hospital_URNo_Dtls(PatientID, HospitalID, HospitalName, URNo,  no_) as
(
select distinct [Pt Id] , Hospital_ID_1 , [Hospital (1)_], [Medical record no (1)_], 1  from  [Bariatric Procedures]
union  
select distinct [Pt Id] , Hospital_ID_2  , [Hospital (2)_] , [Medical record no (2)_] , 2  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_3 ,  [Hospital (3)_] ,[Medical record no (3)_], 3  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_4 ,  [Hospital (4)_] ,'', 4  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_5 ,  [Hospital (5)_] ,'' , 5  from  [Bariatric Procedures]
)
select * from Hospital_URNo_Dtls where HospitalID is not null and URNo is null and 
(CAST(PatientID as CHAR(10)) +  CAST(HospitalID as CHAR(10))) not in 
(select (CAST(PatientID as CHAR(10)) +  CAST(HospitalID as CHAR(10))) from tbl_URN  )

 /*Inserting missing UR nos*/
 With Hospital_URNo_Dtls(PatientID, HospitalID, HospitalName, URNo,  no_) as
(
select distinct [Pt Id] , Hospital_ID_1 , [Hospital (1)_], [Medical record no (1)_], 1  from  [Bariatric Procedures]
union  
select distinct [Pt Id] , Hospital_ID_2  , [Hospital (2)_] , [Medical record no (2)_] , 2  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_3 ,  [Hospital (3)_] ,[Medical record no (3)_], 3  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_4 ,  [Hospital (4)_] ,'', 4  from  [Bariatric Procedures]
union 
select distinct [Pt Id] , Hospital_ID_5 ,  [Hospital (5)_] ,'' , 5  from  [Bariatric Procedures]
)
insert into tbl_urn (PatientID,HospitalID,URNo)
select distinct PatientID, HospitalID, 'Missing' + CAST(PatientID as CHAR(10)) from Hospital_URNo_Dtls 
where HospitalID is not null and URNo is null and 
(CAST(PatientID as CHAR(10)) +  CAST(HospitalID as CHAR(10))) not in 
(select (CAST(PatientID as CHAR(10)) +  CAST(HospitalID as CHAR(10))) from tbl_URN  )


/*Checking for duplicates*/      
select PatientID,HospitalID, COUNT(*) from tbl_URN 
group by PatientID,HospitalID
having COUNT(*) > 1


/*-------------------- Creating Operations ----------------------*/

 select * from tbl_patientOperation
 
 select * from [Bariatric Procedures] 
 
 select * from tlkp_Procedure
 
 
/*Matching operations procedures and tlkp_Procedure */
With OperationProcedures(OperationType, no_) as
(
select distinct  [Original Procedure]  , 10 from  [Bariatric Procedures] where  [Original Procedure]  is not null --For last bariatic surgery
union 
select distinct  [Procedure (1)_] , 1 from  [Bariatric Procedures] where  [Procedure (1)_] is not null 
union  
select distinct [Procedure (2)_], 2 from  [Bariatric Procedures] where [Procedure (2)_] is not null 
union  
select distinct [Procedure (3)_], 3 from  [Bariatric Procedures] where [Procedure (3)_]  is not null 
union  
select distinct [Procedure (4)_], 4 from  [Bariatric Procedures] where [Procedure (4)_]   is not null 
union  
select distinct [Procedure (5)_], 5 from  [Bariatric Procedures] where [Procedure (5)_]   is not null 
) 
select OperationType, no_ from OperationProcedures 
left outer join tlkp_Procedure op 
       on op.Description = case when OperationType like '%Other%' then 'Other (specify)' else OperationType end 
where op.Description is null and OperationType is not null

--Updating these to correct ones : select * from tlkp_Procedure
update [Bariatric Procedures]  set  [Procedure (1)_] = 'Bilio pancreatic bypass/duodenal switch' 
where [Procedure (1)_]='Bilio-pancreatic bypass/duodenal'
 
update [Bariatric Procedures]  set  [Procedure (3)_]  = 'Bilio pancreatic bypass/duodenal switch' 
where [Procedure (3)_] ='Bilio-pancreatic bypass/duodenal'

update [Bariatric Procedures]  set [Original Procedure] = 'Bilio pancreatic bypass/duodenal switch' 
where [Original Procedure] = 'Bilio-pancreatic bypass/duodenal switch'

 --drop table temp_UpdateOperations_WithTypeNull
 
 /*Are there operations with all details but missing proc type*/
 With Ops(PatID, Surg, Hospital,Hospital_State, OperationDate,OperationType,OperationStatus,Ht,StWt,OpWt,OpBMI, StBMI, 
         DiabStat,DiaxTreat, OtherInfo,  [Renal Tx], [Liver Tx], no_, Name ) as
(select [Pt Id] , [Surgeon (1)_], [Hospital (1)_] , [Hospital State (1)_] , [Procedure date (1)_], [Procedure (1)_] , [Procedure status (1)_], 
      Height, [Start Wt], [Op Wt (1)_], [Op BMI(1)_], [Start BMI], [Diabetes Status] , [Diabetes Treatment (1)], [Other info (1)_]  OtherInfo, 
       [Renal Tx], [Liver Tx] , 1, [Last name] 
     from  [Bariatric Procedures] 
     where [Procedure date (1)_]is not null 
union  
select [Pt Id] ,[Surgeon (2)_], [Hospital (2)_], [Hospital State (2)_] , [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
      Height, 0, [Weight at Revision/Reversal (2)_], [BMI (2)_], 0, null [Diabetes Status] , null [Diabetes Treatment (1)], [Other info(2)_] OtherInfo, 
      [Renal Tx], [Liver Tx] , 2, [Last name] 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_] is not null 
union 
select [Pt Id] , [Surgeon (3)_], [Hospital (3)_], [Hospital State (3)_] , [Date Revision/Reversal (3)_], [Procedure (3)_], [Procedure status (3)_], 
      Height, 0, [Weight at Revision/Reversal (3)_], [BMI (3)_], 0, null , null , [Other info(3)_]  OtherInfo, [Renal Tx], [Liver Tx], 3 , [Last name] 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (3)_] is not null
union 
select [Pt Id] ,[Surgeon (4)_], [Hospital (4)_], [Hospital State (4)_] , convert(datetime, convert(datetime, [Date Revision/Reversal (4)_], 103), 103), [Procedure (4)_], [Procedure status (4)_], 
      Height, 0, [Weight at Revision/Reversal (4)_], [BMI (4)_], 0, null , null , [Other info(4)_]  OtherInfo, [Renal Tx], [Liver Tx] , 4, [Last name] 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (4)_] is not null 
union 
select [Pt Id] ,[Surgeon (5)_], [Hospital (5)_], [Hospital State (5)_] , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
      Height, 0, [Weight at Revision/Reversal (5)_], [BMI (5)_],0, null , null , [Other info(5)_]  OtherInfo, [Renal Tx], [Liver Tx] , 5, [Last name] 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (5)_] is not null      
     )  
 select  --* into temp_UpdateOperations_WithTypeNull --//TODO - update these operations to NULL
  distinct no_
 from Ops where OperationDate is not null and  OperationType is null  

--Updating temporarily OperationType to 'unspecified'

begin tran 

update [Bariatric Procedures]  set  [Procedure (1)_] = 'Not stated/inadequately described' 
where ([Procedure (1)_] is null or [Procedure (1)_] ='') and [Procedure date (1)_] is not null

commit 

 
  /*Are there operations with all details but missing revision/primary*/
 With Ops(PatID, Surg, Hospital,Hospital_State, OperationDate,OperationType,OperationStatus,Ht,StWt,OpWt,OpBMI, StBMI, 
         DiabStat,DiaxTreat, OtherInfo,  [Renal Tx], [Liver Tx], no_, Name ) as
(select [Pt Id] , [Surgeon (1)_], [Hospital (1)_] , [Hospital State (1)_] , [Procedure date (1)_], [Procedure (1)_] , [Procedure status (1)_], 
      Height, [Start Wt], [Op Wt (1)_], [Op BMI(1)_], [Start BMI], [Diabetes Status] , [Diabetes Treatment (1)], [Other info (1)_]  OtherInfo, 
       [Renal Tx], [Liver Tx] , 1, [Last name] 
     from  [Bariatric Procedures] 
     where [Procedure date (1)_]is not null 
union  
select [Pt Id] ,[Surgeon (2)_], [Hospital (2)_], [Hospital State (2)_] , [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
      Height, 0, [Weight at Revision/Reversal (2)_], [BMI (2)_], 0, null [Diabetes Status] , null [Diabetes Treatment (1)], [Other info(2)_] OtherInfo, 
      [Renal Tx], [Liver Tx] , 2, [Last name] 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_] is not null 
union 
select [Pt Id] , [Surgeon (3)_], [Hospital (3)_], [Hospital State (3)_] , [Date Revision/Reversal (3)_], [Procedure (3)_], [Procedure status (3)_], 
      Height, 0, [Weight at Revision/Reversal (3)_], [BMI (3)_], 0, null , null , [Other info(3)_]  OtherInfo, [Renal Tx], [Liver Tx], 3 , [Last name] 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (3)_] is not null
union 
select [Pt Id] ,[Surgeon (4)_], [Hospital (4)_], [Hospital State (4)_] , convert(datetime, convert(datetime, [Date Revision/Reversal (4)_], 103), 103), [Procedure (4)_], [Procedure status (4)_], 
      Height, 0, [Weight at Revision/Reversal (4)_], [BMI (4)_], 0, null , null , [Other info(4)_]  OtherInfo, [Renal Tx], [Liver Tx] , 4, [Last name] 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (4)_] is not null 
union 
select [Pt Id] ,[Surgeon (5)_], [Hospital (5)_], [Hospital State (5)_] , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
      Height, 0, [Weight at Revision/Reversal (5)_], [BMI (5)_],0, null , null , [Other info(5)_]  OtherInfo, [Renal Tx], [Liver Tx] , 5, [Last name] 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (5)_] is not null    
     )  
 select --* --into temp_UpdateOperations_WithStatusNull 
 distinct no_
 from Ops where OperationDate is not null and  OperationStatus is null  
 
select distinct  [Procedure status (1)_] from  [Bariatric Procedures]   

select distinct  [Procedure status (2)_] from  [Bariatric Procedures]   

/*Updating stats temporaily */
begin tran 

update [Bariatric Procedures]  set  [Procedure status (1)_] = 'Revision procedure' 
where ([Procedure status (1)_] is null or [Procedure status (1)_] ='') and [Procedure date (1)_] is not null

commit 


--Check for operation status
With OperationProcedures(OperationStatus, no_, patID) as
(select distinct [Procedure status (1)_] , 1, [pt id] from  [Bariatric Procedures] where [Original Procedure] is not null 
union  
select distinct [Procedure status (2)_]  , 2, [pt id] from  [Bariatric Procedures] where [Procedure (2)_] is not null 
union  
select distinct [Procedure status (3)_]  , 3, [pt id] from  [Bariatric Procedures] where [Procedure (3)_]  is not null 
union  
select distinct [Procedure status (4)_]  , 4, [pt id] from  [Bariatric Procedures] where [Procedure (4)_]   is not null 
union  
select distinct [Procedure status (5)_]  , 5, [pt id] from  [Bariatric Procedures] where [Procedure (5)_]   is not null 
) 
select *  from OperationProcedures left outer join    
                tlkp_OperationStatus os on 
                os.Id = case when coalesce(OperationStatus, '') like '%revision%' then 1 else 
                        case when coalesce(OperationStatus, '') like '%primary%' then 0 else -1 end end
				where os.Description is null

select * from [Bariatric Procedures] 
     where [Pt Id] in (2743,2797,3838,4053)
     
--Last Bariatic surgery details  
select * from [Bariatric Procedures] 
     where [Procedure status (1)_] like '%revision%' and [Original Procedure] is null 
     
     
--Checking no of operations 
With Ops(PatientId,Hosp,Surg,OpDate,OpStat, OpType ,LstBarProc,Ht, StWt,StBMI,OpWt,
   OpBMI,DiabStat,DiabRx, RenalTx,LiverTx, OthInfoOp) as
(select distinct [Pt Id] PatientId , hospital_ID_1 Hosp , surgeon_ID_1 Surg , [Procedure date (1)_] OpDate, [Procedure status (1)_] OpStat,
      [Procedure (1)_] OpType, 
      case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height, [Start Wt],[Start BMI], [Op Wt (1)_], [Op BMI(1)_], [Diabetes Status] , [Diabetes Treatment (1)], [Renal Tx], [Liver Tx], 
      [Other info (1)_]  OthInfoOp
     from  [Bariatric Procedures] 
     where [Procedure date (1)_] is not null 
union  
select distinct [Pt Id] PatientId , hospital_ID_2 Hosp , surgeon_ID_2 Surg , [Date Revision/Reversal (2)_] OpDate, [Procedure status (2)_] OpStat,
      [Procedure (2)_] OpType, case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (2)_]  , [BMI (2)_]  , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(2)_] OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_]  is not null  
union 
select distinct [Pt Id] PatientId , hospital_ID_3 Hosp , surgeon_ID_3 Surg , convert(datetime, [Date Revision/Reversal (3)_]  , 103) OpDate, [Procedure status (3)_]  OpStat,
      [Procedure (3)_]  OpType, case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (3)_]   , [BMI (3)_]  , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(3)_]  OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (3)_]  is not null 
union 
select distinct [Pt Id] PatientId , hospital_ID_4 Hosp , surgeon_ID_4 Surg , convert(datetime, [Date Revision/Reversal (4)_] , 103) OpDate, 
      [Procedure status (4)_]   OpStat,
      [Procedure (4)_]   OpType, case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (4)_]    , [BMI (4)_]   , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(4)_]  OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (4)_]   is not null 
union 
select distinct [Pt Id] PatientId , hospital_ID_5 Hosp , surgeon_ID_5 Surg , convert(datetime, [Date Revision/Reversal (5)_] , 103) OpDate, 
      [Procedure status (5)_]    OpStat,
      [Procedure (5)_]  OpType, case when [Procedure status (5)_]  like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (5)_]     , [BMI (5)_]    , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(5)_]   OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (5)_] is not null      
     )  
   select COUNT(*) from Ops  --4120
   
  /*Checking count with basics*/ 
 With Ops(PatientId,Hosp,Surg,OpDate,OpStat, OpType ,LstBarProc,Ht, StWt,StBMI,OpWt,
   OpBMI,DiabStat,DiabRx, RenalTx,LiverTx, OthInfoOp) as
(select distinct [Pt Id] PatientId , hospital_ID_1 Hosp , surgeon_ID_1 Surg , [Procedure date (1)_] OpDate, [Procedure status (1)_] OpStat,
      [Procedure (1)_] OpType, 
      case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height, [Start Wt],[Start BMI], [Op Wt (1)_], [Op BMI(1)_], [Diabetes Status] , [Diabetes Treatment (1)], [Renal Tx], [Liver Tx], 
      [Other info (1)_]  OthInfoOp
     from  [Bariatric Procedures] 
     where [Procedure date (1)_] is not null 
union  
select distinct [Pt Id] PatientId , hospital_ID_2 Hosp , surgeon_ID_2 Surg , [Date Revision/Reversal (2)_] OpDate, [Procedure status (2)_] OpStat,
      [Procedure (2)_] OpType, case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (2)_]  , [BMI (2)_]  , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(2)_] OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_]  is not null  
union 
select distinct [Pt Id] PatientId , hospital_ID_3 Hosp , surgeon_ID_3 Surg , convert(datetime, [Date Revision/Reversal (3)_]  , 103) OpDate, [Procedure status (3)_]  OpStat,
      [Procedure (3)_]  OpType, case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (3)_]   , [BMI (3)_]  , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(3)_]  OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (3)_]  is not null 
union 
select distinct [Pt Id] PatientId , hospital_ID_4 Hosp , surgeon_ID_4 Surg , convert(datetime, [Date Revision/Reversal (4)_] , 103) OpDate, 
      [Procedure status (4)_]   OpStat,
      [Procedure (4)_]   OpType, case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (4)_]    , [BMI (4)_]   , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(4)_]  OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (4)_]   is not null 
union 
select distinct [Pt Id] PatientId , hospital_ID_5 Hosp , surgeon_ID_5 Surg , convert(datetime, [Date Revision/Reversal (5)_] , 103) OpDate, 
      [Procedure status (5)_]    OpStat,
      [Procedure (5)_]  OpType, case when [Procedure status (5)_]  like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (5)_]     , [BMI (5)_]    , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(5)_]   OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (5)_] is not null      
     )  
   select COUNT(*) from Ops 
    inner join tlkp_OperationStatus os on os.Id = case when coalesce(OpStat, '') like '%revision%' then 1 else  0 end 
    inner join tlkp_Procedure op on op.Description = case when OpType like '%Other%' then 'Other (specify)' else OpType end 
   --4120    
   
   --Checking operations with 'other' 
    With Ops(PatientId,Hosp,Surg,OpDate,OpStat, OpType ,LstBarProc,Ht, StWt,StBMI,OpWt,
   OpBMI,DiabStat,DiabRx, RenalTx,LiverTx, OthInfoOp) as
(select distinct [Pt Id] PatientId , hospital_ID_1 Hosp , surgeon_ID_1 Surg , [Procedure date (1)_] OpDate, [Procedure status (1)_] OpStat,
      [Procedure (1)_] OpType, 
      case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height, [Start Wt],[Start BMI], [Op Wt (1)_], [Op BMI(1)_], [Diabetes Status] , [Diabetes Treatment (1)], [Renal Tx], [Liver Tx], 
      [Other info (1)_]  OthInfoOp
     from  [Bariatric Procedures] 
     where [Procedure date (1)_] is not null 
union  
select distinct [Pt Id] PatientId , hospital_ID_2 Hosp , surgeon_ID_2 Surg , [Date Revision/Reversal (2)_] OpDate, [Procedure status (2)_] OpStat,
      [Procedure (2)_] OpType, case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (2)_]  , [BMI (2)_]  , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(2)_] OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_]  is not null  
union 
select distinct [Pt Id] PatientId , hospital_ID_3 Hosp , surgeon_ID_3 Surg , convert(datetime, [Date Revision/Reversal (3)_]  , 103) OpDate, [Procedure status (3)_]  OpStat,
      [Procedure (3)_]  OpType, case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (3)_]   , [BMI (3)_]  , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(3)_]  OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (3)_]  is not null 
union 
select distinct [Pt Id] PatientId , hospital_ID_4 Hosp , surgeon_ID_4 Surg , convert(datetime, [Date Revision/Reversal (4)_] , 103) OpDate, 
      [Procedure status (4)_]   OpStat,
      [Procedure (4)_]   OpType, case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (4)_]    , [BMI (4)_]   , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(4)_]  OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (4)_]   is not null 
union 
select distinct [Pt Id] PatientId , hospital_ID_5 Hosp , surgeon_ID_5 Surg , convert(datetime, [Date Revision/Reversal (5)_] , 103) OpDate, 
      [Procedure status (5)_]    OpStat,
      [Procedure (5)_]  OpType, case when [Procedure status (5)_]  like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (5)_]     , [BMI (5)_]    , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(5)_]   OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (5)_] is not null      
     )  
   select OpType, SUBSTRING(Optype, charindex(':', Optype)+1, len(Optype))  from Ops where OpType like 'other%'


--Checking for daibetes 

With Ops(PatientId,Hosp,Surg,OpDate,OpStat, OpType ,LstBarProc,Ht, StWt,StBMI,OpWt,
   OpBMI,DiabStat,DiabRx, RenalTx,LiverTx, OthInfoOp) as
(select distinct [Pt Id] PatientId , hospital_ID_1 Hosp , surgeon_ID_1 Surg , [Procedure date (1)_] OpDate, [Procedure status (1)_] OpStat,
      [Procedure (1)_] OpType, 
      case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height, [Start Wt],[Start BMI], [Op Wt (1)_], [Op BMI(1)_], [Diabetes Status] , [Diabetes Treatment (1)], [Renal Tx], [Liver Tx], 
      [Other info (1)_]  OthInfoOp
     from  [Bariatric Procedures] 
     where [Procedure date (1)_] is not null 
union  
select distinct [Pt Id] PatientId , hospital_ID_2 Hosp , surgeon_ID_2 Surg , [Date Revision/Reversal (2)_] OpDate, [Procedure status (2)_] OpStat,
      [Procedure (2)_] OpType, case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (2)_]  , [BMI (2)_]  , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(2)_] OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_]  is not null  
union 
select distinct [Pt Id] PatientId , hospital_ID_3 Hosp , surgeon_ID_3 Surg , convert(datetime, [Date Revision/Reversal (3)_]  , 103) OpDate, [Procedure status (3)_]  OpStat,
      [Procedure (3)_]  OpType, case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (3)_]   , [BMI (3)_]  , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(3)_]  OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (3)_]  is not null 
union 
select distinct [Pt Id] PatientId , hospital_ID_4 Hosp , surgeon_ID_4 Surg , convert(datetime, [Date Revision/Reversal (4)_] , 103) OpDate, 
      [Procedure status (4)_]   OpStat,
      [Procedure (4)_]   OpType, case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (4)_]    , [BMI (4)_]   , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(4)_]  OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (4)_]   is not null 
union 
select distinct [Pt Id] PatientId , hospital_ID_5 Hosp , surgeon_ID_5 Surg , convert(datetime, [Date Revision/Reversal (5)_] , 103) OpDate, 
      [Procedure status (5)_]    OpStat,
      [Procedure (5)_]  OpType, case when [Procedure status (5)_]  like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (5)_]     , [BMI (5)_]    , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(5)_]   OthInfoOp      
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (5)_] is not null      
     )  
Select dt.Description, DiabStat,DiabRx 
from Ops left outer join tlkp_DiabetesTreatment dt on  dt.Description like ('%' + DiabRx + '%')
where coalesce(DiabStat, 0) = 1 and  dt.Description  is null 

select * from tlkp_DiabetesTreatment 
/*
Id	Description
1	Diet/exercise
2	Oral (mono) therapy
3	Oral (poly) therapy
4	Insulin
5	Not stated*/

select distinct [Diabetes treatment (1)]  from  [Bariatric Procedures] where [Procedure date (1)_] is not null -- and [Diabetes treatment (1)] = 'Unspecified'
select *  from  [Bariatric Procedures] where [Procedure date (1)_] is not null and [Diabetes treatment (1)] = 'Unspecified'
begin tran 
update [Bariatric Procedures] set  [Diabetes treatment (1)] = 'Not stated'  where [Procedure date (1)_] is not null and [Diabetes treatment (1)] = 'Unspecified'
commit 

--Updating ht to 2 decimal places
begin tran
update  [Bariatric Procedures] set Height = CAST(Height as decimal(5,2)) where Height is not null
commit


--inserting 
With Ops(PatientId,Hosp,Surg,OpDate,OpStat, OpType ,LstBarProc,Ht, StWt,StBMI,OpWt,
         OpBMI,DiabStat,DiabRx, RenalTx,LiverTx, OthInfoOp) as
(select distinct [Pt Id] PatientId , hospital_ID_1 Hosp , surgeon_ID_1 Surg , [Procedure date (1)_] OpDate, [Procedure status (1)_] OpStat,
      [Procedure (1)_] OpType, 
      case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height, [Start Wt],[Start BMI], [Op Wt (1)_], [Op BMI(1)_], [Diabetes Status] , [Diabetes Treatment (1)], [Renal Tx], [Liver Tx], 
      [Other info (1)_]  OthInfoOp
     from  [Bariatric Procedures] 
     where [Hospital (1)_] is not null 
union  
select distinct [Pt Id] PatientId , hospital_ID_2 Hosp , surgeon_ID_2 Surg , [Date Revision/Reversal (2)_] OpDate, [Procedure status (2)_] OpStat,
      [Procedure (2)_] OpType, case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (2)_]  , [BMI (2)_]  , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(2)_] OthInfoOp      
     from  [Bariatric Procedures] 
     where [Hospital (2)_] is not null  
union 
select distinct [Pt Id] PatientId , hospital_ID_3 Hosp , surgeon_ID_3 Surg , convert(datetime, [Date Revision/Reversal (3)_] , 103)  OpDate, [Procedure status (3)_]  OpStat,
      [Procedure (3)_]  OpType, case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (3)_]   , [BMI (3)_]  , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(3)_]  OthInfoOp      
     from  [Bariatric Procedures] 
     where [Hospital (3)_]  is not null 
union 
select distinct [Pt Id] PatientId , hospital_ID_4 Hosp , surgeon_ID_4 Surg , convert(datetime, [Date Revision/Reversal (4)_] , 103) OpDate, 
      [Procedure status (4)_]   OpStat,
      [Procedure (4)_]   OpType, case when [Procedure status (1)_] like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (4)_]    , [BMI (4)_]   , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(4)_]  OthInfoOp      
     from  [Bariatric Procedures] 
     where [Hospital (4)_]   is not null 
union 
select distinct [Pt Id] PatientId , hospital_ID_5 Hosp , surgeon_ID_5 Surg , convert(datetime, [Date Revision/Reversal (5)_] , 103) OpDate, 
      [Procedure status (5)_]    OpStat,
      [Procedure (5)_]  OpType, case when [Procedure status (1)_]   like '%revision%' then [Original Procedure] else '' end  LstBarProc,  
      Height,  null [Start Wt], 0 [Start BMI], [Weight at Revision/Reversal (5)_]     , [BMI (5)_]    , null DiabStat, null DiabRx, [Renal Tx], [Liver Tx],
      [Other info(5)_]   OthInfoOp      
     from  [Bariatric Procedures] 
     where [Hospital (5)_] is not null   )  
     
insert into tbl_patientOperation(PatientId,Hosp,Surg,OpDate,ProcAban,OpAge,
        OpStat,OpType,OthPriType,OpRevType,OthRevType,LstBarProc,Ht,HtNtKnown,StWt,StWtNtKnown,StBMI,
        OpWt,SameOpWt,OpWtNtKnown,OpBMI,DiabStat,DiabRx,RenalTx,LiverTx,OthInfoOp,OpVal,CreatedBy,CreatedDateTime, 
        LastUpdatedBy , LastUpdatedDateTime )

select patientId,Hosp,Surg,OpDate,  case when OpStat like '%abandon%' then 1 else 0 end ProcAban, 
     cast(DATEDIFF(YEAR ,p.DOb, OpDate) as CHAR(2)) + 'Y ' +  cast(DATEDIFF(MONTH ,p.DOb, OpDate)%12 as CHAR(2)) + 'M' OpAge,   
     coalesce(os.Id, 0) OpStat,
     case when coalesce(os.Id, 0) = 0 then pro.Id else null end OpType, 
     case when coalesce(os.Id, 0) = 0 and OpType like '%Other%' then SUBSTRING(Optype, charindex(':', Optype)+1, len(Optype)) else '' end OthPriType, 
     case when coalesce(os.Id, 0) = 1 then pro.Id else null end OpRevType, 
     case when coalesce(os.Id, 0) = 1 and OpType like '%Other%' then SUBSTRING(Optype, charindex(':', Optype)+1, len(Optype)) else '' end OthRevType,
     LstBaPro.Id LstBarProc  ,Ht, case when ht is null then 1 else 0 end  HtNtKnown ,CAST(StWt as decimal(5,2)) ,   
     case when coalesce(os.Id, 0) = 1 then null else case when StWt is null then 1 else 0 end end StWtNtKnown,
     case when coalesce(Ht, 0) = 0 then null else (coalesce(StWt, 0)/(Ht * Ht)) end StBMI,CAST(OpWt as decimal(5,2)) , case when coalesce(os.Id, 0) = 1 then null else case when StWt = OpWt then 1 else 0 end end SameOpWt,
     case when OpWt is null then 1 else 0 end OpWtNtKnown,  case when coalesce(Ht, 0) = 0 then null else (coalesce(OpWt, 0)/(Ht * Ht)) end opBMI, 
     DiabStat,dt.Id DiabRx, RenalTx,LiverTx, OthInfoOp, 
     2  OpVal, 'ADMINISTRATOR', GETDATE(), 'ADMINISTRATOR', GETDATE()
     from Ops 
     inner join tbl_Patient p on Ops.patientId = p.PatId 
     inner join tlkp_OperationStatus os on os.Id = case when coalesce(OpStat, '') like '%revision%' then 1 else  0 end 
     inner join tlkp_Procedure pro on pro.Description = case when OpType like '%Other%' then 'Other (specify)' else OpType end 
     left outer join tlkp_procedure LstBaPro on LstBarProc = LstBaPro.Description
     left outer join tlkp_DiabetesTreatment dt on  dt.Description like ('%' + DiabRx + '%')
 
     
     
-- Truncating to 2 digits 
update   tbl_patientOperation set   StBMI = CAST(StBMI as decimal(5,2)) where StBMI is not null 
update   tbl_patientOperation set   OpBMI = CAST(OpBMI as decimal(5,2)) where OpBMI is not null 
 
     
     
/*-------------------- Creating Devices ----------------------*/
     
INSERT INTO [tlkp_PortFixationMethod] ([Id],[Description]) VALUES(4, 'Not Used')



--Checking the number of devices  and how it goes with model 
With Devices(PatID, OperationDate, OperationType, OperationStatus, DeviceBrand, DeviceModel, DeviceSerial, no_) as
(select [Pt Id] , [Procedure date (1)_], [Original Procedure], [Procedure status (1)_], 
		[Device type (1)_], [Device model (1)_] , [Device serial no (1)_] , '1' 
		from  [Bariatric Procedures] 
union 
select [Pt Id] , [Procedure date (1)_], [Original Procedure], [Procedure status (1)_],      
		[Device type 2 (1)_] , [Device model 2 (1)_]  , [Device serial no 2 (1)_] , '1_2'    
		from  [Bariatric Procedures] 
union  
select [Pt Id] ,[Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
		[Device type(2)_] , [Device model(2)_]  , [Device serial no (2)_] , '2'
		from  [Bariatric Procedures] 
union  
select [Pt Id] ,[Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 			
		[Device type 2 (2)_] ,   [Device model 2 (2)_]   , null [Device serial no 2 (2)_] , '2_2'
		from  [Bariatric Procedures] 
union 
select [Pt Id] ,convert(datetime, [Date Revision/Reversal (3)_], 103) , [Procedure (3)_] , [Procedure status (3)_], 
	   [Device type (3)_]  , [Device model (3)_]  , null [Device serial no (3)_]  , '3'
	   from  [Bariatric Procedures] 
union 
select [Pt Id] ,convert(datetime, [Date Revision/Reversal (3)_], 103) , [Procedure (3)_] , [Procedure status (3)_], 		    
	   [Device type 2 (3)_]  ,   [Device model 2 (3)_]    , null [Device serial no 2 (3)_] , '3_2'
	   from  [Bariatric Procedures] 	 
union 
select [Pt Id] ,  convert(datetime, [Date Revision/Reversal (4)_], 103) , [Procedure (4)_], [Procedure status (4)_], 
	   [Device type (4)_]   , [Device model (4)_]   , null [Device serial no (4)_] , '4'
	   from  [Bariatric Procedures] 
union 
select [Pt Id] ,  convert(datetime, [Date Revision/Reversal (4)_], 103) , [Procedure (4)_], [Procedure status (4)_], 
	   [Device type 2 (4)_]   ,   [Device model 2 (4)_]     , null [Device serial no 2 (4)_]    , '4_2'  
	   from  [Bariatric Procedures] 
union 
select [Pt Id] , convert(datetime, [Date Revision/Reversal (5)_], 103) , [Procedure (5)_], [Procedure status (5)_], 
	[Device type (5)_]    , [Device model (5)_]    , null [Device serial no (5)_]  , '5'
	from  [Bariatric Procedures] 
union 
select [Pt Id] , convert(datetime, [Date Revision/Reversal (5)_], 103) , [Procedure (5)_], [Procedure status (5)_],   
	[Device type 2 (5)_]    ,   [Device model 2 (5)_]      , null [Device serial no 2 (5)_]  , '5_2'    
	from  [Bariatric Procedures] 
)
select * from   Devices bsrDev
left outer join 
(select dev.DeviceId DeviceId ,  devType.Description devType , brand.Description devBrand , dev.DeviceModel devModel , dev.DeviceDescription DevDescription 
from tbl_Device dev inner join tbl_DeviceBrand brand on brand.Id = dev.DeviceBrandId 
inner join tlkp_DeviceType devType on brand.TypeID = devType.Id ) DeviceInReg 
on  
(bsrDev.DeviceModel = DeviceInReg.devModel) 
where
DeviceModel is not null and DeviceModel not like 'Buttress%' --3032 devices

--Unknow devices 
With Devices(PatID, OperationDate, OperationType, OperationStatus, DeviceBrand, DeviceModel, DeviceSerial, no_) as
(select [Pt Id] , [Procedure date (1)_], [Original Procedure], [Procedure status (1)_], 
		[Device type (1)_], [Device model (1)_] , [Device serial no (1)_] , '1' 
		from  [Bariatric Procedures] 
union 
select [Pt Id] , [Procedure date (1)_], [Original Procedure], [Procedure status (1)_],      
		[Device type 2 (1)_] , [Device model 2 (1)_]  , [Device serial no 2 (1)_] , '1_2'    
		from  [Bariatric Procedures] 
union  
select [Pt Id] ,[Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
		[Device type(2)_] , [Device model(2)_]  , [Device serial no (2)_] , '2'
		from  [Bariatric Procedures] 
union  
select [Pt Id] ,[Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 			
		[Device type 2 (2)_] ,   [Device model 2 (2)_]   , null [Device serial no 2 (2)_] , '2_2'
		from  [Bariatric Procedures] 
union 
select [Pt Id] ,convert(datetime, [Date Revision/Reversal (3)_], 103) , [Procedure (3)_] , [Procedure status (3)_], 
	   [Device type (3)_]  , [Device model (3)_]  , null [Device serial no (3)_]  , '3'
	   from  [Bariatric Procedures] 
union 
select [Pt Id] ,convert(datetime, [Date Revision/Reversal (3)_], 103) , [Procedure (3)_] , [Procedure status (3)_], 		    
	   [Device type 2 (3)_]  ,   [Device model 2 (3)_]    , null [Device serial no 2 (3)_] , '3_2'
	   from  [Bariatric Procedures] 	 
union 
select [Pt Id] ,  convert(datetime, [Date Revision/Reversal (4)_], 103) , [Procedure (4)_], [Procedure status (4)_], 
	   [Device type (4)_]   , [Device model (4)_]   , null [Device serial no (4)_] , '4'
	   from  [Bariatric Procedures] 
union 
select [Pt Id] ,  convert(datetime, [Date Revision/Reversal (4)_], 103) , [Procedure (4)_], [Procedure status (4)_], 
	   [Device type 2 (4)_]   ,   [Device model 2 (4)_]     , null [Device serial no 2 (4)_]    , '4_2'  
	   from  [Bariatric Procedures] 
union 
select [Pt Id] , convert(datetime, [Date Revision/Reversal (5)_], 103) , [Procedure (5)_], [Procedure status (5)_], 
	[Device type (5)_]    , [Device model (5)_]    , null [Device serial no (5)_]  , '5'
	from  [Bariatric Procedures] 
union 
select [Pt Id] , convert(datetime, [Date Revision/Reversal (5)_], 103) , [Procedure (5)_], [Procedure status (5)_],   
	[Device type 2 (5)_]    ,   [Device model 2 (5)_]      , null [Device serial no 2 (5)_]  , '5_2'    
	from  [Bariatric Procedures] 
)
select * from   Devices bsrDev
left outer join 
(select dev.DeviceId DeviceId ,  devType.Description devType , brand.Description devBrand , dev.DeviceModel devModel , dev.DeviceDescription DevDescription 
from tbl_Device dev inner join tbl_DeviceBrand brand on brand.Id = dev.DeviceBrandId 
inner join tlkp_DeviceType devType on brand.TypeID = devType.Id ) DeviceInReg 
on  
(bsrDev.DeviceModel = DeviceInReg.devModel) 
where
DeviceModel is not null --3052 devices
and DeviceId is null and DeviceModel not like 'Buttress%'


--Checking buttres 
 With Devices(PatID, hosp, surgeon, OperationDate, OperationType, OperationStatus, DeviceBrand, DeviceModel, DeviceSerial, no_, Buttress) as
    (select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,  [Procedure date (1)_], [Procedure (1)_] , [Procedure status (1)_], 
            [Device type (1)_], [Device model (1)_] , [Device serial no (1)_] , '1' 
            , case when [Device model 2 (1)_] like '%Buttress%' then [Device model 2 (1)_] else null end Buttress
            from  [Bariatric Procedures] 
     union 
     select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,  [Procedure date (1)_], [Procedure (1)_] , [Procedure status (1)_],      
            [Device type 2 (1)_] , [Device model 2 (1)_]  , [Device serial no 2 (1)_] , '1_2'   , '' 
            from  [Bariatric Procedures] --where [Device model 2 (1)_] not like '%Buttress%'
     union  
     select [Pt Id] , Hospital_ID_2, Surgeon_ID_2,[Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
			[Device type(2)_] , [Device model(2)_]  , [Device serial no (2)_] , '2',
			case when [Device model 2 (2)_] like '%Buttress%' then [Device model 2 (2)_] else null end Buttress
			from  [Bariatric Procedures] 
     union  
     select [Pt Id] ,Hospital_ID_2, Surgeon_ID_2, [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 			
			[Device type 2 (2)_] ,   [Device model 2 (2)_]   , null [Device serial no 2 (2)_] , '2_2',''
			from  [Bariatric Procedures] --where  [Device model 2 (2)_] not like '%Buttress%'
	union 
	select [Pt Id] ,Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_], 103), [Procedure (3)_] , [Procedure status (3)_], 
		   [Device type (3)_]  , [Device model (3)_]  , null [Device serial no (3)_]  , '3', 
		   case when [Device model 2 (3)_] like '%Buttress%' then [Device model 2 (3)_]  else null end Buttress
		   from  [Bariatric Procedures] 
	union 
	select [Pt Id] ,Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_], 103)  , [Procedure (3)_] , [Procedure status (3)_], 		    
		   [Device type 2 (3)_]  ,   [Device model 2 (3)_]    , null [Device serial no 2 (3)_] , '3_2', '' 
		   from  [Bariatric Procedures] --where  [Device model 2 (3)_]   not like '%Buttress%'	 
	union 
	select [Pt Id] , Hospital_ID_4 , Surgeon_ID_4,  convert(datetime, [Date Revision/Reversal (4)_], 103) , [Procedure (4)_], [Procedure status (4)_], 
		   [Device type (4)_]   , [Device model (4)_]   , null [Device serial no (4)_] , '4', 
		   case when [Device model 2 (4)_]  like '%Buttress%' then [Device model 2 (4)_]   else null end Buttress
		   from  [Bariatric Procedures] 
	union 
	select [Pt Id] , Hospital_ID_4 , Surgeon_ID_4,  convert(datetime, [Date Revision/Reversal (4)_], 103) , [Procedure (4)_], [Procedure status (4)_], 
		   [Device type 2 (4)_]   ,   [Device model 2 (4)_]     , null [Device serial no 2 (4)_]    , '4_2'  , '' 
		   from  [Bariatric Procedures]  --where  [Device model 2 (4)_]    not like '%Buttress%'
	union 
	select [Pt Id] , Hospital_ID_5 , Surgeon_ID_5,  convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
	 [Device type (5)_]    , [Device model (5)_]    , null [Device serial no (5)_]  , '5',
	 case when [Device model 2 (5)_]   like '%Buttress%' then  [Device model 2 (5)_]  else null end Buttress
	 from  [Bariatric Procedures] 
	union 
	select [Pt Id] ,Hospital_ID_5 , Surgeon_ID_5 , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_],   
     [Device type 2 (5)_]    ,   [Device model 2 (5)_]      , null [Device serial no 2 (5)_]  , '5_2'  ,''    
     from  [Bariatric Procedures] 
     -- where   [Device model 2 (5)_] not like '%Buttress%'
     )
     
    select * from  Devices where DeviceModel like 'Buttress%'
     

delete from tbl_PatientOperationDeviceDtls 

DBCC CHECKIDENT (tbl_PatientOperationDeviceDtls, RESEED, 0)
 
--Inserting devices
   
 With Devices(PatID, hosp, surgeon, OperationDate, OperationType, OperationStatus, DeviceBrand, DeviceModel, DeviceSerial, no_, Buttress) as
    (select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,  [Procedure date (1)_], [Procedure (1)_] , [Procedure status (1)_], 
            [Device type (1)_], [Device model (1)_] , [Device serial no (1)_] , '1' 
            , case when [Device model 2 (1)_] like '%Buttress%' then [Device model 2 (1)_] else null end Buttress
            from  [Bariatric Procedures] 
     union 
     select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,  [Procedure date (1)_], [Procedure (1)_] , [Procedure status (1)_],      
            [Device type 2 (1)_] , [Device model 2 (1)_]  , [Device serial no 2 (1)_] , '1_2'   , '' 
            from  [Bariatric Procedures] where [Device model 2 (1)_] not like '%Buttress%'
     union  
     select [Pt Id] , Hospital_ID_2, Surgeon_ID_2,[Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
			[Device type(2)_] , [Device model(2)_]  , [Device serial no (2)_] , '2',
			case when [Device model 2 (2)_] like '%Buttress%' then [Device model 2 (2)_] else null end Buttress
			from  [Bariatric Procedures] 
     union  
     select [Pt Id] ,Hospital_ID_2, Surgeon_ID_2, [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 			
			[Device type 2 (2)_] ,   [Device model 2 (2)_]   , [Serial no 2 (2)_]  [Device serial no 2 (2)_] , '2_2',''
			from  [Bariatric Procedures] where  [Device model 2 (2)_] not like '%Buttress%'
	union 
	select [Pt Id] ,Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_], 103), [Procedure (3)_] , [Procedure status (3)_], 
		   [Device type (3)_]  , [Device model (3)_]  , [Serial no (3)_] [Device serial no (3)_]  , '3', 
		   case when [Device model 2 (3)_] like '%Buttress%' then [Device model 2 (3)_]  else null end Buttress
		   from  [Bariatric Procedures] 
	union 
	select [Pt Id] ,Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_], 103)  , [Procedure (3)_] , [Procedure status (3)_], 		    
		   [Device type 2 (3)_]  ,   [Device model 2 (3)_]    , [Serial no 2 (3)_] [Device serial no 2 (3)_] , '3_2', '' 
		   from  [Bariatric Procedures] where  [Device model 2 (3)_]   not like '%Buttress%'	 
	union 
	select [Pt Id] , Hospital_ID_4 , Surgeon_ID_4,  convert(datetime, [Date Revision/Reversal (4)_], 103) , [Procedure (4)_], [Procedure status (4)_], 
		   [Device type (4)_]   , [Device model (4)_]   , [Serial no (4)_]  [Device serial no (4)_] , '4', 
		   case when [Device model 2 (4)_]  like '%Buttress%' then [Device model 2 (4)_]   else null end Buttress
		   from  [Bariatric Procedures] 
	union 
	select [Pt Id] , Hospital_ID_4 , Surgeon_ID_4,  convert(datetime, [Date Revision/Reversal (4)_], 103) , [Procedure (4)_], [Procedure status (4)_], 
		   [Device type 2 (4)_]   ,   [Device model 2 (4)_]     , [Serial no 2 (4)_]    , '4_2'  , '' 
		   from  [Bariatric Procedures]  where  [Device model 2 (4)_]    not like '%Buttress%'
	union 
	select [Pt Id] , Hospital_ID_5 , Surgeon_ID_5,  convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
	 [Device type (5)_]    , [Device model (5)_]    , [Serial no (5)_]  , '5',
	 case when [Device model 2 (5)_]   like '%Buttress%' then  [Device model 2 (5)_]  else null end Buttress
	 from  [Bariatric Procedures] 
	union 
	select [Pt Id] ,Hospital_ID_5 , Surgeon_ID_5 , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_],   
     [Device type 2 (5)_]    ,   [Device model 2 (5)_]      , [Serial no 2 (5)_]  , '5_2'  ,''    
     from  [Bariatric Procedures] 
      where   [Device model 2 (5)_] not like '%Buttress%'
     )
     
  insert into tbl_PatientOperationDeviceDtls
  (PatientOperationId,ParentPatientOperationDevId,DevType,DevBrand,DevOthBrand,DevOthDesc,DevOthMode,DevManuf,DevOthManuf,DevId, DevLotNo
    --,DevPortMethId,PriPortRet
    ,ButtressId   )
  select OpId, null ParentPatientOperationDevId, devTypeId DevType, BrandID DevBrand,
        case when DeviceId IS null then DeviceBrand else '' end DevOthBrand, ''DevOthDesc,
        case when DeviceId IS null then DeviceModel else '' end DevOthMode, 
            ManufacturerId DevManuf, null DevOthManuf, DeviceId DevId, DeviceSerial DevLotNo,
        case when Buttress like '%YES%' then 1 else 0 end     
    from   Devices bsrDev
    left outer join 
   (select dev.DeviceId DeviceId ,  devType.id devTypeId,  devType.Description devType , brand.Description devBrand , 
       dev.DeviceModel devModel , dev.DeviceDescription DevDescription,  brand.Id BrandID, brand.ManufacturerId ManufacturerId
       from tbl_Device dev inner join tbl_DeviceBrand brand on brand.Id = dev.DeviceBrandId 
       inner join tlkp_DeviceType devType on brand.TypeID = devType.Id ) DeviceInReg  on  (bsrDev.DeviceModel = DeviceInReg.devModel)    
	   inner join tbl_Patient p on bsrDev.PatID = p.PatId 
	   inner join tlkp_OperationStatus os on os.Id = case when coalesce(OperationStatus, '') like '%revision%' then 1 else  0 end 
	   inner join tlkp_Procedure pro on pro.Description = case when OperationType like '%Other%' then 'Other (specify)' else OperationType end 
	   inner join tbl_PatientOperation op on op.PatientId =  bsrDev.PatID and op.OpDate =   OperationDate and 
	       bsrDev.hosp = op.Hosp  and  surgeon = op.Surg 
        and 
        (coalesce (pro.id, 100) = (case when OperationStatus like '%revision%' then coalesce(op.OpRevType, 101) else coalesce(op.OpType, 102) end)
        or 
        coalesce (OperationType, 'OperationType') = 
        (case when OperationStatus like '%revision%' then coalesce(op.OthRevType, 'OthRevType') else coalesce(op.OthPriType, 'OthPriType') end))       
                  
    where DeviceModel is not null or  DeviceSerial is not null
   

   --Checking devices 
   select * from tlkp_DeviceType 
   select * from tlkp_PortFixationMethod 
   
   select * from tbl_PatientOperationDeviceDtls where DevType = 1
   
    
   
   begin tran 
   update tbl_PatientOperationDeviceDtls set DevPortMethId = 5 where DevType = 1 
   commit
   
select * from tbl_PatientOperation o inner join tbl_URN u on o.PatientId = u.PatientID where OpId = 4063

/*-------------------- Creating Follow ups ----------------------*/


--Check the count without joining with Operation table : 10425 
With OpDtls
  (PatID, hosp, surg,  OperationDate,OperationType,OperationStatus, 
  FUYear, FUDate, AttemptedCalls, 
  SelfRptWt,FUWt, FUBMI, LTFU, LTFUDate, SentinalEvent, CxDtls, DiabetesSts, DxTreatment, no_, BMI  ) as
(
select distinct [Pt Id] , Hospital_ID_1, Surgeon_ID_1,   [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    0 FUYear , case when [30d f-up date(1)_] is null then  convert(datetime,[30d due(1)_],103)  else convert(datetime,[30d f-up date(1)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt, [30d wt(1)_] FUWt, [30d BMI(1)] FUBMI, LTFU, convert(datetime,[Date LTFU],103)  ,  [30d Sentinel(1)_] , 
    [30d Cx details(1)_] , [Diabetes Status] DiabetesSts, '' DxTreatment, '1_30' , [Op BMI(1)_] 
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null 
union
select distinct [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_],[Procedure (1)_], [Procedure status (1)_], 
    1 FUYear , case when [Date of 12 mo f/up] is null then convert(datetime,[12 mo f/up due],103)   else convert(datetime,[Date of 12 mo f/up],103)  end  FUDate, 
    [Ph calls],[Self reported wt (1yr)_] SelfRptWt, [Weight at 12 mo f/up] FUWt, 
    [BMI (12 mo)] FUBMI, LTFU, convert(datetime,[Date LTFU],103),  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (12 mo)], [Diabetes Treatment (12 mo)] DxTreatment, '1_1' , [Op BMI(1)_] 
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and [12 mo f/up due] is not null   
       
union
select distinct [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    2 FUYear , case when [Date of 2yr f/up] is null then [2yr f/up due] else [Date of 2yr f/up] end  FUDate, 
    [Ph calls],[Self reported wt (2yr)_]  SelfRptWt, [Weight at 2yr f/up] FUWt, 
    [BMI (2yr)] FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (2yr)], [Diabetes Treatment (2yr)] DxTreatment, '1_2' , [Op BMI(1)_] 
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and [2yr f/up due] is not null    
union
select distinct [Pt Id] , Hospital_ID_1, Surgeon_ID_1, [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    3 FUYear , case when convert(datetime,  [Date of 3yr f/up], 103)  is null then convert(datetime,  [3yr f/up due], 103)  else convert(datetime,  [Date of 3yr f/up], 103) end  FUDate, 
    [Ph calls],[Self reported wt (3yr)_]  SelfRptWt, [Weight at 3yr f/up] FUWt, 
    [BMI (3yr)] FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (3yr)], [Diabetes Treatment (3yr)] DxTreatment, '1_3' , [Op BMI(1)_] 
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and [3yr f/up due] is not null   
union  
select distinct [Pt Id] , Hospital_ID_2, Surgeon_ID_2 , [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
     0 FUYear , case when [30d f-up date(2)_]  is null then [30d due(2)_]  else [30d f-up date(2)_] end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(2)_]  FUWt, [30d BMI(2)_] FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(2)_]  , 
    [30d Cx details(2)_]  , '' DiabetesSts, '' DxTreatment, '2' , [BMI (2)_]  
     from  [Bariatric Procedures] 
     where [Hospital (2)_] is not null  and [30d due(2)_] is not null 
union 
select distinct [Pt Id] , Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_] , 103) , [Procedure (3)_] , [Procedure status (3)_], 
   0 FUYear , case when [30d f-up date(3)_]   is null then convert(datetime,  [30d due(3)_] , 103)    else convert(datetime,   [30d f-up date(3)_]  , 103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(3)_]   FUWt, [30d BMI(3)_]  FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(3)_]   , 
    [30d Cx details(3)_]   , '' DiabetesSts, '' DxTreatment, '3' , [BMI (3)_] 
     from  [Bariatric Procedures] 
     where [Hospital (3)_]  is not null and [30d due(3)_] is not null 
union 
select distinct [Pt Id] , Hospital_ID_4, Surgeon_ID_4 ,convert(datetime, [Date Revision/Reversal (4)_], 103), [Procedure (4)_], [Procedure status (4)_], 
     0 FUYear , case when [30d f-up date(4)_] is null then convert(datetime,[30d due(4)_],103)   else  convert(datetime,[30d f-up date(4)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(4)_]   FUWt, [30d BMI(4)_]  FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103),  [30d Sentinel(4)_]   , 
    [30d Cx details(4)_]   , '' DiabetesSts, '' DxTreatment, '4' , [BMI (4)_] 
     from  [Bariatric Procedures] 
     where [Hospital (4)_] is not null and [30d due(4)_]  is not  null
union 
select distinct [Pt Id] , Hospital_ID_5, Surgeon_ID_5 , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
	0 FUYear , case when [30d f-up date(5)_]    is null then convert(datetime,[30d due(5)_],103) else convert(datetime,[30d f-up date(5)_],103)   end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(5)_]    FUWt, [30d BMI(5)_]   FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(5)_]    , 
    [30d Cx details(5)_]    , '' DiabetesSts, '' DxTreatment, '5' , [BMI (5)_] 
     from  [Bariatric Procedures] 
     where [Hospital (5)_] is not null  and [30d due(5)_]     is not  null 
     )     
  
     select COUNT(*) from OpDtls f 
	 
--Check the count with Operation table : 9979 	 

With OpDtls
  (PatID, hosp, surg,  OperationDate,OperationType,OperationStatus, 
  FUYear, FUDate, AttemptedCalls, 
  SelfRptWt,FUWt, FUBMI, LTFU, LTFUDate, SentinalEvent, CxDtls, DiabetesSts, DxTreatment, no_, BMI  ) as
(
select distinct [Pt Id] , Hospital_ID_1, Surgeon_ID_1,   [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    0 FUYear , case when [30d f-up date(1)_] is null then  convert(datetime,[30d due(1)_],103)  else convert(datetime,[30d f-up date(1)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt, [30d wt(1)_] FUWt, [30d BMI(1)] FUBMI, LTFU, convert(datetime,[Date LTFU],103)  ,  [30d Sentinel(1)_] , 
    [30d Cx details(1)_] , [Diabetes Status] DiabetesSts, '' DxTreatment, '1_30' , [Op BMI(1)_] 
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null 
union
select distinct [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_],[Procedure (1)_], [Procedure status (1)_], 
    1 FUYear , case when [Date of 12 mo f/up] is null then convert(datetime,[12 mo f/up due],103)   else convert(datetime,[Date of 12 mo f/up],103)  end  FUDate, 
    [Ph calls],[Self reported wt (1yr)_] SelfRptWt, [Weight at 12 mo f/up] FUWt, 
    [BMI (12 mo)] FUBMI, LTFU, convert(datetime,[Date LTFU],103),  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (12 mo)], [Diabetes Treatment (12 mo)] DxTreatment, '1_1' , [Op BMI(1)_] 
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and [12 mo f/up due] is not null   
       
union
select distinct [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    2 FUYear , case when [Date of 2yr f/up] is null then [2yr f/up due] else [Date of 2yr f/up] end  FUDate, 
    [Ph calls],[Self reported wt (2yr)_]  SelfRptWt, [Weight at 2yr f/up] FUWt, 
    [BMI (2yr)] FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (2yr)], [Diabetes Treatment (2yr)] DxTreatment, '1_2' , [Op BMI(1)_] 
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and [2yr f/up due] is not null    
union
select distinct [Pt Id] , Hospital_ID_1, Surgeon_ID_1, [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    3 FUYear , case when convert(datetime,  [Date of 3yr f/up], 103)  is null then convert(datetime,  [3yr f/up due], 103)  else convert(datetime,  [Date of 3yr f/up], 103) end  FUDate, 
    [Ph calls],[Self reported wt (3yr)_]  SelfRptWt, [Weight at 3yr f/up] FUWt, 
    [BMI (3yr)] FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (3yr)], [Diabetes Treatment (3yr)] DxTreatment, '1_3' , [Op BMI(1)_] 
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and [3yr f/up due] is not null   
union  
select distinct [Pt Id] , Hospital_ID_2, Surgeon_ID_2 , [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
     0 FUYear , case when [30d f-up date(2)_]  is null then [30d due(2)_]  else [30d f-up date(2)_] end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(2)_]  FUWt, [30d BMI(2)_] FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(2)_]  , 
    [30d Cx details(2)_]  , '' DiabetesSts, '' DxTreatment, '2' , [BMI (2)_]  
     from  [Bariatric Procedures] 
     where [Hospital (2)_] is not null  and [30d due(2)_] is not null 
union 
select distinct [Pt Id] , Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_] , 103) , [Procedure (3)_] , [Procedure status (3)_], 
   0 FUYear , case when [30d f-up date(3)_]   is null then convert(datetime,  [30d due(3)_] , 103)    else convert(datetime,   [30d f-up date(3)_]  , 103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(3)_]   FUWt, [30d BMI(3)_]  FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(3)_]   , 
    [30d Cx details(3)_]   , '' DiabetesSts, '' DxTreatment, '3' , [BMI (3)_] 
     from  [Bariatric Procedures] 
     where [Hospital (3)_]  is not null and [30d due(3)_] is not null 
union 
select distinct [Pt Id] , Hospital_ID_4, Surgeon_ID_4 ,convert(datetime, [Date Revision/Reversal (4)_], 103), [Procedure (4)_], [Procedure status (4)_], 
     0 FUYear , case when [30d f-up date(4)_] is null then convert(datetime,[30d due(4)_],103)   else  convert(datetime,[30d f-up date(4)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(4)_]   FUWt, [30d BMI(4)_]  FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103),  [30d Sentinel(4)_]   , 
    [30d Cx details(4)_]   , '' DiabetesSts, '' DxTreatment, '4' , [BMI (4)_] 
     from  [Bariatric Procedures] 
     where [Hospital (4)_] is not null and [30d due(4)_]  is not  null
union 
select distinct [Pt Id] , Hospital_ID_5, Surgeon_ID_5 , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
	0 FUYear , case when [30d f-up date(5)_]    is null then convert(datetime,[30d due(5)_],103) else convert(datetime,[30d f-up date(5)_],103)   end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(5)_]    FUWt, [30d BMI(5)_]   FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(5)_]    , 
    [30d Cx details(5)_]    , '' DiabetesSts, '' DxTreatment, '5' , [BMI (5)_] 
     from  [Bariatric Procedures] 
     where [Hospital (5)_] is not null  and [30d due(5)_]     is not  null 
     )   
select COUNT(*) 
       from OpDtls f 
	   inner join tlkp_OperationStatus os on os.Id = case when coalesce(OperationStatus, '') like '%revision%' then 1 else  0 end 
	   inner join tlkp_Procedure pro on pro.Description = case when OperationType like '%Other%' then 'Other (specify)' else OperationType end 
	   inner join tbl_PatientOperation op on op.PatientId =  f.PatID and op.OpDate =   OperationDate and 
	       f.hosp = op.Hosp  and  f.surg = op.Surg 
        and 
        (coalesce (pro.id, 100) = (case when OperationStatus like '%revision%' then coalesce(op.OpRevType, 101) else coalesce(op.OpType, 102) end)
        or 
        coalesce (OperationType, 'OperationType') = 
        (case when OperationStatus like '%revision%' then coalesce(op.OthRevType, 'OthRevType') else coalesce(op.OthPriType, 'OthPriType') end))       
        
        
  
--step 2 : check for null in Daibetes treatment   
With OpDtls
  (PatID, hosp, surg,  OperationDate,OperationType,OperationStatus, 
  FUYear, FUDate, AttemptedCalls, 
  SelfRptWt,FUWt, FUBMI, LTFU, LTFUDate, SentinalEvent, CxDtls, DiabetesSts, DxTreatment, no_  ) as
(
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,   [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    0 FUYear , case when [30d f-up date(1)_] is null then  convert(datetime,[30d due(1)_],103)  else convert(datetime,[30d f-up date(1)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt, [30d wt(1)_] FUWt, [30d BMI(1)] FUBMI, LTFU, convert(datetime,[Date LTFU],103)  ,  [30d Sentinel(1)_] , 
    [30d Cx details(1)_] , [Diabetes Status] DiabetesSts, [Diabetes treatment (1)] DxTreatment, '1_30' 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([30d due(1)_] is not null or [30d f-up date(1)_] is not null)
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_],[Procedure (1)_], [Procedure status (1)_], 
    1 FUYear , case when [Date of 12 mo f/up] is null then convert(datetime,[12 mo f/up due],103)   else convert(datetime,[Date of 12 mo f/up],103)  end 
     FUDate, 
    [Ph calls],[Self reported wt (1yr)_] SelfRptWt, [Weight at 12 mo f/up] FUWt, 
    [BMI (12 mo)] FUBMI, LTFU, convert(datetime,[Date LTFU],103),  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (12 mo)], [Diabetes Treatment (12 mo)] DxTreatment, '1_1' 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([Date of 12 mo f/up] is not null or [12 mo f/up due] is not null )  
       
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    2 FUYear , case when [Date of 2yr f/up] is null then [2yr f/up due] else [Date of 2yr f/up] end  FUDate, 
    [Ph calls],[Self reported wt (2yr)_]  SelfRptWt, [Weight at 2yr f/up] FUWt, 
    [BMI (2yr)] FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (2yr)], [Diabetes Treatment (2yr)] DxTreatment, '1_2'  
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([2yr f/up due] is not null or [Date of 2yr f/up] is not null)   
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1, [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    3 FUYear , case when convert(datetime,  [Date of 3yr f/up], 103)  is null then convert(datetime,  [3yr f/up due], 103)  else convert(datetime,  [Date of 3yr f/up], 103) end  FUDate, 
    [Ph calls],[Self reported wt (3yr)_]  SelfRptWt, [Weight at 3yr f/up] FUWt, 
    [BMI (3yr)] FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (3yr)], [Diabetes Treatment (3yr)] DxTreatment, '1_3' 
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and [3yr f/up due] is not null   
union  
select distinct [Pt Id] , Hospital_ID_2, Surgeon_ID_2 , [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
     0 FUYear , case when [30d f-up date(2)_]  is null then [30d due(2)_]  else [30d f-up date(2)_] end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(2)_]  FUWt, [30d BMI(2)_] FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(2)_]  , 
    [30d Cx details(2)_]  , '' DiabetesSts, '' DxTreatment, '2' 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_] is not null  and ([30d f-up date(2)_] is not null or [30d due(2)_]  is not null)
union 
select [Pt Id] , Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_] , 103) , [Procedure (3)_] , [Procedure status (3)_], 
   0 FUYear , case when [30d f-up date(3)_]   is null then convert(datetime,  [30d due(3)_] , 103)    else convert(datetime,   [30d f-up date(3)_]  , 103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(3)_]   FUWt, [30d BMI(3)_]  FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(3)_]   , 
    [30d Cx details(3)_]   , '' DiabetesSts, '' DxTreatment, '3' 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (3)_]  is not null  and ([30d f-up date(3)_]  is not null or [30d due(3)_]   is not null)
union 
select [Pt Id] , Hospital_ID_4, Surgeon_ID_4 ,convert(datetime, [Date Revision/Reversal (4)_], 103), [Procedure (4)_], [Procedure status (4)_], 
     0 FUYear , case when [30d f-up date(4)_] is null then convert(datetime,[30d due(4)_],103)   else  convert(datetime,[30d f-up date(4)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(4)_]   FUWt, [30d BMI(4)_]  FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103),  [30d Sentinel(4)_]   , 
    [30d Cx details(4)_]   , '' DiabetesSts, '' DxTreatment, '4' 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (4)_]   is not null  and ([30d f-up date(4)_]   is not null or [30d due(4)_]    is not null)
union 
select [Pt Id] , Hospital_ID_5, Surgeon_ID_5 , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
	0 FUYear , case when [30d f-up date(5)_]    is null then convert(datetime,[30d due(5)_],103) else convert(datetime,[30d f-up date(5)_],103)   end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(5)_]    FUWt, [30d BMI(5)_]   FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(5)_]    , 
    [30d Cx details(5)_]    , '' DiabetesSts, '' DxTreatment, '5' 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (5)_]    is not null  and ([30d f-up date(5)_]    is not null or [30d due(5)_]     is not null)
     )   
select distinct dt.Description, DxTreatment, no_ 
       from OpDtls f 
	   inner join tlkp_OperationStatus os on os.Id = case when coalesce(OperationStatus, '') like '%revision%' then 1 else  0 end 
	   inner join tlkp_Procedure pro on pro.Description = case when OperationType like '%Other%' then 'Other (specify)' else OperationType end 
	   inner join tbl_PatientOperation op on op.PatientId =  f.PatID and op.OpDate =   OperationDate and 
	       f.hosp = op.Hosp  and  f.surg = op.Surg 
        and 
        (coalesce (pro.id, 100) = (case when OperationStatus like '%revision%' then coalesce(op.OpRevType, 101) else coalesce(op.OpType, 102) end)
        or 
        coalesce (OperationType, 'OperationType') = 
        (case when OperationStatus like '%revision%' then coalesce(op.OthRevType, 'OthRevType') else coalesce(op.OthPriType, 'OthPriType') end))       
       left outer join tlkp_DiabetesTreatment dt on  dt.Description = DxTreatment 
       
       where dt.Id is null and DxTreatment is not null  and DxTreatment <> ''
              

Begin tran  
  
             

update   [Bariatric Procedures] set [Diabetes Treatment (12 mo)] = 'Oral (mono) therapy' where [Diabetes Treatment (12 mo)] = 'Oral (mono)'
update   [Bariatric Procedures] set [Diabetes treatment (1)] = 'Oral (mono) therapy' where [Diabetes treatment (1)] = 'Oral (mono)'
update   [Bariatric Procedures] set [Diabetes Treatment (3yr)]    = 'Oral (mono) therapy' where [Diabetes Treatment (3yr)]    = 'Oral (mono)'
update   [Bariatric Procedures] set [Diabetes Treatment (2yr)]     = 'Oral (mono) therapy' where [Diabetes Treatment (2yr)]     = 'Oral (mono)'


update   [Bariatric Procedures] set [Diabetes Treatment (12 mo)] = 'Oral (poly) therapy' where [Diabetes Treatment (12 mo)] = 'Oral (poly)'
update   [Bariatric Procedures] set [Diabetes treatment (1)] = 'Oral (poly) therapy' where [Diabetes treatment (1)] = 'Oral (poly)'
update   [Bariatric Procedures] set [Diabetes Treatment (3yr)]    =  'Oral (poly) therapy' where [Diabetes Treatment (3yr)]    ='Oral (poly)'
update   [Bariatric Procedures] set [Diabetes Treatment (2yr)]     =  'Oral (poly) therapy' where [Diabetes Treatment (2yr)]     = 'Oral (poly)'

commit

      
--Checking ReOp details           
With OpDtls
  (PatID, hosp, surg,  OperationDate,OperationType,OperationStatus, 
  FUYear, FUDate, AttemptedCalls, 
  SelfRptWt,FUWt, FUBMI, LTFU, LTFUDate, SentinalEvent, CxDtls, DiabetesSts, DxTreatment, no_ , ReOpDetails ) as
(
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,   [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    0 FUYear , case when [30d f-up date(1)_] is null then  convert(datetime,[30d due(1)_],103)  else convert(datetime,[30d f-up date(1)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt, [30d wt(1)_] FUWt, [30d BMI(1)] FUBMI, LTFU, convert(datetime,[Date LTFU],103)  ,  [30d Sentinel(1)_] , 
    [30d Cx details(1)_] , [Diabetes Status] DiabetesSts, [Diabetes treatment (1)] DxTreatment, '1_30' , '' ReOpDetails
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([30d due(1)_] is not null or [30d f-up date(1)_] is not null)
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_],[Procedure (1)_], [Procedure status (1)_], 
    1 FUYear , case when [Date of 12 mo f/up] is null then convert(datetime,[12 mo f/up due],103)   else convert(datetime,[Date of 12 mo f/up],103)  end 
     FUDate, 
    [Ph calls],[Self reported wt (1yr)_] SelfRptWt, [Weight at 12 mo f/up] FUWt, 
    [BMI (12 mo)] FUBMI, LTFU, convert(datetime,[Date LTFU],103),  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (12 mo)], [Diabetes Treatment (12 mo)] DxTreatment, '1_1' , [YR1 Reop Reason]  ReOpReason
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([Date of 12 mo f/up] is not null or [12 mo f/up due] is not null )  
       
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    2 FUYear , case when [Date of 2yr f/up] is null then [2yr f/up due] else [Date of 2yr f/up] end  FUDate, 
    [Ph calls],[Self reported wt (2yr)_]  SelfRptWt, [Weight at 2yr f/up] FUWt, 
    [BMI (2yr)] FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (2yr)], [Diabetes Treatment (2yr)] DxTreatment, '1_2'  , [YR2 Reop Reason]   ReOpReason
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([2yr f/up due] is not null or [Date of 2yr f/up] is not null)   
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1, [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    3 FUYear , case when convert(datetime,  [Date of 3yr f/up], 103)  is null then convert(datetime,  [3yr f/up due], 103)  else convert(datetime,  [Date of 3yr f/up], 103) end  FUDate, 
    [Ph calls],[Self reported wt (3yr)_]  SelfRptWt, [Weight at 3yr f/up] FUWt, 
    [BMI (3yr)] FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (3yr)], [Diabetes Treatment (3yr)] DxTreatment, '1_3' , ''ReOpReason
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and [3yr f/up due] is not null   
union  
select distinct [Pt Id] , Hospital_ID_2, Surgeon_ID_2 , [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
     0 FUYear , case when [30d f-up date(2)_]  is null then [30d due(2)_]  else [30d f-up date(2)_] end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(2)_]  FUWt, [30d BMI(2)_] FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(2)_]  , 
    [30d Cx details(2)_]  , '' DiabetesSts, '' DxTreatment, '2' , ''ReOpReason
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_] is not null  and ([30d f-up date(2)_] is not null or [30d due(2)_]  is not null)
union 
select [Pt Id] , Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_] , 103) , [Procedure (3)_] , [Procedure status (3)_], 
   0 FUYear , case when [30d f-up date(3)_]   is null then convert(datetime,  [30d due(3)_] , 103)    else convert(datetime,   [30d f-up date(3)_]  , 103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(3)_]   FUWt, [30d BMI(3)_]  FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(3)_]   , 
    [30d Cx details(3)_]   , '' DiabetesSts, '' DxTreatment, '3' , ''ReOpReason
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (3)_]  is not null  and ([30d f-up date(3)_]  is not null or [30d due(3)_]   is not null)
union 
select [Pt Id] , Hospital_ID_4, Surgeon_ID_4 ,convert(datetime, [Date Revision/Reversal (4)_], 103), [Procedure (4)_], [Procedure status (4)_], 
     0 FUYear , case when [30d f-up date(4)_] is null then convert(datetime,[30d due(4)_],103)   else  convert(datetime,[30d f-up date(4)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(4)_]   FUWt, [30d BMI(4)_]  FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103),  [30d Sentinel(4)_]   , 
    [30d Cx details(4)_]   , '' DiabetesSts, '' DxTreatment, '4' , ''ReOpReason
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (4)_]   is not null  and ([30d f-up date(4)_]   is not null or [30d due(4)_]    is not null)
union 
select [Pt Id] , Hospital_ID_5, Surgeon_ID_5 , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
	0 FUYear , case when [30d f-up date(5)_]    is null then convert(datetime,[30d due(5)_],103) else convert(datetime,[30d f-up date(5)_],103)   end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(5)_]    FUWt, [30d BMI(5)_]   FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(5)_]    , 
    [30d Cx details(5)_]    , '' DiabetesSts, '' DxTreatment, '5' , ''ReOpReason
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (5)_]    is not null  and ([30d f-up date(5)_]    is not null or [30d due(5)_]     is not null)
     )   
select distinct ReOpDetails,c.Description, no_, rp.Description 
       from OpDtls f 
	   inner join tlkp_OperationStatus os on os.Id = case when coalesce(OperationStatus, '') like '%revision%' then 1 else  0 end 
	   inner join tlkp_Procedure pro on pro.Description = case when OperationType like '%Other%' then 'Other (specify)' else OperationType end 
	   inner join tbl_PatientOperation op on op.PatientId =  f.PatID and op.OpDate =   OperationDate and 
	       f.hosp = op.Hosp  and  f.surg = op.Surg 
        and 
        (coalesce (pro.id, 100) = (case when OperationStatus like '%revision%' then coalesce(op.OpRevType, 101) else coalesce(op.OpType, 102) end)
        or 
        coalesce (OperationType, 'OperationType') = 
        (case when OperationStatus like '%revision%' then coalesce(op.OthRevType, 'OthRevType') else coalesce(op.OthPriType, 'OthPriType') end))       
       left outer join tlkp_DiabetesTreatment dt on  dt.Description = DxTreatment 
       left outer join tlkp_Complications c on c.Description = case when ReOpDetails like '%:%' then SUBSTRING(ReOpDetails, 0, charindex(':', ReOpDetails)) else ReOpDetails end  
	   left outer join tlkp_ReasonPort rp on rp.Description =   SUBSTRING(ReOpDetails, charindex(':', ReOpDetails) + 2, LEN(ReOpDetails)) 
	
	
    where   coalesce(ReOpDetails, '')  <> '' and c.Description is null 


begin tran 
update [Bariatric Procedures] set  [YR1 Reop Reason] = 'Symmetrical pouch dilatation' where [YR1 Reop Reason]= 'Symmetrical pouch dilatation`'          
update [Bariatric Procedures] set  [YR2 Reop Reason]  = 'Symmetrical pouch dilatation' where [YR2 Reop Reason] = 'Symmetrical pouch dilatation`'
commit



      
---Checking for sentinel events         
With OpDtls
  (PatID, hosp, surg,  OperationDate,OperationType,OperationStatus, 
  FUYear, FUDate, AttemptedCalls, 
  SelfRptWt,FUWt, FUBMI, LTFU, LTFUDate, SentinalEvent, CxDtls, DiabetesSts, DxTreatment, no_ , ReOpDetails ) as
(
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,   [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    0 FUYear , case when [30d f-up date(1)_] is null then  convert(datetime,[30d due(1)_],103)  else convert(datetime,[30d f-up date(1)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt, [30d wt(1)_] FUWt, [30d BMI(1)] FUBMI, LTFU, convert(datetime,[Date LTFU],103)  ,  [30d Sentinel(1)_] , 
    [30d Cx details(1)_] , [Diabetes Status] DiabetesSts, [Diabetes treatment (1)] DxTreatment, '1_30' , '' ReOpDetails
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([30d due(1)_] is not null or [30d f-up date(1)_] is not null)
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_],[Procedure (1)_], [Procedure status (1)_], 
    1 FUYear , case when [Date of 12 mo f/up] is null then convert(datetime,[12 mo f/up due],103)   else convert(datetime,[Date of 12 mo f/up],103)  end 
     FUDate, 
    [Ph calls],[Self reported wt (1yr)_] SelfRptWt, [Weight at 12 mo f/up] FUWt, 
    [BMI (12 mo)] FUBMI, LTFU, convert(datetime,[Date LTFU],103),  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (12 mo)], [Diabetes Treatment (12 mo)] DxTreatment, '1_1' , [YR1 Reop Reason]  ReOpReason
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([Date of 12 mo f/up] is not null or [12 mo f/up due] is not null )  
       
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    2 FUYear , case when [Date of 2yr f/up] is null then [2yr f/up due] else [Date of 2yr f/up] end  FUDate, 
    [Ph calls],[Self reported wt (2yr)_]  SelfRptWt, [Weight at 2yr f/up] FUWt, 
    [BMI (2yr)] FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (2yr)], [Diabetes Treatment (2yr)] DxTreatment, '1_2'  , [YR2 Reop Reason]   ReOpReason
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([2yr f/up due] is not null or [Date of 2yr f/up] is not null)   
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1, [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    3 FUYear , case when convert(datetime,  [Date of 3yr f/up], 103)  is null then convert(datetime,  [3yr f/up due], 103)  else convert(datetime,  [Date of 3yr f/up], 103) end  FUDate, 
    [Ph calls],[Self reported wt (3yr)_]  SelfRptWt, [Weight at 3yr f/up] FUWt, 
    [BMI (3yr)] FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (3yr)], [Diabetes Treatment (3yr)] DxTreatment, '1_3' , ''ReOpReason
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and [3yr f/up due] is not null   
union  
select distinct [Pt Id] , Hospital_ID_2, Surgeon_ID_2 , [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
     0 FUYear , case when [30d f-up date(2)_]  is null then [30d due(2)_]  else [30d f-up date(2)_] end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(2)_]  FUWt, [30d BMI(2)_] FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(2)_]  , 
    [30d Cx details(2)_]  , '' DiabetesSts, '' DxTreatment, '2' , ''ReOpReason
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_] is not null  and ([30d f-up date(2)_] is not null or [30d due(2)_]  is not null)
union 
select [Pt Id] , Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_] , 103) , [Procedure (3)_] , [Procedure status (3)_], 
   0 FUYear , case when [30d f-up date(3)_]   is null then convert(datetime,  [30d due(3)_] , 103)    else convert(datetime,   [30d f-up date(3)_]  , 103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(3)_]   FUWt, [30d BMI(3)_]  FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(3)_]   , 
    [30d Cx details(3)_]   , '' DiabetesSts, '' DxTreatment, '3' , ''ReOpReason
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (3)_]  is not null  and ([30d f-up date(3)_]  is not null or [30d due(3)_]   is not null)
union 
select [Pt Id] , Hospital_ID_4, Surgeon_ID_4 ,convert(datetime, [Date Revision/Reversal (4)_], 103), [Procedure (4)_], [Procedure status (4)_], 
     0 FUYear , case when [30d f-up date(4)_] is null then convert(datetime,[30d due(4)_],103)   else  convert(datetime,[30d f-up date(4)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(4)_]   FUWt, [30d BMI(4)_]  FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103),  [30d Sentinel(4)_]   , 
    [30d Cx details(4)_]   , '' DiabetesSts, '' DxTreatment, '4' , ''ReOpReason
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (4)_]   is not null  and ([30d f-up date(4)_]   is not null or [30d due(4)_]    is not null)
union 
select [Pt Id] , Hospital_ID_5, Surgeon_ID_5 , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
	0 FUYear , case when [30d f-up date(5)_]    is null then convert(datetime,[30d due(5)_],103) else convert(datetime,[30d f-up date(5)_],103)   end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(5)_]    FUWt, [30d BMI(5)_]   FUBMI, LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(5)_]    , 
    [30d Cx details(5)_]    , '' DiabetesSts, '' DxTreatment, '5' , ''ReOpReason
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (5)_]    is not null  and ([30d f-up date(5)_]    is not null or [30d due(5)_]     is not null)
     )   
select  distinct 
		--SentinalEvent, se.Description , no_
        --ReOpDetails,   rp.Description ,
		CxDtls, sc.Description Compli , rp1.Description PortCompl, no_
       from OpDtls f 
	   inner join tlkp_OperationStatus os on os.Id = case when coalesce(OperationStatus, '') like '%revision%' then 1 else  0 end 
	   inner join tlkp_Procedure pro on pro.Description = case when OperationType like '%Other%' then 'Other (specify)' else OperationType end 
	   inner join tbl_PatientOperation op on op.PatientId =  f.PatID and op.OpDate =   OperationDate and 
	       f.hosp = op.Hosp  and  f.surg = op.Surg 
        and 
        (coalesce (pro.id, 100) = (case when OperationStatus like '%revision%' then coalesce(op.OpRevType, 101) else coalesce(op.OpType, 102) end)
        or 
        coalesce (OperationType, 'OperationType') = 
        (case when OperationStatus like '%revision%' then coalesce(op.OthRevType, 'OthRevType') else coalesce(op.OthPriType, 'OthPriType') end))       
       left outer join tlkp_DiabetesTreatment dt on  dt.Description = DxTreatment 
       left outer join tlkp_Complications c on c.Description = case when ReOpDetails like '%:%' then SUBSTRING(ReOpDetails, 0, charindex(':', ReOpDetails)) else ReOpDetails end  
	   left outer join tlkp_ReasonPort rp on rp.Description =   SUBSTRING(ReOpDetails, charindex(':', ReOpDetails) + 2, LEN(ReOpDetails)) 
	   left outer join tlkp_Complications sc on sc.Description = case when CxDtls like '%:%' then SUBSTRING(CxDtls, 0, charindex(':', CxDtls)) else CxDtls end  
	   left outer join tlkp_ReasonPort rp1 on rp1.Description =   SUBSTRING(CxDtls, charindex(':', CxDtls) + 2, LEN(CxDtls)) 
	   left outer join tlkp_AttemptedCalls ac on ac.Description = case when AttemptedCalls < 6 then AttemptedCalls else 5 end
       left outer join tlkp_SentinelEvent se on se.Description = SentinalEvent 
        --where   coalesce(ReOpDetails, '')  = '' and rp.Description is not  null -- reOP
        -- where   AttemptedCalls is not null and ac.Id is null  --Attempted Call
        --where  SentinalEvent is not null and  SentinalEvent <> '' and  se.Description is null
        --where CxDtls <> '' and CxDtls is not null and sc.Description is null
        --where FUWt > 999

     select * from tlkp_SentinelEvent
     /*
     SentinalEvent						Description	no_
	 Unplanned readmission to hospital	NULL				1_30
	 Unplanned readmission to hospital	NULL				2
	 Unplanned readmission to hospital	NULL				3
	 Unplanned readmission to hospital	NULL				4
     
     */
     
     update [Bariatric Procedures]  set [30d Sentinel(1)_] =  'Unplanned re-admission to hospital' where  [30d Sentinel(1)_] ='Unplanned readmission to hospital'
     update [Bariatric Procedures]  set [30d Sentinel(2)_]  =  'Unplanned re-admission to hospital' where  [30d Sentinel(2)_]  ='Unplanned readmission to hospital'
     update [Bariatric Procedures]  set [30d Sentinel(4)_]   =  'Unplanned re-admission to hospital' where  [30d Sentinel(4)_]   ='Unplanned readmission to hospital'
     
     
     
     
     select * from tlkp_Complications 
     /*
        Description				 no_	Description
		Haemorrhage NOS			1_30	NULL
		Infected Gastric Band	1_30	NULL
		Internal hernia			1_30	NULL
		Leak					1_30	NULL
		Other					1_30	NULL
		Other					3		NULL
		Port					1_30	Infection
		Port					2		Infection
		Port					4		Detached
		Wound dehiscence		2		NULL
		Wound infection			1_30	NULL
     
     */
     
    

  select distinct [YR1 Reop Reason], [YR2 Reop Reason]  from  [Bariatric Procedures]    
  
--Checking if both REOP and Seninel are given   
With OpDtls
(PatID, hosp, surg,  OperationDate,OperationType,OperationStatus, 
FUYear, FUDate, AttemptedCalls, 
SelfRptWt,FUWt, Ht, LTFU, LTFUDate, SentinalEvent, CxDtls, DiabetesSts, DxTreatment,
no_ , ReOpDetails ) as
(
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,   [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    0 FUYear , case when [30d f-up date(1)_] is null then  convert(datetime,[30d due(1)_],103)  else convert(datetime,[30d f-up date(1)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt, [30d wt(1)_] FUWt, [Height] , LTFU, convert(datetime,[Date LTFU],103)  ,  [30d Sentinel(1)_] , 
    [30d Cx details(1)_] , [Diabetes Status] DiabetesSts, [Diabetes treatment (1)] DxTreatment, '1_30' , ''			
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([30d due(1)_] is not null or [30d f-up date(1)_] is not null)
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_],[Procedure (1)_], [Procedure status (1)_], 
    1 FUYear , case when [Date of 12 mo f/up] is null then convert(datetime,[12 mo f/up due],103)   else convert(datetime,[Date of 12 mo f/up],103)  end 
     FUDate, 
    [Ph calls],[Self reported wt (1yr)_] SelfRptWt, [Weight at 12 mo f/up] FUWt, 
    [Height] , LTFU, convert(datetime,[Date LTFU],103),  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (12 mo)], [Diabetes Treatment (12 mo)] DxTreatment, '1_1' , [YR1 Reop Reason]  ReOpReason
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([Date of 12 mo f/up] is not null or [12 mo f/up due] is not null )  
       
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    2 FUYear , case when [Date of 2yr f/up] is null then [2yr f/up due] else [Date of 2yr f/up] end  FUDate, 
    [Ph calls],[Self reported wt (2yr)_]  SelfRptWt, [Weight at 2yr f/up] FUWt, 
    [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (2yr)], [Diabetes Treatment (2yr)] DxTreatment, '1_2'  , [YR2 Reop Reason]   ReOpReason
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([2yr f/up due] is not null or [Date of 2yr f/up] is not null)   
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1, [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    3 FUYear , case when convert(datetime,  [Date of 3yr f/up], 103)  is null then convert(datetime,  [3yr f/up due], 103)  else convert(datetime,  [Date of 3yr f/up], 103) end  FUDate, 
    [Ph calls],[Self reported wt (3yr)_]  SelfRptWt, [Weight at 3yr f/up] FUWt, 
    [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (3yr)], [Diabetes Treatment (3yr)] DxTreatment, '1_3' , ''ReOpReason
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and [3yr f/up due] is not null   
union  
select distinct [Pt Id] , Hospital_ID_2, Surgeon_ID_2 , [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
     0 FUYear , case when [30d f-up date(2)_]  is null then [30d due(2)_]  else [30d f-up date(2)_] end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(2)_]  FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(2)_]  , 
    [30d Cx details(2)_]  , '' DiabetesSts, '' DxTreatment, '2' , ''ReOpReason
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_] is not null  and ([30d f-up date(2)_] is not null or [30d due(2)_]  is not null)
union 
select [Pt Id] , Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_] , 103) , [Procedure (3)_] , [Procedure status (3)_], 
   0 FUYear , case when [30d f-up date(3)_]   is null then convert(datetime,  [30d due(3)_] , 103)    else convert(datetime,   [30d f-up date(3)_]  , 103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(3)_]   FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(3)_]   , 
    [30d Cx details(3)_]   , '' DiabetesSts, '' DxTreatment, '3' , ''ReOpReason
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (3)_]  is not null  and ([30d f-up date(3)_]  is not null or [30d due(3)_]   is not null)
union 
select [Pt Id] , Hospital_ID_4, Surgeon_ID_4 ,convert(datetime, [Date Revision/Reversal (4)_], 103), [Procedure (4)_], [Procedure status (4)_], 
     0 FUYear , case when [30d f-up date(4)_] is null then convert(datetime,[30d due(4)_],103)   else  convert(datetime,[30d f-up date(4)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(4)_]   FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103),  [30d Sentinel(4)_]   , 
    [30d Cx details(4)_]   , '' DiabetesSts, '' DxTreatment, '4' , ''ReOpReason
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (4)_]   is not null  and ([30d f-up date(4)_]   is not null or [30d due(4)_]    is not null)
union 
select [Pt Id] , Hospital_ID_5, Surgeon_ID_5 , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
	0 FUYear , case when [30d f-up date(5)_]    is null then convert(datetime,[30d due(5)_],103) else convert(datetime,[30d f-up date(5)_],103)   end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(5)_]    FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(5)_]    , 
    [30d Cx details(5)_]    , '' DiabetesSts, '' DxTreatment, '5' , ''ReOpReason
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (5)_]    is not null  and ([30d f-up date(5)_]    is not null or [30d due(5)_]     is not null)
     )   
select ReOpDetails, ReOpDetails
       from OpDtls f --where FUDate is not null
	   inner join tlkp_OperationStatus os on os.Id = case when coalesce(OperationStatus, '') like '%revision%' then 1 else  0 end 
	   inner join tlkp_Procedure pro on pro.Description = case when OperationType like '%Other%' then 'Other (specify)' else OperationType end 
	   inner join tbl_PatientOperation op on op.PatientId =  f.PatID and op.OpDate =   OperationDate and 
	       f.hosp = op.Hosp  and  f.surg = op.Surg 
        and 
        (coalesce (pro.id, 100) = (case when OperationStatus like '%revision%' then coalesce(op.OpRevType, 101) else coalesce(op.OpType, 102) end)
        or 
        coalesce (OperationType, 'OperationType') = 
        (case when OperationStatus like '%revision%' then coalesce(op.OthRevType, 'OthRevType') else coalesce(op.OthPriType, 'OthPriType') end))       
       left outer join tlkp_DiabetesTreatment dt on  dt.Description = DxTreatment 
       left outer join tlkp_Complications c on c.Description = case when ReOpDetails like '%:%' then SUBSTRING(ReOpDetails, 0, charindex(':', ReOpDetails)) else ReOpDetails end  
	   left outer join tlkp_ReasonPort rp on rp.Description =   SUBSTRING(ReOpDetails, charindex(':', ReOpDetails) + 2, LEN(ReOpDetails)) 
	   left outer join tlkp_Complications sc on sc.Description = case when CxDtls like '%:%' then SUBSTRING(CxDtls, 0, charindex(':', CxDtls)) else CxDtls end  
	   left outer join tlkp_ReasonPort rp1 on rp1.Description =   SUBSTRING(CxDtls, charindex(':', CxDtls) + 2, LEN(CxDtls)) 
	   left outer join tlkp_AttemptedCalls ac on ac.Description = case when AttemptedCalls < 6 then AttemptedCalls else 5 end
       left outer join tlkp_SentinelEvent se on se.Description = SentinalEvent 
       where SentinalEvent is not null and ReOpDetails is not null and  SentinalEvent <> '' and ReOpDetails <> ''
       

--Checking Count  --
With OpDtls
(PatID, hosp, surg,  OperationDate,OperationType,OperationStatus, 
FUYear, FUDate, AttemptedCalls, 
SelfRptWt,FUWt, Ht, LTFU, LTFUDate, SentinalEvent, CxDtls, DiabetesSts, DxTreatment,
no_ , ReOpDetails ) as
(
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,   [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    0 FUYear , case when [30d f-up date(1)_] is null then  convert(datetime,[30d due(1)_],103)  else convert(datetime,[30d f-up date(1)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt, [30d wt(1)_] FUWt, [Height] , LTFU, convert(datetime,[Date LTFU],103)  ,  [30d Sentinel(1)_] , 
    [30d Cx details(1)_] , [Diabetes Status] DiabetesSts, [Diabetes treatment (1)] DxTreatment, '1_30' , ''			
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and [30d f-up date(1)_] is not null)
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_],[Procedure (1)_], [Procedure status (1)_], 
    1 FUYear , case when [Date of 12 mo f/up] is null then convert(datetime,[12 mo f/up due],103)   else convert(datetime,[Date of 12 mo f/up],103)  end 
     FUDate, 
    [Ph calls],[Self reported wt (1yr)_] SelfRptWt, [Weight at 12 mo f/up] FUWt, 
    [Height] , LTFU, convert(datetime,[Date LTFU],103),  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (12 mo)], [Diabetes Treatment (12 mo)] DxTreatment, '1_1' , [YR1 Reop Reason]  ReOpReason
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([Date of 12 mo f/up] is not null)  
       
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    2 FUYear , case when [Date of 2yr f/up] is null then [2yr f/up due] else [Date of 2yr f/up] end  FUDate, 
    [Ph calls],[Self reported wt (2yr)_]  SelfRptWt, [Weight at 2yr f/up] FUWt, 
    [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (2yr)], [Diabetes Treatment (2yr)] DxTreatment, '1_2'  , [YR2 Reop Reason]   ReOpReason
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([Date of 2yr f/up] is not null)   
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1, [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    3 FUYear , case when convert(datetime,  [Date of 3yr f/up], 103)  is null then convert(datetime,  [3yr f/up due], 103)  else convert(datetime,  [Date of 3yr f/up], 103) end  FUDate, 
    [Ph calls],[Self reported wt (3yr)_]  SelfRptWt, [Weight at 3yr f/up] FUWt, 
    [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (3yr)], [Diabetes Treatment (3yr)] DxTreatment, '1_3' , ''ReOpReason
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and [Date of 3yr f/up] is not null   
union  
select distinct [Pt Id] , Hospital_ID_2, Surgeon_ID_2 , [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
     0 FUYear , case when [30d f-up date(2)_]  is null then [30d due(2)_]  else [30d f-up date(2)_] end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(2)_]  FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(2)_]  , 
    [30d Cx details(2)_]  , '' DiabetesSts, '' DxTreatment, '2' , ''ReOpReason
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_] is not null  and ([30d f-up date(2)_] is not null or [30d due(2)_]  is not null)
union 
select [Pt Id] , Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_] , 103) , [Procedure (3)_] , [Procedure status (3)_], 
   0 FUYear , case when [30d f-up date(3)_]   is null then convert(datetime,  [30d due(3)_] , 103)    else convert(datetime,   [30d f-up date(3)_]  , 103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(3)_]   FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(3)_]   , 
    [30d Cx details(3)_]   , '' DiabetesSts, '' DxTreatment, '3' , ''ReOpReason
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (3)_]  is not null  and ([30d f-up date(3)_]  is not null or [30d due(3)_]   is not null)
union 
select [Pt Id] , Hospital_ID_4, Surgeon_ID_4 ,convert(datetime, [Date Revision/Reversal (4)_], 103), [Procedure (4)_], [Procedure status (4)_], 
     0 FUYear , case when [30d f-up date(4)_] is null then convert(datetime,[30d due(4)_],103)   else  convert(datetime,[30d f-up date(4)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(4)_]   FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103),  [30d Sentinel(4)_]   , 
    [30d Cx details(4)_]   , '' DiabetesSts, '' DxTreatment, '4' , ''ReOpReason
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (4)_]   is not null  and ([30d f-up date(4)_]   is not null or [30d due(4)_]    is not null)
union 
select [Pt Id] , Hospital_ID_5, Surgeon_ID_5 , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
	0 FUYear , case when [30d f-up date(5)_]    is null then convert(datetime,[30d due(5)_],103) else convert(datetime,[30d f-up date(5)_],103)   end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(5)_]    FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(5)_]    , 
    [30d Cx details(5)_]    , '' DiabetesSts, '' DxTreatment, '5' , ''ReOpReason
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (5)_]    is not null  and ([30d f-up date(5)_]    is not null or [30d due(5)_]     is not null)
     )   
select  COUNT (*)
       from OpDtls f --where FUDate is not null
	   inner join tlkp_OperationStatus os on os.Id = case when coalesce(OperationStatus, '') like '%revision%' then 1 else  0 end 
	   inner join tlkp_Procedure pro on pro.Description = case when OperationType like '%Other%' then 'Other (specify)' else OperationType end 
	   inner join tbl_PatientOperation op on op.PatientId =  f.PatID and op.OpDate =   OperationDate and 
	       f.hosp = op.Hosp  and  f.surg = op.Surg 
        and 
        (coalesce (pro.id, 100) = (case when OperationStatus like '%revision%' then coalesce(op.OpRevType, 101) else coalesce(op.OpType, 102) end)
        or 
        coalesce (OperationType, 'OperationType') = 
        (case when OperationStatus like '%revision%' then coalesce(op.OthRevType, 'OthRevType') else coalesce(op.OthPriType, 'OthPriType') end))       
       left outer join tlkp_DiabetesTreatment dt on  dt.Description = DxTreatment 
       left outer join tlkp_Complications c on c.Description = case when ReOpDetails like '%:%' then SUBSTRING(ReOpDetails, 0, charindex(':', ReOpDetails)) else ReOpDetails end  
	   left outer join tlkp_ReasonPort rp on rp.Description =   SUBSTRING(ReOpDetails, charindex(':', ReOpDetails) + 2, LEN(ReOpDetails)) 
	   left outer join tlkp_Complications sc on sc.Description = case when CxDtls like '%:%' then SUBSTRING(CxDtls, 0, charindex(':', CxDtls)) else CxDtls end  
	   left outer join tlkp_ReasonPort rp1 on rp1.Description =   SUBSTRING(CxDtls, charindex(':', CxDtls) + 2, LEN(CxDtls)) 
	   left outer join tlkp_AttemptedCalls ac on ac.Description = case when AttemptedCalls < 6 then AttemptedCalls else 5 end
       left outer join tlkp_SentinelEvent se on se.Description = SentinalEvent 
       
       
       
       
-- Inserting follow Up for 157,446,543,591,3953
With OpDtls
(PatID, hosp, surg,  OperationDate,OperationType,OperationStatus, FUYear, FUDate, AttemptedCalls, 
SelfRptWt,FUWt, Ht, LTFU, LTFUDate, SentinalEvent, CxDtls, DiabetesSts, DxTreatment,no_ , ReOpDetails, otherInfo ) as
(
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,   [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    0 FUYear , [30d f-up date(1)_]  FUDate, 
    [Ph calls] AttemptedCalls,    
    0  SelfRptWt, [30d wt(1)_] FUWt, [Height] , LTFU, convert(datetime,[Date LTFU],103)  ,  [30d Sentinel(1)_] , 
    [30d Cx details(1)_] , [Diabetes Status] DiabetesSts, [Diabetes treatment (1)] DxTreatment, '1_30' , '' ReOpDetails, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and [30d f-up date(1)_] is null and [30d f-up date(1)_]due dat
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_],[Procedure (1)_], [Procedure status (1)_], 
    1 FUYear , [Date of 12 mo f/up]   FUDate, 
    [Ph calls] AttemptedCalls,
    [Self reported wt (1yr)_] SelfRptWt, [Weight at 12 mo f/up] FUWt, 
    [Height] , LTFU, convert(datetime,[Date LTFU],103),  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (12 mo)], [Diabetes Treatment (12 mo)] DxTreatment, '1_1' , [YR1 Reop Reason]  ReOpReason, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and [Date of 12 mo f/up] is not null       
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    2 FUYear , [Date of 2yr f/up] FUDate, 
    [Ph calls] AttemptedCalls,
    [Self reported wt (2yr)_]  SelfRptWt, [Weight at 2yr f/up] FUWt, 
    [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (2yr)], [Diabetes Treatment (2yr)] DxTreatment, '1_2'  , [YR2 Reop Reason]   ReOpReason, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and [Date of 2yr f/up] is not null
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1, [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    3 FUYear , convert(datetime,  [Date of 3yr f/up], 103)   FUDate,  
    [Ph calls] AttemptedCalls,
    [Self reported wt (3yr)_]  SelfRptWt, [Weight at 3yr f/up] FUWt, 
    [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (3yr)], [Diabetes Treatment (3yr)] DxTreatment, '1_3' , ''ReOpReason, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and convert(datetime,  [Date of 3yr f/up], 103)  is not null
union  
select distinct [Pt Id] , Hospital_ID_2, Surgeon_ID_2 , [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
     0 FUYear , [30d f-up date(2)_] FUDate, 
    [Ph calls] AttemptedCalls,0  SelfRptWt , [30d wt(2)_]  FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(2)_]  , 
    [30d Cx details(2)_]  , '' DiabetesSts, '' DxTreatment, '2' , ''ReOpReason, [Other info(2)_] 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_] is not null  and [30d f-up date(2)_] is not null
union 
select [Pt Id] , Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_] , 103) , [Procedure (3)_] , [Procedure status (3)_], 
   0 FUYear , convert(datetime,  [30d f-up date(3)_] , 103) FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(3)_]   FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(3)_]   , 
    [30d Cx details(3)_]   , '' DiabetesSts, '' DxTreatment, '3' , ''ReOpReason, [Other info(3)_] 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (3)_]  is not null  and [30d f-up date(3)_]  is not null 
union 
select [Pt Id] , Hospital_ID_4, Surgeon_ID_4 ,convert(datetime, [Date Revision/Reversal (4)_], 103), [Procedure (4)_], [Procedure status (4)_], 
     0 FUYear , convert(datetime,  [30d f-up date(4)_] , 103) FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(4)_]   FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103),  [30d Sentinel(4)_]   , 
    [30d Cx details(4)_]   , '' DiabetesSts, '' DxTreatment, '4' , ''ReOpReason, [Other info(4)_] 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (4)_]   is not null  and [30d f-up date(4)_]   is not null 
union 
select [Pt Id] , Hospital_ID_5, Surgeon_ID_5 , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
	0 FUYear , convert(datetime,  [30d f-up date(5)_]  , 103)  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(5)_]    FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(5)_]    , 
    [30d Cx details(5)_]    , '' DiabetesSts, '' DxTreatment, '5' , ''ReOpReason, [Other info(5)_] 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (5)_]    is not null  and [30d f-up date(5)_] is not null
     )  
 insert into tbl_FollowUp  
 (PatientId,OperationId,FUDate,AttmptCallId,SelfRptWt,FUVal,FUPeriodId,BSR_to_Follow_Up,BSR_to_Follow_Up_Reason,LTFU,
 LTFUDate,FUWt,FUBMI,PatientFollowUpNotKnown,SEId1,SEId2,SEId3,ReasonOther,DiabStatId,DiabRxId,ReOpStatId,FurtherInfoSlip,
 FurtherInfoPort,Othinfo,EmailSentToSurg,LastUpdatedBy,LastUpdatedDateTime,CreatedBy,CreatedDateTime)
select  
     f.PatID PatientId, opid OperationId, FUDate FUDate, ac.id AttmptCallId, SelfRptWt SelfRptWt, 
     case when FUDate < getdate() then 2 else 4 end FUVal, FUYear FUPeriodId, 
     null BSR_to_Follow_Up_Reason, null BSR_to_Follow_Up_Reason,LTFU LTFU,LTFUDate LTFUDate, 
     cast (FUWt as decimal(10,2)),case when coalesce(f.Ht, 0) = 0 then null else cast ((coalesce(FUWt, 0)/(f.Ht * f.Ht))as decimal(10,2) ) end FUBMI,          
     case when FUWt is null then 1 else 0 end PatientFollowUpNotKnown, 
     case when se.id = 1 then 1 else null end SEId1, 
     case when se.id = 2 then 1 else null end SEId2,
     case when se.id = 3 then 1 else null end SEId3, 
     case when CxDtls is null and ReOpDetails is null then null else 
          (case when CxDtls like '%Other%' then SUBSTRING(CxDtls, charindex(':', CxDtls) + 2, LEN(CxDtls)) else (case when ReOpDetails like '%Other%' then SUBSTRING(ReOpDetails, charindex(':', ReOpDetails) + 2, LEN(ReOpDetails)) else null end ) end)  end 
           ReasonOther, 
     DiabetesSts DiabStatId, dt.id DiabRxId, 
     case when (ReOpDetails is not null and ReOpDetails <> '') then 1 else 0 end  ReOpStatId, 
     case when coalesce(CxDtls, '') like 'slip%' then rs1.Id else rs.Id end FurtherInfoSlip,
	 case when coalesce(CxDtls, '') like 'port%' then rp1.Id else rp.Id end FurtherInfoPort,
	 otherInfo Othinfo,
	 null EmailSentToSurg,null LastUpdatedBy, null LastUpdatedDateTime,'ADMINISTRATOR' CreatedBy, getdate() CreatedDateTime 	 
       from OpDtls f --where FUDate is not null
	   inner join tlkp_OperationStatus os on os.Id = case when coalesce(OperationStatus, '') like '%revision%' then 1 else  0 end 
	   inner join tlkp_Procedure pro on pro.Description = case when OperationType like '%Other%' then 'Other (specify)' else OperationType end 
	   inner join tbl_PatientOperation op on op.PatientId =  f.PatID and op.OpDate =   OperationDate and 
	       f.hosp = op.Hosp  and  f.surg = op.Surg 
        and 
        (coalesce (pro.id, 100) = (case when OperationStatus like '%revision%' then coalesce(op.OpRevType, 101) else coalesce(op.OpType, 102) end)
        or 
        coalesce (OperationType, 'OperationType') = 
        (case when OperationStatus like '%revision%' then coalesce(op.OthRevType, 'OthRevType') else coalesce(op.OthPriType, 'OthPriType') end))       
       left outer join tlkp_DiabetesTreatment dt on  dt.Description = DxTreatment 
       left outer join tlkp_Complications c on c.Description = case when ReOpDetails like '%:%' then SUBSTRING(ReOpDetails, 0, charindex(':', ReOpDetails)) else ReOpDetails end  
	   left outer join tlkp_ReasonPort rp on rp.Description =   SUBSTRING(ReOpDetails, charindex(':', ReOpDetails) + 2, LEN(ReOpDetails)) 
	   left outer join tlkp_ReasonSlip rs on rs.Description =   SUBSTRING(ReOpDetails, charindex(':', ReOpDetails) + 2, LEN(ReOpDetails))
	   left outer join tlkp_Complications sc on sc.Description = case when CxDtls like '%:%' then SUBSTRING(CxDtls, 0, charindex(':', CxDtls)) else CxDtls end  
	   left outer join tlkp_ReasonPort rp1 on rp1.Description =   SUBSTRING(CxDtls, charindex(':', CxDtls) + 2, LEN(CxDtls)) 
	   left outer join tlkp_ReasonSlip rs1 on rs1.Description =   SUBSTRING(CxDtls, charindex(':', CxDtls) + 2, LEN(CxDtls))	   
	   left outer join tlkp_AttemptedCalls ac on ac.Description = case when AttemptedCalls < 6 then AttemptedCalls else 5 end
       left outer join tlkp_SentinelEvent se on se.Description = SentinalEvent              
      
--Inserting for patients 157,446,543,591,3953,
With OpDtls
(PatID, hosp, surg,  OperationDate,OperationType,OperationStatus, 
FUYear, FUDate, AttemptedCalls, 
SelfRptWt,FUWt, Ht, LTFU, LTFUDate, SentinalEvent, CxDtls, DiabetesSts, DxTreatment,
no_ , ReOpDetails, otherInfo ) as
(
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,   [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    0 FUYear , case when [30d f-up date(1)_] is null then  convert(datetime,[30d due(1)_],103)  else convert(datetime,[30d f-up date(1)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt, [30d wt(1)_] FUWt, [Height] , LTFU, convert(datetime,[Date LTFU],103)  ,  [30d Sentinel(1)_] , 
    [30d Cx details(1)_] , [Diabetes Status] DiabetesSts, [Diabetes treatment (1)] DxTreatment, '1_30' , '' ReOpDetails, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([30d due(1)_] is not null and [30d f-up date(1)_] is null)
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_],[Procedure (1)_], [Procedure status (1)_], 
    1 FUYear , case when [Date of 12 mo f/up] is null then convert(datetime,[12 mo f/up due],103)   else convert(datetime,[Date of 12 mo f/up],103)  end 
     FUDate, 
    [Ph calls],[Self reported wt (1yr)_] SelfRptWt, [Weight at 12 mo f/up] FUWt, 
    [Height] , LTFU, convert(datetime,[Date LTFU],103),  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (12 mo)], [Diabetes Treatment (12 mo)] DxTreatment, '1_1' , [YR1 Reop Reason]  ReOpReason, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([Date of 12 mo f/up] is null and [12 mo f/up due] is not null )  
       
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    2 FUYear , case when [Date of 2yr f/up] is null then [2yr f/up due] else [Date of 2yr f/up] end  FUDate, 
    [Ph calls],[Self reported wt (2yr)_]  SelfRptWt, [Weight at 2yr f/up] FUWt, 
    [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (2yr)], [Diabetes Treatment (2yr)] DxTreatment, '1_2'  , [YR2 Reop Reason]   ReOpReason, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and [2yr f/up due] is not null and [Date of 2yr f/up] is null
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1, [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    3 FUYear , case when convert(datetime,  [Date of 3yr f/up], 103)  is null then convert(datetime,  [3yr f/up due], 103)  else convert(datetime,  [Date of 3yr f/up], 103) end  FUDate, 
    [Ph calls],[Self reported wt (3yr)_]  SelfRptWt, [Weight at 3yr f/up] FUWt, 
    [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (3yr)], [Diabetes Treatment (3yr)] DxTreatment, '1_3' , ''ReOpReason, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and [3yr f/up due] is not null and    [Date of 3yr f/up] is null
union  
select distinct [Pt Id] , Hospital_ID_2, Surgeon_ID_2 , [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
     0 FUYear , case when [30d f-up date(2)_]  is null then [30d due(2)_]  else [30d f-up date(2)_] end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(2)_]  FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(2)_]  , 
    [30d Cx details(2)_]  , '' DiabetesSts, '' DxTreatment, '2' , ''ReOpReason, [Other info(2)_] 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_] is not null  and [30d f-up date(2)_] is null and [30d due(2)_]  is not null
union 
select [Pt Id] , Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_] , 103) , [Procedure (3)_] , [Procedure status (3)_], 
   0 FUYear , case when [30d f-up date(3)_]   is null then convert(datetime,  [30d due(3)_] , 103)    else convert(datetime,   [30d f-up date(3)_]  , 103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(3)_]   FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(3)_]   , 
    [30d Cx details(3)_]   , '' DiabetesSts, '' DxTreatment, '3' , ''ReOpReason, [Other info(3)_] 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (3)_]  is not null  and ([30d f-up date(3)_]  is null and [30d due(3)_]   is not null)
union 
select [Pt Id] , Hospital_ID_4, Surgeon_ID_4 ,convert(datetime, [Date Revision/Reversal (4)_], 103), [Procedure (4)_], [Procedure status (4)_], 
     0 FUYear , case when [30d f-up date(4)_] is null then convert(datetime,[30d due(4)_],103)   else  convert(datetime,[30d f-up date(4)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(4)_]   FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103),  [30d Sentinel(4)_]   , 
    [30d Cx details(4)_]   , '' DiabetesSts, '' DxTreatment, '4' , ''ReOpReason, [Other info(4)_] 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (4)_]   is not null  and ([30d f-up date(4)_]   is null and [30d due(4)_] is not null)
union 
select [Pt Id] , Hospital_ID_5, Surgeon_ID_5 , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
	0 FUYear , case when [30d f-up date(5)_]    is null then convert(datetime,[30d due(5)_],103) else convert(datetime,[30d f-up date(5)_],103)   end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(5)_]    FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(5)_]    , 
    [30d Cx details(5)_]    , '' DiabetesSts, '' DxTreatment, '5' , ''ReOpReason, [Other info(5)_] 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (5)_]    is not null  and ([30d f-up date(5)_]    is null and [30d due(5)_]  is not null)
     )  
 insert into tbl_FollowUp  
 (PatientId,OperationId,FUDate,AttmptCallId,SelfRptWt,FUVal,FUPeriodId,BSR_to_Follow_Up,BSR_to_Follow_Up_Reason,LTFU,
 LTFUDate,FUWt,FUBMI,PatientFollowUpNotKnown,SEId1,SEId2,SEId3,ReasonOther,DiabStatId,DiabRxId,ReOpStatId,FurtherInfoSlip,
 FurtherInfoPort,Othinfo,EmailSentToSurg,LastUpdatedBy,LastUpdatedDateTime,CreatedBy,CreatedDateTime)
select  
     f.PatID PatientId, opid OperationId, FUDate FUDate, ac.id AttmptCallId, SelfRptWt SelfRptWt, 
     case when FUDate < getdate() then 2 else 4 end FUVal, FUYear FUPeriodId, 
     null BSR_to_Follow_Up, null BSR_to_Follow_Up_Reason,LTFU LTFU,LTFUDate LTFUDate, 
     cast (FUWt as decimal(10,2)),case when coalesce(f.Ht, 0) = 0 then null else cast ((coalesce(FUWt, 0)/(f.Ht * f.Ht))as decimal(10,2) ) end FUBMI,          
     case when FUWt is null then 1 else 0 end PatientFollowUpNotKnown, 
     case when se.id = 1 then 1 else null end SEId1, 
     case when se.id = 2 then 1 else null end SEId2,
     case when se.id = 3 then 1 else null end SEId3, 
     case when CxDtls is null and ReOpDetails is null then null else 
          (case when CxDtls like '%Other%' then SUBSTRING(CxDtls, charindex(':', CxDtls) + 2, LEN(CxDtls)) else (case when ReOpDetails like '%Other%' then SUBSTRING(ReOpDetails, charindex(':', ReOpDetails) + 2, LEN(ReOpDetails)) else null end ) end)  end 
           ReasonOther, 
     DiabetesSts DiabStatId, dt.id DiabRxId, 
     case when (ReOpDetails is not null and ReOpDetails <> '') then 1 else 0 end  ReOpStatId, 
     case when coalesce(CxDtls, '') like 'slip%' then rs1.Id else rs.Id end FurtherInfoSlip,
	 case when coalesce(CxDtls, '') like 'port%' then rp1.Id else rp.Id end FurtherInfoPort,
	 otherInfo Othinfo,
	 null EmailSentToSurg,null LastUpdatedBy, null LastUpdatedDateTime,'ADMINISTRATOR' CreatedBy, getdate() CreatedDateTime 	 
       from OpDtls f --where FUDate is not null
	   inner join tlkp_OperationStatus os on os.Id = case when coalesce(OperationStatus, '') like '%revision%' then 1 else  0 end 
	   inner join tlkp_Procedure pro on pro.Description = case when OperationType like '%Other%' then 'Other (specify)' else OperationType end 
	   inner join tbl_PatientOperation op on op.PatientId =  f.PatID and op.OpDate =   OperationDate and 
	       f.hosp = op.Hosp  and  f.surg = op.Surg 
        and 
        (coalesce (pro.id, 100) = (case when OperationStatus like '%revision%' then coalesce(op.OpRevType, 101) else coalesce(op.OpType, 102) end)
        or 
        coalesce (OperationType, 'OperationType') = 
        (case when OperationStatus like '%revision%' then coalesce(op.OthRevType, 'OthRevType') else coalesce(op.OthPriType, 'OthPriType') end))       
       left outer join tlkp_DiabetesTreatment dt on  dt.Description = DxTreatment 
       left outer join tlkp_Complications c on c.Description = case when ReOpDetails like '%:%' then SUBSTRING(ReOpDetails, 0, charindex(':', ReOpDetails)) else ReOpDetails end  
	   left outer join tlkp_ReasonPort rp on rp.Description =   SUBSTRING(ReOpDetails, charindex(':', ReOpDetails) + 2, LEN(ReOpDetails)) 
	   left outer join tlkp_ReasonSlip rs on rs.Description =   SUBSTRING(ReOpDetails, charindex(':', ReOpDetails) + 2, LEN(ReOpDetails))
	   left outer join tlkp_Complications sc on sc.Description = case when CxDtls like '%:%' then SUBSTRING(CxDtls, 0, charindex(':', CxDtls)) else CxDtls end  
	   left outer join tlkp_ReasonPort rp1 on rp1.Description =   SUBSTRING(CxDtls, charindex(':', CxDtls) + 2, LEN(CxDtls)) 
	   left outer join tlkp_ReasonSlip rs1 on rs1.Description =   SUBSTRING(CxDtls, charindex(':', CxDtls) + 2, LEN(CxDtls))	   
	   left outer join tlkp_AttemptedCalls ac on ac.Description = case when AttemptedCalls < 6 then AttemptedCalls else 5 end
       left outer join tlkp_SentinelEvent se on se.Description = SentinalEvent              
      where f.PatID in (157,446,543,591,3953) and FUWt is not null
        
              
       
--Inserting in follow Up Complications  

--Check if complication IDS are shown everywhere - select * from tlkp_Complications

select * from tbl_PatientComplications

With OpDtls
(PatID, hosp, surg,  OperationDate,OperationType,OperationStatus, 
FUYear, FUDate, AttemptedCalls, 
SelfRptWt,FUWt, Ht, LTFU, LTFUDate, SentinalEvent, CxDtls, DiabetesSts, DxTreatment,
no_ , ReOpDetails, otherInfo ) as
(
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,   [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    0 FUYear , case when [30d f-up date(1)_] is null then  convert(datetime,[30d due(1)_],103)  else convert(datetime,[30d f-up date(1)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt, [30d wt(1)_] FUWt, [Height] , LTFU, convert(datetime,[Date LTFU],103)  ,  [30d Sentinel(1)_] , 
    [30d Cx details(1)_] , [Diabetes Status] DiabetesSts, [Diabetes treatment (1)] DxTreatment, '1_30' , '' ReOpDetails, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([30d due(1)_] is not null or [30d f-up date(1)_] is not null)
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_],[Procedure (1)_], [Procedure status (1)_], 
    1 FUYear , case when [Date of 12 mo f/up] is null then convert(datetime,[12 mo f/up due],103)   else convert(datetime,[Date of 12 mo f/up],103)  end 
     FUDate, 
    [Ph calls],[Self reported wt (1yr)_] SelfRptWt, [Weight at 12 mo f/up] FUWt, 
    [Height] , LTFU, convert(datetime,[Date LTFU],103),  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (12 mo)], [Diabetes Treatment (12 mo)] DxTreatment, '1_1' , [YR1 Reop Reason]  ReOpReason, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([Date of 12 mo f/up] is not null or [12 mo f/up due] is not null )  
       
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    2 FUYear , case when [Date of 2yr f/up] is null then [2yr f/up due] else [Date of 2yr f/up] end  FUDate, 
    [Ph calls],[Self reported wt (2yr)_]  SelfRptWt, [Weight at 2yr f/up] FUWt, 
    [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (2yr)], [Diabetes Treatment (2yr)] DxTreatment, '1_2'  , [YR2 Reop Reason]   ReOpReason, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([2yr f/up due] is not null or [Date of 2yr f/up] is not null)   
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1, [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    3 FUYear , case when convert(datetime,  [Date of 3yr f/up], 103)  is null then convert(datetime,  [3yr f/up due], 103)  else convert(datetime,  [Date of 3yr f/up], 103) end  FUDate, 
    [Ph calls],[Self reported wt (3yr)_]  SelfRptWt, [Weight at 3yr f/up] FUWt, 
    [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (3yr)], [Diabetes Treatment (3yr)] DxTreatment, '1_3' , ''ReOpReason, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and [3yr f/up due] is not null   
union  
select distinct [Pt Id] , Hospital_ID_2, Surgeon_ID_2 , [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
     0 FUYear , case when [30d f-up date(2)_]  is null then [30d due(2)_]  else [30d f-up date(2)_] end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(2)_]  FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(2)_]  , 
    [30d Cx details(2)_]  , '' DiabetesSts, '' DxTreatment, '2' , ''ReOpReason, [Other info(2)_] 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_] is not null  and ([30d f-up date(2)_] is not null or [30d due(2)_]  is not null)
union 
select [Pt Id] , Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_] , 103) , [Procedure (3)_] , [Procedure status (3)_], 
   0 FUYear , case when [30d f-up date(3)_]   is null then convert(datetime,  [30d due(3)_] , 103)    else convert(datetime,   [30d f-up date(3)_]  , 103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(3)_]   FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(3)_]   , 
    [30d Cx details(3)_]   , '' DiabetesSts, '' DxTreatment, '3' , ''ReOpReason, [Other info(3)_] 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (3)_]  is not null  and ([30d f-up date(3)_]  is not null or [30d due(3)_]   is not null)
union 
select [Pt Id] , Hospital_ID_4, Surgeon_ID_4 ,convert(datetime, [Date Revision/Reversal (4)_], 103), [Procedure (4)_], [Procedure status (4)_], 
     0 FUYear , case when [30d f-up date(4)_] is null then convert(datetime,[30d due(4)_],103)   else  convert(datetime,[30d f-up date(4)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(4)_]   FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103),  [30d Sentinel(4)_]   , 
    [30d Cx details(4)_]   , '' DiabetesSts, '' DxTreatment, '4' , ''ReOpReason, [Other info(4)_] 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (4)_]   is not null  and ([30d f-up date(4)_]   is not null or [30d due(4)_]    is not null)
union 
select [Pt Id] , Hospital_ID_5, Surgeon_ID_5 , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
	0 FUYear , case when [30d f-up date(5)_]    is null then convert(datetime,[30d due(5)_],103) else convert(datetime,[30d f-up date(5)_],103)   end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(5)_]    FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(5)_]    , 
    [30d Cx details(5)_]    , '' DiabetesSts, '' DxTreatment, '5' , ''ReOpReason, [Other info(5)_] 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (5)_]    is not null  and ([30d f-up date(5)_]    is not null or [30d due(5)_]     is not null)
     )  
  insert into tbl_PatientComplications(FuId,ComplicationId)
  select fuid,
         (case when SentinalEvent is not null and SentinalEvent <> '' then sc.id else c.id end) Comp_ID
          from OpDtls f 
  inner join tlkp_OperationStatus os on os.Id = case when coalesce(OperationStatus, '') like '%revision%' then 1 else  0 end 
	   inner join tlkp_Procedure pro on pro.Description = case when OperationType like '%Other%' then 'Other (specify)' else OperationType end 
	   inner join tbl_PatientOperation op on op.PatientId =  f.PatID and op.OpDate =   OperationDate and 
	       f.hosp = op.Hosp  and  f.surg = op.Surg 
        and 
        (coalesce (pro.id, 100) = (case when OperationStatus like '%revision%' then coalesce(op.OpRevType, 101) else coalesce(op.OpType, 102) end)
        or 
        coalesce (OperationType, 'OperationType') = 
        (case when OperationStatus like '%revision%' then coalesce(op.OthRevType, 'OthRevType') else coalesce(op.OthPriType, 'OthPriType') end))               	
   inner join tbl_FollowUp fu on fu.OperationId = op.OpId and fu.FUPeriodId = f.FUYear 
   left outer join tlkp_Complications sc on sc.Description = case when CxDtls like '%:%' then SUBSTRING(CxDtls, 0, charindex(':', CxDtls)) else CxDtls end  
   left outer join tlkp_Complications c on c.Description = case when ReOpDetails like '%:%' then SUBSTRING(ReOpDetails, 0, charindex(':', ReOpDetails)) else ReOpDetails end  	
   where --sc.id is not null or c.id is not null 
  --f.PatID = 203 
      coalesce(ReOpDetails, '') <> '' or coalesce(CxDtls, '') <> ''
      --	ReOpDetails like '%other%' or 	CxDtls like '%other%' 
       
          
      
            
--Updating ReOP     : NOT DONE WAITING FOR USER CLARIFICATION 

select f.PatientId  , f.FUPeriodId , f.FUDate , o2.OpDate, f.OperationId , o2.OpId,  * from tbl_FollowUp f 
--inner join tbl_PatientOperation o1 on OpId = OperationId and OpStat = 0 
inner join tbl_PatientOperation o2 on f.OperationId <> o2.OpId and f.PatientId = o2.PatientId 
and DATEDIFF(day,o2.OpDate,f.FUDate ) between 0 and 365 
where f.FUPeriodId > 0 and coalesce(f.ReOpStatId , 0) = 0

--update tbl_FollowUp set ReOpStatId = 1 where FUId in 
(
	select f.FUId  from tbl_FollowUp f --inner join tbl_PatientOperation o1 on OpId = OperationId and OpStat = 0 
	inner join tbl_PatientOperation o2 on f.OperationId <> o2.OpId and f.PatientId = o2.PatientId 
	and DATEDIFF(day,o2.OpDate,f.FUDate ) between 0 and 365 
	where f.FUPeriodId > 0
)
 
 -- Checking ReOP - Wrongly updated 
 
--Updating REOP

/*Begin tran 

update tbl_FollowUp set ReOpStatId = null where FUPeriodId > 2 and FUVal = 4


update tbl_FollowUp set ReOpStatId = 0 where FUPeriodId > 2 and FUVal = 2

commit*/


select distinct ReOpStatId,FUPeriodId, FUVal from tbl_FollowUp 

       
With OpDtls
(PatID, hosp, surg,  OperationDate,OperationType,OperationStatus, 
FUYear, FUDate, AttemptedCalls, 
SelfRptWt,FUWt, Ht, LTFU, LTFUDate, SentinalEvent, CxDtls, DiabetesSts, DxTreatment,
no_ , ReOpDetails, otherInfo ) as
(
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,   [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    0 FUYear , case when [30d f-up date(1)_] is null then  convert(datetime,[30d due(1)_],103)  else convert(datetime,[30d f-up date(1)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt, [30d wt(1)_] FUWt, [Height] , LTFU, convert(datetime,[Date LTFU],103)  ,  [30d Sentinel(1)_] , 
    [30d Cx details(1)_] , [Diabetes Status] DiabetesSts, [Diabetes treatment (1)] DxTreatment, '1_30' , '' ReOpDetails, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([30d due(1)_] is not null or [30d f-up date(1)_] is not null)
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_],[Procedure (1)_], [Procedure status (1)_], 
    1 FUYear , case when [Date of 12 mo f/up] is null then convert(datetime,[12 mo f/up due],103)   else convert(datetime,[Date of 12 mo f/up],103)  end 
     FUDate, 
    [Ph calls],[Self reported wt (1yr)_] SelfRptWt, [Weight at 12 mo f/up] FUWt, 
    [Height] , LTFU, convert(datetime,[Date LTFU],103),  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (12 mo)], [Diabetes Treatment (12 mo)] DxTreatment, '1_1' , [YR1 Reop Reason]  ReOpReason, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([Date of 12 mo f/up] is not null or [12 mo f/up due] is not null )  
       
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    2 FUYear , case when [Date of 2yr f/up] is null then [2yr f/up due] else [Date of 2yr f/up] end  FUDate, 
    [Ph calls],[Self reported wt (2yr)_]  SelfRptWt, [Weight at 2yr f/up] FUWt, 
    [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (2yr)], [Diabetes Treatment (2yr)] DxTreatment, '1_2'  , [YR2 Reop Reason]   ReOpReason, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([2yr f/up due] is not null or [Date of 2yr f/up] is not null)   
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1, [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    3 FUYear , case when convert(datetime,  [Date of 3yr f/up], 103)  is null then convert(datetime,  [3yr f/up due], 103)  else convert(datetime,  [Date of 3yr f/up], 103) end  FUDate, 
    [Ph calls],[Self reported wt (3yr)_]  SelfRptWt, [Weight at 3yr f/up] FUWt, 
    [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (3yr)], [Diabetes Treatment (3yr)] DxTreatment, '1_3' , ''ReOpReason, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and [3yr f/up due] is not null   
union  
select distinct [Pt Id] , Hospital_ID_2, Surgeon_ID_2 , [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
     0 FUYear , case when [30d f-up date(2)_]  is null then [30d due(2)_]  else [30d f-up date(2)_] end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(2)_]  FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(2)_]  , 
    [30d Cx details(2)_]  , '' DiabetesSts, '' DxTreatment, '2' , ''ReOpReason, [Other info(2)_] 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_] is not null  and ([30d f-up date(2)_] is not null or [30d due(2)_]  is not null)
union 
select [Pt Id] , Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_] , 103) , [Procedure (3)_] , [Procedure status (3)_], 
   0 FUYear , case when [30d f-up date(3)_]   is null then convert(datetime,  [30d due(3)_] , 103)    else convert(datetime,   [30d f-up date(3)_]  , 103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(3)_]   FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(3)_]   , 
    [30d Cx details(3)_]   , '' DiabetesSts, '' DxTreatment, '3' , ''ReOpReason, [Other info(3)_] 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (3)_]  is not null  and ([30d f-up date(3)_]  is not null or [30d due(3)_]   is not null)
union 
select [Pt Id] , Hospital_ID_4, Surgeon_ID_4 ,convert(datetime, [Date Revision/Reversal (4)_], 103), [Procedure (4)_], [Procedure status (4)_], 
     0 FUYear , case when [30d f-up date(4)_] is null then convert(datetime,[30d due(4)_],103)   else  convert(datetime,[30d f-up date(4)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(4)_]   FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103),  [30d Sentinel(4)_]   , 
    [30d Cx details(4)_]   , '' DiabetesSts, '' DxTreatment, '4' , ''ReOpReason, [Other info(4)_] 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (4)_]   is not null  and ([30d f-up date(4)_]   is not null or [30d due(4)_]    is not null)
union 
select [Pt Id] , Hospital_ID_5, Surgeon_ID_5 , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
	0 FUYear , case when [30d f-up date(5)_]    is null then convert(datetime,[30d due(5)_],103) else convert(datetime,[30d f-up date(5)_],103)   end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(5)_]    FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(5)_]    , 
    [30d Cx details(5)_]    , '' DiabetesSts, '' DxTreatment, '5' , ''ReOpReason, [Other info(5)_] 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (5)_]    is not null  and ([30d f-up date(5)_]    is not null or [30d due(5)_]     is not null)
     )  
  select fu.FUId ,ReOpDetails, fu.ReOpStatId --into temp1
          from OpDtls f 
  inner join tlkp_OperationStatus os on os.Id = case when coalesce(OperationStatus, '') like '%revision%' then 1 else  0 end 
	   inner join tlkp_Procedure pro on pro.Description = case when OperationType like '%Other%' then 'Other (specify)' else OperationType end 
	   inner join tbl_PatientOperation op on op.PatientId =  f.PatID and op.OpDate =   OperationDate and 
	       f.hosp = op.Hosp  and  f.surg = op.Surg 
        and 
        (coalesce (pro.id, 100) = (case when OperationStatus like '%revision%' then coalesce(op.OpRevType, 101) else coalesce(op.OpType, 102) end)
        or 
        coalesce (OperationType, 'OperationType') = 
        (case when OperationStatus like '%revision%' then coalesce(op.OthRevType, 'OthRevType') else coalesce(op.OthPriType, 'OthPriType') end))               	
   inner join tbl_FollowUp fu on fu.OperationId = op.OpId and fu.FUPeriodId = f.FUYear 
   where coalesce(ReOpDetails, '') = '' and fu.ReOpStatId = 1
       
 
 

--Finding out how many had reoP 
With OpDtls
(PatID, hosp, surg,  OperationDate,OperationType,OperationStatus, 
FUYear, FUDate, AttemptedCalls, 
SelfRptWt,FUWt, Ht, LTFU, LTFUDate, SentinalEvent, CxDtls, DiabetesSts, DxTreatment,
no_ , ReOpDetails, otherInfo ) as
(
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,   [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    0 FUYear , case when [30d f-up date(1)_] is null then  convert(datetime,[30d due(1)_],103)  else convert(datetime,[30d f-up date(1)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt, [30d wt(1)_] FUWt, [Height] , LTFU, convert(datetime,[Date LTFU],103)  ,  [30d Sentinel(1)_] , 
    [30d Cx details(1)_] , [Diabetes Status] DiabetesSts, [Diabetes treatment (1)] DxTreatment, '1_30' , '' ReOpDetails, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([30d due(1)_] is not null or [30d f-up date(1)_] is not null)
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_],[Procedure (1)_], [Procedure status (1)_], 
    1 FUYear , case when [Date of 12 mo f/up] is null then convert(datetime,[12 mo f/up due],103)   else convert(datetime,[Date of 12 mo f/up],103)  end 
     FUDate, 
    [Ph calls],[Self reported wt (1yr)_] SelfRptWt, [Weight at 12 mo f/up] FUWt, 
    [Height] , LTFU, convert(datetime,[Date LTFU],103),  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (12 mo)], [Diabetes Treatment (12 mo)] DxTreatment, '1_1' , [YR1 Reop Reason]  ReOpReason, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([Date of 12 mo f/up] is not null or [12 mo f/up due] is not null )  
       
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1,[Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    2 FUYear , case when [Date of 2yr f/up] is null then [2yr f/up due] else [Date of 2yr f/up] end  FUDate, 
    [Ph calls],[Self reported wt (2yr)_]  SelfRptWt, [Weight at 2yr f/up] FUWt, 
    [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (2yr)], [Diabetes Treatment (2yr)] DxTreatment, '1_2'  , [YR2 Reop Reason]   ReOpReason, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Procedure date (1)_] is not null and ([2yr f/up due] is not null or [Date of 2yr f/up] is not null)   
union
select [Pt Id] , Hospital_ID_1, Surgeon_ID_1, [Procedure date (1)_], [Procedure (1)_], [Procedure status (1)_], 
    3 FUYear , case when convert(datetime,  [Date of 3yr f/up], 103)  is null then convert(datetime,  [3yr f/up due], 103)  else convert(datetime,  [Date of 3yr f/up], 103) end  FUDate, 
    [Ph calls],[Self reported wt (3yr)_]  SelfRptWt, [Weight at 3yr f/up] FUWt, 
    [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  ''  SentinalEvent, 
    ''  CxDtls, [Diab Status (3yr)], [Diabetes Treatment (3yr)] DxTreatment, '1_3' , ''ReOpReason, [Other info (1)_] 
    from  [Bariatric Procedures] 
    where [Hospital (1)_] is not null and [3yr f/up due] is not null   
union  
select distinct [Pt Id] , Hospital_ID_2, Surgeon_ID_2 , [Date Revision/Reversal (2)_], [Procedure (2)_], [Procedure status (2)_], 
     0 FUYear , case when [30d f-up date(2)_]  is null then [30d due(2)_]  else [30d f-up date(2)_] end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(2)_]  FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(2)_]  , 
    [30d Cx details(2)_]  , '' DiabetesSts, '' DxTreatment, '2' , ''ReOpReason, [Other info(2)_] 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (2)_] is not null  and ([30d f-up date(2)_] is not null or [30d due(2)_]  is not null)
union 
select [Pt Id] , Hospital_ID_3, Surgeon_ID_3 ,convert(datetime, [Date Revision/Reversal (3)_] , 103) , [Procedure (3)_] , [Procedure status (3)_], 
   0 FUYear , case when [30d f-up date(3)_]   is null then convert(datetime,  [30d due(3)_] , 103)    else convert(datetime,   [30d f-up date(3)_]  , 103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(3)_]   FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(3)_]   , 
    [30d Cx details(3)_]   , '' DiabetesSts, '' DxTreatment, '3' , ''ReOpReason, [Other info(3)_] 
     from  [Bariatric Procedures] 
     where [Date Revision/Reversal (3)_]  is not null  and ([30d f-up date(3)_]  is not null or [30d due(3)_]   is not null)
union 
select [Pt Id] , Hospital_ID_4, Surgeon_ID_4 ,convert(datetime, [Date Revision/Reversal (4)_], 103), [Procedure (4)_], [Procedure status (4)_], 
     0 FUYear , case when [30d f-up date(4)_] is null then convert(datetime,[30d due(4)_],103)   else  convert(datetime,[30d f-up date(4)_],103) end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(4)_]   FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103),  [30d Sentinel(4)_]   , 
    [30d Cx details(4)_]   , '' DiabetesSts, '' DxTreatment, '4' , ''ReOpReason, [Other info(4)_] 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (4)_]   is not null  and ([30d f-up date(4)_]   is not null or [30d due(4)_]    is not null)
union 
select [Pt Id] , Hospital_ID_5, Surgeon_ID_5 , convert(datetime, [Date Revision/Reversal (5)_] , 103), [Procedure (5)_], [Procedure status (5)_], 
	0 FUYear , case when [30d f-up date(5)_]    is null then convert(datetime,[30d due(5)_],103) else convert(datetime,[30d f-up date(5)_],103)   end  FUDate, 
    [Ph calls],0  SelfRptWt , [30d wt(5)_]    FUWt, [Height] , LTFU, convert(datetime,  [Date LTFU] , 103) ,  [30d Sentinel(5)_]    , 
    [30d Cx details(5)_]    , '' DiabetesSts, '' DxTreatment, '5' , ''ReOpReason, [Other info(5)_] 
     from  [Bariatric Procedures] 
     where  [Date Revision/Reversal (5)_]    is not null  and ([30d f-up date(5)_]    is not null or [30d due(5)_]     is not null)
     )  
         
         select COUNT(*) from OpDtls f 
  inner join tlkp_OperationStatus os on os.Id = case when coalesce(OperationStatus, '') like '%revision%' then 1 else  0 end 
	   inner join tlkp_Procedure pro on pro.Description = case when OperationType like '%Other%' then 'Other (specify)' else OperationType end 
	   inner join tbl_PatientOperation op on op.PatientId =  f.PatID and op.OpDate =   OperationDate and 
	       f.hosp = op.Hosp  and  f.surg = op.Surg 
        and 
        (coalesce (pro.id, 100) = (case when OperationStatus like '%revision%' then coalesce(op.OpRevType, 101) else coalesce(op.OpType, 102) end)
        or 
        coalesce (OperationType, 'OperationType') = 
        (case when OperationStatus like '%revision%' then coalesce(op.OthRevType, 'OthRevType') else coalesce(op.OthPriType, 'OthPriType') end))               	
   inner join tbl_FollowUp fu on fu.OperationId = op.OpId and fu.FUPeriodId = f.FUYear 
   where coalesce(ReOpDetails, '') <> ''
            
     select count(*) from tbl_FollowUp where         ReOpStatId = 1
  
 
 
 	/*------------------------Finished----------------------------*/ 
 	
update tbl_User set FName = UPPER([FName]), LastName= UPPER(LastName);

update tbl_Patient set HomePh =replace(HomePh, ' ', '') where HomePh is not null

update tbl_Patient set MobPh =replace(MobPh, ' ', '') where MobPh is not null

update tbl_FollowUp set PatientFollowUpNotKnown = null where FUVal <> 2

select PatientId, MAX(FUPeriodId ) max_FUPeriodId into temp2 from tbl_FollowUp where FUVal = 2 group by PatientId

select * from temp2 --3098

select COUNT(*) from tbl_FollowUp

select 3098 + 1722

select * into temp_followUp from tbl_FollowUp


select COUNT(*) from tbl_FollowUp  where cast(PatientId as varchar(10)) + 'P' + cast(FUPeriodId as varchar(2)) not in 
(select cast(PatientId as varchar(10)) + 'P' + cast(max_FUPeriodId as varchar(2)) from temp2 )

select COUNT(*) from tbl_FollowUp  where cast(PatientId as varchar(10)) + 'P' + cast(FUPeriodId as varchar(2)) in 
(select cast(PatientId as varchar(10)) + 'P' + cast(max_FUPeriodId as varchar(2)) from temp2 )

select 3180 + 1722

update tbl_FollowUp set AttmptCallId = (select AttmptCallId from temp_followUp where temp_followUp.FUId = tbl_FollowUp.FUId  )



begin tran t1 

select * from tbl_FollowUp  where cast(PatientId as varchar(10)) + 'P' + cast(FUPeriodId as varchar(2)) not in 
(select cast(PatientId as varchar(10)) + 'P' + cast(max_FUPeriodId as varchar(2)) from temp2 )



update tbl_FollowUp set AttmptCallId =null where cast(PatientId as varchar(10)) + 'P' + cast(FUPeriodId as varchar(2)) not in 
(select cast(PatientId as varchar(10)) + 'P' + cast(max_FUPeriodId as varchar(2)) from temp2 )


commit


select * from tbl_FollowUp where FUVal <> 2

select FUPeriodId,  * from tbl_FollowUp order by PatientId 



exec usp_CreateFollowUps





 	
 	
 	/**/
 	
 	select * from temp_UpdateOperations_WithTypeNull  
 	select * from tlkp_Procedure 
 	
 	
 	select * from tbl_PatientOperation where patientid in (  2227,2441,3838,3935,4021,4067,4203,4205,4206,4207 ) --- Operations with operation type as null
 	
 	
	
	select * from temp_UpdateOperations_WithStatusNull  --Operations with status null
	
	select * from tbl_PatientOperation where patientid in(	3935,4021,4067,4203,4205,4206,4207)

select * from tlkp_OperationStatus 


select URNo , * from tbl_PatientOperation o left outer join tbl_URN u on u.PatientID = o.PatientId  where o.patientid in(	3935,4021,4067,4203,4205,4206,4207)



select URNo , * from tbl_PatientOperation o left outer join tbl_URN u on u.PatientID = o.PatientId 
inner join tbl_PatientOperationDeviceDtls opd on opd.PatientOperationId = o.OpId  
 where --o.patientid in(	3935,4021,4067,4203,4205,4206,4207)
 opd.DevId is not null
order by o.PatientId , o.OpId 




select URNo , FUPeriodId , * from tbl_PatientOperation o left outer join tbl_URN u on u.PatientID = o.PatientId 
inner join tbl_FollowUp f on f.OperationId = o.OpId 
 where o.patientid in(139)
      f.ReOpStatId = 1
order by o.PatientId , o.OpId 

select --URNo , FUPeriodId , 
COUNT(*) from tbl_PatientOperation o left outer join tbl_URN u on u.PatientID = o.PatientId 
inner join tbl_FollowUp f on f.OperationId = o.OpId 
 where f.SEId1 = 1 or f.SEId2 = 1 or f.SEId3 = 1
--order by o.PatientId , o.OpId 

--109 

select 85 + 14 + 8 + 1  



select * from tbl_FollowUp where fuid = 7683



select * from tbl_FollowUp where and FUPeriodId = 3


select * from [Bariatric Procedures] where [Pt Id] = 1350



select * from tbl_Patient where PatId = 214 

update tbl_Patient set LastName ='Veliz', FName ='V' where PatId = 93 
update tbl_Patient set LastName ='Adams', FName ='S' where PatId = 214 


McareNo
3133639666


--Check the names 
PatID	Last name			FirstName	LastName
8	OPT OFF				PT OF	
19	OPT OFF				PT OF	
93	OPT OFF (Veliz, V)		V		VELIZ, V)
214	OPT OFF (Adams, S)		S		ADAMS, S)


select * from tbl_Patient where PatId = 196

select URNo , FUPeriodId , * from tbl_PatientOperation o left outer join tbl_URN u on u.PatientID = o.PatientId 
inner join tbl_FollowUp f on f.OperationId = o.OpId 
 where o.PatientId in 
 (75,141,154,366,529,709, 2209,2398)
 
select URNo, * from tbl_PatientOperation o left outer join tbl_URN u on u.PatientID = o.PatientId 
 where o.PatientId in 
 (75,141,154,366,529,709, 2209,2398)


 
 select * from tbl_patient where patid = 196
 
 select * from tlkp_OptOffStatus 
 
 /*
Id	Description
0	Consented
1	Yes (Total Opt Off)
2	Yes (Partial Opt Off)
3	Unconsented
4	LTFU
 
 */
 select * --into temp_OptOff 
 from tbl_Patient where OptOffStatId =4
 
 begin tran t1 
 
 update tbl_Patient set FName = (select temp_OptOff.LastName from temp_OptOff where temp_OptOff.Patid = tbl_Patient.PatId ), 
 LastName = (select temp_OptOff.FName from temp_OptOff where temp_OptOff.Patid = tbl_Patient.PatId )
  where OptOffStatId = 0
 
 commit
 
 select * from tbl_PatientOperation where [PatientId] = 576 
 
 
 select * from [Bariatric Procedures]  where [Pt Id]  = 576 
 
 
 select * from tbl_PatientOperationDeviceDtls where DevLotNo ='17191158'
 
 
 select * from tbl_PatientOperationDeviceDtls where DevLotNo ='17191158'
 
 
 select * from tbl_Device where DeviceModel ='B-20304'
 
 
 select * from tbl_User 


select * from tbl_Site 
/*
SiteId	HPIO	SiteName
46	NULL	St Vincent's Private
47	NULL	The Alfred

*/

select URNo , FUDate,  FUPeriodId , * from tbl_PatientOperation o left outer join tbl_URN u on u.PatientID = o.PatientId  and u.HospitalID = o.Hosp 
inner join tbl_FollowUp f on f.OperationId = o.OpId 
where o.PatientId  = 419
 
 

select * from tbl_PatientOperation where PatientId in (2376,2794,2963,3040)
 
select * from tbl_PatientOperation where DiabStat = 1
 
 
select PatientId pat_1 , MAX(DiabStat ) DiabStat_max , MAX(DiabRx) DiabRx_max into temp4
 from tbl_PatientOperation group by PatientId
 having MAX(DiabStat ) = 1
  
 
 
select * from tbl_PatientOperation 
 where PatientId in (select pat_1 from temp4 )
 --476
 
 select * from tbl_PatientOperation 
 where PatientId in
 (
 select PatientId from tbl_PatientOperation group by PatientId 
 having COUNT(*) > 1
 ) and PatientId  in 
 (select distinct PatientId from tbl_PatientOperation where DiabStat =1 )
 
--409 


select PatientId temp4_PatientId,DiabRx temp4_DiabRx --into temp4 
from tbl_PatientOperation where DiabStat =1 


 select PatientId, COUNT(*) from tbl_PatientOperation 
 where PatientId in
 ( select temp4_PatientId from temp4 )
 group by PatientId
  having COUNT(*) > 1
 --476 
 

 begin tran t1 
 
 update tbl_PatientOperation 
 set DiabRx = (select temp4_DiabRx from temp4 where temp4_PatientId =PatientId), DiabStat = 1 
 where PatientId in (select temp4_PatientId from temp4 )

commit 
 
 rollback
 --drop table temp4 
 
 --select * into backupOP from tbl_PatientOperation
 
 select * from tlkp_OptOffStatus 
 /*
Id	Description
0	Consented
1	Yes (Total Opt Off)
2	Yes (Partial Opt Off)
3	Unconsented
4	LTFU
 
 */
 
 select * from tbl_Patient where OptOffStatId =1
 
 
 select * from tbl_Site 
 
 select * into bck_patient from tbl_Patient 
 
 
 select * from tbl_Patient  where OptOffStatId =1 and PriSiteId is null
 
 
 update tbl_Patient set PriSiteId = 51  where OptOffStatId =1 and PriSiteId is null
 
 
insert into tbl_urn (PatientID,HospitalID,URNo)
select distinct PatID, PriSiteId, 'OPTOFF' + cast(Patid as varchar(50)) from tbl_Patient  where OptOffStatId =1 and PriSiteId = 51
      
 
 
 select temp4_PatientId, COUNT(*) from temp4group by temp4_PatientId having count(*) > 1
 
 select count (*) from tbl_FollowUp where FUPeriodId = 0 --3286
 
 select 5 + 3096 + 156 + 21 + 7
 
 
 
 select patientid, OperationId , count (*) from tbl_FollowUp where FUPeriodId = 0 --3286
 group by patientid, OperationId
 