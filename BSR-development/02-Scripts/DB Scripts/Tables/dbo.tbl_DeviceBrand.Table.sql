IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_DeviceBrand]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_DeviceBrand] DROP CONSTRAINT IF EXISTS [FK_tbl_DeviceBrand_tlkp_DeviceType_TypeID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_DeviceBrand]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_DeviceBrand] DROP CONSTRAINT IF EXISTS [FK_tbl_DeviceBrand_tlkp_DeviceManufacturer_DeviceManufacturerID]
GO
/****** Object:  Table [dbo].[tbl_DeviceBrand]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_DeviceBrand]
GO
/****** Object:  Table [dbo].[tbl_DeviceBrand]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_DeviceBrand]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_DeviceBrand](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
	[ManufacturerId] [int] NULL,
	[TypeID] [int] NULL,
	[IsActive] [int] NULL,
	[LastUpdateBy] [varchar](50) NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[CreateBy] [varchar](50) NULL,
	[CreateDateTime] [datetime] NULL,
 CONSTRAINT [PK_tbl_DeviceBrand] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_DeviceBrand_tlkp_DeviceManufacturer_DeviceManufacturerID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_DeviceBrand]'))
ALTER TABLE [dbo].[tbl_DeviceBrand]  WITH CHECK ADD  CONSTRAINT [FK_tbl_DeviceBrand_tlkp_DeviceManufacturer_DeviceManufacturerID] FOREIGN KEY([ManufacturerId])
REFERENCES [dbo].[tlkp_DeviceManufacturer] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_DeviceBrand_tlkp_DeviceManufacturer_DeviceManufacturerID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_DeviceBrand]'))
ALTER TABLE [dbo].[tbl_DeviceBrand] CHECK CONSTRAINT [FK_tbl_DeviceBrand_tlkp_DeviceManufacturer_DeviceManufacturerID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_DeviceBrand_tlkp_DeviceType_TypeID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_DeviceBrand]'))
ALTER TABLE [dbo].[tbl_DeviceBrand]  WITH CHECK ADD  CONSTRAINT [FK_tbl_DeviceBrand_tlkp_DeviceType_TypeID] FOREIGN KEY([TypeID])
REFERENCES [dbo].[tlkp_DeviceType] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_DeviceBrand_tlkp_DeviceType_TypeID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_DeviceBrand]'))
ALTER TABLE [dbo].[tbl_DeviceBrand] CHECK CONSTRAINT [FK_tbl_DeviceBrand_tlkp_DeviceType_TypeID]
GO
