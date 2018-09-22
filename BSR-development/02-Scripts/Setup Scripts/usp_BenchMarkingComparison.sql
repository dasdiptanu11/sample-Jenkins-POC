

/****** Object:  StoredProcedure [dbo].[usp_BenchMarkingComparison]    Script Date: 05/20/2015 13:37:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_BenchMarkingComparison]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_BenchMarkingComparison]
GO


/****** Object:  StoredProcedure [dbo].[usp_BenchMarkingComparison]    Script Date: 05/20/2015 13:37:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_BenchMarkingComparison] 
	-- Add the parameters for the stored procedure here
	@pStateId_A int,
	@pCountryId_A int,
	@pSiteId_A int,
	@pSurgeonId_A int,
	@pOpTypeID_A int,	
	@pStateId_B int,
	@pCountryId_B int,
	@pSiteId_B int,
	@pSurgeonId_B int,
	@pOpTypeID_B int,
	@pRunForLegacyOnly_A int, 	
	@pRunForLegacyOnly_B int
AS
BEGIN
declare @cntA as int,  @cntB as int

IF 1=0 BEGIN -- this was assed as Table Adapter cannot recognize temp tables
    SET FMTONLY OFF
END
	SET NOCOUNT ON;
	Create table #tableA
	(
	FUPeriodId INT,
	AvgWtLossA decimal(10,2)
	)
INSERT #tableA
exec dbo.usp_BenchMarkingReport @pSurgeonId = @pSurgeonId_A, @pStateId = @pStateId_A,@pCountryId=@pCountryId_A,@pSiteId=@pSiteId_A, @pOpTypeID = @pOpTypeID_A, @pRunForLegacyOnly = @pRunForLegacyOnly_A

Create table #tableB
	(
	FUPeriodId INT,
	AvgWtLossB decimal(10,2)
	)
INSERT #tableB
exec dbo.usp_BenchMarkingReport @pSurgeonId = @pSurgeonId_B, @pStateId = @pStateId_B,@pCountryId=@pCountryId_B,@pSiteId=@pSiteId_B, @pOpTypeID = @pOpTypeID_B, @pRunForLegacyOnly = @pRunForLegacyOnly_B

 
 
 set @cntA = (SELECT count(*) from #tableA);
 set @cntB =  (SELECT count(*) from #tableB);
 
 if(@cntA> @cntB) 
 	SELECT #tableA.FUPeriodId as FUPeriodId,AvgWtLossA as AvgWtLossCriteria1, AvgWtLossB as AvgWtLossCriteria2 from #tableA 
		left outer join #tableB on #tableA.FUPeriodId =  #tableB.FUPeriodId
 else		
		SELECT #tableB.FUPeriodId as FUPeriodId, AvgWtLossA as AvgWtLossCriteria1,AvgWtLossB as AvgWtLossCriteria2 from #tableB 
		left outer join #tableA on #tableA.FUPeriodId =  #tableB.FUPeriodId
		
		DROP TABLE #tableA
		DROP TABLE #tableB
END












GO


