/****** Object:  Table [dbo].[_tmpBulk]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[_tmpBulk]
GO
/****** Object:  Table [dbo].[_tmpBulk]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_tmpBulk]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[_tmpBulk](
	[FUId] [float] NULL,
	[PatientId] [float] NULL,
	[Date] [datetime] NULL
) ON [PRIMARY]
END
GO
