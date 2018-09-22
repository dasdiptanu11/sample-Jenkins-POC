
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_Missing_DataList]    Script Date: 09/26/2016 09:41:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufn_Missing_DataList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ufn_Missing_DataList]
GO


GO

/****** Object:  UserDefinedFunction [dbo].[ufn_Missing_DataList]    Script Date: 09/26/2016 09:41:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--SELECT     r.ApplicationId, r.RoleId, r.RoleName, r.LoweredRoleName, r.Description, u.UserId, u.UId, u.TitleId, u.FName, u.LastName, u.RoleId AS Expr1, u.CountryId, u.StateId, 
--                      u.SiteAccessSiteId, u.[HPI-I], u.Email, u.NoNotificationEmail, u.AccountStatusActive, u.AccountStatusLocked, u.LastUpdatedBy, u.LastUpdatedDateTime, u.CreatedBy, 
--                      u.CreatedDateTime
--FROM         dbo.tbl_User AS u INNER JOIN
--                      dbo.aspnet_Users AS au ON u.UId = au.UserId INNER JOIN
--                      dbo.aspnet_Roles AS r ON r.ApplicationId = au.ApplicationId INNER JOIN
--                      dbo.aspnet_UsersInRoles AS ur ON ur.UserId = au.UserId AND r.RoleId = ur.RoleId
--WHERE     (r.RoleName IN ('ADMINREGISTRY', 'ADMINCENTRAL')) AND (u.UserId = 165)

                 

--165 admin
--select * from [ufn_Missing_DataList](-1, -1, 0, -1, '01/01/1940', '01/01/2017')
--select * from [ufn_Missing_DataList](-1, -1, null, -1, '01/01/1940', '01/01/2017')

--select * from [ufn_Missing_DataList](-1, -1, 4, -1, '01/01/1940', '01/01/2017')

--select * from [ufn_Missing_DataList](-1, -1, 2, -1, '01/01/1940', '01/01/2017')

--select * from [ufn_Missing_DataList](-1, -1, -1, -1, '01/01/1940', '01/01/2017')

--select * from [ufn_Missing_DataList](-1, -1, 85, -1, null, null)

--select * from [ufn_Missing_DataList](-1, -1, 165, -1, '01/01/1940', '01/01/2017')

--Site list
--select * from [ufn_Missing_DataList](-1, -1, null, null, '01/01/1940', '01/01/2017')




CREATE FUNCTION [dbo].[ufn_Missing_DataList]
(	
	@pCountryId int,
	@pOpStat int, 
	@pSurgeonId int, 
	@pSiteId int, 
	@pOpDateFrom DateTime, --Uses mm/dd/yyyy format
	@pOpDateTo DateTime   --Uses mm/dd/yyyy format 	
)
RETURNS 
@MissingDataTable TABLE 
(	
	FollowUpPeriodID int not null,
	OperationID int not null, 
	Patient_ID int not null, 
	Patient_FName VARCHAR(100) not null, 
	Patient_LastName VARCHAR(100) not null,
	Patient_Gender VARCHAR(100) not null,
	Operation_Date datetime,
	Surgeon VARCHAR(100) not null,
	Hospital VARCHAR(100) not null,	
	Op_Form_Status VARCHAR(100) not null,
	Day_30 VARCHAR(50) not null,
	Year_1 VARCHAR(50) not null,
	Year_2 VARCHAR(50) not null,
	Year_3 VARCHAR(50) not null,
	Year_4 VARCHAR(50) not null,
	Year_5 VARCHAR(50) not null,
	Year_6 VARCHAR(50) not null,
	Year_7 VARCHAR(50) not null,
	Year_8 VARCHAR(50) not null,
	Year_9 VARCHAR(50) not null,
	Year_10 VARCHAR(50) not null
)
AS
BEGIN
		
		declare @DftDate datetime
	    set @DftDate = '01/01/1940';
	  
	
		 	     
		With FollowUp(PatientId,OperationId,Day_30 , Year_1 ,Year_2 ,Year_3 , Year_4 ,Year_5 ,Year_6 ,Year_7 ,Year_8 ,Year_9 ,Year_10  ) 
		as
		(SELECT * FROM ( 
			SELECT  fu.PatientId , fu.OperationId , fu.FUPeriodId  PeriodID, ff.Description Descrip 
			        from tbl_FollowUp fu 
			              inner join tlkp_FollowUp_FUVal ff on case when fu.FUVal = 5 then 2 else fu.FUVal end = ff.id) as s
		PIVOT(max(Descrip)	FOR  PeriodID IN ([0],[1], [2], [3], [4], [5], [6], [7], [8], [9], [10]))AS pvt
		)
		insert into @MissingDataTable
		select 	0  FollowUpID, fu.OperationID, fu.PatientId,  
				p.FName Patient_FName , p.LastName Patient_LastName , 
				coalesce(g.Description, 'Not known') Patient_Gender , po.OpDate Operation_Date, 
				(rtrim(tt.Description) + ' ' + u.FName + ' ' + u.LastName) Surgeon, ts.SiteName ,
				case when coalesce(po.Opval, 0) = 2 then 'Completed' else 'Incomplete' end Op_Form_Status , 
				coalesce(Day_30,'Not Applicable') Day_30 , coalesce(Year_1,'Not Applicable') Year_1 , coalesce(Year_2,'Not Applicable') Year_2 , 
				coalesce(Year_3,'Not Applicable') Year_3 , coalesce(Year_4,'Not Applicable') Year_4 ,coalesce(Year_5,'Not Applicable') Year_5 ,
				coalesce(Year_6,'Not Applicable') Year_6 , coalesce(Year_7,'Not Applicable') Year_7 , coalesce(Year_8,'Not Applicable') Year_8 , 
				coalesce(Year_9,'Not Applicable') Year_9 , coalesce(Year_10,'Not Applicable') Year_10
		from FollowUp fu
			inner join tbl_PatientOperation po on fu.OperationId  = po.OpId  
			inner join tbl_Patient p on p.PatId = po.PatientId 
			left outer join tlkp_Gender g on p.GenderId = g.Id 
			inner join tbl_Site ts on po.Hosp = ts.SiteId
			inner join  tbl_User u on u.UserId = case when po.OpStat = 1 then po.Surg else p.PriSurgId end
			inner join tlkp_Title tt on u.TitleId = tt.Id 
			inner join  aspnet_Users au on u.UId = au.UserId
		where 
		   CONVERT(datetime, OpDate, 103) >= case when @pOpDateFrom <> @DftDate then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, OpDate, 103) end
		   and CONVERT(datetime, OpDate, 103) <= case when @pOpDateTo <> @DftDate then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, OpDate, 103) end
		   and p.CountryId = case when @pCountryId <> -1 then @pCountryId else p.CountryId  end
		   and SiteId  = case when @pSiteId <> -1 then @pSiteId else SiteId end
		   and po.OpStat  = case when @pOpStat <> -1 then @pOpStat else po.OpStat end		
		   --and u.UserId  = case when @pSurgeonId <> -1  then @pSurgeonId else u.UserId end		
		   and u.UserId  = Case when (SELECT     COUNT(r.RoleName) AS UserCount
FROM         dbo.tbl_User AS u INNER JOIN
                      dbo.aspnet_Users AS au ON u.UId = au.UserId INNER JOIN
                      dbo.aspnet_Roles AS r ON r.ApplicationId = au.ApplicationId INNER JOIN
                      dbo.aspnet_UsersInRoles AS ur ON ur.UserId = au.UserId AND r.RoleId = ur.RoleId
WHERE     (r.RoleName IN ('ADMINREGISTRY', 'ADMINCENTRAL')) AND (u.UserId = @pSurgeonId))>0 THEN u.UserId ELSE @pSurgeonId END

		   
		   
--(Select r.RoleName from tbl_User u inner join dbo.aspnet_Users au
--on u.UId = au.UserId inner join dbo.aspnet_Roles r on r.ApplicationId = au.ApplicationId 
--where r.RoleName IN( 'ADMINREGISTRY','ADMINCENTRAL') AND u.UserId=@pSurgeonId)

--SELECT     COUNT(r.RoleName) AS UserCount
--FROM         dbo.tbl_User AS u INNER JOIN
--                      dbo.aspnet_Users AS au ON u.UId = au.UserId INNER JOIN
--                      dbo.aspnet_Roles AS r ON r.ApplicationId = au.ApplicationId INNER JOIN
--                      dbo.aspnet_UsersInRoles AS ur ON ur.UserId = au.UserId AND r.RoleId = ur.RoleId
--WHERE     (r.RoleName IN ('ADMINREGISTRY', 'ADMINCENTRAL')) AND (u.UserId = 4)

--SELECT     *
--FROM         dbo.tbl_User AS u INNER JOIN
--                      dbo.aspnet_Users AS au ON u.UId = au.UserId INNER JOIN
--                      dbo.aspnet_Roles AS r ON r.ApplicationId = au.ApplicationId INNER JOIN
--                      dbo.aspnet_UsersInRoles AS ur ON ur.UserId = au.UserId AND r.RoleId = ur.RoleId
--WHERE     (u.UserId = 85)


       
RETURN 
END






GO


