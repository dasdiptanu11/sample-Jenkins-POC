IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Complications_tlkp_Procedure_ProcedureId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Complications] DROP CONSTRAINT [FK_tbl_Complications_tlkp_Procedure_ProcedureId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Device_tbl_DeviceBrand_DeviceBrandId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Device] DROP CONSTRAINT [FK_tbl_Device_tbl_DeviceBrand_DeviceBrandId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_DeviceBrand_tlkp_DeviceManufacturer_DeviceManufacturerID]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_DeviceBrand] DROP CONSTRAINT [FK_tbl_DeviceBrand_tlkp_DeviceManufacturer_DeviceManufacturerID]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_DeviceBrand_tlkp_DeviceType_TypeID]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_DeviceBrand] DROP CONSTRAINT [FK_tbl_DeviceBrand_tlkp_DeviceType_TypeID]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_FollowUp_tbl_Patient_PatientId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT [FK_tbl_FollowUp_tbl_Patient_PatientId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_FollowUp_tlkp_ReasonPort_furtherInfoPort]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT [FK_tbl_FollowUp_tlkp_ReasonPort_furtherInfoPort]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_FollowUp_tlkp_ReasonSlip_FurtherInfoSlip]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT [FK_tbl_FollowUp_tlkp_ReasonSlip_FurtherInfoSlip]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_FollowUp_tlkp_YesNo_ReOpStatId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT [FK_tbl_FollowUp_tlkp_YesNo_ReOpStatId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_FollowUp_tbl_PatientOperation_OperationId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT [FK_tbl_FollowUp_tbl_PatientOperation_OperationId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_FollowUp_tlkp_AttemptedCalls_AttmptCallId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT [FK_tbl_FollowUp_tlkp_AttemptedCalls_AttmptCallId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_FollowUp_tlkp_DeathRelatedToPrimaryProcedure_DeathRelSurgId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT [FK_tbl_FollowUp_tlkp_DeathRelatedToPrimaryProcedure_DeathRelSurgId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_FollowUp_tlkp_DiabetesTreatment_DiabRxId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT [FK_tbl_FollowUp_tlkp_DiabetesTreatment_DiabRxId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_FollowUp_tlkp_FollowUpPeriod_FUPeriodId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_FollowUp] DROP CONSTRAINT [FK_tbl_FollowUp_tlkp_FollowUpPeriod_FUPeriodId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Patient_tlkp_AboriginalStatus_AborStatusId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT [FK_tbl_Patient_tlkp_AboriginalStatus_AborStatusId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Patient_tlkp_IndigenousStatus_IndiStatusId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT [FK_tbl_Patient_tlkp_IndigenousStatus_IndiStatusId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Patient_tlkp_OptOffStatus_OptOffStatId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT [FK_tbl_Patient_tlkp_OptOffStatus_OptOffStatId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Patient_tlkp_Title_TitleId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT [FK_tbl_Patient_tlkp_Title_TitleId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Patient_tlkp_HealthStatus_HealthSatusId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT [FK_tbl_Patient_tlkp_HealthStatus_HealthSatusId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Patient_tlkp_Country_CountryId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT [FK_tbl_Patient_tlkp_Country_CountryId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Patient_tlkp_State_StateId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT [FK_tbl_Patient_tlkp_State_StateId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Patient_tlkp_Gender_GenderId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT [FK_tbl_Patient_tlkp_Gender_GenderId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Patient_tbl_User_PriSurgId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT [FK_tbl_Patient_tbl_User_PriSurgId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Patient_tbl_Site_PriSiteId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Patient] DROP CONSTRAINT [FK_tbl_Patient_tbl_Site_PriSiteId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientComplications_tbl_Complications_ComplicationId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientComplications] DROP CONSTRAINT [FK_tbl_PatientComplications_tbl_Complications_ComplicationId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientComplications_tbl_FollowUp]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientComplications] DROP CONSTRAINT [FK_tbl_PatientComplications_tbl_FollowUp]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientComplications_tlkp_Complications_ComplicationId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientComplications] DROP CONSTRAINT [FK_tbl_PatientComplications_tlkp_Complications_ComplicationId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperation_tbl_Patient_PatientId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT [FK_tbl_PatientOperation_tbl_Patient_PatientId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperation_tlkp_Procedure_LstBarProc]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT [FK_tbl_PatientOperation_tlkp_Procedure_LstBarProc]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperation_tbl_Site_Hosp]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT [FK_tbl_PatientOperation_tbl_Site_Hosp]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperation_tlkp_YesNo_LiverTx]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT [FK_tbl_PatientOperation_tlkp_YesNo_LiverTx]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperation_tlkp_YesNo_RenalTx]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT [FK_tbl_PatientOperation_tlkp_YesNo_RenalTx]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperation_tlkp_YesNoNotStated_DiabStat]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT [FK_tbl_PatientOperation_tlkp_YesNoNotStated_DiabStat]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperation_tlkp_DiabetesTreatment_DiabRx]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT [FK_tbl_PatientOperation_tlkp_DiabetesTreatment_DiabRx]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperation_tlkp_OperationStatus_OpStat]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT [FK_tbl_PatientOperation_tlkp_OperationStatus_OpStat]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperation_tlkp_Procedure_OpRevType]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT [FK_tbl_PatientOperation_tlkp_Procedure_OpRevType]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperation_tlkp_Procedure_OpType]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperation] DROP CONSTRAINT [FK_tbl_PatientOperation_tlkp_Procedure_OpType]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperationDeviceDtls_tbl_DeviceBrand_DevBrand]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] DROP CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tbl_DeviceBrand_DevBrand]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperationDeviceDtls_tbl_PatientOperation]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] DROP CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tbl_PatientOperation]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceManufacturer_DevManuf]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] DROP CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceManufacturer_DevManuf]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceType_DevType]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] DROP CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceType_DevType]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperationDeviceDtls_tlkp_PortFixationMethod]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] DROP CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_PortFixationMethod]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_PatientOperationDeviceDtls_tlkp_YesNo]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] DROP CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_YesNo]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Site_tlkp_Country_SiteCountryId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Site] DROP CONSTRAINT [FK_tbl_Site_tlkp_Country_SiteCountryId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Site_tlkp_SiteStatus]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Site] DROP CONSTRAINT [FK_tbl_Site_tlkp_SiteStatus]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Site_tlkp_SiteType_SiteTypeId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Site] DROP CONSTRAINT [FK_tbl_Site_tlkp_SiteType_SiteTypeId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_Site_tlkp_State]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_Site] DROP CONSTRAINT [FK_tbl_Site_tlkp_State]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[DBO].[FK_tbl_URN_tbl_Site_HospitalID]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [DBO].[tbl_URN] DROP CONSTRAINT [FK_tbl_URN_tbl_Site_HospitalID]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[DBO].[FK_tbl_URN_tbl_Patient_PatientID]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [DBO].[tbl_URN] DROP CONSTRAINT [FK_tbl_URN_tbl_Patient_PatientID]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_User_tlkp_Country_CountryId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_User] DROP CONSTRAINT [FK_tbl_User_tlkp_Country_CountryId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_User_tlkp_State_StateId]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_User] DROP CONSTRAINT [FK_tbl_User_tlkp_State_StateId]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[FK_tbl_User_tlkp_Title]') AND OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [dbo].[tbl_User] DROP CONSTRAINT [FK_tbl_User_tlkp_Title]
;



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tbl_Complications]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_Complications]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tbl_Device]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_Device]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tbl_DeviceBrand]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_DeviceBrand]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tbl_FollowUp]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_FollowUp]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tbl_HistoryEmail]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_HistoryEmail]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tbl_HistoryExtract]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_HistoryExtract]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tbl_HistoryLogin]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_HistoryLogin]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[DBO].[tbl_IgnorePatients]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [DBO].[tbl_IgnorePatients]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tbl_Patient]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_Patient]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tbl_PatientComplications]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_PatientComplications]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tbl_PatientOperation]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_PatientOperation]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tbl_PatientOperationDeviceDtls]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_PatientOperationDeviceDtls]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tbl_Site]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_Site]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[DBO].[tbl_URN]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [DBO].[tbl_URN]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tbl_User]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_User]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_AboriginalStatus]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_AboriginalStatus]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_AttemptedCalls]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_AttemptedCalls]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_BandType]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_BandType]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_CauseOfDeath]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_CauseOfDeath]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_Complications]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_Complications]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_Country]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_Country]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_DeviceManufacturer]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_DeviceManufacturer]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_DeviceType]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_DeviceType]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_DiabetesStatus]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_DiabetesStatus]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_DiabetesTreatment]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_DiabetesTreatment]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_FollowUp_FUVal]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_FollowUp_FUVal]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_FollowUpPeriod]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_FollowUpPeriod]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_Gender]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_Gender]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_HealthStatus]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_HealthStatus]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_IndigenousStatus]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_IndigenousStatus]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_OperationStatus]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_OperationStatus]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_OperationType]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_OperationType]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_OptOffStatus]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_OptOffStatus]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_OptOutReason]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_OptOutReason]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_PatientGroup]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_PatientGroup]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_PortFixationMethod]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_PortFixationMethod]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_Procedure]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_Procedure]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_ReasonPort]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_ReasonPort]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_ReasonSlip]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_ReasonSlip]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_SecurityQuestions]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_SecurityQuestions]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_SentinelEvent]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_SentinelEvent]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_SiteStatus]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_SiteStatus]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_SiteType]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_SiteType]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_State]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_State]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_Title]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_Title]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_YesNo]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_YesNo]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_YesNoNotknownNotStated]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_YesNoNotknownNotStated]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_YesNoNotknownRecorded]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_YesNoNotknownRecorded]
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[dbo].[tlkp_YesNoNotStated]') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [dbo].[tlkp_YesNoNotStated]
;


CREATE TABLE [dbo].[tbl_Complications] ( 
	[Id] int identity(1,1)  NOT NULL,
	[ProcedureId] int,
	[ComplicationId] int
)
;

CREATE TABLE [dbo].[tbl_Device] ( 
	[DeviceId] int identity(1,1)  NOT NULL,
	[DeviceModel] varchar(100),
	[DeviceBrandId] int,
	[DeviceDescription] varchar(100),
	[IsDeviceActive] int,
	[LastUpdatedBy] varchar(50),
	[LastUpdatedDateTime] datetime,
	[CreatedBy] varchar(50),
	[CreatedDateTime] datetime
)
;

CREATE TABLE [dbo].[tbl_DeviceBrand] ( 
	[Id] int identity(1,1)  NOT NULL,
	[Description] varchar(100),
	[ManufacturerId] int,
	[TypeID] int,
	[IsActive] int,
	[LastUpdateBy] varchar(50),
	[LastUpdateDateTime] datetime,
	[CreateBy] varchar(50),
	[CreateDateTime] datetime
)
;

CREATE TABLE [dbo].[tbl_FollowUp] ( 
	[FUId] int identity(1,1)  NOT NULL,
	[PatientId] int,
	[OperationId] int,
	[FUDate] date,
	[AttmptCallId] int,
	[SelfRptWt] bit,
	[FUVal] int,
	[FUPeriodId] int,
	[RecommendedLTFU] bit,
	[RecommendedLTFUReason] varchar(200),
	[LTFU] bit,
	[LTFUDate] date,
	[FUWt] decimal(5,1),
	[FUBMI] decimal(10,1),
	[PatientFollowUpNotKnown] bit,
	[SEId1] bit,
	[SEId2] bit,
	[SEId3] bit,
	[ReasonOther] varchar(200),
	[DiabStatId] int,
	[DiabRxId] int,
	[ReOpStatId] int,
	[FurtherInfoSlip] int,
	[FurtherInfoPort] int,
	[Othinfo] varchar(500),
	[EmailSentToSurg] int,
	[LastUpdatedBy] varchar(50),
	[LastUpdatedDateTime] datetime,
	[CreatedBy] varchar(50),
	[CreatedDateTime] datetime,
	[BatchUpdateReason] varchar(100)
)
;

CREATE TABLE [dbo].[tbl_HistoryEmail] ( 
	[Id] int identity(1,1)  NOT NULL,
	[EmailFrom] varchar(200),
	[EmailTo] varchar(200),
	[EmailCC] varchar(200),
	[EmailBcc] varchar(200),
	[Subject] varchar(500),
	[Body] varchar(max),
	[TimeStamp] datetime,
	[Status] varchar(50)
)
;

CREATE TABLE [dbo].[tbl_HistoryExtract] ( 
	[ID] int identity(1,1)  NOT NULL,
	[Username] varchar(50),
	[AttemptDateTime] datetime,
	[DataExtract] varchar(max)
)
;

CREATE TABLE [dbo].[tbl_HistoryLogin] ( 
	[ID] int identity(1,1)  NOT NULL,
	[Username] varchar(50),
	[AttemptDateTime] datetime,
	[Status] varchar(50),
	[IpAddress] varchar(50),
	[UserAgent] varchar(max)
)
;

CREATE TABLE [DBO].[tbl_IgnorePatients] ( 
	[Id] int identity(1,1)  NOT NULL,
	[PatID1] int,
	[PatID2] int
)
;

CREATE TABLE [dbo].[tbl_Patient] ( 
	[PatId] int identity(1,1)  NOT NULL,
	[LastName] varchar(40),
	[FName] varchar(40),
	[TitleId] int,
	[DOB] date,
	[DOBNotKnown] bit,
	[GenderId] int,
	[McareNo] varchar(11),
	[NoMcareNo] bit,
	[DvaNo] varchar(9),
	[NoDvaNo] bit,
	[IHI] varchar(16),
	[AborStatusId] int,
	[IndiStatusId] int,
	[NhiNo] varchar(10),
	[NoNhiNo] bit,
	[PriSiteId] int,
	[PriSurgId] int,
	[Addr] varchar(100),
	[AddrNotKnown] bit,
	[Sub] varchar(100),
	[StateId] int,
	[Pcode] varchar(4),
	[NoPcode] bit,
	[CountryId] int,
	[HomePh] varchar(30),
	[MobPh] varchar(30),
	[NoHomePh] bit,
	[NoMobPh] bit,
	[HStatId] int,
	[DateDeath] date,
	[DateDeathNotKnown] bit,
	[CauseOfDeath] varchar(200),
	[DeathRelSurgId] int,
	[DateESSent] date,
	[Undel] bit,
	[OptOffStatId] int,
	[OptOffDate] date,
	[Legacy] int,
	[LastUpdatedBy] varchar(50),
	[LastUpdatedDateTime] datetime,
	[CreatedBy] varchar(50),
	[CreatedDateTime] datetime
)
;

CREATE TABLE [dbo].[tbl_PatientComplications] ( 
	[Id] int identity(1,1)  NOT NULL,
	[FuId] int,
	[ComplicationId] int
)
;

CREATE TABLE [dbo].[tbl_PatientOperation] ( 
	[OpId] int identity(1,1)  NOT NULL,
	[PatientId] int NOT NULL,
	[Hosp] int,
	[Surg] int,
	[OpDate] date,
	[ProcAban] bit,
	[OpAge] varchar(10),
	[OpStat] int,
	[OpType] int,
	[OthPriType] varchar(50),
	[OpRevType] int,
	[OthRevType] varchar(250),
	[LstBarProc] int,
	[Ht] decimal(10,2),
	[HtNtKnown] bit,
	[StWt] decimal(10,1),
	[StWtNtKnown] bit,
	[StBMI] decimal(10,1),
	[OpWt] decimal(10,1),
	[SameOpWt] bit,
	[OpWtNtKnown] bit,
	[OpBMI] decimal(10,1),
	[DiabStat] int,
	[DiabRx] int,
	[RenalTx] int,
	[LiverTx] int,
	[Time] int,
	[OthInfoOp] varchar(500),
	[OpVal] int,
	[LastUpdatedBy] varchar(50),
	[LastUpdatedDateTime] datetime,
	[CreatedBy] varchar(50),
	[CreatedDateTime] datetime
)
;

CREATE TABLE [dbo].[tbl_PatientOperationDeviceDtls] ( 
	[PatientOperationDevId] int identity(1,1)  NOT NULL,
	[PatientOperationId] int,
	[ParentPatientOperationDevId] int,
	[DevType] int,
	[DevBrand] int,
	[DevOthBrand] varchar(100),
	[DevOthDesc] varchar(100),
	[DevOthMode] varchar(100),
	[DevManuf] int,
	[DevOthManuf] varchar(100),
	[DevId] int,
	[DevLotNo] varchar(30),
	[DevPortMethId] int,
	[PriPortRet] bit,
	[ButtressId] int,
	[IgnoreDevice] int
)
;

CREATE TABLE [dbo].[tbl_Site] ( 
	[SiteId] int identity(1,1)  NOT NULL,
	[HPIO] varchar(16),
	[SiteName] varchar(200),
	[SiteRoleName] varchar(10),
	[SitePrimaryContact] nvarchar(100),
	[SitePh1] varchar(40),
	[SiteSecondaryContact] varchar(100),
	[SitePh2] varchar(40),
	[SiteAddr] varchar(100),
	[SiteSuburb] varchar(50),
	[SiteStateId] int,
	[SitePcode] varchar(4),
	[SiteCountryId] int,
	[SiteTypeId] int,
	[SiteStatusId] int,
	[LastUpdatedBy] varchar(50),
	[LastUpdatedDateTime] datetime,
	[CreatedBy] varchar(50),
	[CreatedByDateTime] datetime
)
;

CREATE TABLE [DBO].[tbl_URN] ( 
	[URId] int identity(1,1)  NOT NULL,
	[PatientID] int NOT NULL,
	[HospitalID] int NOT NULL,
	[URNo] varchar(16) NOT NULL
)
;

CREATE TABLE [dbo].[tbl_User] ( 
	[UserId] int identity(1,1)  NOT NULL,
	[UId] uniqueidentifier,
	[TitleId] int,
	[FName] varchar(40),
	[LastName] varchar(40),
	[RoleId] varchar(16),
	[CountryId] int,
	[StateId] int,
	[SiteAccessSiteId] int,
	[HPI-I] numeric(16),
	[Email] varchar(250),
	[NoNotificationEmail] bit,
	[AccountStatusActive] int,
	[AccountStatusLocked] int,
	[LastUpdatedBy] varchar(50),
	[LastUpdatedDateTime] datetime,
	[CreatedBy] varchar(50),
	[CreatedDateTime] datetime
)
;

CREATE TABLE [dbo].[tlkp_AboriginalStatus] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_AttemptedCalls] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_BandType] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_CauseOfDeath] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_Complications] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_Country] ( 
	[Id] int NOT NULL,
	[Description] varchar(50)
)
;

CREATE TABLE [dbo].[tlkp_DeviceManufacturer] ( 
	[Id] int identity(1,1)  NOT NULL,
	[Description] varchar(100),
	[IsActive] int
)
;

CREATE TABLE [dbo].[tlkp_DeviceType] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_DiabetesStatus] ( 
	[Id] int NOT NULL,
	[Description] varchar(50)
)
;

CREATE TABLE [dbo].[tlkp_DiabetesTreatment] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_FollowUp_FUVal] ( 
	[Id] int NOT NULL,
	[Description] nvarchar(100)
)
;

CREATE TABLE [dbo].[tlkp_FollowUpPeriod] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_Gender] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_HealthStatus] ( 
	[Id] int NOT NULL,
	[Description] varchar(50)
)
;

CREATE TABLE [dbo].[tlkp_IndigenousStatus] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_OperationStatus] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_OperationType] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_OptOffStatus] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_OptOutReason] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_PatientGroup] ( 
	[Id] int NOT NULL,
	[Description] varchar(50)
)
;

CREATE TABLE [dbo].[tlkp_PortFixationMethod] ( 
	[Id] int NOT NULL,
	[Description] varchar(50)
)
;

CREATE TABLE [dbo].[tlkp_Procedure] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_ReasonPort] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_ReasonSlip] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_SecurityQuestions] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_SentinelEvent] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_SiteStatus] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_SiteType] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_State] ( 
	[Id] int NOT NULL,
	[Description] varchar(50)
)
;

CREATE TABLE [dbo].[tlkp_Title] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_YesNo] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_YesNoNotknownNotStated] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_YesNoNotknownRecorded] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;

CREATE TABLE [dbo].[tlkp_YesNoNotStated] ( 
	[Id] int NOT NULL,
	[Description] varchar(100)
)
;


ALTER TABLE [dbo].[tbl_Complications] ADD CONSTRAINT [PK_tbl_Complications] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tbl_Device] ADD CONSTRAINT [PK_tbl_Device] 
	PRIMARY KEY CLUSTERED ([DeviceId])
;

ALTER TABLE [dbo].[tbl_DeviceBrand] ADD CONSTRAINT [PK_tbl_DeviceBrand] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tbl_FollowUp] ADD CONSTRAINT [PK_tbl_FollowUp] 
	PRIMARY KEY CLUSTERED ([FUId])
;

ALTER TABLE [dbo].[tbl_HistoryEmail] ADD CONSTRAINT [PK_tbl_HistoryEmail] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tbl_HistoryExtract] ADD CONSTRAINT [PK_tbl_HistoryExtract] 
	PRIMARY KEY CLUSTERED ([ID])
;

ALTER TABLE [dbo].[tbl_HistoryLogin] ADD CONSTRAINT [PK_tbl_HistoryLogin] 
	PRIMARY KEY CLUSTERED ([ID])
;

ALTER TABLE [DBO].[tbl_IgnorePatients] ADD CONSTRAINT [PK_tbl_IgnorePatients] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tbl_Patient] ADD CONSTRAINT [PK_tbl_Patient] 
	PRIMARY KEY CLUSTERED ([PatId])
;

ALTER TABLE [dbo].[tbl_PatientComplications] ADD CONSTRAINT [PK_tbl_PatientComplications] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tbl_PatientOperation] ADD CONSTRAINT [PK_tbl_PatientOperation] 
	PRIMARY KEY CLUSTERED ([OpId])
;

ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] ADD CONSTRAINT [PK_tbl_PatientOperationDeviceDtls] 
	PRIMARY KEY CLUSTERED ([PatientOperationDevId])
;

ALTER TABLE [dbo].[tbl_Site] ADD CONSTRAINT [PK_tbl_Site] 
	PRIMARY KEY CLUSTERED ([SiteId])
;

ALTER TABLE [DBO].[tbl_URN] ADD CONSTRAINT [PK_tbl_URN] 
	PRIMARY KEY CLUSTERED ([URId])
;

ALTER TABLE [dbo].[tbl_User] ADD CONSTRAINT [PK_tbl_User] 
	PRIMARY KEY CLUSTERED ([UserId])
;

ALTER TABLE [dbo].[tlkp_AboriginalStatus] ADD CONSTRAINT [PK_tlkp_AboriginalStatus] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_AttemptedCalls] ADD CONSTRAINT [PK_tlkp_AttemptedCalls] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_BandType] ADD CONSTRAINT [PK_tlkp_BandType] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_CauseOfDeath] ADD CONSTRAINT [PK_tlkp_CauseOfDeath] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_Complications] ADD CONSTRAINT [PK_tlkp_Complications] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_Country] ADD CONSTRAINT [PK_tlkp_Country] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_DeviceManufacturer] ADD CONSTRAINT [PK_tlkp_DeviceManufacturer] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_DeviceType] ADD CONSTRAINT [PK_tlkp_DeviceType] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_DiabetesStatus] ADD CONSTRAINT [PK_tlkp_DiabetesStatus] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_DiabetesTreatment] ADD CONSTRAINT [PK_tlkp_DiabetesTreatment] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_FollowUp_FUVal] ADD CONSTRAINT [PK_tlkp_FollowUp_FUVal] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_FollowUpPeriod] ADD CONSTRAINT [PK_tlkp_FollowUpPeriod] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_Gender] ADD CONSTRAINT [PK_tbl_Gender] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_HealthStatus] ADD CONSTRAINT [PK_tlkp_HealthStatus] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_IndigenousStatus] ADD CONSTRAINT [PK_tlkp_IndigenousStatus] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_OperationStatus] ADD CONSTRAINT [PK_tlkp_OperationStatus] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_OperationType] ADD CONSTRAINT [PK_tlkp_OperationType] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_OptOffStatus] ADD CONSTRAINT [PK_tbl_OptOffStatus] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_OptOutReason] ADD CONSTRAINT [PK_tlkp_OptOutReason] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_PatientGroup] ADD CONSTRAINT [PK_tlkp_PatientGroup] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_PortFixationMethod] ADD CONSTRAINT [PK_tlkp_PortFixationMethod] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_Procedure] ADD CONSTRAINT [PK_tlkp_Procedure] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_ReasonPort] ADD CONSTRAINT [PK_tlkp_ReasonPort] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_ReasonSlip] ADD CONSTRAINT [PK_tlkp_ReasonSlip] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_SecurityQuestions] ADD CONSTRAINT [PK_tlkp_SecurityQuestions] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_SentinelEvent] ADD CONSTRAINT [PK_tlkp_SentinelEvent] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_SiteStatus] ADD CONSTRAINT [PK_tlkp_SiteStatus] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_SiteType] ADD CONSTRAINT [PK_tlkp_SiteType] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_State] ADD CONSTRAINT [PK_tlkp_State] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_Title] ADD CONSTRAINT [PK_tlkp_Title] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_YesNo] ADD CONSTRAINT [PK_tlkp_YesNo] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_YesNoNotknownNotStated] ADD CONSTRAINT [PK_tlkp_YesNoNotknownNotStated] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_YesNoNotknownRecorded] ADD CONSTRAINT [PK_tlkp_YesNoNotknownRecorded] 
	PRIMARY KEY CLUSTERED ([Id])
;

ALTER TABLE [dbo].[tlkp_YesNoNotStated] ADD CONSTRAINT [PK_tlkp_YesNoNotStated] 
	PRIMARY KEY CLUSTERED ([Id])
;



ALTER TABLE [dbo].[tbl_Complications] ADD CONSTRAINT [FK_tbl_Complications_tlkp_Procedure_ProcedureId] 
	FOREIGN KEY ([ProcedureId]) REFERENCES [dbo].[tlkp_Procedure] ([Id])
;

ALTER TABLE [dbo].[tbl_Device] ADD CONSTRAINT [FK_tbl_Device_tbl_DeviceBrand_DeviceBrandId] 
	FOREIGN KEY ([DeviceBrandId]) REFERENCES [dbo].[tbl_DeviceBrand] ([Id])
;

ALTER TABLE [dbo].[tbl_DeviceBrand] ADD CONSTRAINT [FK_tbl_DeviceBrand_tlkp_DeviceManufacturer_DeviceManufacturerID] 
	FOREIGN KEY ([ManufacturerId]) REFERENCES [dbo].[tlkp_DeviceManufacturer] ([Id])
;

ALTER TABLE [dbo].[tbl_DeviceBrand] ADD CONSTRAINT [FK_tbl_DeviceBrand_tlkp_DeviceType_TypeID] 
	FOREIGN KEY ([TypeID]) REFERENCES [dbo].[tlkp_DeviceType] ([Id])
;

ALTER TABLE [dbo].[tbl_FollowUp] ADD CONSTRAINT [FK_tbl_FollowUp_tbl_Patient_PatientId] 
	FOREIGN KEY ([PatientId]) REFERENCES [dbo].[tbl_Patient] ([PatId])
;

ALTER TABLE [dbo].[tbl_FollowUp] ADD CONSTRAINT [FK_tbl_FollowUp_tlkp_ReasonPort_furtherInfoPort] 
	FOREIGN KEY ([FurtherInfoPort]) REFERENCES [dbo].[tlkp_ReasonPort] ([Id])
;

ALTER TABLE [dbo].[tbl_FollowUp] ADD CONSTRAINT [FK_tbl_FollowUp_tlkp_ReasonSlip_FurtherInfoSlip] 
	FOREIGN KEY ([FurtherInfoSlip]) REFERENCES [dbo].[tlkp_ReasonSlip] ([Id])
;

ALTER TABLE [dbo].[tbl_FollowUp] ADD CONSTRAINT [FK_tbl_FollowUp_tlkp_YesNo_ReOpStatId] 
	FOREIGN KEY ([ReOpStatId]) REFERENCES [dbo].[tlkp_YesNo] ([Id])
;

ALTER TABLE [dbo].[tbl_FollowUp] ADD CONSTRAINT [FK_tbl_FollowUp_tbl_PatientOperation_OperationId] 
	FOREIGN KEY ([OperationId]) REFERENCES [dbo].[tbl_PatientOperation] ([OpId])
;

ALTER TABLE [dbo].[tbl_FollowUp] ADD CONSTRAINT [FK_tbl_FollowUp_tlkp_AttemptedCalls_AttmptCallId] 
	FOREIGN KEY ([AttmptCallId]) REFERENCES [dbo].[tlkp_AttemptedCalls] ([Id])
;

ALTER TABLE [dbo].[tbl_FollowUp] ADD CONSTRAINT [FK_tbl_FollowUp_tlkp_DiabetesTreatment_DiabRxId] 
	FOREIGN KEY ([DiabRxId]) REFERENCES [dbo].[tlkp_DiabetesTreatment] ([Id])
;

ALTER TABLE [dbo].[tbl_FollowUp] ADD CONSTRAINT [FK_tbl_FollowUp_tlkp_FollowUpPeriod_FUPeriodId] 
	FOREIGN KEY ([FUPeriodId]) REFERENCES [dbo].[tlkp_FollowUpPeriod] ([Id])
;

ALTER TABLE [dbo].[tbl_Patient] ADD CONSTRAINT [FK_tbl_Patient_tlkp_AboriginalStatus_AborStatusId] 
	FOREIGN KEY ([AborStatusId]) REFERENCES [dbo].[tlkp_AboriginalStatus] ([Id])
;

ALTER TABLE [dbo].[tbl_Patient] ADD CONSTRAINT [FK_tbl_Patient_tlkp_IndigenousStatus_IndiStatusId] 
	FOREIGN KEY ([IndiStatusId]) REFERENCES [dbo].[tlkp_IndigenousStatus] ([Id])
;

ALTER TABLE [dbo].[tbl_Patient] ADD CONSTRAINT [FK_tbl_Patient_tlkp_OptOffStatus_OptOffStatId] 
	FOREIGN KEY ([OptOffStatId]) REFERENCES [dbo].[tlkp_OptOffStatus] ([Id])
;

ALTER TABLE [dbo].[tbl_Patient] ADD CONSTRAINT [FK_tbl_Patient_tlkp_Title_TitleId] 
	FOREIGN KEY ([TitleId]) REFERENCES [dbo].[tlkp_Title] ([Id])
;

ALTER TABLE [dbo].[tbl_Patient] ADD CONSTRAINT [FK_tbl_Patient_tlkp_HealthStatus_HealthSatusId] 
	FOREIGN KEY ([HStatId]) REFERENCES [dbo].[tlkp_HealthStatus] ([Id])
;

ALTER TABLE [dbo].[tbl_Patient] ADD CONSTRAINT [FK_tbl_Patient_tlkp_Country_CountryId] 
	FOREIGN KEY ([CountryId]) REFERENCES [dbo].[tlkp_Country] ([Id])
;

ALTER TABLE [dbo].[tbl_Patient] ADD CONSTRAINT [FK_tbl_Patient_tlkp_State_StateId] 
	FOREIGN KEY ([StateId]) REFERENCES [dbo].[tlkp_State] ([Id])
;

ALTER TABLE [dbo].[tbl_Patient] ADD CONSTRAINT [FK_tbl_Patient_tlkp_Gender_GenderId] 
	FOREIGN KEY ([GenderId]) REFERENCES [dbo].[tlkp_Gender] ([Id])
;

ALTER TABLE [dbo].[tbl_Patient] ADD CONSTRAINT [FK_tbl_Patient_tbl_User_PriSurgId] 
	FOREIGN KEY ([PriSurgId]) REFERENCES [dbo].[tbl_User] ([UserId])
;

ALTER TABLE [dbo].[tbl_Patient] ADD CONSTRAINT [FK_tbl_Patient_tbl_Site_PriSiteId] 
	FOREIGN KEY ([PriSiteId]) REFERENCES [dbo].[tbl_Site] ([SiteId])
;

ALTER TABLE [dbo].[tbl_PatientComplications] ADD CONSTRAINT [FK_tbl_PatientComplications_tbl_Complications_ComplicationId] 
	FOREIGN KEY ([ComplicationId]) REFERENCES [dbo].[tbl_Complications] ([Id])
;

ALTER TABLE [dbo].[tbl_PatientComplications] ADD CONSTRAINT [FK_tbl_PatientComplications_tbl_FollowUp] 
	FOREIGN KEY ([FuId]) REFERENCES [dbo].[tbl_FollowUp] ([FUId])
;

ALTER TABLE [dbo].[tbl_PatientComplications] ADD CONSTRAINT [FK_tbl_PatientComplications_tlkp_Complications_ComplicationId] 
	FOREIGN KEY ([ComplicationId]) REFERENCES [dbo].[tlkp_Complications] ([Id])
;

ALTER TABLE [dbo].[tbl_PatientOperation] ADD CONSTRAINT [FK_tbl_PatientOperation_tbl_Patient_PatientId] 
	FOREIGN KEY ([PatientId]) REFERENCES [dbo].[tbl_Patient] ([PatId])
;

ALTER TABLE [dbo].[tbl_PatientOperation] ADD CONSTRAINT [FK_tbl_PatientOperation_tlkp_Procedure_LstBarProc] 
	FOREIGN KEY ([LstBarProc]) REFERENCES [dbo].[tlkp_Procedure] ([Id])
;

ALTER TABLE [dbo].[tbl_PatientOperation] ADD CONSTRAINT [FK_tbl_PatientOperation_tbl_Site_Hosp] 
	FOREIGN KEY ([Hosp]) REFERENCES [dbo].[tbl_Site] ([SiteId])
;

ALTER TABLE [dbo].[tbl_PatientOperation] ADD CONSTRAINT [FK_tbl_PatientOperation_tlkp_YesNo_LiverTx] 
	FOREIGN KEY ([LiverTx]) REFERENCES [dbo].[tlkp_YesNo] ([Id])
;

ALTER TABLE [dbo].[tbl_PatientOperation] ADD CONSTRAINT [FK_tbl_PatientOperation_tlkp_YesNo_RenalTx] 
	FOREIGN KEY ([RenalTx]) REFERENCES [dbo].[tlkp_YesNo] ([Id])
;

ALTER TABLE [dbo].[tbl_PatientOperation] ADD CONSTRAINT [FK_tbl_PatientOperation_tlkp_YesNoNotStated_DiabStat] 
	FOREIGN KEY ([DiabStat]) REFERENCES [dbo].[tlkp_YesNoNotStated] ([Id])
;

ALTER TABLE [dbo].[tbl_PatientOperation] ADD CONSTRAINT [FK_tbl_PatientOperation_tlkp_DiabetesTreatment_DiabRx] 
	FOREIGN KEY ([DiabRx]) REFERENCES [dbo].[tlkp_DiabetesTreatment] ([Id])
;

ALTER TABLE [dbo].[tbl_PatientOperation] ADD CONSTRAINT [FK_tbl_PatientOperation_tlkp_OperationStatus_OpStat] 
	FOREIGN KEY ([OpStat]) REFERENCES [dbo].[tlkp_OperationStatus] ([Id])
;

ALTER TABLE [dbo].[tbl_PatientOperation] ADD CONSTRAINT [FK_tbl_PatientOperation_tlkp_Procedure_OpRevType] 
	FOREIGN KEY ([OpRevType]) REFERENCES [dbo].[tlkp_Procedure] ([Id])
;

ALTER TABLE [dbo].[tbl_PatientOperation] ADD CONSTRAINT [FK_tbl_PatientOperation_tlkp_Procedure_OpType] 
	FOREIGN KEY ([OpType]) REFERENCES [dbo].[tlkp_Procedure] ([Id])
;

ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] ADD CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tbl_DeviceBrand_DevBrand] 
	FOREIGN KEY ([DevBrand]) REFERENCES [dbo].[tbl_DeviceBrand] ([Id])
;

ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] ADD CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tbl_PatientOperation] 
	FOREIGN KEY ([PatientOperationId]) REFERENCES [dbo].[tbl_PatientOperation] ([OpId])
;

ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] ADD CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceManufacturer_DevManuf] 
	FOREIGN KEY ([DevManuf]) REFERENCES [dbo].[tlkp_DeviceManufacturer] ([Id])
;

ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] ADD CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_DeviceType_DevType] 
	FOREIGN KEY ([DevType]) REFERENCES [dbo].[tlkp_DeviceType] ([Id])
;

ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] ADD CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_PortFixationMethod] 
	FOREIGN KEY ([DevPortMethId]) REFERENCES [dbo].[tlkp_PortFixationMethod] ([Id])
;

ALTER TABLE [dbo].[tbl_PatientOperationDeviceDtls] ADD CONSTRAINT [FK_tbl_PatientOperationDeviceDtls_tlkp_YesNo] 
	FOREIGN KEY ([ButtressId]) REFERENCES [dbo].[tlkp_YesNo] ([Id])
;

ALTER TABLE [dbo].[tbl_Site] ADD CONSTRAINT [FK_tbl_Site_tlkp_Country_SiteCountryId] 
	FOREIGN KEY ([SiteCountryId]) REFERENCES [dbo].[tlkp_Country] ([Id])
;

ALTER TABLE [dbo].[tbl_Site] ADD CONSTRAINT [FK_tbl_Site_tlkp_SiteStatus] 
	FOREIGN KEY ([SiteStatusId]) REFERENCES [dbo].[tlkp_SiteStatus] ([Id])
;

ALTER TABLE [dbo].[tbl_Site] ADD CONSTRAINT [FK_tbl_Site_tlkp_SiteType_SiteTypeId] 
	FOREIGN KEY ([SiteTypeId]) REFERENCES [dbo].[tlkp_SiteType] ([Id])
;

ALTER TABLE [dbo].[tbl_Site] ADD CONSTRAINT [FK_tbl_Site_tlkp_State] 
	FOREIGN KEY ([SiteStateId]) REFERENCES [dbo].[tlkp_State] ([Id])
;

ALTER TABLE [DBO].[tbl_URN] ADD CONSTRAINT [FK_tbl_URN_tbl_Site_HospitalID] 
	FOREIGN KEY ([HospitalID]) REFERENCES [dbo].[tbl_Site] ([SiteId])
;

ALTER TABLE [DBO].[tbl_URN] ADD CONSTRAINT [FK_tbl_URN_tbl_Patient_PatientID] 
	FOREIGN KEY ([PatientID]) REFERENCES [dbo].[tbl_Patient] ([PatId])
;

ALTER TABLE [dbo].[tbl_User] ADD CONSTRAINT [FK_tbl_User_tlkp_Country_CountryId] 
	FOREIGN KEY ([CountryId]) REFERENCES [dbo].[tlkp_Country] ([Id])
;

ALTER TABLE [dbo].[tbl_User] ADD CONSTRAINT [FK_tbl_User_tlkp_State_StateId] 
	FOREIGN KEY ([StateId]) REFERENCES [dbo].[tlkp_State] ([Id])
;

ALTER TABLE [dbo].[tbl_User] ADD CONSTRAINT [FK_tbl_User_tlkp_Title] 
	FOREIGN KEY ([TitleId]) REFERENCES [dbo].[tlkp_Title] ([Id])
;


/* Update on the schema 15-02-2016 */
--------------------------------------------
/* Add new columns to the tables */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_PatientComplications' AND COLUMN_NAME='OpId')
BEGIN
/* tbl_PatientComplications - add columns - OpId */
ALTER TABLE tbl_PatientComplications 
ADD OpId int null
END

/* Drop Foreignkey */
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
/* tbl_PatientOperation - add columns - SEId1,SEId2,SEId3 */
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

/* tbl_PatientOperation_audit - add columns - SEId1,SEId2,SEId3 */
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
/* tbl_Followup - add columns - OpEvent */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_Followup' AND COLUMN_NAME='OpEvent')
BEGIN
ALTER TABLE tbl_Followup
ADD OpEvent int null
END

/* tbl_Followup_audit - add columns - OpEvent */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='tbl_Followup_audit' AND COLUMN_NAME='OpEvent')
BEGIN
ALTER TABLE tbl_Followup_audit
ADD OpEvent int null
END
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


		

		