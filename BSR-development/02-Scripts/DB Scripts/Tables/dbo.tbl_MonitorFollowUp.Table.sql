/****** Object:  Table [dbo].[tbl_MonitorFollowUp]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_MonitorFollowUp]
GO
/****** Object:  Table [dbo].[tbl_MonitorFollowUp]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_MonitorFollowUp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_MonitorFollowUp](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RunDateTime] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
