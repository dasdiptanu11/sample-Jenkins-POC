/****** Object:  View [dbo].[vw_ref_tbl_patient]    Script Date: 13-11-2017 03:48:16 PM ******/
DROP VIEW [dbo].[vw_ref_tbl_patient]
GO
/****** Object:  View [dbo].[vw_ref_tbl_patient]    Script Date: 13-11-2017 03:48:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ref_tbl_patient]
AS
SELECT [PatId]
      ,[LastName]
      ,[FName]
      ,[TitleId]
      ,[DOB]
      ,[DOBNotKnown]
      ,[GenderId]
      ,[McareNo]
      ,[NoMcareNo]
      ,[DvaNo]
      ,[NoDvaNo]    
      ,[AborStatusId]
      ,[IndiStatusId]
      ,[NhiNo]
      ,[NoNhiNo]
      ,[PriSiteId]
      ,[PriSurgId]
      ,[Addr]
      ,[AddrNotKnown]
      ,[Sub]
      ,[StateId]
      ,[Pcode]
      ,[NoPcode]
      ,[CountryId]
      ,[HomePh]
      ,[MobPh]
      ,[NoHomePh]
      ,[NoMobPh]
      ,[HStatId]
      ,[DateDeath]
      ,[DateDeathNotKnown]
      ,[CauseOfDeath]
      ,[DeathRelSurgId]
      ,[DateESSent]
      ,[Undel]
      ,[OptOffStatId]
      ,[OptOffDate]
      ,[Legacy]  
  FROM [dbo].[tbl_Patient]

GO
