/****** Object:  Table [MONASH\jigyasas].[WrongAttemptedCall]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [MONASH\jigyasas].[WrongAttemptedCall]
GO
/****** Object:  Table [MONASH\jigyasas].[WrongAttemptedCall]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MONASH\jigyasas].[WrongAttemptedCall]') AND type in (N'U'))
BEGIN
CREATE TABLE [MONASH\jigyasas].[WrongAttemptedCall](
	[AttemptedCalls] [nvarchar](255) NULL,
	[Opid] [int] NOT NULL,
	[FUYear] [int] NOT NULL,
	[InsertedCallID] [int] NULL
) ON [PRIMARY]
END
GO
