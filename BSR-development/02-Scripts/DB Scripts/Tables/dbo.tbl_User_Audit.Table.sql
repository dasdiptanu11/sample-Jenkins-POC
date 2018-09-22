/****** Object:  Table [dbo].[tbl_User_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_User_Audit]
GO
/****** Object:  Table [dbo].[tbl_User_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_User_Audit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_User_Audit](
	[Action] [nvarchar](50) NULL,
	[AuditUserName] [nvarchar](50) NULL,
	[AuditDate] [datetime] NOT NULL,
	[UserId] [int] NOT NULL,
	[UId] [uniqueidentifier] NULL,
	[TitleId] [int] NULL,
	[FName] [varchar](40) NULL,
	[LastName] [varchar](40) NULL,
	[RoleId] [varchar](16) NULL,
	[CountryId] [int] NULL,
	[StateId] [int] NULL,
	[SiteAccessSiteId] [int] NULL,
	[HPI-I] [numeric](16, 0) NULL,
	[Email] [varchar](250) NULL,
	[NoNotificationEmail] [bit] NULL,
	[AccountStatusActive] [int] NULL,
	[AccountStatusLocked] [int] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDateTime] [datetime] NULL
) ON [PRIMARY]
END
GO
