/****** Object:  Table [MONASH\jigyasas].[bck_patient]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [MONASH\jigyasas].[bck_patient]
GO
/****** Object:  Table [MONASH\jigyasas].[bck_patient]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MONASH\jigyasas].[bck_patient]') AND type in (N'U'))
BEGIN
CREATE TABLE [MONASH\jigyasas].[bck_patient](
	[PatId] [int] IDENTITY(1,1) NOT NULL,
	[LastName] [varchar](40) NULL,
	[FName] [varchar](40) NULL,
	[TitleId] [int] NULL,
	[DOB] [date] NULL,
	[DOBNotKnown] [bit] NULL,
	[GenderId] [int] NULL,
	[McareNo] [varchar](11) NULL,
	[NoMcareNo] [bit] NULL,
	[DvaNo] [varchar](9) NULL,
	[NoDvaNo] [bit] NULL,
	[IHI] [varchar](16) NULL,
	[AborStatusId] [int] NULL,
	[IndiStatusId] [int] NULL,
	[NhiNo] [varchar](10) NULL,
	[NoNhiNo] [bit] NULL,
	[PriSiteId] [int] NULL,
	[PriSurgId] [int] NULL,
	[Addr] [varchar](100) NULL,
	[AddrNotKnown] [bit] NULL,
	[Sub] [varchar](100) NULL,
	[StateId] [int] NULL,
	[Pcode] [varchar](4) NULL,
	[NoPcode] [bit] NULL,
	[CountryId] [int] NULL,
	[HomePh] [varchar](30) NULL,
	[MobPh] [varchar](30) NULL,
	[NoHomePh] [bit] NULL,
	[NoMobPh] [bit] NULL,
	[HStatId] [int] NULL,
	[DateDeath] [date] NULL,
	[DateDeathNotKnown] [bit] NULL,
	[CauseOfDeath] [varchar](200) NULL,
	[DeathRelSurgId] [int] NULL,
	[DateESSent] [date] NULL,
	[Undel] [bit] NULL,
	[OptOffStatId] [int] NULL,
	[OptOffDate] [date] NULL,
	[Legacy] [int] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDateTime] [datetime] NULL
) ON [PRIMARY]
END
GO
