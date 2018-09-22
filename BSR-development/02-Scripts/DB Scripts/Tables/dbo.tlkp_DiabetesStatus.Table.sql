/****** Object:  Table [dbo].[tlkp_DiabetesStatus]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tlkp_DiabetesStatus]
GO
/****** Object:  Table [dbo].[tlkp_DiabetesStatus]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tlkp_DiabetesStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tlkp_DiabetesStatus](
	[Id] [int] NOT NULL,
	[Description] [varchar](50) NULL,
 CONSTRAINT [PK_tlkp_DiabetesStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
