/****** Object:  Table [MONASH\jigyasas].[temp_UpdateOperations_WithStatusNull]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [MONASH\jigyasas].[temp_UpdateOperations_WithStatusNull]
GO
/****** Object:  Table [MONASH\jigyasas].[temp_UpdateOperations_WithStatusNull]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MONASH\jigyasas].[temp_UpdateOperations_WithStatusNull]') AND type in (N'U'))
BEGIN
CREATE TABLE [MONASH\jigyasas].[temp_UpdateOperations_WithStatusNull](
	[PatID] [float] NULL,
	[Surg] [nvarchar](255) NULL,
	[Hospital] [nvarchar](255) NULL,
	[Hospital_State] [nvarchar](255) NULL,
	[OperationDate] [datetime] NULL,
	[OperationType] [nvarchar](255) NULL,
	[OperationStatus] [nvarchar](255) NULL,
	[Ht] [float] NULL,
	[StWt] [float] NULL,
	[OpWt] [float] NULL,
	[OpBMI] [float] NULL,
	[StBMI] [float] NULL,
	[DiabStat] [bit] NULL,
	[DiaxTreat] [nvarchar](255) NULL,
	[OtherInfo] [nvarchar](255) NULL,
	[Renal Tx] [bit] NOT NULL,
	[Liver Tx] [bit] NOT NULL,
	[no_] [int] NOT NULL,
	[Name] [nvarchar](255) NULL
) ON [PRIMARY]
END
GO
