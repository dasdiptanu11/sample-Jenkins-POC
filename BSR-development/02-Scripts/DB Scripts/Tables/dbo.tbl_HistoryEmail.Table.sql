/****** Object:  Table [dbo].[tbl_HistoryEmail]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_HistoryEmail]
GO
/****** Object:  Table [dbo].[tbl_HistoryEmail]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_HistoryEmail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_HistoryEmail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmailFrom] [varchar](200) NULL,
	[EmailTo] [varchar](200) NULL,
	[EmailCC] [varchar](200) NULL,
	[EmailBcc] [varchar](200) NULL,
	[Subject] [varchar](500) NULL,
	[Body] [varchar](max) NULL,
	[TimeStamp] [datetime] NULL,
	[Status] [varchar](50) NULL,
 CONSTRAINT [PK_tbl_HistoryEmail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
