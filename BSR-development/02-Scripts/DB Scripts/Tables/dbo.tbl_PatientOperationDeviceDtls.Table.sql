IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperationDeviceDtls_tlkp_YesNo]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperationDeviceDtls_tlkp_PortFixationMethod]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceType_DevType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceManufacturer_DevManuf]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperationDeviceDtls_tbl_PatientOperation]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] DROP CONSTRAINT IF EXISTS [FK_tbl_PatientOperationDeviceDtls_tbl_DeviceBrand_DevBrand]
GO
/****** Object:  Table [dbo].[tbl_PatientOperationDeviceDtls]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_PatientOperationDeviceDtls]
GO
/****** Object:  Table [dbo].[tbl_PatientOperationDeviceDtls]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_PatientOperationDeviceDtls](
	[PatientOperationDevId] [int] IDENTITY(1,1) NOT NULL,
	[PatientOperationId] [int] NULL,
	[ParentPatientOperationDevId] [int] NULL,
	[DevType] [int] NULL,
	[DevBrand] [int] NULL,
	[DevOthBrand] [varchar](100) NULL,
	[DevOthDesc] [varchar](100) NULL,
	[DevOthMode] [varchar](100) NULL,
	[DevManuf] [int] NULL,
	[DevOthManuf] [varchar](100) NULL,
	[DevId] [int] NULL,
	[DevLotNo] [varchar](30) NULL,
	[DevPortMethId] [int] NULL,
	[PriPortRet] [bit] NULL,
	[ButtressId] [int] NULL,
	[IgnoreDevice] [int] NULL,
 CONSTRAINT [PK_tbl_PatientOperationDeviceDtls] PRIMARY KEY CLUSTERED 
(
	[PatientOperationDevId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperationDeviceDtls_tbl_DeviceBrand_DevBrand]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tbl_DeviceBrand_DevBrand] FOREIGN KEY([DevBrand])
REFERENCES [dbo].[tbl_DeviceBrand] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperationDeviceDtls_tbl_DeviceBrand_DevBrand]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] CHECK CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tbl_DeviceBrand_DevBrand]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperationDeviceDtls_tbl_PatientOperation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tbl_PatientOperation] FOREIGN KEY([PatientOperationId])
REFERENCES [dbo].[tbl_PatientOperation] ([OpId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperationDeviceDtls_tbl_PatientOperation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] CHECK CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tbl_PatientOperation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceManufacturer_DevManuf]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceManufacturer_DevManuf] FOREIGN KEY([DevManuf])
REFERENCES [dbo].[tlkp_DeviceManufacturer] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceManufacturer_DevManuf]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] CHECK CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceManufacturer_DevManuf]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceType_DevType]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceType_DevType] FOREIGN KEY([DevType])
REFERENCES [dbo].[tlkp_DeviceType] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceType_DevType]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] CHECK CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceType_DevType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperationDeviceDtls_tlkp_PortFixationMethod]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_PortFixationMethod] FOREIGN KEY([DevPortMethId])
REFERENCES [dbo].[tlkp_PortFixationMethod] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperationDeviceDtls_tlkp_PortFixationMethod]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] CHECK CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_PortFixationMethod]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperationDeviceDtls_tlkp_YesNo]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_YesNo] FOREIGN KEY([ButtressId])
REFERENCES [dbo].[tlkp_YesNo] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_PatientOperationDeviceDtls_tlkp_YesNo]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls]'))
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] CHECK CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_YesNo]
GO
