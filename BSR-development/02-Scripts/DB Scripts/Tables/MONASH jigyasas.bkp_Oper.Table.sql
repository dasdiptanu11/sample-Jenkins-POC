/****** Object:  Table [MONASH\jigyasas].[bkp_Oper]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [MONASH\jigyasas].[bkp_Oper]
GO
/****** Object:  Table [MONASH\jigyasas].[bkp_Oper]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MONASH\jigyasas].[bkp_Oper]') AND type in (N'U'))
BEGIN
CREATE TABLE [MONASH\jigyasas].[bkp_Oper](
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
	[StWt] [decimal](10, 2) NULL,
	[StWtNtKnown] [bit] NULL,
	[StBMI] [decimal](10, 2) NULL,
	[OpWt] [decimal](10, 2) NULL,
	[SameOpWt] [bit] NULL,
	[OpWtNtKnown] [bit] NULL,
	[OpBMI] [decimal](10, 2) NULL,
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
	[CreatedDateTime] [datetime] NULL
) ON [PRIMARY]
END
GO
