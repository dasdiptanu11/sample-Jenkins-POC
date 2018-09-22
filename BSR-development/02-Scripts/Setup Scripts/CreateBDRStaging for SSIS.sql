USE [MNHS-Registry-BDR-STAGING]
GO
/****** Object:  Table [dbo].[tbl_StagingBDR]    Script Date: 09/27/2013 16:56:38 ******/
DROP TABLE [dbo].[tbl_StagingBDR]
GO
/****** Object:  Table [dbo].[tbl_StagingBDR_ERR]    Script Date: 09/27/2013 16:56:39 ******/
ALTER TABLE [dbo].[tbl_StagingBDR_ERR] DROP CONSTRAINT [DF__tbl_Stagi__INSER__37703C52]
GO
DROP TABLE [dbo].[tbl_StagingBDR_ERR]
GO
/****** Object:  Table [dbo].[tbl_StagingBDR_ERR]    Script Date: 09/27/2013 16:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_StagingBDR_ERR](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FNAME] [varchar](1000) NULL,
	[Source_Error] [text] NULL,
	[Err_Code] [int] NULL,
	[Err_Message] [varchar](1000) NULL,
	[Err_Col] [int] NULL,
	[Err_Col_Name] [varchar](500) NULL,
	[INSERT_DATE] [datetime] NOT NULL DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_StagingBDR]    Script Date: 09/27/2013 16:56:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_StagingBDR](
	[FNAME] [varchar](150) NOT NULL,
	[Account_Number] [varchar](20) NOT NULL,
	[Surname] [varchar](50) NOT NULL,
	[Given_Name] [varchar](50) NOT NULL,
	[Middle_Name] [varchar](50) NULL,
	[Former_Name] [varchar](100) NULL,
	[Patient_Date_of_Birth] [date] NOT NULL,
	[Patient_Date_of_Death] [date] NOT NULL,
	[Cause_of_Death] [varchar](50) NULL,
	[Medicare_No] [varchar](15) NULL,
	[Sex_Code] [varchar](10) NULL,
	[Patient_Address_Line_1] [varchar](100) NULL,
	[Patient_Address_Line_2] [varchar](100) NULL,
	[Patient_Suburb] [varchar](50) NULL,
	[Patient_State] [varchar](10) NOT NULL,
	[Patient_Post_Code] [varchar](10) NOT NULL,
	[Patient_Phone_home] [varchar](40) NULL,
	[Patient_Phone_work] [varchar](40) NULL,
	[Patient_Phone_mobile] [varchar](40) NULL,
	[Email] [varchar](50) NULL,
	[NOK_Surname] [varchar](50) NULL,
	[NOK_Given_Name] [varchar](50) NULL,
	[NOK_Relationship_to_patient] [varchar](10) NULL,
	[NOK_Address_Line_1] [varchar](100) NULL,
	[NOK_Address_Line_2] [varchar](100) NULL,
	[NOK_Suburb] [varchar](50) NULL,
	[NOK_State] [varchar](10) NOT NULL,
	[NOK_Post_Code] [varchar](10) NOT NULL,
	[NOK_Phone_Home] [varchar](40) NULL,
	[NOK_Phone_Work] [varchar](40) NULL,
	[NOK_Phone_Mobile] [varchar](40) NULL,
	[Operation_Date] [date] NOT NULL,
	[Discharge_Date] [date] NULL,
	[Preferred_Language] [varchar](10) NULL,
	[Surgeon_Title] [varchar](10) NOT NULL,
	[Surgeon_Surname] [varchar](50) NOT NULL,
	[Surgeon_Given_Name] [varchar](50) NOT NULL,
	[Procedure_Code_1] [varchar](15) NULL,
	[Procedure_Code_2] [varchar](15) NULL,
	[Procedure_Code_3] [varchar](15) NULL,
	[Procedure_Code_4] [varchar](15) NULL,
	[Diagnosis_Code_1] [varchar](15) NULL,
	[Diagnosis_Code_2] [varchar](15) NULL,
	[Diagnosis_Code_3] [varchar](15) NULL,
	[Diagnosis_Code_4] [varchar](15) NULL,
	[Hospital_Code] [varchar](10) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
