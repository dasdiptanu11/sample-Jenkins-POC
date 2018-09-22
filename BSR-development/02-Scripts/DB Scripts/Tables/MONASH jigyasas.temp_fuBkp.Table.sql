/****** Object:  Table [MONASH\jigyasas].[temp_fuBkp]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [MONASH\jigyasas].[temp_fuBkp]
GO
/****** Object:  Table [MONASH\jigyasas].[temp_fuBkp]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MONASH\jigyasas].[temp_fuBkp]') AND type in (N'U'))
BEGIN
CREATE TABLE [MONASH\jigyasas].[temp_fuBkp](
	[opid] [int] NOT NULL,
	[OpDate] [date] NULL,
	[FUDate] [date] NULL,
	[FUPeriodId] [int] NULL,
	[fuVal] [int] NULL,
	[FUId] [int] NOT NULL
) ON [PRIMARY]
END
GO
