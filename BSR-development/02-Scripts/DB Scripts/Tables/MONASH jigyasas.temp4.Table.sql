/****** Object:  Table [MONASH\jigyasas].[temp4]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [MONASH\jigyasas].[temp4]
GO
/****** Object:  Table [MONASH\jigyasas].[temp4]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MONASH\jigyasas].[temp4]') AND type in (N'U'))
BEGIN
CREATE TABLE [MONASH\jigyasas].[temp4](
	[temp4_PatientId] [int] NOT NULL,
	[temp4_DiabRx] [int] NULL
) ON [PRIMARY]
END
GO
