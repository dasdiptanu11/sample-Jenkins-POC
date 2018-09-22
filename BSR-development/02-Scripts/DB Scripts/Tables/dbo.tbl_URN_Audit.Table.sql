/****** Object:  Table [dbo].[tbl_URN_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_URN_Audit]
GO
/****** Object:  Table [dbo].[tbl_URN_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_URN_Audit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_URN_Audit](
	[Action] [nvarchar](50) NULL,
	[AuditUserName] [nvarchar](50) NULL,
	[AuditDate] [datetime] NOT NULL,
	[URId] [int] NOT NULL,
	[PatientID] [int] NOT NULL,
	[HospitalID] [int] NOT NULL,
	[URNo] [varchar](16) NOT NULL
) ON [PRIMARY]
END
GO
