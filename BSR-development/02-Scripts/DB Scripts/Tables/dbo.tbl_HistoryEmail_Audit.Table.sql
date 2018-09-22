/****** Object:  Table [dbo].[tbl_HistoryEmail_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_HistoryEmail_Audit]
GO
/****** Object:  Table [dbo].[tbl_HistoryEmail_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_HistoryEmail_Audit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_HistoryEmail_Audit](
	[Action] [nvarchar](50) NULL,
	[AuditUserName] [nvarchar](50) NULL,
	[AuditDate] [datetime] NOT NULL,
	[Id] [int] NOT NULL,
	[EmailFrom] [varchar](200) NULL,
	[EmailTo] [varchar](200) NULL,
	[EmailCC] [varchar](200) NULL,
	[EmailBcc] [varchar](200) NULL,
	[Subject] [varchar](500) NULL,
	[Body] [varchar](max) NULL,
	[TimeStamp] [datetime] NULL,
	[Status] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
