/****** Object:  Table [dbo].[tmpEmailsSentNov]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tmpEmailsSentNov]
GO
/****** Object:  Table [dbo].[tmpEmailsSentNov]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tmpEmailsSentNov]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tmpEmailsSentNov](
	[FUID] [float] NULL,
	[OpID] [float] NULL,
	[PatientID] [float] NULL,
	[RecordDate] [datetime] NULL
) ON [PRIMARY]
END
GO
