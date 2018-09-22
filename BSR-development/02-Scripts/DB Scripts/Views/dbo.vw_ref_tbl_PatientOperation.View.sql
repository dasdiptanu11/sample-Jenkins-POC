/****** Object:  View [dbo].[vw_ref_tbl_PatientOperation]    Script Date: 13-11-2017 03:48:16 PM ******/
DROP VIEW [dbo].[vw_ref_tbl_PatientOperation]
GO
/****** Object:  View [dbo].[vw_ref_tbl_PatientOperation]    Script Date: 13-11-2017 03:48:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ref_tbl_PatientOperation] AS
SELECT [OpId]
      ,[PatientId]
      ,[Hosp]
      ,[Surg]
      ,[OpDate]
      ,[ProcAban]
      ,[OpAge]
      ,[OpStat]
      ,[OpType]
      ,[OthPriType]
      ,[OpRevType]
      ,[OthRevType]
      ,[LstBarProc]
      ,[Ht]
      ,[HtNtKnown]
      ,[StWt]
      ,[StWtNtKnown]
      ,[StBMI]
      ,[OpWt]
      ,[SameOpWt]
      ,[OpWtNtKnown]
      ,[OpBMI]
      ,[DiabStat]
      ,[DiabRx]
      ,[RenalTx]
      ,[LiverTx]
      ,[Time]
      ,[OthInfoOp]
      ,[OpVal]   
      --,[SEId1]
      --,[SEId2]
      --,[SEId3]
      --,[FurtherInfoSlip]
      --,[FurtherInfoPort]
      --,[ReasonOther]
      --,[OpEvent]
  FROM [dbo].[tbl_PatientOperation]

GO
