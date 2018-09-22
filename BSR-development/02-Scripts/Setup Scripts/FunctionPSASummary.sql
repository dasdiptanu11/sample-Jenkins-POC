IF EXISTS (
    SELECT * FROM sysobjects WHERE id = object_id(N'ufn_PSASummary') 
    AND xtype IN (N'FN', N'IF', N'TF')
) 
DROP FUNCTION ufn_PSASummary
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_PSASummary]    Script Date: 03/15/2013 09:43:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[ufn_PSASummary]
(	
	-- Add the parameters for the function here
	@PatientID INT
)
RETURNS
 @PSATable TABLE 
 (
	patientID int,
	PSADate datetime,
	PSALevel decimal(10,4),
	PSALevelValue decimal(10,4),
	PSAFrom varchar(200),
	PSASource varchar(200)
 )
AS
Begin
 Insert Into @PSATable
   select tbl_TreatmentSummary.PtID as patientId, tbl_PSA.PSAdat, tbl_PSA.PSALev as PSALevel, Cast(CONVERT(DECIMAL(10,4),tbl_PSA.PSABDL) as nvarchar) AS PSALevelValue,
    case when tbl_Hifu.HifuPSAStatus = 1 then 'HIFU' end as PSAFrom, tlkp_PSASource.Description as PSASource from tbl_Hifu
                                             inner join tbl_TreatmentSummary on tbl_Hifu.TsId = tbl_TreatmentSummary.TSId
                                             inner join  tbl_PSA on tbl_TreatmentSummary.PtID = tbl_PSA.PtID
                                              inner join tlkp_PSASource on tbl_PSA.PSAsource = tlkp_PSASource.Id
    
    where tbl_Hifu.HifuPSA = tbl_PSA.PSAID and tbl_Hifu.HifuPSAStatus = 1 and tbl_TreatmentSummary.PtID = @PatientID

UNION

select tbl_TreatmentSummary.PtID as patientId, tbl_PSA.PSAdat, tbl_PSA.PSALev as PSALevel, Cast(CONVERT(DECIMAL(10,4),tbl_PSA.PSABDL) as nvarchar) AS PSALevelValue,
    case when tbl_Surgery.SurPSAStatus = 1 then 'Surgery' end as PSAFrom, tlkp_PSASource.Description as PSASource from tbl_Surgery
                                             inner join tbl_TreatmentSummary on tbl_Surgery.TsId = tbl_TreatmentSummary.TSId
                                             inner join  tbl_PSA on tbl_TreatmentSummary.PtID = tbl_PSA.PtID
                                             inner join tlkp_PSASource on tbl_PSA.PSAsource = tlkp_PSASource.Id    
    where tbl_Surgery.SurPSA = tbl_PSA.PSAID and tbl_Surgery.SurPSAStatus = 1 and tbl_TreatmentSummary.PtID = @PatientID
    
UNION
 
 select tbl_TreatmentSummary.PtID as patientId, tbl_PSA.PSAdat, tbl_PSA.PSALev as PSALevel, Cast(CONVERT(DECIMAL(10,4),tbl_PSA.PSABDL) as nvarchar) AS PSALevelValue,
    case when tbl_Radiotherapy.RtPSAStatus = 1 then 'Radiotherapy' end as PSAFrom, tlkp_PSASource.Description as PSASource from tbl_Radiotherapy
                                             inner join tbl_TreatmentSummary on tbl_Radiotherapy.TsId = tbl_TreatmentSummary.TSId
                                             inner join  tbl_PSA on tbl_TreatmentSummary.PtID = tbl_PSA.PtID
                                             inner join tlkp_PSASource on tbl_PSA.PSAsource = tlkp_PSASource.Id    
    where tbl_Radiotherapy.RtPSA = tbl_PSA.PSAID and tbl_Radiotherapy.RtPSAStatus= 1 and tbl_TreatmentSummary.PtID = @PatientID 
	
UNION
 
 select tbl_TreatmentSummary.PtID as patientId, tbl_PSA.PSAdat, tbl_PSA.PSALev as PSALevel, Cast(CONVERT(DECIMAL(10,4),tbl_PSA.PSABDL) as nvarchar) AS PSALevelValue,
    case when tbl_PalliativeRadiotherapy.RtPalPSAStatus = 1 then 'Palliative Radiotherapy' end as PSAFrom, tlkp_PSASource.Description as PSASource from tbl_PalliativeRadiotherapy
                                             inner join tbl_TreatmentSummary on tbl_PalliativeRadiotherapy.TsId = tbl_TreatmentSummary.TSId
                                             inner join  tbl_PSA on tbl_TreatmentSummary.PtID = tbl_PSA.PtID
                                             inner join tlkp_PSASource on tbl_PSA.PSAsource = tlkp_PSASource.Id    
    where tbl_PalliativeRadiotherapy.RtPalPSA = tbl_PSA.PSAID and tbl_PalliativeRadiotherapy.RtPalPSAStatus= 1 and tbl_TreatmentSummary.PtID = @PatientID 
	
UNION

 select tbl_TreatmentSummary.PtID as patientId, tbl_PSA.PSAdat, tbl_PSA.PSALev as PSALevel, Cast(CONVERT(DECIMAL(10,4),tbl_PSA.PSABDL) as nvarchar) AS PSALevelValue,
    case when tbl_Brachytherapy.BraPSAStatus = 1 then 'Brachytherapy' end as PSAFrom, tlkp_PSASource.Description as PSASource from tbl_Brachytherapy
                                             inner join tbl_TreatmentSummary on tbl_Brachytherapy.TsId = tbl_TreatmentSummary.TSId
                                             inner join  tbl_PSA on tbl_TreatmentSummary.PtID = tbl_PSA.PtID
                                             inner join tlkp_PSASource on tbl_PSA.PSAsource = tlkp_PSASource.Id    
    where tbl_Brachytherapy.BraPSA = tbl_PSA.PSAID and tbl_Brachytherapy.BraPSAStatus= 1 and tbl_TreatmentSummary.PtID = @PatientID 
	
UNION

 select tbl_TreatmentSummary.PtID as patientId, tbl_PSA.PSAdat, tbl_PSA.PSALev as PSALevel, Cast(CONVERT(DECIMAL(10,4),tbl_PSA.PSABDL) as nvarchar) AS PSALevelValue,
    case when tbl_AdjuvantADTtherapy.ADTPSAStatus = 1 then 'Adjuvant ADT Therapy' end as PSAFrom, tlkp_PSASource.Description as PSASource from tbl_AdjuvantADTtherapy
                                             inner join tbl_TreatmentSummary on tbl_AdjuvantADTtherapy.TsId = tbl_TreatmentSummary.TSId
                                             inner join  tbl_PSA on tbl_TreatmentSummary.PtID = tbl_PSA.PtID
                                             inner join tlkp_PSASource on tbl_PSA.PSAsource = tlkp_PSASource.Id    
    where tbl_AdjuvantADTtherapy.ADTPSA = tbl_PSA.PSAID and tbl_AdjuvantADTtherapy.ADTPSAStatus = 1 and tbl_TreatmentSummary.PtID = @PatientID
	
UNION 

   select tbl_TreatmentSummary.PtID as patientId, tbl_PSA.PSAdat, tbl_PSA.PSALev as PSALevel, Cast(CONVERT(DECIMAL(10,4),tbl_PSA.PSABDL) as nvarchar) AS PSALevelValue,
    case when tbl_PalliativeADTtherapy.PalADTPSAStatus = 1 then 'Palliative ADT Therapy' end as PSAFrom, tlkp_PSASource.Description as PSASource from tbl_PalliativeADTtherapy
                                             inner join tbl_TreatmentSummary on tbl_PalliativeADTtherapy.TsId = tbl_TreatmentSummary.TSId
                                             inner join  tbl_PSA on tbl_TreatmentSummary.PtID = tbl_PSA.PtID
                                             inner join tlkp_PSASource on tbl_PSA.PSAsource = tlkp_PSASource.Id    
    where tbl_PalliativeADTtherapy.PaladtPSA = tbl_PSA.PSAID and tbl_PalliativeADTtherapy.PalADTPSAStatus = 1 and tbl_TreatmentSummary.PtID = @PatientID
	
UNION

  select tbl_TreatmentSummary.PtID as patientId, tbl_PSA.PSAdat, tbl_PSA.PSALev as PSALevel, Cast(CONVERT(DECIMAL(10,4),tbl_PSA.PSABDL) as nvarchar) AS PSALevelValue,
    case when tbl_Chemotherapy.ChePSAStatus = 1 then 'Chemotherapy' end as PSAFrom, tlkp_PSASource.Description as PSASource from tbl_Chemotherapy
                                             inner join tbl_TreatmentSummary on tbl_Chemotherapy.TsId = tbl_TreatmentSummary.TSId
                                             inner join  tbl_PSA on tbl_TreatmentSummary.PtID = tbl_PSA.PtID
                                             inner join tlkp_PSASource on tbl_PSA.PSAsource = tlkp_PSASource.Id    
    where tbl_Chemotherapy.ChePSA = tbl_PSA.PSAID and tbl_Chemotherapy.ChePSAStatus = 1 and tbl_TreatmentSummary.PtID = @PatientID
	
UNION

select tbl_TreatmentSummary.PtID as patientId, tbl_PSA.PSAdat, tbl_PSA.PSALev as PSALevel, Cast(CONVERT(DECIMAL(10,4),tbl_PSA.PSABDL) as nvarchar) AS PSALevelValue,
       case when tbl_Trus.AsPSAStatus = 1 and tbl_Trus.Sequence =1 then 'WWAS Trus 1' 
            when tbl_Trus.AsPSAStatus = 1 and tbl_Trus.Sequence =2 then 'WWAS Trus 2' 
            when tbl_Trus.AsPSAStatus = 1 and tbl_Trus.Sequence =3 then 'WWAS Trus 3' 
            when tbl_Trus.AsPSAStatus = 1 and tbl_Trus.Sequence =4 then 'WWAS Trus 4' 
            when tbl_Trus.AsPSAStatus = 1 and tbl_Trus.Sequence =5 then 'WWAS Trus 5' 
            when tbl_Trus.AsPSAStatus = 1 and tbl_Trus.Sequence =6 then 'WWAS Trus 6' 
            when tbl_Trus.AsPSAStatus = 1 and tbl_Trus.Sequence =7 then 'WWAS Trus 7' 
            when tbl_Trus.AsPSAStatus = 1 and tbl_Trus.Sequence =8 then 'WWAS Trus 8' 
            when tbl_Trus.AsPSAStatus = 1 and tbl_Trus.Sequence =9 then 'WWAS Trus 9' 
            when tbl_Trus.AsPSAStatus = 1 and tbl_Trus.Sequence =10 then 'WWAS Trus 10'             
            end as PSAFrom,tlkp_PSASource.Description as PSASource from tbl_Trus
              inner join tbl_WWAS on tbl_Trus.WwAsId = tbl_WWAS.WwAsId 
              inner join tbl_TreatmentSummary on tbl_TreatmentSummary.TSId = tbl_WWAS.TsId
              inner join  tbl_PSA on tbl_TreatmentSummary.PtID = tbl_PSA.PtID
              inner join tlkp_PSASource on tbl_PSA.PSAsource = tlkp_PSASource.Id  
 where tbl_Trus.AsPSA = tbl_PSA.PSAID and tbl_Trus.AsPSAStatus = 1 and tbl_TreatmentSummary.PtID = @PatientID
 
 UNION
 
 select tbl_TreatmentSummary.PtID as patientId, tbl_PSA.PSAdat, tbl_PSA.PSALev as PSALevel, Cast(CONVERT(DECIMAL(10,4),tbl_PSA.PSABDL) as nvarchar) AS PSALevelValue,
       case when tbl_Turp.TurpPSAStatus = 1 and tbl_Turp.Sequence =1 then 'TURP 1' 
            when tbl_Turp.TurpPSAStatus = 1 and tbl_Turp.Sequence =2 then 'TURP 2' 
            when tbl_Turp.TurpPSAStatus = 1 and tbl_Turp.Sequence =3 then 'TURP 3' 
            when tbl_Turp.TurpPSAStatus = 1 and tbl_Turp.Sequence =4 then 'TURP 4' 
            when tbl_Turp.TurpPSAStatus = 1 and tbl_Turp.Sequence =5 then 'TURP 5' 
            when tbl_Turp.TurpPSAStatus = 1 and tbl_Turp.Sequence =6 then 'TURP 6' 
            when tbl_Turp.TurpPSAStatus = 1 and tbl_Turp.Sequence =7 then 'TURP 7' 
            when tbl_Turp.TurpPSAStatus = 1 and tbl_Turp.Sequence =8 then 'TURP 8' 
            when tbl_Turp.TurpPSAStatus = 1 and tbl_Turp.Sequence =9 then 'TURP 9' 
            when tbl_Turp.TurpPSAStatus = 1 and tbl_Turp.Sequence =10 then 'TURP 10'             
            end as PSAFrom,tlkp_PSASource.Description as PSASource from tbl_Turp             
              inner join tbl_TreatmentSummary on tbl_TreatmentSummary.TSId = tbl_Turp.TsId
              inner join  tbl_PSA on tbl_TreatmentSummary.PtID = tbl_PSA.PtID
              inner join tlkp_PSASource on tbl_PSA.PSAsource = tlkp_PSASource.Id  
 where tbl_Turp.TurpPSA = tbl_PSA.PSAID and tbl_Turp.TurpPSAStatus = 1 and tbl_TreatmentSummary.PtID = @PatientID
 
UNION
 
  select tbl_TreatmentSummary.PtID as patientId, tbl_PSA.PSAdat, tbl_PSA.PSALev as PSALevel, Cast(CONVERT(DECIMAL(10,4),tbl_PSA.PSABDL) as nvarchar) AS PSALevelValue,
    case when tbl_OtherTreatment.OthPSAStatus = 1 then 'Other/Unknown/Referred Treatment' end as PSAFrom, tlkp_PSASource.Description as PSASource from tbl_OtherTreatment
                                             inner join tbl_TreatmentSummary on tbl_OtherTreatment.TsId = tbl_TreatmentSummary.TSId
                                             inner join  tbl_PSA on tbl_TreatmentSummary.PtID = tbl_PSA.PtID
                                             inner join tlkp_PSASource on tbl_PSA.PSAsource = tlkp_PSASource.Id    
    where tbl_OtherTreatment.OthPsa = tbl_PSA.PSAID and tbl_OtherTreatment.OthPSAStatus = 1 and tbl_TreatmentSummary.PtID = @PatientID
 
union 
  
select tbl_FollowUp.PtID as PatientId, tbl_PSA.PSAdat, tbl_PSA.PSALev as PSALevel, 
          Cast(CONVERT(DECIMAL(10,4),tbl_PSA.PSABDL) as nvarchar) AS PSALevelValue,
          case when tbl_FollowUp.Month = 12 then '12M Folow Up'
               when tbl_FollowUp.Month = 24 then '24M Folow Up'
               when tbl_FollowUp.Month = 60 then '60M Folow Up'
               end as PSAFrom , tlkp_PSASource.Description as PSASource from tbl_FollowUp
              -- inner join tbl_PSA on tbl_FollowUp.PtID = tbl_PSA.PtID
               inner join tbl_PSA  on tbl_FollowUp.FUPsa = tbl_PSA.PSAID
               inner join tlkp_PSASource on tbl_PSA.PSAsource = tlkp_PSASource.Id
               
         where tbl_FollowUp.FUPsa = tbl_PSA.PSAID and tbl_FollowUp.PtID= @PatientID

RETURN 
End


GO
