IF NOT EXISTS ( SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[tlkp_Procedure]') AND name = 'IsDeviceRequired')
BEGIN
ALTER TABLE [dbo].[tlkp_Procedure]
ADD IsDeviceRequired bit;
END
GO

UPDATE a
SET a.IsDeviceRequired=0
FROM [dbo].[tlkp_Procedure] a
where a.ID not in(1,2,3,4,5,6,8)
GO

UPDATE a
SET a.IsDeviceRequired=1
FROM [dbo].[tlkp_Procedure] a
where a.ID in(1,2,3,4,5,6,8)
GO