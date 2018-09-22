
ALTER FUNCTION [dbo].[ufn_Missing_DataList]
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
	
	DECLARE
@Staging TABLE 
(	
	FollowUpPeriodID int not null,
	OperationID int not null, 
	
	Patient_FName VARCHAR(100) not null, 
	Patient_LastName VARCHAR(100) not null,
	Patient_Gender VARCHAR(100) not null,
	Operation_Date datetime,
	Surgeon VARCHAR(100) not null,
	Hospital VARCHAR(100) not null,	
	Op_Form_Status VARCHAR(100) not null
	
	)	
		declare @DftDate datetime
	    set @DftDate = '01/01/1940';
	
		insert into  @Staging
		select 	0  FollowUpID, 
		 PO.OpId,
				p.FName Patient_FName , p.LastName Patient_LastName , 
				coalesce(g.Description, 'Not known') Patient_Gender , po.OpDate Operation_Date, 
				(rtrim(tt.Description) + ' ' + u.FName + ' ' + u.LastName) Surgeon, ts.SiteName ,
				case when coalesce(po.Opval, 0) = 2 then 'Completed' else 'Incomplete' end Op_Form_Status --, 
				
				
				
		from tbl_PatientOperation po  
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
		   
		   and u.UserId  = Case when (SELECT     COUNT(r.RoleName) AS UserCount
FROM         dbo.tbl_User AS u INNER JOIN
                      dbo.aspnet_Users AS au ON u.UId = au.UserId INNER JOIN
                      dbo.aspnet_Roles AS r ON r.ApplicationId = au.ApplicationId INNER JOIN
                      dbo.aspnet_UsersInRoles AS ur ON ur.UserId = au.UserId AND r.RoleId = ur.RoleId
WHERE     (r.RoleName IN ('ADMINREGISTRY', 'ADMINCENTRAL','DATACOLLECTOR')) AND (u.UserId = @pSurgeonId))>0 THEN u.UserId ELSE @pSurgeonId END



insert into @MissingDataTable
		SELECT 
		R.FollowUpPeriodID
		, r.OperationID
		, fu.PatientId
		, R.Patient_FName
		, R.Patient_LastName
		, R.Patient_Gender
		, R.Operation_Date
		, R.Surgeon
		, R.Hospital
		, R.Op_Form_Status
		, 
		coalesce(Day_30,'Not Applicable') Day_30 , coalesce(Year_1,'Not Applicable') Year_1 , coalesce(Year_2,'Not Applicable') Year_2 , 
				coalesce(Year_3,'Not Applicable') Year_3 , coalesce(Year_4,'Not Applicable') Year_4 ,coalesce(Year_5,'Not Applicable') Year_5 ,
				coalesce(Year_6,'Not Applicable') Year_6 , coalesce(Year_7,'Not Applicable') Year_7 , coalesce(Year_8,'Not Applicable') Year_8 , 
				coalesce(Year_9,'Not Applicable') Year_9 , coalesce(Year_10,'Not Applicable') Year_10
		FROM @Staging R
		cross apply (
			SELECT PatientId,OperationId, [0] as Day_30 , [1] as Year_1 ,[2] as Year_2 , [3] as Year_3 ,[4] as Year_4 , [5] as Year_5 ,[6] as Year_6 , [7] as Year_7 , [8] as Year_8 , [9] as Year_9 , [10] as Year_10   
			FROM ( 
			SELECT  fu.PatientId , fu.OperationId , fu.FUPeriodId  PeriodID, ff.Description Descrip 
			        from tbl_FollowUp fu 
			              inner join tlkp_FollowUp_FUVal ff on case when fu.FUVal = 5 then 2 else fu.FUVal end = ff.id
						  where fu.OperationId = R.OperationId
						  ) as s
			PIVOT(max(Descrip)	FOR  PeriodID IN ([0],[1], [2], [3], [4], [5], [6], [7], [8], [9], [10]))AS pvt
		) fu
		

		       
RETURN 
END