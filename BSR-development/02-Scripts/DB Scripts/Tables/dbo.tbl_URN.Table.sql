IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_URN]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_URN] DROP CONSTRAINT IF EXISTS [FK_tbl_URN_tbl_Site_HospitalID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_URN]') AND type in (N'U'))
ALTER TABLE [dbo].[tbl_URN] DROP CONSTRAINT IF EXISTS [FK_tbl_URN_tbl_Patient_PatientID]
GO
/****** Object:  Table [dbo].[tbl_URN]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tbl_URN]
GO
/****** Object:  Table [dbo].[tbl_URN]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_URN]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_URN](
	[URId] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NOT NULL,
	[HospitalID] [int] NOT NULL,
	[URNo] [varchar](16) NOT NULL,
 CONSTRAINT [PK_tbl_URN] PRIMARY KEY CLUSTERED 
(
	[URId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_URN_tbl_Patient_PatientID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_URN]'))
ALTER TABLE [dbo].[tbl_URN]  WITH CHECK ADD  CONSTRAINT [FK_tbl_URN_tbl_Patient_PatientID] FOREIGN KEY([PatientID])
REFERENCES [dbo].[tbl_Patient] ([PatId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_URN_tbl_Patient_PatientID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_URN]'))
ALTER TABLE [dbo].[tbl_URN] CHECK CONSTRAINT [FK_tbl_URN_tbl_Patient_PatientID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_URN_tbl_Site_HospitalID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_URN]'))
ALTER TABLE [dbo].[tbl_URN]  WITH CHECK ADD  CONSTRAINT [FK_tbl_URN_tbl_Site_HospitalID] FOREIGN KEY([HospitalID])
REFERENCES [dbo].[tbl_Site] ([SiteId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_URN_tbl_Site_HospitalID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_URN]'))
ALTER TABLE [dbo].[tbl_URN] CHECK CONSTRAINT [FK_tbl_URN_tbl_Site_HospitalID]
GO
