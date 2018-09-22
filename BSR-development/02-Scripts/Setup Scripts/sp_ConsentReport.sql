/****** Object:  StoredProcedure [dbo].[sp_ConsentReport]    Script Date: 11/13/2014 10:35:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ConsentReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_ConsentReport]
GO

/****** Object:  StoredProcedure [dbo].[sp_ConsentReport]    Script Date: 10/22/2014 10:56:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ConsentReport](
	@pSiteId int,
	@pSurgeonId int,
	@pESSDateFrom date,
	@pESSDateTo date)
AS

BEGIN

With T_PatDtls as
	(SELECT * FROM tbl_Patient p WHERE  
	CONVERT(datetime, p.DateESSent, 103) >= case when @pESSDateFrom <> '01/01/1940' 
				then CONVERT(datetime, @pESSDateFrom, 103) else CONVERT(datetime, p.DateESSent, 103) end
	and CONVERT(datetime, p.DateESSent, 103) <= case when @pESSDateTo <> '01/01/1940' 
				then CONVERT(datetime, @pESSDateTo, 103) else CONVERT(datetime, p.DateESSent, 103) end
	and p.PriSiteId  = case when @pSiteId > 0 then @pSiteId else p.PriSiteId end 
	and p.PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else p.PriSurgId end)	
SELECT  * FROM 
(
 SELECT TotPatInReg, TotConsentedPatInReg, TotCompleteOptOffPatInReg, TotPartialOptOffPatInReg,CASE WHEN TotPatInReg =0  THEN '0%' ELSE (CAST(ROUND((CAST(TotCompleteOptOffPatInReg as FLOAT)/NULLIF(CAST(TotPatInReg as FLOAT),0) )*100,2) AS VARCHAR(50))+ '%') END AS OptOffpercentage from 
	(SELECT count(distinct PatID) TotPatInReg from T_PatDtls ) TotPat, 
	(SELECT count(distinct PatID) TotConsentedPatInReg from T_PatDtls where OptOffStatId =0 ) TotConsentedPat, 
	(SELECT count(distinct PatID) TotCompleteOptOffPatInReg from T_PatDtls where OptOffStatId =1 ) TotCompleteOptOffPat, 
	(SELECT count(distinct PatID) TotPartialOptOffPatInReg from T_PatDtls where OptOffStatId =2) TotPartialOptOffPat
)

 ConsentReport

END


GO


