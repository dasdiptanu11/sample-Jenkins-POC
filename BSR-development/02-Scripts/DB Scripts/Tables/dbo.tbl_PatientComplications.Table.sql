IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientComplications]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientComplications] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientComplications_tlkp_Complications_ComplicationId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientComplications]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientComplications] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientComplications_tbl_PatientOperation_OpId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientComplications]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientComplications] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientComplications_tbl_FollowUp]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientComplications]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientComplications] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientComplications_tbl_Complications_ComplicationId]
GO
/****** Object:  Table [dbo].[tbl_PatientComplications]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_PatientComplications]
GO
/****** Object:  Table [dbo].[tbl_PatientComplications]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientComplications]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_PatientComplications](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FuId] [int] NULL,
	[ComplicationId] [int] NULL,
	[OpId] [int] NULL,
 CONSTRAINT [PK_tbl_PatientComplications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientComplications_tbl_Complications_ComplicationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientComplications]'))
ALTER TABLE [dbo].[tbl_PatientComplications]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientComplications_tbl_Complications_ComplicationId] FOREIGN KEY([ComplicationId])
REFERENCES [dbo].[tbl_Complications] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientComplications_tbl_Complications_ComplicationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientComplications]'))
ALTER TABLE [dbo].[tbl_PatientComplications] CHECK CONSTRAINT [FK_tbl_PatientComplications_tbl_Complications_ComplicationId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientComplications_tbl_FollowUp]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientComplications]'))
ALTER TABLE [dbo].[tbl_PatientComplications]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientComplications_tbl_FollowUp] FOREIGN KEY([FuId])
REFERENCES [dbo].[tbl_FollowUp] ([FUId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientComplications_tbl_FollowUp]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientComplications]'))
ALTER TABLE [dbo].[tbl_PatientComplications] CHECK CONSTRAINT [FK_tbl_PatientComplications_tbl_FollowUp]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientComplications_tbl_PatientOperation_OpId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientComplications]'))
ALTER TABLE [dbo].[tbl_PatientComplications]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientComplications_tbl_PatientOperation_OpId] FOREIGN KEY([OpId])
REFERENCES [dbo].[tbl_PatientOperation] ([OpId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientComplications_tbl_PatientOperation_OpId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientComplications]'))
ALTER TABLE [dbo].[tbl_PatientComplications] CHECK CONSTRAINT [FK_tbl_PatientComplications_tbl_PatientOperation_OpId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientComplications_tlkp_Complications_ComplicationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientComplications]'))
ALTER TABLE [dbo].[tbl_PatientComplications]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientComplications_tlkp_Complications_ComplicationId] FOREIGN KEY([ComplicationId])
REFERENCES [dbo].[tlkp_Complications] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientComplications_tlkp_Complications_ComplicationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientComplications]'))
ALTER TABLE [dbo].[tbl_PatientComplications] CHECK CONSTRAINT [FK_tbl_PatientComplications_tlkp_Complications_ComplicationId]
GO
