/****** Object:  Table [dbo].[tbl_PatientOperationDeviceDtls_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_PatientOperationDeviceDtls_Audit]
GO
/****** Object:  Table [dbo].[tbl_PatientOperationDeviceDtls_Audit]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PatientOperationDeviceDtls_Audit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_PatientOperationDeviceDtls_Audit](
	[Action] [nvarchar](50) NULL,
	[AuditUserName] [nvarchar](50) NULL,
	[AuditDate] [datetime] NOT NULL,
	[PatientOperationDevId] [int] NOT NULL,
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
	[IgnoreDevice] [int] NULL
) ON [PRIMARY]
END
GO
