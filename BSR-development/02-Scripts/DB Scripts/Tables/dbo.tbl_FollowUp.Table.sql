IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT IF EXISTS [FK_tbl_FollowUp_tlkp_YesNo_ReOpStatId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT IF EXISTS [FK_tbl_FollowUp_tlkp_ReasonSlip_FurtherInfoSlip]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT IF EXISTS [FK_tbl_FollowUp_tlkp_ReasonPort_furtherInfoPort]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT IF EXISTS [FK_tbl_FollowUp_tlkp_FollowUpPeriod_FUPeriodId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT IF EXISTS [FK_tbl_FollowUp_tlkp_DiabetesTreatment_DiabRxId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT IF EXISTS [FK_tbl_FollowUp_tlkp_AttemptedCalls_AttmptCallId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT IF EXISTS [FK_tbl_FollowUp_tbl_PatientOperation_OperationId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT IF EXISTS [FK_tbl_FollowUp_tbl_Patient_PatientId]
GO
/****** Object:  Table [dbo].[tbl_FollowUp]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_FollowUp]
GO
/****** Object:  Table [dbo].[tbl_FollowUp]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_FollowUp](
	[FUId] [int] IDENTITY(1,1) NOT NULL,
	[PatientId] [int] NULL,
	[OperationId] [int] NULL,
	[FUDate] [date] NULL,
	[AttmptCallId] [int] NULL,
	[SelfRptWt] [bit] NULL,
	[FUVal] [int] NULL,
	[FUPeriodId] [int] NULL,
	[BSR_to_Follow_Up] [bit] NULL,
	[BSR_to_Follow_Up_Reason] [varchar](200) NULL,
	[LTFU] [bit] NULL,
	[LTFUDate] [date] NULL,
	[FUWt] [decimal](5, 1) NULL,
	[FUBMI] [decimal](10, 1) NULL,
	[PatientFollowUpNotKnown] [bit] NULL,
	[SEId1] [bit] NULL,
	[SEId2] [bit] NULL,
	[SEId3] [bit] NULL,
	[ReasonOther] [varchar](200) NULL,
	[DiabStatId] [int] NULL,
	[DiabRxId] [int] NULL,
	[ReOpStatId] [int] NULL,
	[FurtherInfoSlip] [int] NULL,
	[FurtherInfoPort] [int] NULL,
	[Othinfo] [varchar](500) NULL,
	[EmailSentToSurg] [int] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDateTime] [datetime] NULL,
	[BatchUpdateReason] [varchar](100) NULL,
	[OpBowelObsID] [int] NULL,
 CONSTRAINT [PK_tbl_FollowUp] PRIMARY KEY CLUSTERED 
(
	[FUId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tbl_Patient_PatientId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp]  WITH CHECK ADD  CONSTRAINT [FK_tbl_FollowUp_tbl_Patient_PatientId] FOREIGN KEY([PatientId])
REFERENCES [dbo].[tbl_Patient] ([PatId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tbl_Patient_PatientId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp] CHECK CONSTRAINT [FK_tbl_FollowUp_tbl_Patient_PatientId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tbl_PatientOperation_OperationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp]  WITH CHECK ADD  CONSTRAINT [FK_tbl_FollowUp_tbl_PatientOperation_OperationId] FOREIGN KEY([OperationId])
REFERENCES [dbo].[tbl_PatientOperation] ([OpId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tbl_PatientOperation_OperationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp] CHECK CONSTRAINT [FK_tbl_FollowUp_tbl_PatientOperation_OperationId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tlkp_AttemptedCalls_AttmptCallId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp]  WITH CHECK ADD  CONSTRAINT [FK_tbl_FollowUp_tlkp_AttemptedCalls_AttmptCallId] FOREIGN KEY([AttmptCallId])
REFERENCES [dbo].[tlkp_AttemptedCalls] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tlkp_AttemptedCalls_AttmptCallId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp] CHECK CONSTRAINT [FK_tbl_FollowUp_tlkp_AttemptedCalls_AttmptCallId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tlkp_DiabetesTreatment_DiabRxId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp]  WITH CHECK ADD  CONSTRAINT [FK_tbl_FollowUp_tlkp_DiabetesTreatment_DiabRxId] FOREIGN KEY([DiabRxId])
REFERENCES [dbo].[tlkp_DiabetesTreatment] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tlkp_DiabetesTreatment_DiabRxId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp] CHECK CONSTRAINT [FK_tbl_FollowUp_tlkp_DiabetesTreatment_DiabRxId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tlkp_FollowUpPeriod_FUPeriodId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp]  WITH CHECK ADD  CONSTRAINT [FK_tbl_FollowUp_tlkp_FollowUpPeriod_FUPeriodId] FOREIGN KEY([FUPeriodId])
REFERENCES [dbo].[tlkp_FollowUpPeriod] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tlkp_FollowUpPeriod_FUPeriodId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp] CHECK CONSTRAINT [FK_tbl_FollowUp_tlkp_FollowUpPeriod_FUPeriodId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tlkp_ReasonPort_furtherInfoPort]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp]  WITH CHECK ADD  CONSTRAINT [FK_tbl_FollowUp_tlkp_ReasonPort_furtherInfoPort] FOREIGN KEY([FurtherInfoPort])
REFERENCES [dbo].[tlkp_ReasonPort] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tlkp_ReasonPort_furtherInfoPort]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp] CHECK CONSTRAINT [FK_tbl_FollowUp_tlkp_ReasonPort_furtherInfoPort]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tlkp_ReasonSlip_FurtherInfoSlip]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp]  WITH CHECK ADD  CONSTRAINT [FK_tbl_FollowUp_tlkp_ReasonSlip_FurtherInfoSlip] FOREIGN KEY([FurtherInfoSlip])
REFERENCES [dbo].[tlkp_ReasonSlip] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tlkp_ReasonSlip_FurtherInfoSlip]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp] CHECK CONSTRAINT [FK_tbl_FollowUp_tlkp_ReasonSlip_FurtherInfoSlip]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tlkp_YesNo_ReOpStatId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp]  WITH CHECK ADD  CONSTRAINT [FK_tbl_FollowUp_tlkp_YesNo_ReOpStatId] FOREIGN KEY([ReOpStatId])
REFERENCES [dbo].[tlkp_YesNo] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_FollowUp_tlkp_YesNo_ReOpStatId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp]'))
ALTER TABLE [dbo].[tbl_FollowUp] CHECK CONSTRAINT [FK_tbl_FollowUp_tlkp_YesNo_ReOpStatId]
GO
