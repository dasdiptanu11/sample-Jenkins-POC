/****** Object:  Table [MONASH\jigyasas].[temp2]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [MONASH\jigyasas].[temp2]
GO
/****** Object:  Table [MONASH\jigyasas].[temp2]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MONASH\jigyasas].[temp2]') AND type in (N'U'))
BEGIN
CREATE TABLE [MONASH\jigyasas].[temp2](
	[PatientId] [int] NULL,
	[max_FUPeriodId] [int] NULL
) ON [PRIMARY]
END
GO
