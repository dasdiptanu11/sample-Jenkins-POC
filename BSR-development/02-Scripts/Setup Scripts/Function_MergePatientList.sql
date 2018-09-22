
/****** Object:  UserDefinedFunction [dbo].[ufn_Matching_Patient_List]    Script Date: 11/28/2014 13:52:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufn_Matching_Patient_List]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ufn_Matching_Patient_List]
GO


/****** Object:  UserDefinedFunction [dbo].[ufn_Matching_Patient_List]    Script Date: 11/28/2014 13:52:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[ufn_Matching_Patient_List]
()
RETURNS 
@matching_patient_Table TABLE 
(	
	
		OriPatId INT NOT NULL,
	    OriPatientURN VARCHAR(20), 	    
	    OriLastName VARCHAR(50),
	    OriFName VARCHAR(50),
	    OriDOB datetime, 
	    OriGenderId INT NOT NULL,
	    OriGender VARCHAR(100), 
	    OriMcareNo VARCHAR(15),
	    OriDvaNo VARCHAR(15), 
	    OriIHI VARCHAR(20), 
	    OriNhiNo VARCHAR(15), 
		OriPriSite VARCHAR(200), 
		OriPriSurg VARCHAR(100), 		
		OriAddr VARCHAR(150), 
		OriSub VARCHAR(100), 
		OriState VARCHAR(55), 
		OriPcode VARCHAR(4), 
		OriCountry VARCHAR(50),
		OriHomePh VARCHAR(30), 
		OriMobPh VARCHAR(30), 
		OriIndigenousSts VARCHAR(100),
		MatchingPatId int NOT NULL, 
		MatchingPatientURN VARCHAR(50), 
		MatchingLastName VARCHAR(50),
		MatchingFName VARCHAR(50),
		MatchingDOB datetime, 
		MatchingGenderId INT NOT NULL, 
		MatchingGender VARCHAR(100), 
		MatchingMcareNo VARCHAR(15), 
		MatchingDvaNo VARCHAR(15), 
		MatchingIHI VARCHAR(20), 
		MatchingNhiNo VARCHAR(15), 
		MatchingPriSite VARCHAR(200), 
		MatchingPriSurg VARCHAR(100), 
		MatchingAddr VARCHAR(150), 
		MatchingSub VARCHAR(100), 
		MatchingState VARCHAR(55), 
		MatchingPcode VARCHAR(15), 
		MatchingCountry VARCHAR(50),
		MatchingHomePh VARCHAR(30), 
		MatchingMobPh VARCHAR(30), 
		MatchingIndigenousSts VARCHAR(100), 
		Identifier VARCHAR(20), 
		IdentifierNo VARCHAR(15), 
		OriOpDate datetime, 
		OriOperationType  VARCHAR(100),
		OriHosp VARCHAR(200),
		MatchingOpDate datetime, 
		MatchingOperationType  VARCHAR(100),
		MatchingHosp VARCHAR(200),
		OriHealthSts VARCHAR(100),
		MatchingHealthSts VARCHAR(100),
		OriOptOffSts  VARCHAR(100),
		MatchingOptOffSts  VARCHAR(100),
		OriTitle  VARCHAR(100),
		MatchingTitle  VARCHAR(100),
		OriOpProc  VARCHAR(100),
		MatchingOpProc  VARCHAR(100)
)
AS
BEGIN

		declare @DftDate datetime
	    set @DftDate = '01/01/1940';
	    
		With 
		MatchingPatientRecords( OriPatId,OriLastName,OriFName,OriDOB, OriGenderId, OriMcareNo, OriDvaNo, OriIHI, OriNhiNo, 
		OriPriSiteId,OriPriSurgId, OriAddr, OriSub, OriStateId, OriPcode, OriCountryId,OriHomePh ,OriMobPh, OriAborStatusId ,
		MatchingPatId,MatchingLastName,MatchingFName,MatchingDOB, MatchingGenderId, MatchingMcareNo, 
		MatchingDvaNo, MatchingIHI, MatchingNhiNo, MatchingPriSiteId,MatchingPriSurgId, MatchingAddr, MatchingSub, 
		MatchingStateId, MatchingPcode, MatchingCountryId, MatchingHomePh ,MatchingMobPh, MatchingAborStatusId , 
		Identifier, IdentifierNo, OriHStatId , MatchingHStatId, OriOptOffStsID, MatchingOptOffStsID,
		OriTitleId,  MatchingTitleId ) as
		(
		--Same Name and Medicare No/DVA No/IHI No/NHI No
		select p1.PatId, p1.LastName,p1.FName,p1.DOB, p1.GenderId, p1.McareNo, p1.DvaNo, p1.IHI, p1.NhiNo, p1.PriSiteId,
		p1.PriSurgId, p1.Addr, p1.Sub, p1.StateId, p1.Pcode, p1.CountryId, coalesce(p1.HomePh , ''), coalesce(p1.MobPh , ''), 
		p1.AborStatusId,
		p2.PatId,p2.LastName,p2.FName,p2.DOB, p2.GenderId, p2.McareNo, p2.DvaNo, p2.IHI, p2.NhiNo, p2.PriSiteId,
		p2.PriSurgId, p2.Addr, p2.Sub, p2.StateId, p2.Pcode, p2.CountryId,  coalesce(p2.HomePh , ''), coalesce(p2.MobPh , ''), 
		p2.AborStatusId, 
		case when p1.IHI = p2.IHI then 'IHI'
		else case when p1.McareNo = p2.McareNo then 'Medicare No'
		else case when p1.DvaNo = p2.DvaNo then 'DVA No'
		else case when p1.NhiNo = p2.NhiNo then 'NHI No' end end end end Identifier, 
		case when p1.IHI = p2.IHI then p1.IHI
		else case when p1.McareNo = p2.McareNo then p1.McareNo
		else case when p1.DvaNo = p2.DvaNo then p1.DvaNo
		else case when p1.NhiNo = p2.NhiNo then p1.NhiNo end end end end IdentifierNo,
		p1.HStatId , p2.HStatId,p1.OptOffStatId ,p2.OptOffStatId, p1.TitleId , p2.TitleId 
		from tbl_Patient p1 
		inner join tbl_Patient p2 on p1.FName = p2.FName and (p1.IHI = p2.IHI or p1.McareNo = p2.McareNo or p1.DvaNo = p2.DvaNo or p1.NhiNo = p2.NhiNo )
		and p1.PatId <> p2.PatId and p1.PriSiteId <> p2.PriSiteId 
		where p1.PatId < p2.PatId 
		Union
		--Same FirstName and LastName and any 2 of DOB's date/year/month and gender
		select p1.PatId,p1.LastName,p1.FName,p1.DOB, p1.GenderId, p1.McareNo, p1.DvaNo, p1.IHI, p1.NhiNo, p1.PriSiteId,
		p1.PriSurgId, p1.Addr, p1.Sub, p1.StateId, p1.Pcode, p1.CountryId,coalesce(p1.HomePh , ''), coalesce(p1.MobPh , ''), 
		p1.AborStatusId,
		p2.PatId,p2.LastName,p2.FName,p2.DOB, p2.GenderId, p2.McareNo, p2.DvaNo, p2.IHI, p2.NhiNo, p2.PriSiteId,
		p2.PriSurgId, p2.Addr, p2.Sub, p2.StateId, p2.Pcode, p2.CountryId,  coalesce(p2.HomePh , ''), coalesce(p2.MobPh , ''), 
		p2.AborStatusId ,'' Identifier, '' IdentifierNo, p1.HStatId , p2.HStatId ,p1.OptOffStatId ,p2.OptOffStatId,
		p1.TitleId , p2.TitleId 
		from tbl_Patient p1 
		inner join tbl_Patient p2 on p1.FName = p2.FName and p1.LastName = p2.LastName 
		and 
		(
		(YEAR(p1.dob) = Year(p2.DOB) and MONTH(p1.dob) = MONTH(p2.DOB)) 
		or  (YEAR(p1.dob) = Year(p2.DOB) and DAY(p1.dob) = DAY(p2.DOB)) 
		or  (MONTH(p1.dob) = MONTH(p2.DOB) and DAY(p1.dob) = DAY(p2.DOB))
		)
		and p1.GenderId = p2.GenderId 
		and p1.PatId <> p2.PatId and p1.PriSiteId <> p2.PriSiteId 
		where p1.PatId < p2.PatId 
		union 
		--Same FirstName and DOB and gender
		select p1.PatId,p1.LastName,p1.FName,p1.DOB, p1.GenderId, p1.McareNo, p1.DvaNo, p1.IHI, p1.NhiNo, p1.PriSiteId,
		p1.PriSurgId, p1.Addr, p1.Sub, p1.StateId, p1.Pcode, p1.CountryId,coalesce(p1.HomePh , ''), coalesce(p1.MobPh , ''), 
		p1.AborStatusId ,
		p2.PatId,p2.LastName,p2.FName,p2.DOB, p2.GenderId, p2.McareNo, p2.DvaNo, p2.IHI, p2.NhiNo, p2.PriSiteId,
		p2.PriSurgId, p2.Addr, p2.Sub, p2.StateId, p2.Pcode, p2.CountryId,  coalesce(p2.HomePh , ''), coalesce(p2.MobPh , ''), 
		p2.AborStatusId ,'' Identifier, '' IdentifierNo, p1.HStatId , p2.HStatId ,p1.OptOffStatId ,p2.OptOffStatId
		,p1.TitleId , p2.TitleId  from tbl_Patient p1 
		inner join tbl_Patient p2 on p1.FName = p2.FName and 
		p1.GenderId = p2.GenderId and coalesce(p1.DOB, @DftDate) =  coalesce(p2.DOB, '02/01/1940')
		and p1.PatId <> p2.PatId and p1.PriSiteId <> p2.PriSiteId 
		where p1.PatId < p2.PatId 
		union 
		--Same LastName and DOB and gender
		select p1.PatId,p1.LastName,p1.FName,p1.DOB, p1.GenderId, p1.McareNo, p1.DvaNo, p1.IHI, p1.NhiNo, p1.PriSiteId,
		p1.PriSurgId, p1.Addr, p1.Sub, p1.StateId, p1.Pcode, p1.CountryId,coalesce(p1.HomePh , ''), coalesce(p1.MobPh , ''), 
		p1.AborStatusId ,	
		p2.PatId,p2.LastName,p2.FName,p2.DOB, p2.GenderId, p2.McareNo, p2.DvaNo, p2.IHI, p2.NhiNo, p2.PriSiteId,
		p2.PriSurgId, p2.Addr, p2.Sub, p2.StateId, p2.Pcode, p2.CountryId,  coalesce(p2.HomePh , ''), coalesce(p2.MobPh , ''), 
		p2.AborStatusId ,'' Identifier, '' IdentifierNo, p1.HStatId , p2.HStatId ,p1.OptOffStatId ,p2.OptOffStatId 
		,  p1.TitleId , p2.TitleId 
		from tbl_Patient p1 
		inner join tbl_Patient p2 on p1.LastName = p2.LastName and 
		p1.GenderId = p2.GenderId and coalesce(p1.DOB, @DftDate) =  coalesce(p2.DOB, '02/01/1940')
		and p1.PatId <> p2.PatId and p1.PriSiteId <> p2.PriSiteId 
		where p1.PatId < p2.PatId )
		iNSERT INTO @matching_patient_Table 
		select OriPatId, OriUrn.URNo OriPatientURN, OriLastName,OriFName,OriDOB, OriGenderId,sGenOri.Description , OriMcareNo, OriDvaNo, OriIHI, OriNhiNo, 
		sOriSite.SiteName OriPriSite, ('Dr ' + uOri.FName + ' ' + uOri.LastName) OriPriSurg, OriAddr, OriSub, sOri.Description OriState , OriPcode,
		cOri.Description OriCountry, OriHomePh ,OriMobPh, aOri.Description OriAborStatus,
		MatchingPatId, MatchingUrn.URNo MatchingPatientURN , MatchingLastName,MatchingFName,MatchingDOB, MatchingGenderId,sGenMatching.Description , MatchingMcareNo, MatchingDvaNo, MatchingIHI, 
		MatchingNhiNo, sMatchingSite.SiteName MatchingPriSite, ('Dr.' + ' ' + uMatching.FName + ' ' + uMatching.LastName) MatchingPriSurg, 
		MatchingAddr, MatchingSub, sMatching.Description MatchingState, MatchingPcode, 
		cMatching.Description MatchingCountry,   MatchingHomePh ,MatchingMobPh, aMatching.Description  MatchingAborStatus, Identifier, IdentifierNo ,
		OpDate1, OperationType1, Hosp1, OpDate2, OperationType2, Hosp2, hltOri.Description , hltMat.Description, 
		OriOSts.Description, MatchingOSts.Description, OriTitle.Description , MatchingTitle.Description ,  Procedure1, Procedure2
		from 
		MatchingPatientRecords 
		left outer join 
		--Get the last operation - not abadoned for oriPatient
		(SELECT patientid as patientid1, OpDate as OpDate1, os.Description OperationType1 , OpStat OpStat1, s.SiteName Hosp1, 
		pr.Description Procedure1 from tbl_PatientOperation po 
		inner join tlkp_OperationStatus os on OpStat = os.Id 
		inner join tbl_Site s on po.Hosp = s.SiteId 
		inner join tlkp_Procedure pr on pr.Id = case when po.OpStat = 0 then po.OpType else po.OpRevType end
		where coalesce(po.ProcAban, 0) =0 and po.OpDate = 
		(SELECT min(po1.OpDate) from tbl_PatientOperation po1 where po1.patientid = po.patientid group by patientid )) OperationDetails1 
		on patientid1 = OriPatId
		left outer join 
		--Get the last operation - not abadoned for matching Patient
		(SELECT patientid as patientid2, OpDate as OpDate2, os.Description OperationType2 , OpStat OpStat2, s.SiteName Hosp2,
		pr.Description Procedure2
		from tbl_PatientOperation po 
		inner join tlkp_OperationStatus os on OpStat = os.Id 
		inner join tbl_Site s on po.Hosp = s.SiteId 
		inner join tlkp_Procedure pr on pr.Id = case when po.OpStat = 0 then po.OpType else po.OpRevType end
		where coalesce(po.ProcAban, 0) =0 and 
		po.OpDate = 
		(SELECT min(po1.OpDate) from tbl_PatientOperation po1 where po1.PatientId = po.patientid group by patientid )) OperationDetails2
		on patientid2 = MatchingPatId 
		and  ((cast(patientid1 as CHAR(15)) + cast(patientid2 as CHAR(15))) not in 
		  (SELECT (cast(PatId1 as CHAR(15)) + cast(PatId2 as CHAR(15))) from tbl_IgnorePatients ))  
		--getting gender 
		LEFT outer join tlkp_State sOri on  sOri.Id = OriStateId
		LEFT outer join tlkp_State sMatching on  sMatching.Id = MatchingStateId
		inner join tlkp_Country cOri on  cOri.Id = OriCountryId
		LEFT outer join tlkp_State cMatching on  cMatching.Id = MatchingCountryId
		inner join tbl_User uOri on uOri.UserId = OriPriSurgId 
		--inner join aspnet_Users auOri on auOri.UserId = uOri.UId  
		inner join tbl_User uMatching on uMatching.UserId = MatchingPriSurgId 
		--inner join aspnet_Users auMatching on auMatching.UserId = uMatching.UId  
		inner join tbl_Site sOriSite on sOriSite.SiteId =  OriPriSiteId
		inner join tbl_Site sMatchingSite on sMatchingSite.SiteId =  MatchingPriSiteId 
		inner join tbl_URN OriUrn on OriUrn.PatientID = OriPatId and OriUrn.HospitalID = OriPriSiteId 
		inner join tbl_URN MatchingUrn on MatchingUrn.PatientID = MatchingPatId and MatchingUrn.HospitalID = MatchingPriSiteId 
		inner join tlkp_Gender sGenOri on  sGenOri.Id = OriGenderId 
		inner join tlkp_Gender sGenMatching on  sGenMatching.Id = MatchingGenderId 		
		LEFT outer join tlkp_AboriginalStatus aMatching on  aMatching.Id = MatchingAborStatusId 
		LEFT outer join tlkp_AboriginalStatus aOri on  aOri.Id = OriAborStatusId 	
		inner join tlkp_HealthStatus hltOri on  hltOri.Id = OriHStatId 		
		inner join tlkp_HealthStatus hltMat on  hltMat.Id = MatchingHStatId 
		inner join tlkp_OptOffStatus OriOSts on  OriOSts.Id = OriOptOffStsID 
		inner join tlkp_OptOffStatus MatchingOSts on  MatchingOSts.Id = MatchingOptOffStsID 
		inner join tlkp_Title MatchingTitle on  MatchingTitle.Id = MatchingTitleId  
		inner join tlkp_Title OriTitle on  OriTitle.Id = OriTitleId 
	
	RETURN 
END














GO


