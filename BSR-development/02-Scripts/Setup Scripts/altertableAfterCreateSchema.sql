--alter table tbl_PatientOperation add constraint [UK_tbl_PatientOperation] UNIQUE(PatientId, SiteId);

alter table tbl_PatientOperationBSideDtls add constraint [UK_tbl_PatientOperationBSideDtls] UNIQUE(PatientOperationId,BreastSideId);

--Add 2 options in device list---
SET IDENTITY_INSERT [dbo].[tbl_Device] ON
INSERT INTO [dbo].[tbl_Device]([DeviceId],[DeviceReferenceNo]) VALUES(-88,'Not known')
INSERT INTO [dbo].[tbl_Device]([DeviceId],[DeviceReferenceNo]) VALUES(-99,'Not recorded')
INSERT INTO [dbo].[tbl_Device]([DeviceId],[DeviceReferenceNo]) VALUES(-1,'Other')
SET IDENTITY_INSERT [dbo].[tbl_Device] OFF
GO

CREATE TABLE [dbo].[tbl_HistoryLogin](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](50) NULL,
	[AttemptDateTime] [datetime] NULL,
	[Status] [varchar](50) NULL,
	[IpAddress] [varchar](50) NULL,
	[UserAgent] [varchar](max) NULL,
 CONSTRAINT [PK_tbl_HistoryLogin] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[tbl_HistoryExtract](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](50) NULL,
	[AttemptDateTime] [datetime] NULL,
	[DataExtract] [varchar](max) NULL,
 CONSTRAINT [PK_tbl_HistoryExtract] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO