/****** Object:  View [dbo].[vw_ref_tbl_PatientComplications]    Script Date: 13-11-2017 03:48:16 PM ******/
DROP VIEW [dbo].[vw_ref_tbl_PatientComplications]
GO
/****** Object:  View [dbo].[vw_ref_tbl_PatientComplications]    Script Date: 13-11-2017 03:48:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ref_tbl_PatientComplications] AS
SELECT [Id]
      ,[FuId]
      ,[ComplicationId]
      ,[OpId]
  FROM [dbo].[tbl_PatientComplications]

GO
