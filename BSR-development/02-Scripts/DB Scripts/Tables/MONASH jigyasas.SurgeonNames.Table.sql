/****** Object:  Table [MONASH\jigyasas].[SurgeonNames]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [MONASH\jigyasas].[SurgeonNames]
GO
/****** Object:  Table [MONASH\jigyasas].[SurgeonNames]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MONASH\jigyasas].[SurgeonNames]') AND type in (N'U'))
BEGIN
CREATE TABLE [MONASH\jigyasas].[SurgeonNames](
	[Surgeon (1)_] [nvarchar](255) NULL,
	[Title] [nvarchar](255) NULL,
	[Family Name] [nvarchar](255) NULL,
	[Given Name] [nvarchar](255) NULL,
	[Email] [nvarchar](255) NULL,
	[Contributing?] [nvarchar](255) NULL,
	[F7] [nvarchar](255) NULL
) ON [PRIMARY]
END
GO
