/****** Object:  Table [dbo].[tbl_IgnorePatients]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_IgnorePatients]
GO
/****** Object:  Table [dbo].[tbl_IgnorePatients]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_IgnorePatients]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_IgnorePatients](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PatID1] [int] NULL,
	[PatID2] [int] NULL,
 CONSTRAINT [PK_tbl_IgnorePatients] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
