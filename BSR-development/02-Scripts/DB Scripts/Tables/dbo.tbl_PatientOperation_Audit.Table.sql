/****** Object:  Table [dbo].[tbl_PatientOperation_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_PatientOperation_Audit]
GO
/****** Object:  Table [dbo].[tbl_PatientOperation_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperation_Audit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_PatientOperation_Audit](
	[Action] [nvarchar](50) NULL,
	[AuditUserName] [nvarchar](50) NULL,
	[AuditDate] [datetime] NOT NULL,
	[OpId] [int] NOT NULL,
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
	[OpTypeBulkLoad] [int] NULL
) ON [PRIMARY]
END
GO
