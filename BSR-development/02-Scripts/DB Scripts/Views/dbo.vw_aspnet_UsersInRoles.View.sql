/****** Object:  View [dbo].[vw_aspnet_UsersInRoles]    Script Date: 13-11-2017 03:48:16 PM ******/
DROP VIEW [dbo].[vw_aspnet_UsersInRoles]
GO
/****** Object:  View [dbo].[vw_aspnet_UsersInRoles]    Script Date: 13-11-2017 03:48:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_aspnet_UsersInRoles]
  AS SELECT [dbo].[aspnet_UsersInRoles].[UserId], [dbo].[aspnet_UsersInRoles].[RoleId]
  FROM [dbo].[aspnet_UsersInRoles]

GO
