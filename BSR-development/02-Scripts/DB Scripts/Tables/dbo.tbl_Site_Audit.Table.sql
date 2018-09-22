/****** Object:  Table [dbo].[tbl_Site_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_Site_Audit]
GO
/****** Object:  Table [dbo].[tbl_Site_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Site_Audit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_Site_Audit](
	[Action] [nvarchar](50) NULL,
	[AuditUserName] [nvarchar](50) NULL,
	[AuditDate] [datetime] NOT NULL,
	[SiteId] [int] NOT NULL,
	[HPIO] [varchar](16) NULL,
	[SiteName] [varchar](200) NULL,
	[SiteRoleName] [varchar](10) NULL,
	[SitePrimaryContact] [nvarchar](100) NULL,
	[SitePh1] [varchar](40) NULL,
	[SiteSecondaryContact] [varchar](100) NULL,
	[SitePh2] [varchar](40) NULL,
	[SiteAddr] [varchar](100) NULL,
	[SiteSuburb] [varchar](50) NULL,
	[SiteStateId] [int] NULL,
	[SitePcode] [varchar](4) NULL,
	[SiteCountryId] [int] NULL,
	[SiteTypeId] [int] NULL,
	[SiteStatusId] [int] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedByDateTime] [datetime] NULL,
	[EAD] [date] NULL
) ON [PRIMARY]
END
GO
