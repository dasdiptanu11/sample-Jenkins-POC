/****** Object:  View [dbo].[vw_ref_tbl_Device]    Script Date: 13-11-2017 03:48:16 PM ******/
DROP VIEW [dbo].[vw_ref_tbl_Device]
GO
/****** Object:  View [dbo].[vw_ref_tbl_Device]    Script Date: 13-11-2017 03:48:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ref_tbl_Device]
AS
SELECT [DeviceId]
      ,[DeviceModel]
      ,[DeviceBrandId]
      ,[DeviceDescription]
      ,[IsDeviceActive]    
  FROM [dbo].[tbl_Device]

GO
