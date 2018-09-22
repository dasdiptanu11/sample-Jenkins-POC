

DELETE FROM [tlkp_SecurityQuestions]
INSERT INTO [tlkp_SecurityQuestions] ([Id],[Description]) VALUES(1,'First pet''s name?')
INSERT INTO [tlkp_SecurityQuestions] ([Id],[Description]) VALUES(2,'First school attended?')
INSERT INTO [tlkp_SecurityQuestions] ([Id],[Description]) VALUES(3,'First occupation?')
INSERT INTO [tlkp_SecurityQuestions] ([Id],[Description]) VALUES(4,'First teacher''s name?')
INSERT INTO [tlkp_SecurityQuestions] ([Id],[Description]) VALUES(5,'First car?')

DELETE FROM [tlkp_SiteStatus]
INSERT [tlkp_SiteStatus]([Id] ,[Description])  VALUES ( 1 ,'Participating') 
INSERT [tlkp_SiteStatus]([Id] ,[Description])  VALUES ( 2 ,'Pending') 

DELETE FROM [tlkp_Title]
INSERT [tlkp_Title]([Id] ,[Description])  VALUES ( 1 ,'Mr')
INSERT [tlkp_Title]([Id] ,[Description])  VALUES ( 2 ,'Ms')
INSERT [tlkp_Title]([Id] ,[Description])  VALUES ( 3 ,'Mrs')
INSERT [tlkp_Title]([Id] ,[Description])  VALUES ( 4 ,'Miss')
INSERT [tlkp_Title]([Id] ,[Description])  VALUES ( 5 ,'Dr') 
INSERT [tlkp_Title]([Id] ,[Description])  VALUES ( 6 ,'Prof') 
INSERT [tlkp_Title]([Id] ,[Description])  VALUES ( 7 ,'A/Prof') 


DELETE FROM tlkp_SiteType
INSERT INTO [tlkp_SiteType]([Id] ,[Description])  VALUES ( 1 ,'Public') 
INSERT INTO [tlkp_SiteType]([Id] ,[Description])  VALUES ( 2 ,'Private') 

delete from [tlkp_YesNo]
INSERT INTO [tlkp_YesNo] ([Id] ,[Description])  VALUES ( 0 ,'No') 
INSERT INTO [tlkp_YesNo] ([Id] ,[Description])  VALUES ( 1 ,'Yes') 

DELETE FROM [tlkp_DeviceType]
INSERT INTO [tlkp_DeviceType] ([Id],[Description]) VALUES(0, 'Gastric Band')
INSERT INTO [tlkp_DeviceType] ([Id],[Description]) VALUES(1, 'Access Port Alone')
INSERT INTO [tlkp_DeviceType] ([Id],[Description]) VALUES(2, 'Port Fixation Device')
INSERT INTO [tlkp_DeviceType] ([Id],[Description]) VALUES(3, 'Stapling Device')
INSERT INTO [tlkp_DeviceType] ([Id],[Description]) VALUES(4, 'Tubing Repair Kit')
INSERT INTO [tlkp_DeviceType] ([Id],[Description]) VALUES(5, 'Banded Bypass')
INSERT INTO [tlkp_DeviceType] ([Id],[Description]) VALUES(6, 'Existing Device')

DELETE FROM [tlkp_PortFixationMethod]
INSERT INTO [tlkp_PortFixationMethod] ([Id],[Description]) VALUES(1, 'Port fixation Device')
INSERT INTO [tlkp_PortFixationMethod] ([Id],[Description]) VALUES(2, 'Mesh')
INSERT INTO [tlkp_PortFixationMethod] ([Id],[Description]) VALUES(3, 'Suture')
INSERT INTO [tlkp_PortFixationMethod] ([Id],[Description]) VALUES(4, 'Not Used')

delete from [tlkp_State]
INSERT INTO [tlkp_State] ([Id] ,[Description])  VALUES ( 1 ,'NSW') 
INSERT INTO [tlkp_State] ([Id] ,[Description])  VALUES ( 2 ,'VIC') 
INSERT INTO [tlkp_State] ([Id] ,[Description])  VALUES ( 3 ,'QLD') 
INSERT INTO [tlkp_State] ([Id] ,[Description])  VALUES ( 4 ,'SA') 
INSERT INTO [tlkp_State] ([Id] ,[Description])  VALUES ( 5 ,'WA') 
INSERT INTO [tlkp_State] ([Id] ,[Description])  VALUES ( 6 ,'TAS') 
INSERT INTO [tlkp_State] ([Id] ,[Description])  VALUES ( 7 ,'NT') 
INSERT INTO [tlkp_State] ([Id] ,[Description])  VALUES ( 8 ,'ACT')
INSERT INTO [tlkp_State] ([Id] ,[Description])  VALUES ( 9 ,'Other territories')
--INSERT INTO [tlkp_State] ([Id] ,[Description])  VALUES ( 99 ,'Not stated/inadequately described')

delete from [dbo].[tlkp_Country]
INSERT INTO [dbo].[tlkp_Country] ([Id] ,[Description])  VALUES ( 1 ,'Australia') 
INSERT INTO [dbo].[tlkp_Country] ([Id] ,[Description])  VALUES ( 2 ,'New Zealand') 
-- INSERT INTO [dbo].[tlkp_Country] ([Id] ,[Description])  VALUES ( 99 ,'Not stated/Inadequately described') 

delete from [tlkp_Gender]
INSERT INTO [tlkp_Gender] ([Id] ,[Description])  VALUES ( 1 ,'Male') 
INSERT INTO [tlkp_Gender] ([Id] ,[Description])  VALUES ( 2 ,'Female') 
INSERT INTO [tlkp_Gender] ([Id] ,[Description])  VALUES ( 3 ,'Intersex or indeterminate') 
-- INSERT INTO [tlkp_Gender] ([Id] ,[Description])  VALUES ( 88 ,'Unknown') 
-- INSERT INTO [tlkp_Gender] ([Id] ,[Description])  VALUES ( 99 ,'Not stated/Inadequately described') 

DELETE FROM [tlkp_HealthStatus]
INSERT INTO [tlkp_HealthStatus] ([Id],[Description]) VALUES(0, 'Alive')
INSERT INTO [tlkp_HealthStatus] ([Id],[Description]) VALUES(1, 'Deceased')
-- INSERT INTO [tlkp_HealthStatus] ([Id],[Description]) VALUES(2, 'Unknown')


-- DELETE FROM [tlkp_Consent]
-- INSERT INTO [tlkp_Consent] ([Id],[Description]) VALUES(0,'Patient did not opt off after 2 weeks ')
-- INSERT INTO [tlkp_Consent] ([Id],[Description]) VALUES(1,'Patient opt off')
-- INSERT INTO [tlkp_Consent] ([Id],[Description]) VALUES(2,'Letter not yet sent and health status not confirmed')
-- INSERT INTO [tlkp_Consent] ([Id],[Description]) VALUES(3,'Letter sent')

DELETE FROM [tlkp_OptOutReason]
INSERT INTO [tlkp_OptOutReason] ([Id],[Description]) VALUES(1,'Not interested')
INSERT INTO [tlkp_OptOutReason] ([Id],[Description]) VALUES(2,'Concerned about data privacy')
INSERT INTO [tlkp_OptOutReason] ([Id],[Description]) VALUES(3,'Unable to consent')
INSERT INTO [tlkp_OptOutReason] ([Id],[Description]) VALUES(4,'Lost contact')
INSERT INTO [tlkp_OptOutReason] ([Id],[Description]) VALUES(5,'Other')

DELETE FROM [tlkp_OptOffStatus]
INSERT INTO [tlkp_OptOffStatus] ([Id],[Description]) VALUES(0,'Consented')
INSERT INTO [tlkp_OptOffStatus] ([Id],[Description]) VALUES(1,'Yes (Total Opt Off)')
INSERT INTO [tlkp_OptOffStatus] ([Id],[Description]) VALUES(2,'Yes (Partial Opt Off)')
INSERT INTO [tlkp_OptOffStatus] ([Id],[Description]) VALUES(3,'Unconsented')
INSERT INTO [tlkp_OptOffStatus] ([Id],[Description]) VALUES(4,'LTFU')

DELETE FROM [tlkp_CauseOfDeath]
INSERT INTO [tlkp_CauseOfDeath] ([Id],[Description]) VALUES(1,'Definitely or probably related to breast implant')
INSERT INTO [tlkp_CauseOfDeath] ([Id],[Description]) VALUES(2,'Unlikely or not related tobreast implant')
INSERT INTO [tlkp_CauseOfDeath] ([Id],[Description]) VALUES(-1,'Unable to be ascertained')

DELETE FROM [tlkp_FollowUpPeriod]
INSERT INTO [tlkp_FollowUpPeriod] ([Id],[Description]) VALUES(0,'30 days')
INSERT INTO [tlkp_FollowUpPeriod] ([Id],[Description]) VALUES(1,'1yr')
INSERT INTO [tlkp_FollowUpPeriod] ([Id],[Description]) VALUES(2,'2yr')
INSERT INTO [tlkp_FollowUpPeriod] ([Id],[Description]) VALUES(3,'3yr')
INSERT INTO [tlkp_FollowUpPeriod] ([Id],[Description]) VALUES(4,'4yr')
INSERT INTO [tlkp_FollowUpPeriod] ([Id],[Description]) VALUES(5,'5yr')
INSERT INTO [tlkp_FollowUpPeriod] ([Id],[Description]) VALUES(6,'6yr')
INSERT INTO [tlkp_FollowUpPeriod] ([Id],[Description]) VALUES(7,'7yr')
INSERT INTO [tlkp_FollowUpPeriod] ([Id],[Description]) VALUES(8,'8yr')
INSERT INTO [tlkp_FollowUpPeriod] ([Id],[Description]) VALUES(9,'9yr')
INSERT INTO [tlkp_FollowUpPeriod] ([Id],[Description]) VALUES(10,'10yr')

DELETE FROM [tlkp_FollowUp_FUVal]
INSERT [tlkp_FollowUp_FUVal]([Id] ,[Description])  VALUES ( 0 ,'Incomplete')
INSERT [tlkp_FollowUp_FUVal]([Id] ,[Description])  VALUES ( 1 ,'Incomplete')
INSERT [tlkp_FollowUp_FUVal]([Id] ,[Description])  VALUES ( 2 ,'Completed')
INSERT [tlkp_FollowUp_FUVal]([Id] ,[Description])  VALUES ( 3 ,'Not Applicable')
INSERT [tlkp_FollowUp_FUVal]([Id] ,[Description])  VALUES ( 4 ,'Not Due')



DELETE FROM [tlkp_SentinelEvent]
INSERT INTO [tlkp_SentinelEvent] ([Id],[Description]) VALUES(1,'Unplanned return to theatre')
INSERT INTO [tlkp_SentinelEvent] ([Id],[Description]) VALUES(2,'Unplanned ICU admission')
INSERT INTO [tlkp_SentinelEvent] ([Id],[Description]) VALUES(3,'Unplanned re-admission to hospital')

DELETE FROM [tlkp_DiabetesTreatment]
INSERT INTO [tlkp_DiabetesTreatment] ([Id],[Description]) VALUES(1,'Diet/exercise')
INSERT INTO [tlkp_DiabetesTreatment] ([Id],[Description]) VALUES(2,'Oral (mono) therapy')
INSERT INTO [tlkp_DiabetesTreatment] ([Id],[Description]) VALUES(3,'Oral (poly) therapy')
INSERT INTO [tlkp_DiabetesTreatment] ([Id],[Description]) VALUES(4,'Insulin')
INSERT INTO [tlkp_DiabetesTreatment] ([Id],[Description]) VALUES(5,'Not stated')

DELETE FROM [tlkp_AttemptedCalls]
INSERT INTO [tlkp_AttemptedCalls] ([Id],[Description]) VALUES(1,'1')
INSERT INTO [tlkp_AttemptedCalls] ([Id],[Description]) VALUES(2,'2')
INSERT INTO [tlkp_AttemptedCalls] ([Id],[Description]) VALUES(3,'3')
INSERT INTO [tlkp_AttemptedCalls] ([Id],[Description]) VALUES(4,'4')
INSERT INTO [tlkp_AttemptedCalls] ([Id],[Description]) VALUES(5,'5')

DELETE FROM [tlkp_AboriginalStatus]
INSERT INTO [tlkp_AboriginalStatus] ([Id] ,[Description])  VALUES ( 1 ,'Neither Aboriginal nor Torres Strait Islander') 
INSERT INTO [tlkp_AboriginalStatus] ([Id] ,[Description])  VALUES ( 2 ,'Aboriginal') 
INSERT INTO [tlkp_AboriginalStatus] ([Id] ,[Description])  VALUES ( 3 ,'Torres Strait Islander') 
INSERT INTO [tlkp_AboriginalStatus] ([Id] ,[Description])  VALUES ( 4 ,'Both Aboriginal & Torres Strait Islander') 
INSERT INTO [tlkp_AboriginalStatus] ([Id] ,[Description])  VALUES ( 5 ,'Unknown') 

DELETE FROM [tlkp_IndigenousStatus]
INSERT INTO [tlkp_IndigenousStatus] ([Id] ,[Description])  VALUES ( 1 ,'Neither Maori nor Pacific Islander') 
INSERT INTO [tlkp_IndigenousStatus] ([Id] ,[Description])  VALUES ( 2 ,'Maori') 
INSERT INTO [tlkp_IndigenousStatus] ([Id] ,[Description])  VALUES ( 3 ,'Pacific Islander') 
INSERT INTO [tlkp_IndigenousStatus] ([Id] ,[Description])  VALUES ( 4 ,'Both Maori & Pacific Islander') 
INSERT INTO [tlkp_IndigenousStatus] ([Id] ,[Description])  VALUES ( 5 ,'Other') 
INSERT INTO [tlkp_IndigenousStatus] ([Id] ,[Description])  VALUES ( 6 ,'Unknown') 

delete from [dbo].[tlkp_OperationType]
INSERT INTO [dbo].[tlkp_OperationType] ([Id] ,[Description])  VALUES ( 1 ,'Primary') 
INSERT INTO [dbo].[tlkp_OperationType] ([Id] ,[Description])  VALUES ( 2 ,'Revision') 	

delete from [dbo].[tlkp_YesNoNotknownNotStated]
INSERT INTO [dbo].[tlkp_YesNoNotknownNotStated] ([Id] ,[Description])  VALUES ( 0 ,'No') 
INSERT INTO [dbo].[tlkp_YesNoNotknownNotStated] ([Id] ,[Description])  VALUES ( 1 ,'Yes') 	
INSERT INTO [dbo].[tlkp_YesNoNotknownNotStated] ([Id] ,[Description])  VALUES ( 88 ,'Not known') 	
INSERT INTO [dbo].[tlkp_YesNoNotknownNotStated] ([Id] ,[Description])  VALUES ( 99 ,'Not stated') 

delete from [dbo].[tlkp_OperationStatus]
INSERT INTO [dbo].[tlkp_OperationStatus] ([Id] ,[Description])  VALUES ( 0 ,'Primary bariatric procedure') 	
INSERT INTO [dbo].[tlkp_OperationStatus] ([Id] ,[Description])  VALUES ( 1 ,'Revision bariatric procedure') 

delete from [dbo].[tlkp_Procedure]
INSERT INTO [dbo].[tlkp_Procedure] ([Id] ,[Description])  VALUES ( 1 ,'Gastric banding') 	
INSERT INTO [dbo].[tlkp_Procedure] ([Id] ,[Description])  VALUES ( 2 ,'Gastroplasty') 	
INSERT INTO [dbo].[tlkp_Procedure] ([Id] ,[Description])  VALUES ( 3 ,'R-Y gastric bypass') 
INSERT INTO [dbo].[tlkp_Procedure] ([Id] ,[Description])  VALUES ( 4 ,'Single anastomosis gastric bypass') 	
INSERT INTO [dbo].[tlkp_Procedure] ([Id] ,[Description])  VALUES ( 5 ,'Sleeve gastrectomy') 
INSERT INTO [dbo].[tlkp_Procedure] ([Id] ,[Description])  VALUES ( 6 ,'Bilio pancreatic bypass/duodenal switch') 
INSERT INTO [dbo].[tlkp_Procedure] ([Id] ,[Description])  VALUES ( 7 ,'Gastric imbrication') 
INSERT INTO [dbo].[tlkp_Procedure] ([Id] ,[Description])  VALUES ( 8 ,'Gastric imbrication, plus gastric band (iBand)') 
INSERT INTO [dbo].[tlkp_Procedure] ([Id] ,[Description])  VALUES ( 9 ,'Other (specify)') 
INSERT INTO [dbo].[tlkp_Procedure] ([Id] ,[Description])  VALUES ( 10 ,'Port revision') 
INSERT INTO [dbo].[tlkp_Procedure] ([Id] ,[Description])  VALUES ( 11 ,'Surgical reversal') 
INSERT INTO [dbo].[tlkp_Procedure] ([Id] ,[Description])  VALUES ( 99 ,'Not stated/inadequately described') 

--delete from [dbo].[tlkp_BandType]
--INSERT INTO [dbo].[tlkp_BandType] ([Id] ,[Description])  VALUES ( 1 ,'Lap-Band') 	
--INSERT INTO [dbo].[tlkp_BandType] ([Id] ,[Description])  VALUES ( 2 ,'Realize band') 	
--INSERT INTO [dbo].[tlkp_BandType] ([Id] ,[Description])  VALUES ( 3 ,'Bioring band') 
--INSERT INTO [dbo].[tlkp_BandType] ([Id] ,[Description])  VALUES ( 4 ,'MiniMizer band')
--INSERT INTO [dbo].[tlkp_BandType] ([Id] ,[Description])  VALUES ( 5 ,'Midband')
--INSERT INTO [dbo].[tlkp_BandType] ([Id] ,[Description])  VALUES ( 6 ,'HAGA band')
--INSERT INTO [dbo].[tlkp_BandType] ([Id] ,[Description])  VALUES ( 99 ,'Not stated/inadequately described')

delete from [dbo].[tlkp_YesNoNotStated]
INSERT INTO [dbo].[tlkp_YesNoNotStated] ([Id] ,[Description])  VALUES ( 0 ,'No') 	
INSERT INTO [dbo].[tlkp_YesNoNotStated] ([Id] ,[Description])  VALUES ( 1 ,'Yes') 	
INSERT INTO [dbo].[tlkp_YesNoNotStated] ([Id] ,[Description])  VALUES ( 99 ,'Not stated/inadequately described') 


DELETE FROM [tlkp_ReasonSlip]
INSERT [tlkp_ReasonSlip]([Id] ,[Description])  VALUES ( 1 ,'Anterior')
INSERT [tlkp_ReasonSlip]([Id] ,[Description])  VALUES ( 2 ,'Posterior')
INSERT [tlkp_ReasonSlip]([Id] ,[Description])  VALUES ( 3 ,'Unspecified')

DELETE FROM [tlkp_ReasonPort]
INSERT [tlkp_ReasonPort]([Id] ,[Description])  VALUES ( 1 ,'Leak baseplate')
INSERT [tlkp_ReasonPort]([Id] ,[Description])  VALUES ( 2 ,'Tubing problem')
INSERT [tlkp_ReasonPort]([Id] ,[Description])  VALUES ( 3 ,'Needlestick injury')
INSERT [tlkp_ReasonPort]([Id] ,[Description])  VALUES ( 4 ,'Infection')
INSERT [tlkp_ReasonPort]([Id] ,[Description])  VALUES ( 5 ,'Detached')
INSERT [tlkp_ReasonPort]([Id] ,[Description])  VALUES ( 6 ,'Difficult access')
INSERT [tlkp_ReasonPort]([Id] ,[Description])  VALUES ( 7 ,'NOS')
INSERT [tlkp_ReasonPort]([Id] ,[Description])  VALUES ( 8 ,'Haematoma/Seroma')

DELETE FROM [tlkp_Complications]
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (1,'Prolapse/Slip')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (2,'Symmetrical pouch dilatation')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (3,'Erosion of Band')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (4,'Gastric Perforation')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (5,'Infected Gastric Band')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (6,'Leak from Gastric Band')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (7,'Malposition of Band')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (8,'Port')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (9,'Band unbuckled')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (10,'Wound dehiscence')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (11,'Wound infection')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (12,'DVT/PE')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (13,'Haemorrhage')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (14,'Torsion')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (15,'Staple line haemorrhage')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (16,'Leak')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (17,'Refractory Reflux')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (18,'Dysphagia NOS')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (19,'Haemorrhage NOS')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (20,'Internal hernia')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (21,'Malnutrition')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (22,'Suture line hernia')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (23,'Perforation')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (24,'Pouch dilatation')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (25,'Sternal stenosis')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (26,'Staple line failure')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (27,'Other')
INSERT [tlkp_Complications]([Id] ,[Description])  VALUES (28,'Bowel Perforation')
-- Adding complications to procedures
DELETE FROM [tbl_Complications]
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (1,1)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (1,2)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (1,3)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (1,4)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (1,5)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (1,6)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (1,7)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (1,8)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (1,9)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (1,10)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (1,11)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (1,12)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (1,13)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (1,27)
--
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (2,23)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (2,24)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (2,25)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (2,26)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (2,17)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (2,16)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (2,13)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (2,10)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (2,11)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (2,12)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (2,27)
--
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (3,15)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (3,16)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (3,20)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (3,21)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (3,18)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (3,19)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (3,10)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (3,11)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (3,12)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (3,27)
--
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (4,15)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (4,16)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (4,20)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (4,21)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (4,18)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (4,19)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (4,10)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (4,11)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (4,12)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (4,27)
--
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (5,14)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (5,15)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (5,16)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (5,17)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (5,18)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (5,19)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (5,10)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (5,11)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (5,12)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (5,27)
--
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (6,15)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (6,16)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (6,20)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (6,21)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (6,18)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (6,19)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (6,10)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (6,11)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (6,12)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (6,27)
----
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (7,22)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (7,13)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (7,18)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (7,19)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (7,10)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (7,11)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (7,12)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (7,27)
----
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,22)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,13)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,18)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,19)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,10)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,11)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,12)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,27)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,1)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,2)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,3)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,4)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,5)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,6)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,7)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,8)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (8,9)

-----
----
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (9,10)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (9,11)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (9,12)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (9,13)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (9,16)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (9,27)
----
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (10,8)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (10,10)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (10,11)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (10,12)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (10,13)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (10,27)
----
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (11,28)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (11,10)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (11,11)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (11,12)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (11,13)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (11,27)
----
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (99,10)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (99,11)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (99,12)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (99,13)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (99,16)
INSERT [tbl_Complications]([ProcedureId],[ComplicationId])  VALUES (99,27)

/* Device tables data */
DELETE FROM [tlkp_DeviceManufacturer]
INSERT [dbo].[tlkp_DeviceManufacturer] ([Description], [IsActive]) VALUES (N'Apollo Endosurgery', 1)
INSERT [dbo].[tlkp_DeviceManufacturer] ([Description], [IsActive]) VALUES (N'Bariatric Solutions', 1)
INSERT [dbo].[tlkp_DeviceManufacturer] ([Description], [IsActive]) VALUES (N'Cousin Biotech', 1)
INSERT [dbo].[tlkp_DeviceManufacturer] ([Description], [IsActive]) VALUES (N'Covidien', 1)
INSERT [dbo].[tlkp_DeviceManufacturer] ([Description], [IsActive]) VALUES (N'Ethicon Endosurgery', 1)
INSERT [dbo].[tlkp_DeviceManufacturer] ([Description], [IsActive]) VALUES ( N'Helioscopie/Matrix Surgical', 1)
INSERT [dbo].[tlkp_DeviceManufacturer] ([Description], [IsActive]) VALUES ( N'Life Healthcare Australia', 1)

DELETE FROM [tbl_DeviceBrand]
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'BIORING', 3, 0, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'BIORING', 3, 1, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'Curved Adjustable Gastric Band', 5, 0, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'Curved Adjustable Gastric Band', 5, 1, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'Curved Adjustable Gastric Band', 5, 2, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'Echelon ENDOPATH', 5, 3, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'Echelon Flex ENDOPATH', 5, 3, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'EEA Circular', 4, 3, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'Endo GIA', 4, 3, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'ENDOPATH ETS', 5, 3, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'Heliogast ', 6, 0, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'Heliogast ', 6, 1, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'Intraluminal Circular Stapler', 5, 3, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'LAP-BAND', 1, 0, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'LAP-BAND ', 1, 1, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'Lap-Band', 1, 2, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'Lap-band', 1, 4, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'MIDband', 7, 0, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'MIDband', 7, 1, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'MiniMizer', 2, 0, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'MiniMizer', 2, 5, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))
INSERT [dbo].[tbl_DeviceBrand] ([Description], [ManufacturerId], [TypeID], [IsActive], [LastUpdateBy], [LastUpdateDateTime], [CreateBy], [CreateDateTime]) VALUES ( N'MiniMizer Port ', 2, 1, 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E28D52 AS DateTime))

DELETE FROM [tbl_Device]
SET IDENTITY_INSERT [dbo].[tbl_Device] ON
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (1, N'AB-20260', 14, N'AP Small', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (2, N'AB-20265', 14, N'AP Large', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (3, N'RLZB32', 3, N'Curved Adjustable Gastric Band with Sutureless Port and Applier', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (4, N'RLZB32D1', 3, N'Curved Adjustable Gastric Band with Gastric Band Dissector.', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (5, N'RLZB32DG1', 3, N'Curved Adjustable Gastric Band with Gastric Band Dissector and Gastric Calibration Tube', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (6, N'MMEX', 20, N'Extra', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (7, N'MID-100-M', 18, N'Pre-curved MIDband', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (8, N'HAGA-EV3', 11, N'Helioscopie Gastric Band  with Advanced EV3 Port', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (9, N'HAGE-EV3', 11, N'Helioscopie Gastric Band - Evolution with EV3 Port', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (10, N'HAGE', 11, N'Helioscopie Gastric Band - Evolution', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (11, N'RINGS 20000', 1, N'2.3cm', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (12, N'BCB R123', 1, N'2.8cm', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (13, N'BCB RIXL', 1, N'3.7cm', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (14, N'B-20101', 15, N'Access Port Kit', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (15, N'B-20304', 15, N'Access Port Kit - Rapid Port EZ', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (16, N'RLZPT2', 4, N'Gastric Band Sutureless Port and Applier.', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (17, N'BCB RIRE PO', 2, N'Access port', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (18, N'H-K Heliogast', 12, N'Standard port replacement kit', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (19, N'H-K Heliogast EV3', 12, N'EV3 port 360 degree injection surface', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (20, N'H-KEV1', 12, N'Low profile port replacement kit', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (21, N'MICPS', 22, N'Small 13 mm', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (22, N'MICPM', 22, N'Medium 18mm', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (23, N'MID-004-605PM ', 19, N'MID-Port', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (26, N'B-20303', 16, N'Rapid Port Tack Assembly', 1, N'cidmu', CAST(0x0000A47600EA49AB AS DateTime), NULL, NULL)
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (27, N'RLZPT2', 5, N'Gastric Band Sutureless Port and Applier.', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (28, N'EGIA45AVM', 9, N'45 mm Tan', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (29, N'EGIA60AVM', 9, N'60 mm Tan', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (30, N'EGIA45AMT', 9, N'45 mm Purple', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (31, N'EGIA60AMT', 9, N'60 mm Purple', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (32, N'EGIA45AXT', 9, N'45 mm Black', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (33, N'EGIA60AXT', 9, N'60 mm Black', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (34, N'EEA25XL', 8, N'25 mm X-long', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (35, N'EEAORVIL', 8, N'25 mm ORVIL', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (36, N'PLE45A', 7, N'45  mm Stapler', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (37, N'ECL45AL', 7, N'45 mm Stapler', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (38, N'PLE60A', 7, N'60 mm Stapler', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (39, N'LONG6A', 7, N'60 mm Stapler', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (40, N'ECLG45', 6, N'45 mm Stapler', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (41, N'LONG60', 6, N'60 mm Stapler', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (42, N'LONG45A', 10, N'45 mm stapler', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (43, N'ECS21A', 13, N'21 mm diameter', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (44, N'ECS25A', 13, N'25 mm diameter', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (45, N'ECS29A', 13, N'29 mm diameter', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (46, N'B-20401', 17, N'Tubing accessory kit', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (47, N'MMRING', 21, N'Minimizer Gastric Ring', 1, NULL, NULL, N'CIDMU', CAST(0x0000A40400E29285 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (48, N'AB-20360', 14, N'AP Small- Rapid port EZ system', 1, NULL, NULL, N'cidmu', CAST(0x0000A47600E97A4F AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (49, N'AB-20365', 14, N'AP Large - Rapid port EZ system', 1, NULL, NULL, N'cidmu', CAST(0x0000A47600E99A19 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (50, N'C-20360', 14, N'AP Small - Rapid port EZ system next gen', 1, NULL, NULL, N'cidmu', CAST(0x0000A47600E9B280 AS DateTime))
INSERT [dbo].[tbl_Device] ([DeviceId], [DeviceModel], [DeviceBrandId], [DeviceDescription], [IsDeviceActive], [LastUpdatedBy], [LastUpdatedDateTime], [CreatedBy], [CreatedDateTime]) VALUES (51, N'C-20365', 14, N'AP Large - Rapid port EZ system next gen', 1, NULL, NULL, N'cidmu', CAST(0x0000A47600E9CF23 AS DateTime))
SET IDENTITY_INSERT [dbo].[tbl_Device] OFF


DELETE FROM [tlkp_PatientGroup]
INSERT [tlkp_PatientGroup]([Id] ,[Description])  VALUES ( 0 ,'Primary Patients')
INSERT [tlkp_PatientGroup]([Id] ,[Description])  VALUES ( 1 ,'Legacy Patients')


/* 15-02-2015 */
/* Auto Incomplete Value is added to the tlkp_Followup_FUVal */
INSERT INTO tlkp_Followup_FUVal([Id],[Description]) VALUES(5, 'Auto Incomplete')