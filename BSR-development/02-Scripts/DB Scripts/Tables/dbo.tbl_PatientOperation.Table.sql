IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperation_tlkp_YesNoNotStated_DiabStat]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperation_tlkp_YesNo_RenalTx]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperation_tlkp_YesNo_LiverTx]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperation_tlkp_ReasonSlip_FurtherInfoSlip]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperation_tlkp_ReasonPort_FurtherInfoPort]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperation_tlkp_Procedure_OpType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperation_tlkp_Procedure_OpRevType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperation_tlkp_Procedure_LstBarProc]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperation_tlkp_DiabetesTreatment_DiabRx]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperation_tbl_Site_Hosp]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperation_tbl_Patient_PatientId]
GO
/****** Object:  Table [dbo].[tbl_PatientOperation]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_PatientOperation]
GO
/****** Object:  Table [dbo].[tbl_PatientOperation]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_PatientOperation](
	[OpId] [int] IDENTITY(1,1) NOT NULL,
	[PatientId] [int] NOT NULL,
	[Hosp] [int] NULL,
	[Surg] [int] NULL,
	[OpDate] [date] NULL,
	[ProcAban] [bit] NULL,
	[OpAge] [varchar](10) NULL,
	[OpStat] [int] NULL,
	[OpType] [int] NULL,
	[OthPriType] [varchar](50) NULL,
	[OpRevType] [int] NULL,
	[OthRevType] [varchar](250) NULL,
	[LstBarProc] [int] NULL,
	[Ht] [decimal](10, 2) NULL,
	[HtNtKnown] [bit] NULL,
	[StWt] [decimal](10, 1) NULL,
	[StWtNtKnown] [bit] NULL,
	[StBMI] [decimal](10, 1) NULL,
	[OpWt] [decimal](10, 1) NULL,
	[SameOpWt] [bit] NULL,
	[OpWtNtKnown] [bit] NULL,
	[OpBMI] [decimal](10, 1) NULL,
	[DiabStat] [int] NULL,
	[DiabRx] [int] NULL,
	[RenalTx] [int] NULL,
	[LiverTx] [int] NULL,
	[Time] [int] NULL,
	[OthInfoOp] [varchar](500) NULL,
	[OpVal] [int] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDateTime] [datetime] NULL,
	[FurtherInfoSlip] [int] NULL,
	[FurtherInfoPort] [int] NULL,
	[ReasonOther] [varchar](200) NULL,
	[OpEvent] [int] NULL,
	[AdmissionDate] [datetime] NULL,
	[DischargeDate] [datetime] NULL,
	[OpBowelObsID] [int] NULL,
	[OpTypeBulkLoad] [int] NULL,
 CONSTRAINT [PK_tbl_PatientOperation] PRIMARY KEY CLUSTERED 
(
	[OpId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tbl_Patient_PatientId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperation_tbl_Patient_PatientId] FOREIGN KEY([PatientId])
REFERENCES [dbo].[tbl_Patient] ([PatId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tbl_Patient_PatientId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation] CHECK CONSTRAINT [FK_tbl_PatientOperation_tbl_Patient_PatientId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tbl_Site_Hosp]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperation_tbl_Site_Hosp] FOREIGN KEY([Hosp])
REFERENCES [dbo].[tbl_Site] ([SiteId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tbl_Site_Hosp]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation] CHECK CONSTRAINT [FK_tbl_PatientOperation_tbl_Site_Hosp]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_DiabetesTreatment_DiabRx]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperation_tlkp_DiabetesTreatment_DiabRx] FOREIGN KEY([DiabRx])
REFERENCES [dbo].[tlkp_DiabetesTreatment] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_DiabetesTreatment_DiabRx]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation] CHECK CONSTRAINT [FK_tbl_PatientOperation_tlkp_DiabetesTreatment_DiabRx]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_Procedure_LstBarProc]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperation_tlkp_Procedure_LstBarProc] FOREIGN KEY([LstBarProc])
REFERENCES [dbo].[tlkp_Procedure] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_Procedure_LstBarProc]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation] CHECK CONSTRAINT [FK_tbl_PatientOperation_tlkp_Procedure_LstBarProc]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_Procedure_OpRevType]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperation_tlkp_Procedure_OpRevType] FOREIGN KEY([OpRevType])
REFERENCES [dbo].[tlkp_Procedure] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_Procedure_OpRevType]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation] CHECK CONSTRAINT [FK_tbl_PatientOperation_tlkp_Procedure_OpRevType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_Procedure_OpType]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperation_tlkp_Procedure_OpType] FOREIGN KEY([OpType])
REFERENCES [dbo].[tlkp_Procedure] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_Procedure_OpType]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation] CHECK CONSTRAINT [FK_tbl_PatientOperation_tlkp_Procedure_OpType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_ReasonPort_FurtherInfoPort]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperation_tlkp_ReasonPort_FurtherInfoPort] FOREIGN KEY([FurtherInfoPort])
REFERENCES [dbo].[tlkp_ReasonPort] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_ReasonPort_FurtherInfoPort]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation] CHECK CONSTRAINT [FK_tbl_PatientOperation_tlkp_ReasonPort_FurtherInfoPort]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_ReasonSlip_FurtherInfoSlip]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperation_tlkp_ReasonSlip_FurtherInfoSlip] FOREIGN KEY([FurtherInfoSlip])
REFERENCES [dbo].[tlkp_ReasonSlip] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_ReasonSlip_FurtherInfoSlip]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation] CHECK CONSTRAINT [FK_tbl_PatientOperation_tlkp_ReasonSlip_FurtherInfoSlip]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_YesNo_LiverTx]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperation_tlkp_YesNo_LiverTx] FOREIGN KEY([LiverTx])
REFERENCES [dbo].[tlkp_YesNo] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_YesNo_LiverTx]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation] CHECK CONSTRAINT [FK_tbl_PatientOperation_tlkp_YesNo_LiverTx]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_YesNo_RenalTx]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperation_tlkp_YesNo_RenalTx] FOREIGN KEY([RenalTx])
REFERENCES [dbo].[tlkp_YesNo] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_YesNo_RenalTx]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation] CHECK CONSTRAINT [FK_tbl_PatientOperation_tlkp_YesNo_RenalTx]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_YesNoNotStated_DiabStat]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperation_tlkp_YesNoNotStated_DiabStat] FOREIGN KEY([DiabStat])
REFERENCES [dbo].[tlkp_YesNoNotStated] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperation_tlkp_YesNoNotStated_DiabStat]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation]'))
ALTER TABLE [dbo].[tbl_PatientOperation] CHECK CONSTRAINT [FK_tbl_PatientOperation_tlkp_YesNoNotStated_DiabStat]
GO
