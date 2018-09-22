/****** Object:  StoredProcedure [dbo].[usp_MissingDataWorkList]    Script Date: 13-11-2017 03:31:50 PM ******/
DROP PROCEDURE [dbo].[usp_MissingDataWorkList]
GO
/****** Object:  StoredProcedure [dbo].[usp_MissingDataWorkList]    Script Date: 13-11-2017 03:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_MissingDataWorkList] 
	@pCountryId int,
	@pOpStat int, 
	@pSurgeonId int, 
	@pSiteId int, 
	@pOpDateFrom DateTime, --Uses mm/dd/yyyy format
	@pOpDateTo DateTime   --Uses mm/dd/yyyy format 	
AS

BEGIN	
	DECLARE @CountryId int
	DECLARE @OpStat int
	DECLARE @SurgeonId int
	DECLARE @SiteId int
	
	SET @CountryId = CASE WHEN @pCountryId is null THEN -1 ELSE @pCountryId END
	SET @OpStat = CASE WHEN @pOpStat is null THEN -1 ELSE @pOpStat END
	SET @SurgeonId = CASE WHEN @pSurgeonId is null then -1 ELSE @pSurgeonId END
	SET @SiteId = CASE WHEN @pSiteId is null then -1 ELSE @pSiteId END
	
	select a.Patient_ID, u.URNo, a.Patient_LastName, a.Patient_FName, a.Patient_Gender, a.Operation_Date, a.Surgeon, a.Hospital,  
	s.SiteId, a.Op_Form_Status,
	Day_30 as Day30FU,
	Year_1 as Yr1FU,
	Year_2 as Yr2FU,
	Year_3 as Yr3FU,
	Year_4 as Yr4FU,
	Year_5 as Yr5FU,
	Year_6 as Yr6FU,
	Year_7 as Yr7FU,
	Year_8 as Yr8FU,
	Year_9 as Yr9FU,
	Year_10 as Yr10FU
	from [dbo].[ufn_Missing_DataList](@CountryId, @OpStat, @SurgeonId, @SiteId, @pOpDateFrom, @pOpDateTo) a
	join tbl_URN u on u.PatientID = a.Patient_ID
	join tbl_Site s on s.SiteName = a.Hospital
	WHERE Day_30 = 'InComplete' OR Year_1 = 'InComplete' OR Year_2 = 'InComplete' OR Year_3 = 'InComplete' OR Year_4 = 'InComplete' OR Year_5 = 'InComplete' OR Year_6 = 'InComplete'
	OR Year_7 = 'InComplete' OR Year_8 = 'InComplete' OR Year_9 = 'InComplete' OR Year_10 = 'InComplete'


END


GO
