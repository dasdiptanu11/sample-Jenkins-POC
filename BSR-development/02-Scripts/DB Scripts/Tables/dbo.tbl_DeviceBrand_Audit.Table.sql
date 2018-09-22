/****** Object:  Table [dbo].[tbl_DeviceBrand_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_DeviceBrand_Audit]
GO
/****** Object:  Table [dbo].[tbl_DeviceBrand_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_DeviceBrand_Audit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_DeviceBrand_Audit](
	[Action] [nvarchar](50) NULL,
	[AuditUserName] [nvarchar](50) NULL,
	[AuditDate] [datetime] NOT NULL,
	[Id] [int] NOT NULL,
	[Description] [varchar](100) NULL,
	[ManufacturerId] [int] NULL,
	[TypeID] [int] NULL,
	[IsActive] [int] NULL,
	[LastUpdateBy] [varchar](50) NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[CreateBy] [varchar](50) NULL,
	[CreateDateTime] [datetime] NULL
) ON [PRIMARY]
END
GO
