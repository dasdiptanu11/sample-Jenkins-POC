/****** Object:  View [dbo].[vw_ref_tbl_PatientOperationDeviceDtls]    Script Date: 13-11-2017 03:48:16 PM ******/
DROP VIEW [dbo].[vw_ref_tbl_PatientOperationDeviceDtls]
GO
/****** Object:  View [dbo].[vw_ref_tbl_PatientOperationDeviceDtls]    Script Date: 13-11-2017 03:48:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ref_tbl_PatientOperationDeviceDtls] AS
SELECT [PatientOperationDevId]
      ,[PatientOperationId]
      ,[ParentPatientOperationDevId]
      ,[DevType]
      ,[DevBrand]
      ,[DevOthBrand]
      ,[DevOthDesc]
      ,[DevOthMode]
      ,[DevManuf]
      ,[DevOthManuf]
      ,[DevId]
      ,[DevLotNo]
      ,[DevPortMethId]
      ,[PriPortRet]
      ,[ButtressId]
      ,[IgnoreDevice]
  FROM [dbo].[tbl_PatientOperationDeviceDtls]

GO
