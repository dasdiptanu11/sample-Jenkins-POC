
/****** Object: UserDefinedFunction [dbo].[ufn_Matching_Patients] Script Date: 05/18/2015 15:24:30 ******/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufn_Matching_Patients]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))

DROP FUNCTION [dbo].[ufn_Matching_Patients]

GO


/****** Object: UserDefinedFunction [dbo].[ufn_Matching_Patients] Script Date: 05/18/2015 15:24:30 ******/

SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO




CREATE FUNCTION [dbo].[ufn_Matching_Patients]

(

	@Row_Cnt int --specifies which row of row is requested

)

RETURNS 

@matching_patient TABLE 

(	

	PatId INT NOT NULL,
	PatientURN VARCHAR(20), 
	LastName VARCHAR(50),
	FName VARCHAR(50),
	DOB datetime, 
	GenderId INT NOT NULL,
	Gender VARCHAR(100), 
	McareNo VARCHAR(15),
	DvaNo VARCHAR(15), 
	IHI VARCHAR(20), 
	NhiNo VARCHAR(15), 
	PriSite VARCHAR(200), 
	PriSurg VARCHAR(100), 
	Addr VARCHAR(150), 
	Sub VARCHAR(100), 
	Patstate VARCHAR(55), 
	Pcode VARCHAR(4), 
	Country VARCHAR(50),
	Identifier VARCHAR(20), 
	IdentifierNo VARCHAR(15),	
	OperationDate datetime, 
	OperationType VARCHAR(100),
	OperationHospital VARCHAR(200),
	HomePh VARCHAR(30), 
	MobPh VARCHAR(30), 
	IndigenousSts VARCHAR(100), 
	HealthSts VARCHAR(100),
	OptOffSts VARCHAR(100),
	Title VARCHAR(100),
	OpProc VARCHAR(100),
	ProcAban int ,
	No_of_Matching_Rec int
	)

AS

BEGIN

	declare @DftDate datetime
	set @DftDate = '01/01/1940';	

	With MatchingPatientRecords( OriPatId, MatchingPatId,Identifier, IdentifierNo ) as
	(
	--Same Name and Medicare No/DVA No/IHI No/NHI No
	select p1.PatId,p2.PatId,
	case when p1.IHI = p2.IHI then 'IHI'
	else case when p1.McareNo = p2.McareNo then 'Medicare No'
	else case when p1.DvaNo = p2.DvaNo then 'DVA No'
	else case when p1.NhiNo = p2.NhiNo then 'NHI No' end end end end Identifier, 
	case when p1.IHI = p2.IHI then p1.IHI
		else case when p1.McareNo = p2.McareNo then p1.McareNo
		else case when p1.DvaNo = p2.DvaNo then p1.DvaNo
		else case when p1.NhiNo = p2.NhiNo then p1.NhiNo end end end end IdentifierNo
	from tbl_Patient p1 
		inner join tbl_Patient p2 on p1.FName = p2.FName 
			 and 
		 		 ((coalesce(p1.IHI, 'a') = coalesce(p2.IHI, 'b') and coalesce(p1.IHI, '') <> '') or 
				 (coalesce(p1.McareNo, 'a') = coalesce(p2.McareNo, 'b') and coalesce(p1.McareNo, '') <> '') or 
				 (coalesce(p1.DvaNo, 'a') = coalesce(p2.DvaNo, 'b') and coalesce(p1.DvaNo, '') <> '') or 
				 (coalesce(p1.NhiNo, 'a') = coalesce(p2.NhiNo, 'b') and coalesce(p1.NhiNo, '') <> '' ) ) 
		     and p1.PatId <> p2.PatId 
		     and p1.PriSiteId <> p2.PriSiteId 
	where p1.PatId < p2.PatId 
	Union
	--Same FirstName and LastName and any 2 of DOB's date/year/month and gender
	select p1.PatId,p2.PatId, '' Identifier, '' IdentifierNo
	from tbl_Patient p1 inner join tbl_Patient p2 on 
	    p1.FName = p2.FName 
	    and p1.LastName = p2.LastName 	
	    and 
		((YEAR(p1.dob) = Year(p2.DOB) and MONTH(p1.dob) = MONTH(p2.DOB)) or 
		 (YEAR(p1.dob) = Year(p2.DOB) and DAY(p1.dob) = DAY(p2.DOB)) or 
		 (MONTH(p1.dob) = MONTH(p2.DOB) and DAY(p1.dob) = DAY(p2.DOB))
		)
		and coalesce(p1.GenderId, -1) = coalesce(p2.GenderId, -2) 
		and p1.PatId <> p2.PatId 
		and p1.PriSiteId <> p2.PriSiteId 
	where p1.PatId < p2.PatId 
	union 
	--Same FirstName and DOB and gender
	select p1.PatId, p2.PatId, '' Identifier, '' IdentifierNo
	from tbl_Patient p1 inner join tbl_Patient p2 on 
	  p1.FName = p2.FName 
	  and p1.GenderId = p2.GenderId 
	  and coalesce(p1.DOB, @DftDate) = coalesce(p2.DOB, '02/01/1940') 
	  and p1.PatId <> p2.PatId 
	  and p1.PriSiteId <> p2.PriSiteId 
	where p1.PatId < p2.PatId 
	union 
	--Same LastName and DOB and gender
	select p1.PatId, p2.PatId, '' Identifier, '' IdentifierNo
	from tbl_Patient p1 inner join tbl_Patient p2 on 
	    p1.LastName = p2.LastName 
	    and coalesce(p1.GenderId, -1) = coalesce(p2.GenderId, -2) 
	    and coalesce(p1.DOB, @DftDate) = coalesce(p2.DOB, '02/01/1940')
		and p1.PatId <> p2.PatId 
		and p1.PriSiteId <> p2.PriSiteId 
	where p1.PatId < p2.PatId)
	iNSERT INTO @matching_patient 
	select PatId, coalesce(urn.URNo, '') , p.LastName, p.FName,DOB, coalesce(GenderId, 0), coalesce(g.Description, '') gender, McareNo, DvaNo, IHI, NhiNo, 
		coalesce(sSite.SiteName, '') , coalesce(('Dr ' + u.FName + ' ' + u.LastName), '') PriSurg, Addr, Sub, coalesce(s.Description, '') , Pcode, 
		coalesce(c.Description,'') OriCountry,
		Identifier, IdentifierNo, OperationDate, OperationType , OperationHospital, coalesce(p.HomePh, ''), coalesce(p.MobPh, ''), 
		coalesce(a.Description, ''), coalesce(hlt.Description, ''), coalesce(OSts.Description, '') , coalesce(Title.Description, '') , PatProcedure, coalesce(ProcAban, 0), 
		NO_Rec 
	from tbl_Patient p
		inner join (select COUNT(*) NO_Rec from MatchingPatientRecords WHERE
		((cast(OriPatId as CHAR(15)) + cast(MatchingPatId as CHAR(15))) not in 
		(SELECT (cast(PatId1 as CHAR(15)) + cast(PatId2 as CHAR(15))) from tbl_IgnorePatients )))t1 on 'a' = 'a'
		left outer join 
		--Get the last operation - not abadoned for Patient
		(
			SELECT patientid as patientid1, OpDate as OperationDate, os.Description OperationType , OpStat OpStat1, h.sitename 
					OperationHospital, pr.Description PatProcedure, po.ProcAban ProcAban 
			from tbl_PatientOperation po inner join tlkp_OperationStatus os on OpStat = os.Id 
				inner join tbl_Site h on po.Hosp = h.SiteId 
				inner join tlkp_Procedure pr on pr.Id = case when po.OpStat = 0 then po.OpType else po.OpRevType end
			where coalesce(po.ProcAban, 0) =0 and po.OpDate = (SELECT min(po1.OpDate) from tbl_PatientOperation po1 where po1.patientid = po.patientid and coalesce(po.ProcAban, 0) =0	group by patientid)
		) OperationDetails1 on patientid1 = PatId
		left outer join tlkp_State s on s.Id = StateId
		left outer join tlkp_Country c on c.Id = CountryId
		left outer join tlkp_Gender g on g.Id = GenderId 
		left outer join tbl_User u on u.UserId = PriSurgId
		left outer join tbl_Site sSite on sSite.SiteId = PriSiteId
		left outer join tbl_URN Urn on Urn.PatientID = PatId and Urn.HospitalID = PriSiteId 
		LEFT outer join tlkp_AboriginalStatus a on a.Id = p.AborStatusId 
		left outer join tlkp_HealthStatus hlt on hlt.Id = p.HStatId 
		inner join 
		 (
		  SELECt row_number() over(order by OriPatId, MatchingPatId) Row_Cnt , OriPatId, MatchingPatId, Identifier, IdentifierNo 
		  from MatchingPatientRecords where ((cast(OriPatId as CHAR(15)) + cast(MatchingPatId as CHAR(15))) not in (SELECT (cast(PatId1 as CHAR(15)) + cast(PatId2 as CHAR(15))) from tbl_IgnorePatients ))
		 ) mrecs on (p.PatId = OriPatId or p.PatId = MatchingPatId) and Row_Cnt = @Row_Cnt 
		left outer join tlkp_OptOffStatus OSts on OSts.Id = p.OptOffStatId 
		left outer join tlkp_Title Title on Title.Id = p.TitleId 


	RETURN 

END










GO
