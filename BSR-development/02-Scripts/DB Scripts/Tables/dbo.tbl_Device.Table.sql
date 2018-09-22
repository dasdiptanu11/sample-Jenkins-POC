IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Device]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_Device] DROP CONSTRAINT IF EXISTS [FK_tbl_Device_tbl_DeviceBrand_DeviceBrandId]
GO
/****** Object:  Table [dbo].[tbl_Device]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_Device]
GO
/****** Object:  Table [dbo].[tbl_Device]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Device]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_Device](
	[DeviceId] [int] IDENTITY(1,1) NOT NULL,
	[DeviceModel] [varchar](100) NULL,
	[DeviceBrandId] [int] NULL,
	[DeviceDescription] [varchar](100) NULL,
	[IsDeviceActive] [int] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDateTime] [datetime] NULL,
 CONSTRAINT [PK_tbl_Device] PRIMARY KEY CLUSTERED 
(
	[DeviceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Device_tbl_DeviceBrand_DeviceBrandId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Device]'))
ALTER TABLE [dbo].[tbl_Device]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Device_tbl_DeviceBrand_DeviceBrandId] FOREIGN KEY([DeviceBrandId])
REFERENCES [dbo].[tbl_DeviceBrand] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_Device_tbl_DeviceBrand_DeviceBrandId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_Device]'))
ALTER TABLE [dbo].[tbl_Device] CHECK CONSTRAINT [FK_tbl_Device_tbl_DeviceBrand_DeviceBrandId]
GO
