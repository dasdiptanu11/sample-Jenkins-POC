/****** Object:  View [dbo].[vw_aspnet_WebPartState_User]    Script Date: 13-11-2017 03:48:16 PM ******/
DROP VIEW [dbo].[vw_aspnet_WebPartState_User]
GO
/****** Object:  View [dbo].[vw_aspnet_WebPartState_User]    Script Date: 13-11-2017 03:48:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_aspnet_WebPartState_User]
  AS SELECT [dbo].[aspnet_PersonalizationPerUser].[PathId], [dbo].[aspnet_PersonalizationPerUser].[UserId], [DataSize]=DATALENGTH([dbo].[aspnet_PersonalizationPerUser].[PageSettings]), [dbo].[aspnet_PersonalizationPerUser].[LastUpdatedDate]
  FROM [dbo].[aspnet_PersonalizationPerUser]

GO
