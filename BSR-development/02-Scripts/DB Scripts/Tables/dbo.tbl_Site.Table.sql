IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Site]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_Site] DROP CONSTRAINT IF EXISTS [FK_tbl_Site_tlkp_State]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Site]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_Site] DROP CONSTRAINT IF EXISTS [FK_tbl_Site_tlkp_SiteType_SiteTypeId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Site]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_Site] DROP CONSTRAINT IF EXISTS [FK_tbl_Site_tlkp_SiteStatus]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Site]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_Site] DROP CONSTRAINT IF EXISTS [FK_tbl_Site_tlkp_Country_SiteCountryId]
GO
/****** Object:  Table [dbo].[tbl_Site]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_Site]
GO
/****** Object:  Table [dbo].[tbl_Site]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Site]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_Site](
	[SiteId] [int] IDENTITY(1,1) NOT NULL,
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
	[EAD] [date] NULL,
 CONSTRAINT [PK_tbl_Site] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Site_tlkp_Country_SiteCountryId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Site]'))
ALTER TABLE [dbo].[tbl_Site]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Site_tlkp_Country_SiteCountryId] FOREIGN KEY([SiteCountryId])
REFERENCES [dbo].[tlkp_Country] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Site_tlkp_Country_SiteCountryId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Site]'))
ALTER TABLE [dbo].[tbl_Site] CHECK CONSTRAINT [FK_tbl_Site_tlkp_Country_SiteCountryId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Site_tlkp_SiteStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Site]'))
ALTER TABLE [dbo].[tbl_Site]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Site_tlkp_SiteStatus] FOREIGN KEY([SiteStatusId])
REFERENCES [dbo].[tlkp_SiteStatus] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Site_tlkp_SiteStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Site]'))
ALTER TABLE [dbo].[tbl_Site] CHECK CONSTRAINT [FK_tbl_Site_tlkp_SiteStatus]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Site_tlkp_SiteType_SiteTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Site]'))
ALTER TABLE [dbo].[tbl_Site]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Site_tlkp_SiteType_SiteTypeId] FOREIGN KEY([SiteTypeId])
REFERENCES [dbo].[tlkp_SiteType] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Site_tlkp_SiteType_SiteTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Site]'))
ALTER TABLE [dbo].[tbl_Site] CHECK CONSTRAINT [FK_tbl_Site_tlkp_SiteType_SiteTypeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Site_tlkp_State]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Site]'))
ALTER TABLE [dbo].[tbl_Site]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Site_tlkp_State] FOREIGN KEY([SiteStateId])
REFERENCES [dbo].[tlkp_State] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Site_tlkp_State]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Site]'))
ALTER TABLE [dbo].[tbl_Site] CHECK CONSTRAINT [FK_tbl_Site_tlkp_State]
GO
