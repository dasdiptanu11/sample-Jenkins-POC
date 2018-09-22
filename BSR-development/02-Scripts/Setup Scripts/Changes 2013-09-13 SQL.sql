UPDATE tlkp_DeviceFill SET Id = 99 WHERE Id = 9
UPDATE tlkp_DeviceShape SET Id = 99 WHERE Id = 9
UPDATE tlkp_DeviceFill SET Description = 'Not Stated' WHERE Id = 99
UPDATE tlkp_DeviceShape SET Description = 'Not Stated' WHERE Id = 99
UPDATE tlkp_DeviceFill SET Id = 88 WHERE Id = 4
UPDATE tlkp_DeviceShape SET Id = 88 WHERE Id = 4
UPDATE tlkp_DeviceFill SET Description = 'Not Known' WHERE Id = 88
UPDATE tlkp_DeviceShape SET Description = 'Not Known' WHERE Id = 88

UPDATE tbl_Device SET DeviceFillId = 99  WHERE DeviceFillId = 9
UPDATE tbl_Device SET DeviceShapeId  = 99  WHERE DeviceShapeId = 9
UPDATE tbl_Device SET DeviceFillId = 88  WHERE DeviceFillId = 4
UPDATE tbl_Device SET DeviceShapeId  = 88  WHERE DeviceShapeId = 4


UPDATE tbl_PatientOperationBSideDtls SET FillOther = 99  WHERE FillOther = 9
UPDATE tbl_PatientOperationBSideDtls SET ShapeOther  = 99  WHERE ShapeOther = 9
UPDATE tbl_PatientOperationBSideDtls SET FillOther = 88  WHERE FillOther = 4
UPDATE tbl_PatientOperationBSideDtls SET ShapeOther  = 88  WHERE ShapeOther = 4


INSERT INTO [dbo].[tlkp_SiliconExtravasation] ([Id] ,[Description])  VALUES ( 4 ,'None') 	

SET IDENTITY_INSERT [dbo].[tbl_Device] ON
INSERT INTO [dbo].[tbl_Device] (DeviceId,[DeviceReferenceNo]) VALUES (-1,'Other')
SET IDENTITY_INSERT [dbo].[tbl_Device] OFF

ALTER TABLE tbl_Device ALTER COLUMN DeviceReferenceNo  VARCHAR(30) NOT NULL
ALTER TABLE tbl_Device_Audit ALTER COLUMN DeviceReferenceNo  VARCHAR(30) NOT NULL