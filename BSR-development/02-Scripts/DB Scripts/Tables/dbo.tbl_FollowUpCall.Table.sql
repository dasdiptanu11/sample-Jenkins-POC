IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_FollowUpCall]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_FollowUpCall] DROP CONSTRAINT IF EXISTS [FK_tbl_FollowUpCall_tbl_FollowUp_FollowUpId]
GO
/****** Object:  Table [dbo].[tbl_FollowUpCall]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_FollowUpCall]
GO
/****** Object:  Table [dbo].[tbl_FollowUpCall]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_FollowUpCall]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_FollowUpCall](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FollowUpId] [int] NULL,
	[CallOne] [int] NULL,
	[CallTwo] [int] NULL,
	[CallThree] [int] NULL,
	[CallFour] [int] NULL,
	[CallFive] [int] NULL,
	[AssignedTo] [int] NULL,
	[LastUpdatedBy] [nvarchar](100) NULL,
	[LastUpdatedDateTime] [datetime] NULL,
 CONSTRAINT [PK_tbl_FollowUpCall] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUpCall_tbl_FollowUp_FollowUpId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUpCall]'))
ALTER TABLE [dbo].[tbl_FollowUpCall]  WITH CHECK ADD  CONSTRAINT [FK_tbl_FollowUpCall_tbl_FollowUp_FollowUpId] FOREIGN KEY([FollowUpId])
REFERENCES [dbo].[tbl_FollowUp] ([FUId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUpCall_tbl_FollowUp_FollowUpId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUpCall]'))
ALTER TABLE [dbo].[tbl_FollowUpCall] CHECK CONSTRAINT [FK_tbl_FollowUpCall_tbl_FollowUp_FollowUpId]
GO
