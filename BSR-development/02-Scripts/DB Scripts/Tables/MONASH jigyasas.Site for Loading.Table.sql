/****** Object:  Table [MONASH\jigyasas].[Site for Loading]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [MONASH\jigyasas].[Site for Loading]
GO
/****** Object:  Table [MONASH\jigyasas].[Site for Loading]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MONASH\jigyasas].[Site for Loading]') AND type in (N'U'))
BEGIN
CREATE TABLE [MONASH\jigyasas].[Site for Loading](
	[SiteName] [nvarchar](255) NULL,
	[SiteState] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Street number and name] [nvarchar](255) NULL,
	[Suburb] [nvarchar](255) NULL,
	[postcode] [float] NULL,
	[Site type (Public/Private)] [nvarchar](255) NULL,
	[Contributing] [nvarchar](255) NULL
) ON [PRIMARY]
END
GO
