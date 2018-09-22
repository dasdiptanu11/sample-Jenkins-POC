

/****** Object:  StoredProcedure [dbo].[usp_ConsentReport]    Script Date: 10/14/2015 12:32:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ConsentReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ConsentReport]
GO


/****** Object:  StoredProcedure [dbo].[usp_ConsentReport]    Script Date: 10/14/2015 12:32:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*setting @pRunForLegacyOnly = 1  will run only for LegacyPatients only
		  @pRunForLegacyOnly = 0  will run only for non - LegacyPatients only 
		  @pRunForLegacyOnly = 2 will not consider isLegacyPatient field - runs for both   */


CREATE PROCEDURE [dbo].[usp_ConsentReport](
	@pSiteId int,
	@pSurgeonId int,
	@pOptOffdateFrom date,
	@pOptOffdateto date,
	@pRunForLegacyOnly int)
AS

BEGIN

--Selecting all patients according to criteria given 
With T_TotPatDtls as
	(SELECT * FROM tbl_Patient p),
	 T_PatDtls as
	(SELECT * FROM T_TotPatDtls p 
	WHERE  
	/*coalesce(p.optOffdate, '01/01/1940')  >= case when @pOptOffdateFrom <> '01/01/1940' 
	    then CONVERT(datetime, @pOptOffdateFrom, 103) else coalesce(p.optOffdate, '01/01/1940') end
	and coalesce(p.optOffdate, '01/01/1940') <= case when @pOptOffdateto <> '01/01/1940' 
				then CONVERT(datetime, @pOptOffdateto, 103) else coalesce(p.optOffdate, '01/01/1940') end
	and*/
	 coalesce(p.PriSiteId,0)  = case when @pSiteId > 0 then  @pSiteId else coalesce(p.PriSiteId,0) end
	and coalesce(PriSurgId,0) = case when @pSurgeonId > 0 then @pSurgeonId else coalesce(p.PriSurgId,0) end
	and coalesce(p.Legacy, 0) = (case when @pRunForLegacyOnly < 2 then @pRunForLegacyOnly else coalesce(p.Legacy, 0) end)), 
	--As Surgeon/Hosp will be missing for tot opt off patients, they won't be selected in above criteria
	T_TotPatDtlsInReg(Cnt_Of_Tot_reg_Pat) as
	(select COUNT(*) from T_TotPatDtls),
	--Count of all opted off patients in reg
	T_TotOptOffPatDtlsInReg(Cnt_Of_Tot_OptOff_Pat) as
	(select COUNT(*) from tbl_Patient where OptOffStatId = 1)	
	
SELECT  * FROM 
(

 SELECT TotPatInReg, TotUnConsentedPatInReg, TotConsentedPatInReg, TotLTFUPatInReg,
	--Total Opt Off in format n(n%)
    CAST(Cnt_Of_Tot_OptOff_Pat as varchar(15)) + '(' + cast(CAST(Cnt_Of_Tot_OptOff_Pat*100.00/Cnt_Of_Tot_reg_Pat as decimal(5,2)) as varchar(10) )+ '%)' TotCompleteOptOffPatInReg, 
    --Partial opt off in format n(n%)
    cast(TotPartialOptOffPatInReg as varchar(15)) + CASE WHEN TotPatInReg =0  THEN '(0%)' ELSE 
    '(' + cast(CAST(TotPartialOptOffPatInReg*100.00/TotPatInReg as decimal(5,2)) as varchar(10) )+ '%)' END TotPartialOptOffPatInReg
    from 
    --Calculating total patients
	(SELECT count(distinct PatID) TotPatInReg from T_PatDtls ) TotPat, 
	--Calculating total consented patients
	(SELECT count(distinct PatID) TotConsentedPatInReg from T_PatDtls where OptOffStatId in (0, 2,4) ) TotConsentedPat inner join  
	--Calculating total partial opted off patients
	(SELECT count(distinct PatID) TotPartialOptOffPatInReg from T_PatDtls where OptOffStatId =2) TotPartialOptOffPat on 'a' = 'a'  inner join
	--Calculating total unconsented patients
	(SELECT count(distinct PatID) TotUnConsentedPatInReg from T_PatDtls where OptOffStatId =3 ) TotUnConsentedPat on 'a' = 'a'  inner join  
	--Calculating total LTFU patients
	(SELECT count(distinct PatID) TotLTFUPatInReg from T_PatDtls where OptOffStatId =4) TotLTFUPat	on 'a' = 'a'
	inner join T_TotPatDtlsInReg on 'a' = 'a' inner join T_TotOptOffPatDtlsInReg on 'a' = 'a' 
	) ConsentReport
	
	return

END









GO


