/* Update on the schema 15-02/2016 */
--------------------------------------------
/* Add new columns to the tables */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientComplications' AND COLUMN_NAME='OpId')
BEGIN
/* tbl_PatientComplications - add columns - OpId */
ALTER TABLE tbl_PatientComplications 
ADD OpId int null
END

/* Drop Foreginkey */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientComplications_tbl_PatientOperation_OpId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientComplications] DROP CONSTRAINT [FK_tbl_PatientComplications_tbl_PatientOperation_OpId]
;
/* Add Foreignkey */
ALTER TABLE [dbo].[tbl_PatientComplications] ADD CONSTRAINT [FK_tbl_PatientComplications_tbl_PatientOperation_OpId] 
	FOREIGN KEY ([OpId]) REFERENCES [dbo].[tbl_PatientOperation] ([OpId])
;


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientComplications_audit' AND COLUMN_NAME='OpId')
BEGIN
/* tbl_PatientComplications_audit - add columns - OpId */
ALTER TABLE tbl_PatientComplications_audit 
ADD  OpId int null
END

------------------------------------------------------
/* tbl_PatientOperation - add columns - SEId1,SEId2,SEId3 
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientOperation' AND COLUMN_NAME='SEId1')
BEGIN
ALTER TABLE tbl_PatientOperation 
ADD  SEId1 bit null
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientOperation' AND COLUMN_NAME='SEId2')
BEGIN
ALTER TABLE tbl_PatientOperation 
ADD  SEId2 bit null
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientOperation' AND COLUMN_NAME='SEId3')
BEGIN
ALTER TABLE tbl_PatientOperation 
ADD  SEId3 bit null
END
*/
/* tbl_PatientOperation_audit - add columns - SEId1,SEId2,SEId3 
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientOperation_audit' AND COLUMN_NAME='SEId1')
BEGIN
ALTER TABLE tbl_PatientOperation_audit 
ADD  SEId1 bit null
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientOperation_audit' AND COLUMN_NAME='SEId2')
BEGIN
ALTER TABLE tbl_PatientOperation_audit 
ADD  SEId2 bit null
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientOperation_audit' AND COLUMN_NAME='SEId3')
BEGIN
ALTER TABLE tbl_PatientOperation_audit 
ADD  SEId3 bit null
END
*/


----------------------------------------------
/* Add new columns to the tables */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientOperation' AND COLUMN_NAME='FurtherInfoSlip')
BEGIN
/* tbl_PatientOperation - add columns - FurtherInfoSlip */
ALTER TABLE tbl_PatientOperation 
ADD FurtherInfoSlip int null
END

/* Drop Foreginkey */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperation_tlkp_ReasonSlip_FurtherInfoSlip]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT [FK_tbl_PatientOperation_tlkp_ReasonSlip_FurtherInfoSlip]
;
/* Add Foreignkey */
ALTER TABLE [dbo].[tbl_PatientOperation] ADD CONSTRAINT [FK_tbl_PatientOperation_tlkp_ReasonSlip_FurtherInfoSlip] 
	FOREIGN KEY ([FurtherInfoSlip]) REFERENCES [dbo].[tlkp_ReasonSlip] ([Id])
;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientOperation_audit' AND COLUMN_NAME='FurtherInfoSlip')
BEGIN
/* tbl_PatientOperation_audit - add columns - OpId */
ALTER TABLE tbl_PatientOperation_audit 
ADD  FurtherInfoSlip int null
END

-------------------------------------------------

/* Add new columns to the tables */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientOperation' AND COLUMN_NAME='FurtherInfoPort')
BEGIN
/* tbl_PatientOperation - add columns - FurtherInfoPort */
ALTER TABLE tbl_PatientOperation 
ADD FurtherInfoPort int null
END

/* Drop Foreginkey */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperation_tlkp_ReasonPort_FurtherInfoPort]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT [FK_tbl_PatientOperation_tlkp_ReasonPort_FurtherInfoPort]
;
/* Add Foreignkey */
ALTER TABLE [dbo].[tbl_PatientOperation] ADD CONSTRAINT [FK_tbl_PatientOperation_tlkp_ReasonPort_FurtherInfoPort] 
	FOREIGN KEY ([FurtherInfoPort]) REFERENCES [dbo].[tlkp_ReasonPort] ([Id])
;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientOperation_audit' AND COLUMN_NAME='FurtherInfoPort')
BEGIN
/* tbl_PatientOperation_audit - add columns - OpId */
ALTER TABLE tbl_PatientOperation_audit 
ADD  FurtherInfoPort int null
END

-----------------------------------------------------

/* Add new columns to the tables */
/* tbl_PatientOperation - add columns - ReasonOther */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientOperation' AND COLUMN_NAME='ReasonOther')
BEGIN
ALTER TABLE tbl_PatientOperation 
ADD ReasonOther varchar(200) null
END


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientOperation' AND COLUMN_NAME='OpEvent')
BEGIN
ALTER TABLE tbl_patientoperation
ADD OpEvent int null
END

/* tbl_PatientComplications_audit - add columns - ReasonOther */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientOperation_audit' AND COLUMN_NAME='ReasonOther')
BEGIN
ALTER TABLE tbl_PatientOperation_audit 
ADD ReasonOther varchar(200) null
END


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_patientoperation_audit' AND COLUMN_NAME='OpEvent')
BEGIN
ALTER TABLE tbl_patientoperation_audit
ADD OpEvent int null
END

--------------------------------------------------------

/* Add new columns to the tables */
/* tbl_Followup - add columns - ReasonOther */
/*
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_Followup' AND COLUMN_NAME='OpEvent')
BEGIN
ALTER TABLE tbl_Followup
ADD OpEvent int null
END
*/

/* tbl_PatientComplications_audit - add columns - ReasonOther */
/*
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_Followup_audit' AND COLUMN_NAME='OpEvent')
BEGIN
ALTER TABLE tbl_Followup_audit
ADD OpEvent int null
END
*/
-------------------------------------------------------

/* Add new columns to the tables */
/* Add column EAD to tbl_Site */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_Site' AND COLUMN_NAME='EAD')
BEGIN
ALTER TABLE tbl_Site
ADD EAD date NULL
END

/* Add column EAD to tbl_Site_audit */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_Site_audit' AND COLUMN_NAME='EAD')
BEGIN
ALTER TABLE tbl_Site_audit
ADD EAD date NULL
END
---------------------------------------------------------

/* Rename columns in the table - tbl_followup */
IF EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='tbl_followup' AND COLUMN_NAME='RecommendedLTFU')
BEGIN
EXEC sp_RENAME 'tbl_followup.RecommendedLTFU' , 'BSR_to_Follow_Up', 'COLUMN'
END

IF EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='tbl_followup' AND COLUMN_NAME='RecommendedLTFUReason')
BEGIN
EXEC sp_RENAME 'tbl_followup.RecommendedLTFUReason' , 'BSR_to_Follow_Up_Reason', 'COLUMN'
END

/* Rename columns in the table - tbl_FollowUp_Audit */
IF EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='tbl_FollowUp_Audit' AND COLUMN_NAME='RecommendedLTFU')
BEGIN
EXEC sp_RENAME 'tbl_FollowUp_Audit.RecommendedLTFU' , 'BSR_to_Follow_Up', 'COLUMN'
END

IF EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='tbl_FollowUp_Audit' AND COLUMN_NAME='RecommendedLTFUReason')
BEGIN
EXEC sp_RENAME 'tbl_FollowUp_Audit.RecommendedLTFUReason' , 'BSR_to_Follow_Up_Reason', 'COLUMN'
END
---------------------------------------------------------
		

