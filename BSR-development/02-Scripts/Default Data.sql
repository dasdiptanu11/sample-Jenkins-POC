USE [MNHS-Registry-BSR];
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_AboriginalStatus]([Id], [Description])
SELECT 1, N'Neither Aboriginal nor Torres Strait Islander' UNION ALL
SELECT 2, N'Aboriginal' UNION ALL
SELECT 3, N'Torres Strait Islander' UNION ALL
SELECT 4, N'Both Aboriginal & Torres Strait Islander' UNION ALL
SELECT 5, N'Unknown'
COMMIT;
RAISERROR (N'[dbo].[tlkp_AboriginalStatus]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO


BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_AttemptedCalls]([Id], [Description])
SELECT 1, N'1' UNION ALL
SELECT 2, N'2' UNION ALL
SELECT 3, N'3' UNION ALL
SELECT 4, N'4' UNION ALL
SELECT 5, N'5'
COMMIT;
RAISERROR (N'[dbo].[tlkp_AttemptedCalls]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO



BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_Country]([Id], [Description])
SELECT 1, N'Australia' UNION ALL
SELECT 2, N'New Zealand'
COMMIT;
RAISERROR (N'[dbo].[tlkp_Country]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO


BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_Complications]([Id], [Description])
SELECT 1, N'Prolapse/Slip' UNION ALL
SELECT 2, N'Symmetrical pouch dilatation' UNION ALL
SELECT 3, N'Erosion of Band' UNION ALL
SELECT 4, N'Gastric Perforation' UNION ALL
SELECT 5, N'Infected Gastric Band' UNION ALL
SELECT 6, N'Leak from Gastric Band' UNION ALL
SELECT 7, N'Malposition of Band' UNION ALL
SELECT 8, N'Port' UNION ALL
SELECT 9, N'Band unbuckled' UNION ALL
SELECT 10, N'Wound dehiscence' UNION ALL
SELECT 11, N'Wound infection' UNION ALL
SELECT 12, N'DVT/PE' UNION ALL
SELECT 13, N'Haemorrhage' UNION ALL
SELECT 14, N'Torsion' UNION ALL
SELECT 15, N'Staple line haemorrhage' UNION ALL
SELECT 16, N'Leak' UNION ALL
SELECT 17, N'Refractory Reflux' UNION ALL
SELECT 18, N'Dysphagia NOS' UNION ALL
SELECT 19, N'Haemorrhage NOS' UNION ALL
SELECT 20, N'Internal hernia' UNION ALL
SELECT 21, N'Malnutrition' UNION ALL
SELECT 22, N'Suture line hernia' UNION ALL
SELECT 23, N'Perforation' UNION ALL
SELECT 24, N'Pouch dilatation' UNION ALL
SELECT 25, N'Sternal stenosis' UNION ALL
SELECT 26, N'Staple line failure' UNION ALL
SELECT 27, N'Other' UNION ALL
SELECT 28, N'Bowel Perforation'
COMMIT;
RAISERROR (N'[dbo].[tlkp_Complications]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_CauseOfDeath]([Id], [Description])
SELECT -1, N'Unable to be ascertained' UNION ALL
SELECT 1, N'Definitely or probably related to breast implant' UNION ALL
SELECT 2, N'Unlikely or not related tobreast implant'
COMMIT;
RAISERROR (N'[dbo].[tlkp_CauseOfDeath]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO


SET IDENTITY_INSERT [dbo].[tlkp_DeviceManufacturer] ON;

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_DeviceManufacturer]([Id], [Description], [IsActive])
SELECT 1, N'Apollo Endosurgery', 1 UNION ALL
SELECT 2, N'Bariatric Solutions', 1 UNION ALL
SELECT 3, N'Cousin Biotech', 1 UNION ALL
SELECT 4, N'Covidien', 1 UNION ALL
SELECT 5, N'Ethicon Endosurgery', 1 UNION ALL
SELECT 6, N'Helioscopie/Matrix Surgical', 1 UNION ALL
SELECT 7, N'Life Healthcare Australia', 1 UNION ALL
SELECT 8, N'Existing Device', 1
COMMIT;
RAISERROR (N'[dbo].[tlkp_DeviceManufacturer]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

SET IDENTITY_INSERT [dbo].[tlkp_DeviceManufacturer] OFF;


BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_DeviceType]([Id], [Description])
SELECT 0, N'Gastric Band' UNION ALL
SELECT 1, N'Access Port Alone' UNION ALL
SELECT 2, N'Port Fixation Device' UNION ALL
SELECT 3, N'Stapling Device' UNION ALL
SELECT 4, N'Tubing Repair Kit' UNION ALL
SELECT 5, N'Fixed Gastric Ring' UNION ALL
SELECT 6, N'Existing Device'
COMMIT;
RAISERROR (N'[dbo].[tlkp_DeviceType]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO



BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_DiabetesTreatment]([Id], [Description])
SELECT 1, N'Diet/exercise' UNION ALL
SELECT 2, N'Non-Insulin therapy (single)' UNION ALL
SELECT 3, N'Non-Insulin therapy (multiple)' UNION ALL
SELECT 4, N'Insulin' UNION ALL
SELECT 5, N'Not stated'
COMMIT;
RAISERROR (N'[dbo].[tlkp_DiabetesTreatment]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO


BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_FollowUp_FUVal]([Id], [Description])
SELECT 0, N'Incomplete' UNION ALL
SELECT 1, N'Incomplete - WIP' UNION ALL
SELECT 2, N'Completed' UNION ALL
SELECT 3, N'Not Applicable' UNION ALL
SELECT 4, N'Not Due' UNION ALL
SELECT 5, N'Auto Complete'
COMMIT;
RAISERROR (N'[dbo].[tlkp_FollowUp_FUVal]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_FollowUpPeriod]([Id], [Description])
SELECT 0, N'Periop' UNION ALL
SELECT 1, N'1yr' UNION ALL
SELECT 2, N'2yr' UNION ALL
SELECT 3, N'3yr' UNION ALL
SELECT 4, N'4yr' UNION ALL
SELECT 5, N'5yr' UNION ALL
SELECT 6, N'6yr' UNION ALL
SELECT 7, N'7yr' UNION ALL
SELECT 8, N'8yr' UNION ALL
SELECT 9, N'9yr' UNION ALL
SELECT 10, N'10yr'
COMMIT;
RAISERROR (N'[dbo].[tlkp_FollowUpPeriod]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_Gender]([Id], [Description])
SELECT 1, N'Male' UNION ALL
SELECT 2, N'Female' UNION ALL
SELECT 3, N'Intersex or indeterminate'
COMMIT;
RAISERROR (N'[dbo].[tlkp_Gender]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_HealthStatus]([Id], [Description])
SELECT 0, N'Alive' UNION ALL
SELECT 1, N'Deceased'
COMMIT;
RAISERROR (N'[dbo].[tlkp_HealthStatus]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO





BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_IndigenousStatus]([Id], [Description])
SELECT 1, N'Neither Maori nor Pacific Islander' UNION ALL
SELECT 2, N'Maori' UNION ALL
SELECT 3, N'Pacific Islander' UNION ALL
SELECT 4, N'Both Maori & Pacific Islander' UNION ALL
SELECT 5, N'Other' UNION ALL
SELECT 6, N'Unknown'
COMMIT;
RAISERROR (N'[dbo].[tlkp_IndigenousStatus]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_OperationStatus]([Id], [Description])
SELECT 0, N'Primary bariatric procedure' UNION ALL
SELECT 1, N'Revision bariatric procedure'
COMMIT;
RAISERROR (N'[dbo].[tlkp_OperationStatus]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_OperationType]([Id], [Description])
SELECT 1, N'Primary' UNION ALL
SELECT 2, N'Revision'
COMMIT;
RAISERROR (N'[dbo].[tlkp_OperationType]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_OptOffStatus]([Id], [Description])
SELECT 0, N'Consented and Current' UNION ALL
SELECT 1, N'Fully Opted Off' UNION ALL
SELECT 2, N'Consented and Partially Opted off' UNION ALL
SELECT 3, N'Pending Consent' UNION ALL
SELECT 4, N'Consented and LTFU'
COMMIT;
RAISERROR (N'[dbo].[tlkp_OptOffStatus]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_OptOutReason]([Id], [Description])
SELECT 1, N'Not interested' UNION ALL
SELECT 2, N'Concerned about data privacy' UNION ALL
SELECT 3, N'Unable to consent' UNION ALL
SELECT 4, N'Lost contact' UNION ALL
SELECT 5, N'Other'
COMMIT;
RAISERROR (N'[dbo].[tlkp_OptOutReason]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO


BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_PatientGroup]([Id], [Description])
SELECT 0, N'Primary Patients' UNION ALL
SELECT 1, N'Legacy Patients'
COMMIT;
RAISERROR (N'[dbo].[tlkp_PatientGroup]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_PortFixationMethod]([Id], [Description])
SELECT 1, N'Port fixation Device' UNION ALL
SELECT 2, N'Mesh' UNION ALL
SELECT 3, N'Suture' UNION ALL
SELECT 4, N'Not Used' UNION ALL
SELECT 5, N'Unknown'
COMMIT;
RAISERROR (N'[dbo].[tlkp_PortFixationMethod]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_Procedure]([Id], [Description])
SELECT 1, N'Gastric banding' UNION ALL
SELECT 2, N'Gastroplasty' UNION ALL
SELECT 3, N'R-Y gastric bypass' UNION ALL
SELECT 4, N'Single anastomosis gastric bypass' UNION ALL
SELECT 5, N'Sleeve gastrectomy' UNION ALL
SELECT 6, N'Bilio pancreatic bypass/duodenal switch' UNION ALL
SELECT 7, N'Gastric imbrication' UNION ALL
SELECT 8, N'Gastric imbrication, plus gastric band (iBand)' UNION ALL
SELECT 9, N'Other (specify)' UNION ALL
SELECT 10, N'Port revision' UNION ALL
SELECT 11, N'Surgical reversal' UNION ALL
SELECT 99, N'Not stated/inadequately described'
COMMIT;
RAISERROR (N'[dbo].[tlkp_Procedure]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO



BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_ReasonPort]([Id], [Description])
SELECT 1, N'Leak baseplate' UNION ALL
SELECT 2, N'Tubing problem' UNION ALL
SELECT 3, N'Needlestick injury' UNION ALL
SELECT 4, N'Infection' UNION ALL
SELECT 5, N'Detached' UNION ALL
SELECT 6, N'Difficult access' UNION ALL
SELECT 7, N'NOS' UNION ALL
SELECT 8, N'Haematoma/Seroma' UNION ALL
SELECT 9, N'LEAK NOS'
COMMIT;
RAISERROR (N'[dbo].[tlkp_ReasonPort]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO




BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_ReasonSlip]([Id], [Description])
SELECT 1, N'Anterior' UNION ALL
SELECT 2, N'Posterior' UNION ALL
SELECT 3, N'Unspecified'
COMMIT;
RAISERROR (N'[dbo].[tlkp_ReasonSlip]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO



BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_SecurityQuestions]([Id], [Description])
SELECT 1, N'First pet''s name?' UNION ALL
SELECT 2, N'First school attended?' UNION ALL
SELECT 3, N'First occupation?' UNION ALL
SELECT 4, N'First teacher''s name?' UNION ALL
SELECT 5, N'First car?'
COMMIT;
RAISERROR (N'[dbo].[tlkp_SecurityQuestions]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO


BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_SentinelEvent]([Id], [Description])
SELECT 1, N'Unplanned return to theatre' UNION ALL
SELECT 2, N'Unplanned ICU admission' UNION ALL
SELECT 3, N'Unplanned re-admission to hospital'
COMMIT;
RAISERROR (N'[dbo].[tlkp_SentinelEvent]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_SiteStatus]([Id], [Description])
SELECT 1, N'Participating' UNION ALL
SELECT 2, N'Pending'
COMMIT;
RAISERROR (N'[dbo].[tlkp_SiteStatus]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO


BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_State]([Id], [Description])
SELECT 1, N'NSW' UNION ALL
SELECT 2, N'VIC' UNION ALL
SELECT 3, N'QLD' UNION ALL
SELECT 4, N'SA' UNION ALL
SELECT 5, N'WA' UNION ALL
SELECT 6, N'TAS' UNION ALL
SELECT 7, N'NT' UNION ALL
SELECT 8, N'ACT' UNION ALL
SELECT 9, N'Other territories'
COMMIT;
RAISERROR (N'[dbo].[tlkp_State]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_Title]([Id], [Description])
SELECT 1, N'Mr' UNION ALL
SELECT 2, N'Ms' UNION ALL
SELECT 3, N'Mrs' UNION ALL
SELECT 4, N'Miss' UNION ALL
SELECT 5, N'Dr' UNION ALL
SELECT 6, N'Prof' UNION ALL
SELECT 7, N'A/Prof'
COMMIT;
RAISERROR (N'[dbo].[tlkp_Title]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_YesNo]([Id], [Description])
SELECT 0, N'No' UNION ALL
SELECT 1, N'Yes'
COMMIT;
RAISERROR (N'[dbo].[tlkp_YesNo]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_YesNoNotknownNotStated]([Id], [Description])
SELECT 0, N'No' UNION ALL
SELECT 1, N'Yes' UNION ALL
SELECT 88, N'Not known' UNION ALL
SELECT 99, N'Not stated'
COMMIT;
RAISERROR (N'[dbo].[tlkp_YesNoNotknownNotStated]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO


BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_SiteType]([Id], [Description])
SELECT 1, N'Public' UNION ALL
SELECT 2, N'Private'
COMMIT;
RAISERROR (N'[dbo].[tlkp_SiteType]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO



SET IDENTITY_INSERT [dbo].[tbl_Site] ON;

BEGIN TRANSACTION;
INSERT INTO [dbo].[tbl_Site]([SiteId], [HPIO], [SiteName], [SiteRoleName], [SitePrimaryContact], [SitePh1], [SiteSecondaryContact], [SitePh2], [SiteAddr], [SiteSuburb], [SiteStateId], [SitePcode], [SiteCountryId], [SiteTypeId], [SiteStatusId], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedByDateTime], [EAD])
SELECT 1, NULL, N'Ashford Private', N'S_1', N'', N'', N'', N'', N'55-57 Anzac Highway', N' Ashford', 4, N'5035', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140728 00:00:00.000' UNION ALL
SELECT 2, NULL, N'Austin Hospital', N'S_2', N'', N'', N'', N'', N'145 Studley Road', N'Heidelberg', 2, N'3084', 1, 1, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20141111 00:00:00.000' UNION ALL
SELECT 3, NULL, N'Austin Repatriation', N'S_3', N'', N'', N'', N'', N'300 Waterdale Road  ', N'Heidelberg', 2, N'3081', 1, 1, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20141111 00:00:00.000' UNION ALL
SELECT 4, NULL, N'BHH', N'S_4', N'', N'', N'', N'', N'8 Arnold Street', N'Box Hill', 2, N'3128', 1, 1, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20130403 00:00:00.000' UNION ALL
SELECT 5, NULL, N'Cabrini Brighton', N'S_5', N'', N'', N'', N'', N'243 New Street', N'Brighton', 2, N'3186', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150227 00:00:00.000' UNION ALL
SELECT 6, NULL, N'Cabrini Malvern', N'S_6', N'', N'', N'', N'', N'181-183 Wattletree Road', N'Malvern', 2, N'3144', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150227 00:00:00.000' UNION ALL
SELECT 7, NULL, N'Calvary St Vincent''s Launceston', N'S_7', N'', N'', N'', N'', N'5 Frederick Street', N'Launceston', 6, N'7250', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140924 00:00:00.000' UNION ALL
SELECT 8, NULL, N'Calvary North Adelaide', N'S_8', N'', N'', N'', N'', N'89 Strangways Terrace North ', N'Adelaide ', 4, N'5006', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150112 00:00:00.000' UNION ALL
SELECT 9, NULL, N'Calvary Riverina', N'S_9', N'', N'', N'', N'', N' 36 Hardy Ave', N'Wagga Wagga', 1, N'2650', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140801 00:00:00.000' UNION ALL
SELECT 10, NULL, N'Calvary Wakefield', N'S_10', N'', N'', N'', N'', N'300 Wakefield Street', N'Adelaide', 4, N'5000', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150128 00:00:00.000' UNION ALL
SELECT 11, NULL, N'Concord RGH', N'S_11', N'', N'', N'', N'', N'1A Hospital Road', N'Concord', 1, N'2139', 1, 1, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20141009 00:00:00.000' UNION ALL
SELECT 12, NULL, N'Epworth Eastern', N'S_12', N'', N'', N'', N'', N'1 Arnold Street', N'Box Hill ', 2, N'3128', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140331 00:00:00.000' UNION ALL
SELECT 13, NULL, N'Epworth Freemasons', N'S_13', N'', N'', N'', N'', N'320 Victoria Parade', N'East Melbourne', 2, N'3002', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140825 00:00:00.000' UNION ALL
SELECT 14, NULL, N'Epworth Richmond', N'S_14', N'', N'', N'', N'', N'
89 Bridge Road', N'Richmond', 2, N'3121', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140331 00:00:00.000' UNION ALL
SELECT 15, NULL, N'Flinders MC', N'S_15', N'', N'', N'', N'', N' Flinders Dr', N'Bedford Park ', 4, N'5042', 1, 1, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140815 00:00:00.000' UNION ALL
SELECT 16, NULL, N'Flinders Private', N'S_16', N'', N'', N'', N'', N'1 Flinders Drive', N'Bedford Park', 4, N'5042', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140916 00:00:00.000' UNION ALL
SELECT 17, NULL, N'Hamilton', N'S_17', N'', N'', N'', N'', N'20 Foster Street', N'Hamilton', 2, N'3300', 1, 1, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140620 00:00:00.000' UNION ALL
SELECT 18, NULL, N'Hobart Private', N'S_18', N'', N'', N'', N'', N'Corner Argyle & Collins Streets', N'Hobart', 6, N'7000', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140805 00:00:00.000' UNION ALL
SELECT 19, NULL, N'Hollywood Private', N'S_19', N'', N'', N'', N'', N'Monash Avenue', N'Nedlands', 5, N'6009', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140701 00:00:00.000' UNION ALL
SELECT 20, NULL, N'Ipswich General', N'S_20', N'', N'', N'', N'', N'Chelmsford Avenue', N'Ipswich', 3, N'4305', 1, 1, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150327 00:00:00.000' UNION ALL
SELECT 21, NULL, N'John Flynn Private', N'S_21', N'', N'', N'', N'', N'42 Inland Drive', N'Tugun ', 3, N'4224', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20141015 00:00:00.000' UNION ALL
SELECT 22, NULL, N'Latrobe Regional', N'S_22', N'', N'', N'', N'', N'Princes Highway', N'Traralgon West', 2, N'3844', 1, 1, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20141114 00:00:00.000' UNION ALL
SELECT 23, NULL, N'Maryvale Private', N'S_23', N'', N'', N'', N'', N'286 Maryvale Road', N'Morwell', 2, N'3840', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150113 00:00:00.000' UNION ALL
SELECT 24, NULL, N'Mater Sydney', N'S_24', NULL, NULL, NULL, NULL, N'25 Rocklands Road', N'North Sydney', 1, N'2060', 1, 2, 1, N'bsradmin15', '20161107 12:00:14.003', N'ADMINISTRATOR', '20150423 08:15:34.420', '20141223 00:00:00.000' UNION ALL
SELECT 25, NULL, N'North West Private (Brisbane)', N'S_25', N'', N'', N'', N'', N'137 Flockton Street', N'Everton Park', 3, N'4053', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150318 00:00:00.000' UNION ALL
SELECT 26, NULL, N'North West Private (Burnie)', N'S_26', N'', N'', N'', N'', N'21 Brickport Road', N'Burnie', 6, N'7320', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150320 00:00:00.000' UNION ALL
SELECT 27, NULL, N'Peninsula Private', N'S_27', N'', N'', N'', N'', N'525 McClelland Drive', N'Langwarrin', 2, N'3910', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140821 00:00:00.000' UNION ALL
SELECT 28, NULL, N'Pindara Private', N'S_28', N'', N'', N'', N'', N'Allchurch Avenue', N'Benowa', 3, N'4217', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140909 00:00:00.000' UNION ALL
SELECT 29, NULL, N'Repatriation General Hospital', N'S_29', N'', N'', N'', N'', N'216 Daws Road', N'Daw Park', 4, N'5041', 1, 1, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150303 00:00:00.000' UNION ALL
SELECT 30, NULL, N'Royal Brisbane', N'S_30', NULL, NULL, NULL, NULL, N'Butterfield Street', N'Herston', 3, N'4006', 1, 1, 1, N'bsradmin15', '20161216 09:14:28.313', N'ADMINISTRATOR', '20150423 08:15:34.420', '20140620 00:00:00.000' UNION ALL
SELECT 31, NULL, N'Royal Hobart', N'S_31', N'', N'', N'', N'', N'20 Regal Court', N'Seven Mile Beach', 6, N'7170', 1, 1, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140805 00:00:00.000' UNION ALL
SELECT 32, NULL, N'Royal Prince Alfred', N'S_32', N'', N'', N'', N'', N'Level 11, KGV Building, Missenden Road', N'Camperdown', 1, N'2025', 1, 1, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140328 00:00:00.000' UNION ALL
SELECT 33, NULL, N'SJOG Ballarat', N'S_33', N'', N'', N'', N'', N'Po Box 20', N'Ballarat', 2, N'3353', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150115 00:00:00.000' UNION ALL
SELECT 34, NULL, N'SJOG Berwick', N'S_34', N'', N'', N'', N'', N'PO Box 101', N'Berwick', 2, N'3806', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20131205 00:00:00.000' UNION ALL
SELECT 35, NULL, N'SJOG Bunbury', N'S_35', N'', N'', N'', N'', N'700 Robertson Drive', N'Bunbury', 5, N'6230', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150318 00:00:00.000' UNION ALL
SELECT 36, NULL, N'SJOG Geelong', N'S_36', N'', N'', N'', N'', N'PO Box 1016', N'Geelong', 2, N'3220', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150115 00:00:00.000' UNION ALL
SELECT 37, NULL, N'SJOG Mt Lawley', N'S_37', N'', N'', N'', N'', N'Thirlmere Road', N'Mount Lawley', 5, N'6050', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140711 00:00:00.000' UNION ALL
SELECT 38, NULL, N'SJOG Murdoch', N'S_38', N'', N'', N'', N'', N'100 Murdoch Drive', N'Murdoch', 5, N'6150', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150115 00:00:00.000' UNION ALL
SELECT 39, NULL, N'SJOG Subiaco', N'S_39', N'', N'', N'', N'', N'12 Salvado Road', N'Subiaco', 5, N'6008', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20130415 00:00:00.000' UNION ALL
SELECT 40, NULL, N'SJOG Warrnambool', N'S_40', N'', N'', N'', N'', N'136 Botanic Road', N'Warrnambool', 2, N'3280', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20130213 00:00:00.000' UNION ALL
SELECT 41, NULL, N'St George Private', N'S_41', N'', N'', N'', N'', N'1 South Street', N'Kogarah', 1, N'2217', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20140908 00:00:00.000' UNION ALL
SELECT 42, NULL, N'St Vincents Private - Fitzroy', N'S_42', NULL, NULL, NULL, NULL, N'59 Victoria Parade', N'Fitzroy', 2, N'3065', 1, 2, 1, N'bsradmin', '20160505 10:06:49.233', N'ADMINISTRATOR', '20150423 08:15:34.420', '20141118 00:00:00.000' UNION ALL
SELECT 43, NULL, N'The Alfred', N'S_43', N'', N'', N'', N'', N'55 Commercial Rd', N'Melbourne', 2, N'3004', 1, 1, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20120125 00:00:00.000' UNION ALL
SELECT 44, NULL, N'The Avenue', N'S_44', N'', N'', N'', N'', N'40 The Avenue', N'WINDSOR', 2, N'3181', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20120309 00:00:00.000' UNION ALL
SELECT 45, NULL, N'The Valley', N'S_45', N'', N'', N'', N'', N'Police Road', N'Dandenong North', 2, N'3175', 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20141021 00:00:00.000' UNION ALL
SELECT 46, NULL, N'Waikiki Private', N'S_46', N'', N'', N'', N'', N'221 Willmott Drive', N'Waikiki', 5, NULL, 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150319 00:00:00.000' UNION ALL
SELECT 47, NULL, N'Wangaratta Private', N'S_47', N'', N'', N'', N'', N'134 Templeton St', N'Wangaratta', 2, NULL, 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20141210 00:00:00.000' UNION ALL
SELECT 48, NULL, N'Warringal Private', N'S_48', N'', N'', N'', N'', N'216 Burgundy Street', N'Heidelberg', 2, NULL, 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150324 00:00:00.000' UNION ALL
SELECT 49, NULL, N'Western Private', N'S_49', N'', N'', N'', N'', N'11-9 Marion Street', N'Footscray', 2, NULL, 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150303 00:00:00.000' UNION ALL
SELECT 50, NULL, N'Waverley Private', N'S_50', N'', N'', N'', N'', N'357 Blackburn Road', N'Mt Waverley', 2, NULL, 1, 2, 1, N'ADMINISTRATOR', NULL, N'ADMINISTRATOR', '20150423 08:15:34.420', '20150421 00:00:00.000'
COMMIT;
RAISERROR (N'[dbo].[tbl_Site]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tbl_Site]([SiteId], [HPIO], [SiteName], [SiteRoleName], [SitePrimaryContact], [SitePh1], [SiteSecondaryContact], [SitePh2], [SiteAddr], [SiteSuburb], [SiteStateId], [SitePcode], [SiteCountryId], [SiteTypeId], [SiteStatusId], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedByDateTime], [EAD])
SELECT 51, NULL, N'OPTOFFSITE', N'S_51', NULL, NULL, NULL, NULL, N'OPTOFFSITE', N'OPTOFFSITE', 2, N'0000', 1, 2, 2, N'jigyasas', '20150506 08:58:02.397', N'jigyasas', '20150506 08:58:02.397', NULL UNION ALL
SELECT 54, NULL, N'Queen Elizabeth Hospital', N'S_54', NULL, NULL, NULL, NULL, N'28 Woodville Rd', N'Woodville South ', 4, N'5011', 1, 1, 1, N'bsradmin', '20151103 10:13:04.407', N'bsradmin3', '20150520 11:17:21.537', '20150423 00:00:00.000' UNION ALL
SELECT 55, NULL, N'Monash Medical Centre', N'S_55', NULL, NULL, NULL, NULL, N'246 Clayton Rd', N'Clayton ', 2, N'3168', 1, 1, 1, N'bsradmin', '20160402 14:07:50.957', N'bsradmin3', '20150520 11:19:07.687', '20150429 00:00:00.000' UNION ALL
SELECT 56, NULL, N'Joondalup Health Campus (Priv)', N'S_56', NULL, NULL, NULL, NULL, N'Grand Bvld and Shenton Avenue', N'Joondalup ', 5, N'6027', 1, 2, 1, N'bsradmin', '20160829 13:35:57.873', N'bsradmin3', '20150520 11:20:52.073', '20150509 00:00:00.000' UNION ALL
SELECT 57, NULL, N'The Wesley', N'S_57', NULL, NULL, NULL, NULL, N'451 Coronation Drive ', N'Auchenflower ', 3, N'4066', 1, 2, 1, N'bsradmin', '20151124 11:31:39.323', N'bsradmin3', '20150520 11:22:22.583', '20150512 00:00:00.000' UNION ALL
SELECT 58, NULL, N'St Andrew''s War Memorial Hospital', N'S_58', NULL, NULL, NULL, NULL, N'457 Wickham Terrace ', N'Brisbane ', 3, N'4001', 1, 2, 1, N'bsradmin', '20151103 10:14:02.987', N'bsradmin3', '20150520 11:23:49.267', '20150512 00:00:00.000' UNION ALL
SELECT 59, NULL, N'Castle Hill Day Surgery ', N'S_59', NULL, NULL, NULL, NULL, N'72-74 Cecil Avenue ', N'Castle Hill ', 1, N'2154', 1, 2, 1, N'bsradmin3', '20150520 11:25:16.467', N'bsradmin3', '20150520 11:25:16.467', '20150515 00:00:00.000' UNION ALL
SELECT 60, NULL, N'North Shore Private', N'S_60', NULL, N' 02 9437 0504', NULL, NULL, N'Level 5, 1 Westbourne St.', N' St Leonards ', 1, N'2065', 1, 2, 1, N'bsradmin3', '20150609 10:30:33.023', N'bsradmin3', '20150609 10:30:33.023', '20150519 00:00:00.000' UNION ALL
SELECT 61, NULL, N'Mater North Queensland', N'S_61', NULL, N'07 4727 4444', NULL, NULL, N'21-37 Fulham Road', N'Pimlico', 3, N'4812', 1, 2, 1, N'bsradmin3', '20150609 10:33:14.047', N'bsradmin3', '20150609 10:33:14.047', '20150601 00:00:00.000' UNION ALL
SELECT 62, NULL, N'Mater Rockhampton', N'S_62', NULL, N'07 4931 3313', NULL, NULL, N'Cnr Jessie Street & Spencer St', N'Rockhampton', 3, N'4700', 1, 2, 1, N'bsradmin3', '20150609 10:38:41.110', N'bsradmin3', '20150609 10:37:31.270', '20150603 00:00:00.000' UNION ALL
SELECT 63, NULL, N'Mildura Base Hospital', N'S_63', NULL, NULL, NULL, NULL, N'231-237 Thirteenth St, Mildura VIC 3500, Australia', N'Mildura ', 2, N'3500', 1, 1, 1, N'bsradmin', '20160402 14:10:48.863', N'bsradmin9', '20150806 16:17:00.467', '20150618 00:00:00.000' UNION ALL
SELECT 64, NULL, N'Calvary Central Districts', N'S_64', NULL, NULL, NULL, NULL, N'25-37 Jarvis Rd', N'Elizabeth Vale ', 4, N'5112', 1, 2, 1, N'bsradmin', '20160823 12:31:43.500', N'bsradmin9', '20150806 16:20:32.330', '20150619 00:00:00.000' UNION ALL
SELECT 65, NULL, N'Sydney Adventist Hospital', N'S_65', NULL, NULL, NULL, NULL, N'185 Fox Valley Rd ', N'Wahroonga', 1, N'2076', 1, 2, 1, N'bsradmin', '20160208 12:59:30.623', N'bsradmin9', '20150806 16:26:16.470', '20150714 00:00:00.000' UNION ALL
SELECT 66, NULL, N'Essendon Private', N'S_66', NULL, NULL, NULL, NULL, N'35 Rosehill Rd', N'West Essendon', 2, N'3040', 1, 2, 1, N'bsradmin', '20151103 10:10:55.190', N'bsradmin9', '20150806 16:27:51.293', '20150803 00:00:00.000' UNION ALL
SELECT 67, NULL, N'Kareena Private', N'S_67', NULL, NULL, NULL, NULL, N'Locked Bag 8', N'Taren Point ', 1, N'2229', 1, 2, 1, N'bsradmin', '20160402 14:11:15.160', N'bsradmin9', '20150806 16:29:30.693', '20150717 00:00:00.000' UNION ALL
SELECT 68, NULL, N'Greenslopes Private', N'S_68', NULL, NULL, NULL, NULL, N'Newdegate Street ', N'Greenslopes ', 3, N'4120', 1, 2, 1, N'bsradmin', '20160402 15:00:15.610', N'bsradmin9', '20150806 16:31:34.577', '20150716 00:00:00.000' UNION ALL
SELECT 69, NULL, N'Glen Iris Private', N'S_69', NULL, N'61 3 9808 7111', NULL, NULL, N'314 Warrigal Rd ', N'Glen Iris', 2, N'3146', 1, 2, 1, N' bsradmin3', '20160212 13:56:58.127', N'bsradmin3', '20150908 14:42:46.757', '20150824 00:00:00.000' UNION ALL
SELECT 70, NULL, N'Royal North Shore', N'S_70', NULL, NULL, NULL, NULL, N'Reserve Rd', N'St Leonards', 1, N'2065', 1, 1, 1, N'bsradmin3', '20150910 14:01:21.363', N'bsradmin3', '20150910 14:01:21.363', '20150826 00:00:00.000' UNION ALL
SELECT 71, NULL, N'Mildura Private', N'S_71', NULL, N'03 5022 2611', NULL, NULL, N'220-228 Thirteenth St ', N'Mildura', 2, N'3500', 1, 2, 1, N'bsradmin3', '20151001 11:46:03.377', N'bsradmin3', '20151001 11:46:03.377', '20150824 00:00:00.000' UNION ALL
SELECT 72, NULL, N'Holy Spirit Northside', N'S_72', NULL, N'07 3326 3000', NULL, NULL, N'627 Rode Road', N'Chermside', 3, N'4032', 1, 2, 1, N'bsradmin3', '20151020 14:25:57.177', N'bsradmin3', '20151020 14:25:57.177', '20150818 00:00:00.000' UNION ALL
SELECT 73, NULL, N'St Vincent''s Public', N'S_73', NULL, N' 03 9288 2211', NULL, NULL, N'41 Victoria Parade', N'Fitzroy', 2, N'3065', 1, 1, 1, N'bsradmin7', '20160720 11:04:39.390', N'bsradmin3', '20151021 14:24:47.897', '20151013 00:00:00.000' UNION ALL
SELECT 74, NULL, N'Lingard Private', N'S_74', NULL, N'02 4969 6799', NULL, NULL, N'23 Merewether St', N'Merewether', 1, N'2291', 1, 2, 1, N' bsradmin3', '20160212 13:58:12.360', N'bsradmin3', '20151021 15:09:13.033', '20150623 00:00:00.000' UNION ALL
SELECT 75, NULL, N'Bethesda Hospital', N'S_75', NULL, N' 08 9340 6300', NULL, NULL, N' 25 Queenslea Dr,', N'Claremont', 5, N'6010', 1, 2, 1, N'bsradmin', '20160830 09:46:10.497', N'bsradmin3', '20151029 13:55:36.977', '20151020 00:00:00.000' UNION ALL
SELECT 76, NULL, N'Hurstville Private', N'S_76', NULL, N'2 9579 7777', NULL, NULL, N'37 Gloucester Rd ', N'Hurstville', 1, N'2220', 1, 2, 1, N'bsradmin3', '20151130 11:10:10.237', N'bsradmin3', '20151130 11:10:10.237', '20151106 00:00:00.000' UNION ALL
SELECT 78, NULL, N'Kawana Private', N'S_78', NULL, N'075413 9100', NULL, NULL, N'14/5 Innovation Pkwy ', N'Birtinya', 3, N'4575', 1, 2, 1, N' bsradmin3', '20160212 13:57:59.360', N'bsradmin3', '20151217 11:53:28.803', '20151210 00:00:00.000' UNION ALL
SELECT 79, NULL, N'SJOG Geraldton', N'S_79', NULL, N'0899658888', NULL, NULL, N'12 Hermitage St WA', N'Geraldton', 5, N'6530', 1, 2, 1, N'bsradmin3', '20151217 11:57:41.673', N'bsradmin3', '20151217 11:57:30.987', '20151209 00:00:00.000' UNION ALL
SELECT 80, NULL, N'Brisbane Waters Private', N'S_80', NULL, N'024341 9522', NULL, NULL, N'21 Vidler Ave', N' Woy Woy', 1, N'2256', 1, 2, 1, N'bsradmin3', '20151217 11:58:58.017', N'bsradmin3', '20151217 11:58:58.017', '20151126 00:00:00.000' UNION ALL
SELECT 81, NULL, N'Gosford Private', N'S_81', NULL, N'024324 7111', NULL, NULL, N'Burrabil Avenue', N'Gosford', 1, N'2250', 1, 2, 1, N' bsradmin3', '20160212 13:57:17.437', N'bsradmin3', '20151217 15:27:26.090', '20150911 00:00:00.000' UNION ALL
SELECT 82, NULL, N'John Hunter Hospital', N'S_82', NULL, N'024921 3000', NULL, NULL, N'Lookout Rd', N'New Lambton', 1, N'2305', 1, 1, 1, N'bsradmin3', '20151217 15:31:36.760', N'bsradmin3', '20151217 15:31:36.760', '20151211 00:00:00.000' UNION ALL
SELECT 84, NULL, N'Gosford Public', N'S_84', NULL, N'02 4320 2111', NULL, NULL, N'Holden St', N'Gosford ', 1, N'2250', 1, 1, 1, N'bsradmin3', '20160127 14:50:00.277', N'bsradmin3', '20160127 14:46:09.190', '20160121 00:00:00.000' UNION ALL
SELECT 85, NULL, N'HSS', N'S_85', NULL, N'1300 777 477', NULL, NULL, N'17-19 Solent Circuit', N'Baulkham Hills', 1, N'2153', 1, 2, 1, N'bsradmin3', '20160215 10:10:06.770', N'bsradmin3', '20160215 10:10:06.770', '20150807 00:00:00.000' UNION ALL
SELECT 86, NULL, N'Princess Alexandra Hospital', N'S_86', NULL, N'0731762111', NULL, NULL, N'199 Ipswich Rd', N'Woolloongabba ', 3, N'4102', 1, 1, 1, N'bsradmin3', '20160307 12:32:56.370', N'bsradmin3', '20160307 12:32:56.370', '20160304 00:00:00.000' UNION ALL
SELECT 87, NULL, N'Queen Elizabeth II Jubilee', N'S_87', NULL, N'0731826111', NULL, NULL, N'Corner of Kessels Road and Troughton Road', N'Coopers Plains', 3, N'4108', 1, 1, 1, N'bsradmin3', '20160308 14:30:49.190', N'bsradmin3', '20160308 14:26:47.273', '20160307 00:00:00.000' UNION ALL
SELECT 88, NULL, N'Sunshine Coast Private', N'S_88', NULL, N'0754303303', NULL, NULL, N'12 Elsa Wilson Dr', N'Buderim', 3, N'4556', 1, 2, 1, N'bsradmin3', '20160323 11:22:10.567', N'bsradmin3', '20160323 11:22:10.567', '20160125 00:00:00.000' UNION ALL
SELECT 89, NULL, N'NON-BSR SITE', N'S_89', NULL, NULL, NULL, NULL, N'The Alfred Centre, 99 Commercial Road', N'Melbourne', 2, N'3004', 1, 1, 1, N'bsradmin7', '20160802 12:56:04.837', N'bsradmin7', '20160802 12:56:04.837', '20120125 00:00:00.000' UNION ALL
SELECT 90, NULL, N'Joondalup Health Campus (Pub)', N'S_90', NULL, NULL, NULL, NULL, N'Grand Bvld and Shenton Avenue', N'Joondalup', 5, N'6027', 1, 1, 1, N'bsradmin', '20160829 13:52:27.060', N'bsradmin', '20160829 13:36:38.793', '20150509 00:00:00.000' UNION ALL
SELECT 91, NULL, N'Epworth Geelong Hospital', N'S_91', NULL, NULL, NULL, NULL, N'1 Epworth Place ', N'Waurn Ponds', 2, N'3216', 1, 2, 1, N'bsradmin16', '20161024 10:08:37.023', N'bsradmin16', '20161024 10:08:37.023', '20160913 00:00:00.000' UNION ALL
SELECT 92, NULL, N'Jessie McPherson Private Hospital', N'S_92', NULL, N'9594 2776', NULL, NULL, N'Monash Medical Centre, 246 Clayton Road ', N'Clayton', 2, N'3168', 1, 2, 1, N'bsradmin16', '20161024 10:16:03.987', N'bsradmin16', '20161024 10:16:03.987', '20160727 00:00:00.000' UNION ALL
SELECT 93, NULL, N'Port Macquarie Private', N'S_93', NULL, NULL, NULL, NULL, N'86-94 Lake Road', N'Port Macquarie', 1, N'2444', 1, 2, 1, N'bsradmin', '20161024 16:37:15.350', N'bsradmin', '20161024 16:37:15.350', '20150918 00:00:00.000' UNION ALL
SELECT 94, NULL, N'Mount Hospital ', N'S_94', NULL, NULL, NULL, NULL, N'150 Mounts Bay Rd', N'Perth', 5, N'6000', 1, 2, 1, N'bsradmin6', '20170104 14:20:19.797', N'bsradmin6', '20170104 14:20:19.797', '20161201 00:00:00.000' UNION ALL
SELECT 95, NULL, N'Campbelltown Private', N'S_95', NULL, NULL, NULL, NULL, N'42 Parkside Cres', N'Campbelltown', 1, N'2560', 1, 2, 1, N'bsradmin6', '20170104 14:27:35.967', N'bsradmin6', '20170104 14:27:35.967', '20161201 00:00:00.000' UNION ALL
SELECT 96, NULL, N'Darwin Private', N'S_96', NULL, NULL, NULL, NULL, N'Rocklands Dr', N'Tiwi', 7, N'0810', 1, 2, 1, N'bsradmin6', '20170104 14:31:32.560', N'bsradmin6', '20170104 14:31:32.560', '20161201 00:00:00.000' UNION ALL
SELECT 97, NULL, N'John Fawkner', N'S_97', NULL, NULL, NULL, NULL, N'275 Moreland Rd', N'Coburg', 2, N'3058', 1, 2, 1, N'bsradmin6', '20170104 14:33:31.667', N'bsradmin6', '20170104 14:33:31.667', '20161201 00:00:00.000' UNION ALL
SELECT 98, NULL, N'Knox Private', N'S_98', NULL, NULL, NULL, NULL, N'262 Mountain Hwy', N'Wantirna', 2, N'3152', 1, 2, 1, N'bsradmin6', '20170104 14:34:47.027', N'bsradmin6', '20170104 14:34:47.027', '20161201 00:00:00.000' UNION ALL
SELECT 99, NULL, N'National Capital Private', N'S_99', NULL, NULL, NULL, NULL, N'Cnr Gilmore Cres & Hospital Rd', N'Garran', 8, N'2605', 1, 2, 1, N'bsradmin6', '20170104 14:40:40.383', N'bsradmin6', '20170104 14:40:40.383', '20161201 00:00:00.000' UNION ALL
SELECT 100, NULL, N'Nepean Private', N'S_100', NULL, NULL, NULL, NULL, N'Barber Ave', N'Kingswood', 1, N'2747', 1, 2, 1, N'bsradmin6', '20170104 14:42:26.383', N'bsradmin6', '20170104 14:42:26.383', '20161201 00:00:00.000' UNION ALL
SELECT 101, NULL, N'Northpark Private', N'S_101', NULL, NULL, NULL, NULL, N'Cnr Plenty Rd & Greenhills Rd', N'Bundoora', 2, N'3083', 1, 2, 1, N'bsradmin6', '20170104 14:45:34.537', N'bsradmin6', '20170104 14:45:34.537', '20161201 00:00:00.000' UNION ALL
SELECT 102, NULL, N'Norwest Private', N'S_102', NULL, NULL, NULL, NULL, N'11 Norbrik Dr', N'Bella Vista', 1, N'2153', 1, 2, 1, N'bsradmin6', '20170104 14:47:52.973', N'bsradmin6', '20170104 14:47:52.973', '20161201 00:00:00.000' UNION ALL
SELECT 103, NULL, N'Prince of Wales Private', N'S_103', NULL, NULL, NULL, NULL, N'Baker St ', N'Randwick', 1, N'2031', 1, 2, 1, N'bsradmin6', '20170104 14:54:39.660', N'bsradmin6', '20170104 14:54:39.660', '20161201 00:00:00.000' UNION ALL
SELECT 104, NULL, N'Sunnybank Private', N'S_104', NULL, NULL, NULL, NULL, N'245 McCullough St', N'Sunny Bank', 3, N'4109', 1, 2, 1, N'bsradmin6', '20170104 15:01:54.017', N'bsradmin6', '20170104 15:01:54.017', '20161201 00:00:00.000'
COMMIT;
RAISERROR (N'[dbo].[tbl_Site]: Insert Batch: 2.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tbl_Site]([SiteId], [HPIO], [SiteName], [SiteRoleName], [SitePrimaryContact], [SitePh1], [SiteSecondaryContact], [SitePh2], [SiteAddr], [SiteSuburb], [SiteStateId], [SitePcode], [SiteCountryId], [SiteTypeId], [SiteStatusId], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedByDateTime], [EAD])
SELECT 105, NULL, N'Sydney Southwest Private', N'S_105', NULL, NULL, NULL, NULL, N'40 Bigge St', N'Liverpool', 1, N'2170', 1, 2, 1, N'bsradmin6', '20170104 15:05:55.437', N'bsradmin6', '20170104 15:05:55.437', '20161201 00:00:00.000' UNION ALL
SELECT 106, NULL, N'Geelong Private', N'S_106', NULL, NULL, NULL, NULL, N'Cnr Rylie & Bellerine St ', N'Geelong', 2, N'3220', 1, 2, 1, N'bsradmin6', '20170104 15:07:38.733', N'bsradmin6', '20170104 15:07:38.733', '20161201 00:00:00.000' UNION ALL
SELECT 107, NULL, N'Gold Coast Private', N'S_107', NULL, NULL, NULL, NULL, N'14 Hill St', N'Southport', 3, N'4215', 1, 2, 1, N'bsradmin6', '20170116 14:31:31.337', N'bsradmin6', '20170116 14:31:31.337', '20161201 00:00:00.000'
COMMIT;
RAISERROR (N'[dbo].[tbl_Site]: Insert Batch: 3.....Done!', 10, 1) WITH NOWAIT;
GO

SET IDENTITY_INSERT [dbo].[tbl_Site] OFF;

BEGIN TRANSACTION;
INSERT INTO [dbo].[aspnet_Roles]([ApplicationId] ,[RoleName],[LoweredRoleName],[Description])
SELECT ApplicationId,'S_1','s_1','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_3','s_3','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_4','s_4','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_5','s_5','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_6','s_6','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_7','s_7','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_8','s_8','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_9','s_9','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_10','s_10','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_11','s_11','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_12','s_12','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_13','s_13','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_14','s_14','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_15','s_15','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_16','s_16','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_17','s_17','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_18','s_18','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_19','s_19','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_20','s_20','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_21','s_21','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_22','s_22','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_23','s_23','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_24','s_24','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_25','s_25','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_26','s_26','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_27','s_27','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_28','s_28','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_29','s_29','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_30','s_30','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_31','s_31','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_32','s_32','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_33','s_33','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_34','s_34','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_35','s_35','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_36','s_36','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_37','s_37','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_38','s_38','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_39','s_39','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_40','s_40','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_41','s_41','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_42','s_42','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_43','s_43','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_44','s_44','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_45','s_45','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_46','s_46','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_47','s_47','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_48','s_48','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_49','s_49','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_50','s_50','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_51','s_51','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_54','s_54','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_55','s_55','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_56','s_56','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_57','s_57','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_58','s_58','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_59','s_59','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_60','s_60','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_61','s_61','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_62','s_62','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_63','s_63','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_64','s_64','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_65','s_65','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_66','s_66','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_67','s_67','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_68','s_68','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_69','s_69','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_70','s_70','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_71','s_71','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_72','s_72','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_73','s_73','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_74','s_74','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_75','s_75','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_76','s_76','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_78','s_78','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_79','s_79','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_80','s_80','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_81','s_81','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_82','s_82','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_84','s_84','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_85','s_85','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_86','s_86','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_87','s_87','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_88','s_88','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_89','s_89','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_90','s_90','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_91','s_91','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_92','s_92','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_93','s_93','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_94','s_94','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_95','s_95','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_96','s_96','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_97','s_97','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_98','s_98','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_99','s_99','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_100','s_100','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_101','s_101','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_102','s_102','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_103','s_103','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_104','s_104','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_105','s_105','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_106','s_106','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'S_107','s_107','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'SN_5','sn_5','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'SN_6','sn_6','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'SN_7','sn_7','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' UNION ALL
SELECT ApplicationId,'SN_9','sn_9','Site/Hospital' From [dbo].[aspnet_Applications] WHERE ApplicationName='/' 
COMMIT;
RAISERROR (N'[dbo].[tbl_Site]: Insert Sites/Hospital.....Done!',10,1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[tlkp_YesNoNotStated]([Id], [Description])
SELECT 0, N'No' UNION ALL
SELECT 1, N'Yes' UNION ALL
SELECT 99, N'Not stated/inadequately described'
COMMIT;
RAISERROR (N'[dbo].[tlkp_YesNoNotStated]: Insert Batch: .....Done!', 10, 1) WITH NOWAIT;
GO


BEGIN TRANSACTION
SET IDENTITY_INSERT [dbo].[tbl_Complications] ON 

GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (1, 1, 1)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (2, 1, 2)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (3, 1, 3)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (4, 1, 4)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (5, 1, 5)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (6, 1, 6)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (7, 1, 7)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (8, 1, 8)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (9, 1, 9)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (10, 1, 10)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (11, 1, 11)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (12, 1, 12)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (13, 1, 13)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (14, 1, 27)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (15, 2, 23)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (16, 2, 24)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (17, 2, 25)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (18, 2, 26)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (19, 2, 17)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (20, 2, 16)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (21, 2, 13)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (22, 2, 10)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (23, 2, 11)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (24, 2, 12)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (25, 2, 27)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (26, 3, 15)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (27, 3, 16)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (28, 3, 20)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (29, 3, 21)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (30, 3, 18)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (31, 3, 19)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (32, 3, 10)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (33, 3, 11)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (34, 3, 12)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (35, 3, 27)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (36, 4, 15)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (37, 4, 16)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (38, 4, 20)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (39, 4, 21)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (40, 4, 18)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (41, 4, 19)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (42, 4, 10)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (43, 4, 11)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (44, 4, 12)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (45, 4, 27)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (46, 5, 14)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (47, 5, 15)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (48, 5, 16)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (49, 5, 17)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (50, 5, 18)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (51, 5, 19)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (52, 5, 10)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (53, 5, 11)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (54, 5, 12)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (55, 5, 27)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (56, 6, 15)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (57, 6, 16)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (58, 6, 20)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (59, 6, 21)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (60, 6, 18)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (61, 6, 19)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (62, 6, 10)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (63, 6, 11)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (64, 6, 12)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (65, 6, 27)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (66, 7, 22)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (67, 7, 13)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (68, 7, 18)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (69, 7, 19)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (70, 7, 10)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (71, 7, 11)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (72, 7, 12)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (73, 7, 27)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (74, 8, 22)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (75, 8, 13)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (76, 8, 18)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (77, 8, 19)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (78, 8, 10)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (79, 8, 11)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (80, 8, 12)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (81, 8, 27)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (82, 8, 1)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (83, 8, 2)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (84, 8, 3)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (85, 8, 4)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (86, 8, 5)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (87, 8, 6)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (88, 8, 7)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (89, 8, 8)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (90, 8, 9)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (91, 9, 10)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (92, 9, 11)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (93, 9, 12)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (94, 9, 13)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (95, 9, 16)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (96, 9, 27)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (97, 10, 8)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (98, 10, 10)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (99, 10, 11)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (100, 10, 12)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (101, 10, 13)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (102, 10, 27)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (103, 11, 28)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (104, 11, 10)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (105, 11, 11)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (106, 11, 12)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (107, 11, 13)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (108, 11, 27)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (109, 99, 10)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (110, 99, 11)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (111, 99, 12)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (112, 99, 13)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (113, 99, 16)
GO
INSERT [dbo].[tbl_Complications] ([Id], [ProcedureId], [ComplicationId]) VALUES (114, 99, 27)
GO
SET IDENTITY_INSERT [dbo].[tbl_Complications] OFF
GO
COMMIT;
RAISERROR (N'[dbo].[[tbl_Complications]]: Insert Default Data: .....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION
SET IDENTITY_INSERT [dbo].[tbl_DeviceBrand] ON 

GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (1, N'BIORING', 3, 0, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (2, N'BIORING', 3, 1, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (3, N'Curved Adjustable Gastric Band', 5, 0, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (4, N'Curved Adjustable Gastric Band', 5, 1, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (5, N'Curved Adjustable Gastric Band', 5, 2, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (6, N'Echelon ENDOPATH', 5, 3, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (7, N'Echelon Flex ENDOPATH', 5, 3, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (8, N'EEA Circular', 4, 3, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (9, N'Endo GIA', 4, 3, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (10, N'ENDOPATH ETS', 5, 3, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (11, N'Heliogast ', 6, 0, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (12, N'Heliogast ', 6, 1, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (13, N'Intraluminal Circular Stapler', 5, 3, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (14, N'LAP-BAND', 1, 0, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (15, N'LAP-BAND ', 1, 1, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (16, N'Lap-Band', 1, 2, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (17, N'Lap-band', 1, 4, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (18, N'MIDband', 7, 0, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (19, N'MIDband', 7, 1, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (20, N'MiniMizer', 2, 0, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (21, N'MiniMizer', 2, 5, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
INSERT [dbo].[tbl_DeviceBrand] ([Id], [Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES (22, N'MiniMizer Port ', 2, 1, 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:51.047' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[tbl_DeviceBrand] OFF
GO
COMMIT;
RAISERROR (N'[dbo].[[tbl_DeviceBrand]]: Insert Default Data: .....Done!', 10, 1) WITH NOWAIT;
GO
BEGIN TRANSACTION
SET IDENTITY_INSERT [dbo].[tbl_Device] ON 

GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (1, N'AB-20260', 14, N'AP Small', 1, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime), N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (2, N'AB-20265', 14, N'AP Large', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (3, N'RLZB32', 3, N'Curved Adjustable Gastric Band with Sutureless Port and Applier', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (4, N'RLZB32D1', 3, N'Curved Adjustable Gastric Band with Gastric Band Dissector.', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (5, N'RLZB32DG1', 3, N'Curved Adjustable Gastric Band with Gastric Band Dissector and Gastric Calibration Tube', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (6, N'MMEX', 20, N'Extra', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (7, N'MID-100-M', 18, N'Pre-curved MIDband', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (8, N'HAGA-EV3', 11, N'Helioscopie Gastric Band  with Advanced EV3 Port', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (9, N'HAGE-EV3', 11, N'Helioscopie Gastric Band - Evolution with EV3 Port', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (10, N'HAGE', 11, N'Helioscopie Gastric Band - Evolution', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (11, N'RINGS 20000', 1, N'2.3cm', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (12, N'BCB R123', 1, N'2.8cm', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (13, N'BCB RIXL', 1, N'3.7cm', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (14, N'B-20101', 15, N'Access Port Kit', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (15, N'B-20304', 15, N'Access Port Kit - Rapid Port EZ', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (16, N'RLZPT2', 4, N'Gastric Band Sutureless Port and Applier.', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (17, N'BCB RIRE PO', 2, N'Access port', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (18, N'H-K Heliogast', 12, N'Standard port replacement kit', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (19, N'H-K Heliogast EV3', 12, N'EV3 port 360 degree injection surface', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (20, N'H-KEV1', 12, N'Low profile port replacement kit', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (21, N'MICPS', 22, N'Small 13 mm', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (22, N'MICPM', 22, N'Medium 18mm', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (23, N'MID-004-605PM ', 19, N'MID-Port', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (26, N'B-20303', 16, N'Rapid Port Tack Assembly', 1, N'cidmu', CAST(N'2015-04-10 14:13:00.943' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (27, N'RLZPT2', 5, N'Gastric Band Sutureless Port and Applier.', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (28, N'EGIA45AVM', 9, N'45 mm Tan', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (29, N'EGIA60AVM', 9, N'60 mm Tan', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (30, N'EGIA45AMT', 9, N'45 mm Purple', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (31, N'EGIA60AMT', 9, N'60 mm Purple', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (32, N'EGIA45AXT', 9, N'45 mm Black', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (33, N'EGIA60AXT', 9, N'60 mm Black', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (34, N'EEA25XL', 8, N'25 mm X-long', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (35, N'EEAORVIL', 8, N'25 mm ORVIL', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (36, N'PLE45A', 7, N'45  mm Stapler', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (37, N'ECL45AL', 7, N'45 mm Stapler', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (38, N'PLE60A', 7, N'60 mm Stapler', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (39, N'LONG6A', 7, N'60 mm Stapler', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (40, N'ECLG45', 6, N'45 mm Stapler', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (41, N'LONG60', 6, N'60 mm Stapler', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (42, N'LONG45A', 10, N'45 mm stapler', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (43, N'ECS21A', 13, N'21 mm diameter', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (44, N'ECS25A', 13, N'25 mm diameter', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (45, N'ECS29A', 13, N'29 mm diameter', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (46, N'B-20401', 17, N'Tubing accessory kit', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (47, N'MMRING', 21, N'Minimizer Gastric Ring', 1, NULL, NULL, N'CIDMU', CAST(N'2014-12-17 13:44:55.483' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (48, N'AB-20360', 14, N'AP Small- Rapid port EZ system', 1, NULL, NULL, N'cidmu', CAST(N'2015-04-10 14:10:03.997' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (49, N'AB-20365', 14, N'AP Large - Rapid port EZ system', 1, NULL, NULL, N'cidmu', CAST(N'2015-04-10 14:10:31.123' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (50, N'C-20360', 14, N'AP Small - Rapid port EZ system next gen', 1, NULL, NULL, N'cidmu', CAST(N'2015-04-10 14:10:51.947' AS DateTime))
GO
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (51, N'C-20365', 14, N'AP Large - Rapid port EZ system next gen', 1, NULL, NULL, N'cidmu', CAST(N'2015-04-10 14:11:16.383' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[tbl_Device] OFF
GO
COMMIT;
RAISERROR (N'[dbo].[[tbl_Device]]: Insert Default Data: .....Done!', 10, 1) WITH NOWAIT;
GO