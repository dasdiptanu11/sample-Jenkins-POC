/****** Object:  Table [dbo].[tbl_Device_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_Device_Audit]
GO
/****** Object:  Table [dbo].[tbl_Device_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Device_Audit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_Device_Audit](
	[Action] [nvarchar](50) NULL,
	[AuditUserName] [nvarchar](50) NULL,
	[AuditDate] [datetime] NOT NULL,
	[DeviceId] [int] NOT NULL,
	[DeviceModel] [varchar](100) NULL,
	[DeviceBrandId] [int] NULL,
	[DeviceDescription] [varchar](100) NULL,
	[IsDeviceActive] [int] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDateTime] [datetime] NULL
) ON [PRIMARY]
END
GO
