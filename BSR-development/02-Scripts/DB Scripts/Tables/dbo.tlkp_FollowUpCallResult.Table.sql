/****** Object:  Table [dbo].[tlkp_FollowUpCallResult]    Script Date: 13-11-2017 03:24:50 PM ******/
DROP TABLE IF EXISTS [dbo].[tlkp_FollowUpCallResult]
GO
/****** Object:  Table [dbo].[tlkp_FollowUpCallResult]    Script Date: 13-11-2017 03:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tlkp_FollowUpCallResult]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tlkp_FollowUpCallResult](
	[Id] [int] NOT NULL,
	[Description] [varchar](100) NULL
) ON [PRIMARY]
END
GO
