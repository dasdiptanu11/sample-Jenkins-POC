/****** Object:  Table [dbo].[tbl_FollowUp_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_FollowUp_Audit]
GO
/****** Object:  Table [dbo].[tbl_FollowUp_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_FollowUp_Audit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_FollowUp_Audit](
	[Action] [nvarchar](50) NULL,
	[AuditUserName] [nvarchar](50) NULL,
	[AuditDate] [datetime] NOT NULL,
	[FUId] [int] NOT NULL,
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
	[OpBowelObsID] [int] NULL
) ON [PRIMARY]
END
GO
