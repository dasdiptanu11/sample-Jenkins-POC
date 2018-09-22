-- Remove foreign key constrainst for tklp_oprationStatus table
ALTER TABLE [dbo].[tbl_PatientOperation] 
DROP CONSTRAINT [FK_tbl_PatientOperation_tlkp_OperationStatus_OpStat]
GO

-- Make OpStat column nullable
ALTER TABLE  [dbo].[tbl_PatientOperation] 
ALTER COLUMN OpStat INT NULL
GO

--Add OpTypeBulkLoad column in patientOperation table
ALTER TABLE  [dbo].[tbl_PatientOperation] 
ADD OpTypeBulkLoad [int] NULL
GO

--Add OpTypeBulkLoad column in audit table
ALTER TABLE  [dbo].[tbl_PatientOperation_Audit] 
ADD OpTypeBulkLoad [int] NULL
GO