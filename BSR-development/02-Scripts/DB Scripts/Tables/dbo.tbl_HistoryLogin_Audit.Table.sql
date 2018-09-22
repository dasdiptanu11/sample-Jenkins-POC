/****** Object:  Table [dbo].[tbl_HistoryLogin_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_HistoryLogin_Audit]
GO
/****** Object:  Table [dbo].[tbl_HistoryLogin_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_HistoryLogin_Audit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_HistoryLogin_Audit](
	[Action] [nvarchar](50) NULL,
	[AuditUserName] [nvarchar](50) NULL,
	[AuditDate] [datetime] NOT NULL,
	[ID] [int] NOT NULL,
	[Username] [varchar](50) NULL,
	[AttemptDateTime] [datetime] NULL,
	[Status] [varchar](50) NULL,
	[IpAddress] [varchar](50) NULL,
	[UserAgent] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
