IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Patient]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT IF EXISTS [FK_tbl_Patient_tlkp_Title_TitleId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Patient]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT IF EXISTS [FK_tbl_Patient_tlkp_State_StateId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Patient]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT IF EXISTS [FK_tbl_Patient_tlkp_OptOffStatus_OptOffStatId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Patient]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT IF EXISTS [FK_tbl_Patient_tlkp_IndigenousStatus_IndiStatusId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Patient]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT IF EXISTS [FK_tbl_Patient_tlkp_HealthStatus_HealthSatusId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Patient]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT IF EXISTS [FK_tbl_Patient_tlkp_Gender_GenderId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Patient]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT IF EXISTS [FK_tbl_Patient_tlkp_Country_CountryId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Patient]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT IF EXISTS [FK_tbl_Patient_tlkp_AboriginalStatus_AborStatusId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Patient]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT IF EXISTS [FK_tbl_Patient_tbl_User_PriSurgId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Patient]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT IF EXISTS [FK_tbl_Patient_tbl_Site_PriSiteId]
GO
/****** Object:  Table [dbo].[tbl_Patient]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_Patient]
GO
/****** Object:  Table [dbo].[tbl_Patient]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Patient]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_Patient](
	[PatId] [int] IDENTITY(1,1) NOT NULL,
	[LastName] [varchar](40) NULL,
	[FName] [varchar](40) NULL,
	[TitleId] [int] NULL,
	[DOB] [date] NULL,
	[DOBNotKnown] [bit] NULL,
	[GenderId] [int] NULL,
	[McareNo] [varchar](11) NULL,
	[NoMcareNo] [bit] NULL,
	[DvaNo] [varchar](9) NULL,
	[NoDvaNo] [bit] NULL,
	[IHI] [varchar](16) NULL,
	[AborStatusId] [int] NULL,
	[IndiStatusId] [int] NULL,
	[NhiNo] [varchar](10) NULL,
	[NoNhiNo] [bit] NULL,
	[PriSiteId] [int] NULL,
	[PriSurgId] [int] NULL,
	[Addr] [varchar](100) NULL,
	[AddrNotKnown] [bit] NULL,
	[Sub] [varchar](100) NULL,
	[StateId] [int] NULL,
	[Pcode] [varchar](4) NULL,
	[NoPcode] [bit] NULL,
	[CountryId] [int] NULL,
	[HomePh] [varchar](30) NULL,
	[MobPh] [varchar](30) NULL,
	[NoHomePh] [bit] NULL,
	[NoMobPh] [bit] NULL,
	[HStatId] [int] NULL,
	[DateDeath] [date] NULL,
	[DateDeathNotKnown] [bit] NULL,
	[CauseOfDeath] [varchar](200) NULL,
	[DeathRelSurgId] [int] NULL,
	[DateESSent] [date] NULL,
	[Undel] [bit] NULL,
	[OptOffStatId] [int] NULL,
	[OptOffDate] [date] NULL,
	[Legacy] [int] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDateTime] [datetime] NULL,
 CONSTRAINT [PK_tbl_Patient] PRIMARY KEY CLUSTERED 
(
	[PatId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tbl_Site_PriSiteId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Patient_tbl_Site_PriSiteId] FOREIGN KEY([PriSiteId])
REFERENCES [dbo].[tbl_Site] ([SiteId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tbl_Site_PriSiteId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient] CHECK CONSTRAINT [FK_tbl_Patient_tbl_Site_PriSiteId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tbl_User_PriSurgId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Patient_tbl_User_PriSurgId] FOREIGN KEY([PriSurgId])
REFERENCES [dbo].[tbl_User] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tbl_User_PriSurgId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient] CHECK CONSTRAINT [FK_tbl_Patient_tbl_User_PriSurgId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_AboriginalStatus_AborStatusId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Patient_tlkp_AboriginalStatus_AborStatusId] FOREIGN KEY([AborStatusId])
REFERENCES [dbo].[tlkp_AboriginalStatus] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_AboriginalStatus_AborStatusId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient] CHECK CONSTRAINT [FK_tbl_Patient_tlkp_AboriginalStatus_AborStatusId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_Country_CountryId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Patient_tlkp_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[tlkp_Country] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_Country_CountryId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient] CHECK CONSTRAINT [FK_tbl_Patient_tlkp_Country_CountryId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_Gender_GenderId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Patient_tlkp_Gender_GenderId] FOREIGN KEY([GenderId])
REFERENCES [dbo].[tlkp_Gender] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_Gender_GenderId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient] CHECK CONSTRAINT [FK_tbl_Patient_tlkp_Gender_GenderId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_HealthStatus_HealthSatusId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Patient_tlkp_HealthStatus_HealthSatusId] FOREIGN KEY([HStatId])
REFERENCES [dbo].[tlkp_HealthStatus] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_HealthStatus_HealthSatusId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient] CHECK CONSTRAINT [FK_tbl_Patient_tlkp_HealthStatus_HealthSatusId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_IndigenousStatus_IndiStatusId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Patient_tlkp_IndigenousStatus_IndiStatusId] FOREIGN KEY([IndiStatusId])
REFERENCES [dbo].[tlkp_IndigenousStatus] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_IndigenousStatus_IndiStatusId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient] CHECK CONSTRAINT [FK_tbl_Patient_tlkp_IndigenousStatus_IndiStatusId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_OptOffStatus_OptOffStatId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Patient_tlkp_OptOffStatus_OptOffStatId] FOREIGN KEY([OptOffStatId])
REFERENCES [dbo].[tlkp_OptOffStatus] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_OptOffStatus_OptOffStatId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient] CHECK CONSTRAINT [FK_tbl_Patient_tlkp_OptOffStatus_OptOffStatId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_State_StateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Patient_tlkp_State_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[tlkp_State] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_State_StateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient] CHECK CONSTRAINT [FK_tbl_Patient_tlkp_State_StateId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_Title_TitleId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Patient_tlkp_Title_TitleId] FOREIGN KEY([TitleId])
REFERENCES [dbo].[tlkp_Title] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Patient_tlkp_Title_TitleId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Patient]'))
ALTER TABLE [dbo].[tbl_Patient] CHECK CONSTRAINT [FK_tbl_Patient_tlkp_Title_TitleId]
GO
