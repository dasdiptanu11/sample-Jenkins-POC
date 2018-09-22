/****** Object:  Table [dbo].[tbl_Complications_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_Complications_Audit]
GO
/****** Object:  Table [dbo].[tbl_Complications_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Complications_Audit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_Complications_Audit](
	[Action] [nvarchar](50) NULL,
	[AuditUserName] [nvarchar](50) NULL,
	[AuditDate] [datetime] NOT NULL,
	[Id] [int] NOT NULL,
	[ProcedureId] [int] NULL,
	[ComplicationId] [int] NULL
) ON [PRIMARY]
END
GO
