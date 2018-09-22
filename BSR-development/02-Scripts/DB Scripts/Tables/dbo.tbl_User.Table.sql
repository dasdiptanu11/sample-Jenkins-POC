IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_User]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_User] DROP CONSTRAINT IF EXISTS [FK_tbl_User_tlkp_Title]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_User]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_User] DROP CONSTRAINT IF EXISTS [FK_tbl_User_tlkp_State_StateId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_User]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_User] DROP CONSTRAINT IF EXISTS [FK_tbl_User_tlkp_Country_CountryId]
GO
/****** Object:  Table [dbo].[tbl_User]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_User]
GO
/****** Object:  Table [dbo].[tbl_User]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_User]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_User](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
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
	[CreatedDateTime] [datetime] NULL,
 CONSTRAINT [PK_tbl_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_User_tlkp_Country_CountryId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_User]'))
ALTER TABLE [dbo].[tbl_User]  WITH CHECK ADD  CONSTRAINT [FK_tbl_User_tlkp_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[tlkp_Country] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_User_tlkp_Country_CountryId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_User]'))
ALTER TABLE [dbo].[tbl_User] CHECK CONSTRAINT [FK_tbl_User_tlkp_Country_CountryId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_User_tlkp_State_StateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_User]'))
ALTER TABLE [dbo].[tbl_User]  WITH CHECK ADD  CONSTRAINT [FK_tbl_User_tlkp_State_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[tlkp_State] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_User_tlkp_State_StateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_User]'))
ALTER TABLE [dbo].[tbl_User] CHECK CONSTRAINT [FK_tbl_User_tlkp_State_StateId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_User_tlkp_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_User]'))
ALTER TABLE [dbo].[tbl_User]  WITH CHECK ADD  CONSTRAINT [FK_tbl_User_tlkp_Title] FOREIGN KEY([TitleId])
REFERENCES [dbo].[tlkp_Title] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_User_tlkp_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_User]'))
ALTER TABLE [dbo].[tbl_User] CHECK CONSTRAINT [FK_tbl_User_tlkp_Title]
GO
