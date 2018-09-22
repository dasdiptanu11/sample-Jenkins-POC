/****** Object:  Table [dbo].[tbl_HistoryExtract]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_HistoryExtract]
GO
/****** Object:  Table [dbo].[tbl_HistoryExtract]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_HistoryExtract]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_HistoryExtract](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](50) NULL,
	[AttemptDateTime] [datetime] NULL,
	[DataExtract] [varchar](max) NULL,
 CONSTRAINT [PK_tbl_HistoryExtract] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
