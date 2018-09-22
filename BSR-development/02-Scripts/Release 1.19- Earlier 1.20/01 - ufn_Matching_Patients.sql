ALTER FUNCTION [dbo].[ufn_Matching_Patients]  (
	@Row_Cnt int --specifies which row of row is requested
)

RETURNS 

@matching_patient TABLE (	
	PatId INT NOT NULL,
	PatientURN VARCHAR(20), 
	LastName VARCHAR(50),
	FName VARCHAR(50),
	DOB datetime, 
	GenderId INT NULL,
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
	Identifier VARCHAR(max), 
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

Declare @RecordsReturned int
Declare @SourceData table (
	Primarypatid int,
	Primaryfname varchar(100) null,
	Primarylastname varchar(100) null,
	PrimarycountryId int null,
	PrimaryMcareNo varchar(100) null,
	PrimaryIHI varchar(100) null,
	PrimaryDvaNo varchar(100) null,
	PrimaryGenderId int null,
	PrimaryNhiNo varchar(100) null,
	PrimaryDOB datetime null,
	PrimaryURNo varchar(100) null,
	Primaryhospitalid int null,
	Primaryaddr varchar(100) null,
	Primarysub varchar(100) null,
	PrimaryStateId int null,
	Primarypcode varchar(100) null,
	PrimaryPriSiteId int null,
	PrimaryPriSurgId int null,
	PrimaryHomePh varchar(100) null,
	PrimaryMobPh varchar(100) null,
	PrimaryIndiStatusId int null, 
	PrimaryHStatId int null,
	PrimaryOptOffStatId int null,
	PrimaryTitleId int null,
	Secondarypatid int,
	Secondaryfname varchar(100) null,
	Secondarylastname varchar(100) null,
	SecondarycountryId int null,
	SecondaryMcareNo varchar(100) null,
	SecondaryIHI varchar(100) null,
	SecondaryDvaNo varchar(100) null,
	SecondaryGenderId int null,
	SecondaryNhiNo varchar(100) null,
	SecondaryDOB datetime null,
	SecondaryURNo varchar(100) null,
	Secondaryhospitalid int null,
	Secondaryaddr varchar(100) null,
	Secondarysub varchar(100) null,
	SecondaryStateId int null,
	Secondarypcode varchar(100) null,
	SecondaryPriSiteId int null,
	SecondaryPriSurgId int null,
	SecondaryHomePh varchar(100) null,
	SecondaryMobPh varchar(100) null,
	SecondaryIndiStatusId int null, 
	SecondaryHStatId int null,
	SecondaryOptOffStatId int null,
	SecondaryTitleId int null,
	Identifier varchar(max),
	filter int,
	MatchRank int,
	CleaningMatchRow int,
	MatchRow int
);

Declare @ResultData table (
	Primarypatid int,
	PrimaryURNo varchar(100) null,
	Primarylastname varchar(100) null,
	Primaryfname varchar(100) null,
	PrimaryDOB datetime null,
	PrimaryGenderId int null,
	PrimaryGenderLabel varchar(100) null,
	PrimaryMcareNo varchar(100) null,
	PrimaryDvaNo varchar(100) null,
	PrimaryIHI varchar(100) null,
	PrimaryNhiNo varchar(100) null,
	PrimaryConsentSiteName varchar(100) null,
	PrimaryPriSurgId int,
	Primaryaddr varchar(100) null,
	Primarysub varchar(100) null,
	PrimaryStateName varchar(100) null,
	Primarypcode varchar(100) null,
	PrimaryCountryName varchar(100) null,
	PrimaryOpDate datetime null,
	PrimaryOperationType varchar(100) null,
	PrimaryOperationHospital varchar(100) null,
	PrimaryHomePh varchar(100) null,
	PrimaryMobPh varchar(100) null,
	PrimaryIndigenousDescription varchar(100) null,
	PrimaryHealthStatus varchar(100) null,
	PrimaryOptoffStatus varchar(100) null,
	PrimaryHonourific varchar(100) null,
	Primaryopproc varchar(100) null,
	Primaryprocaban varchar(100) null,
	Secondarypatid int,
	SecondaryURNo varchar(100) null,
	Secondarylastname varchar(100) null,
	Secondaryfname varchar(100) null,
	SecondaryDOB datetime null,
	SecondaryGenderId int null,
	SecondaryGenderLabel varchar(100) null,
	SecondaryMcareNo varchar(100) null,
	SecondaryDvaNo varchar(100) null,
	SecondaryIHI varchar(100) null,
	SecondaryNhiNo varchar(100) null,
	SecondaryConsentSiteName varchar(100) null,
	SecondaryPriSurgId int,
	Secondaryaddr varchar(100) null,
	Secondarysub varchar(100) null,
	SecondaryStateName varchar(100) null,
	Secondarypcode varchar(100) null,
	SecondaryCountryName varchar(100) null,
	SecondaryOpDate datetime null,
	SecondaryOperationType varchar(100) null,
	SecondaryOperationHospital varchar(100) null,
	SecondaryHomePh varchar(100) null,
	SecondaryMobPh varchar(100) null,
	SecondaryIndigenousDescription varchar(100) null,
	SecondaryHealthStatus varchar(100) null,
	SecondaryOptoffStatus varchar(100) null,
	SecondaryHonourific varchar(100) null,
	Secondaryopproc varchar(100) null,
	Secondaryprocaban varchar(100) null,
	Identifier varchar(max)
);

	;with Base as (
		select 
			p.PatId "Primarypatid", p.fname "Primaryfname", p.lastname "Primarylastname", p.CountryId "PrimarycountryId", p.McareNo "PrimaryMcareNo", p.IHI "PrimaryIHI", 
				p.DvaNo "PrimaryDvaNo", p.GenderId "PrimaryGenderId", p.NhiNo "PrimaryNhiNo", p.DOB "PrimaryDOB",  pu.URNo "PrimaryURNo", pu.HospitalID "Primaryhospitalid",
				p.Addr "Primaryaddr", p.Sub "Primarysub", p.StateId "PrimaryStateId", p.Pcode "Primarypcode", p.PriSiteId "PrimaryPriSiteId", p.PriSurgId "PrimaryPriSurgId",
				p.HomePh "PrimaryHomePh", p.MobPh "PrimaryMobPh", p.IndiStatusId "PrimaryIndiStatusId", p.HStatId "PrimaryHStatId", p.OptOffStatId "PrimaryOptOffStatId", p.TitleId "PrimaryTitleId", 
			s.PatId "Secondarypatid", s.fname "Secondaryfname", s.lastname "Secondarylastname", s.CountryId "SecondarycountryId", s.McareNo "SecondaryMcareNo", s.IHI "SecondaryIHI", 
				s.DvaNo "SecondaryDvaNo", s.GenderId "SecondaryGenderId", s.NhiNo "SecondaryNhiNo", s.DOB "SecondaryDOB", su.URNo "SecondaryURNo", su.HospitalID "Secondaryhospitalid",
				s.Addr "Secondaryaddr", s.Sub "Secondarysub", s.StateId "SecondaryStateId", s.Pcode "Secondarypcode", s.PriSiteId "SecondaryPriSiteId", s.PriSurgId "SecondaryPriSurgId",
				s.HomePh "SecondaryHomePh", s.MobPh "SecondaryMobPh", s.IndiStatusId "SecondaryIndiStatusId", s.HStatId "SecondaryHStatId", s.OptOffStatId "SecondaryOptOffStatId", s.TitleId "SecondaryTitleId"
		from 
			tbl_Patient P
			inner join tbl_Patient S on p.PatId <> s.PatId
			left join tbl_URN pu on p.PatId=pu.PatientID
			left join tbl_URN su on s.PatId=su.PatientID
	)
	, FullFirstName as (
		select * 
		from Base
		where
			(PrimaryFName = Secondaryfname and 
				(
					(PrimaryCountryId = 1 and SecondaryCountryId = 1 and
						(
							isnull(nullif(PrimaryMcareNo,''),'1') = isnull(nullif(SecondaryMcareNo,''),'2') or 
							isnull(nullif(Primaryihi,''),'1') = isnull(nullif(Secondaryihi,''),'2') or
							isnull(nullif(PrimaryDvaNo,''),'1') = isnull(nullif(SecondaryDvaNo,''),'2')
						)
					) or
					( PrimaryGenderId = SecondaryGenderId and
						(Primarydob = SecondaryDOB or
							(
								month(Primarydob) = month(Secondarydob) and 
								year(Primarydob) = year(Secondarydob) and
								PrimaryLastName = SecondaryLastName
							)
						)
					) or
					( Primaryhospitalid=Secondaryhospitalid and 
						(PrimaryLastName = SecondaryLastName or
							Primarydob = SecondaryDOB 
						)
					)
				) 
			) 
	)
	, NHI as (
		Select * 
		from base
		where
			isnull(nullif(PrimaryNhiNo,''),'1') = isnull(nullif(SecondaryNhiNo,''), '2') and 
			PrimaryCountryId=2 and SecondaryCountryId=2
	)
	, LastName as (
		Select * from base
		where
			PrimaryLastName = SecondaryLastName and
			(Primarydob = SecondaryDOB and
				(PrimaryGenderId = SecondaryGenderId or
					Primaryhospitalid=Secondaryhospitalid
				)
			)
	)
	, Name4_DOB as (
		select * 
		from base
		where
			left(Primaryfname,4) = left(Secondaryfname,4) and 
			left(Primarylastname,4) = left(Secondarylastname,4) and 
			PrimaryDOB = SecondaryDOB
	)
	, URN_Name4 as (
		select * 
		from Name4_DOB
		where
			PrimaryURNo=SecondaryURNo
	)
	, URN as (
		select * 
		from Base
		where
			PrimaryURNo=SecondaryURNo and
			Primaryhospitalid=Secondaryhospitalid
	)
	, Name6_Medicare as (
		select * from base
		where
			(left(Primaryfname,6) = left(Secondaryfname,6) and 
				left(isnull(nullif(PrimaryMcareNo,''),'1'),8) = left(isnull(nullif(SecondaryMcareNo,''),'2'),8)
			)
	)
	, RawCombinedData as (
		select *, 'First Name and one of: (Medicare, IHI, or DVA) or (Gender and DOB), or (Hospital and (DOB or Last Name))' "Identifier", 1 "filter" from FullFirstName
		union 
		select *, 'NHI' "Identifier", 2 "filter" from NHI
		union 
		select *, 'Last Name and DOB and either (Gender or Hospital)' "Identifier", 3 "filter" from LastName
		union 
		select *, 'Full Name (4 Chars each) and DOB' "Identifier", 4 "filter" from Name4_DOB
		union 
		select *, 'Full Name (6 Chars each) and Medicare No.' "Identifier", 5 "filter" from Name6_Medicare
		union 
		select *, 'URN and Hospital' "Identifier", 6 "filter" from URN
		union 
		select *, 'URN and Full Name (4 Chars each) and DOB' "Identifier", 7 "filter" from URN_Name4
	)
	, RemoveIgnoredCombination as (
		select 
			D.*
		from 
			RawCombinedData D
			left join tbl_IgnorePatients I on D.Primarypatid = i.PatID2 and D.Secondarypatid = i.PatID1
			left join tbl_IgnorePatients j on D.Primarypatid = j.PatID1 and D.Secondarypatid = j.PatID2
		where
			i.PatID1 is null and
			j.PatID1 is null
	)	

	, RankResults as (
	   SELECT *
	   ,RANK() OVER (PARTITION BY Primarypatid, Secondarypatid ORDER BY filter)  "MatchRank"
	   FROM RemoveIgnoredCombination
	)
	, CombinedData as (
		select *, ROW_NUMBER() over (order by Primarypatid) as "CleaningMatchRow"
		from RankResults
		where MatchRank = 1
	) 
	, InverseFilter as (
		select Primarypatid, Secondarypatid, CleaningMatchRow
		from  CombinedData
		where CleaningMatchRow not in (
			select r2.CleaningMatchRow
			from  CombinedData r1
			inner join CombinedData r2 on r1.Primarypatid = r2.Secondarypatid and r1.Secondarypatid =  r2.Primarypatid and r1.CleaningMatchRow < r2.CleaningMatchRow
		)
	)
	, CleanedData as (
		select c.*, ROW_NUMBER() over (order by c.Primarypatid) as "MatchRow"
		from CombinedData c
		inner join InverseFilter i on c.CleaningMatchRow = i.CleaningMatchRow
	)
	insert into @SourceData
	select  c.Primarypatid, c.Primaryfname, c.Primarylastname, c.PrimarycountryId, c.PrimaryMcareNo, c.PrimaryIHI, c.PrimaryDvaNo, c.PrimaryGenderId, c.PrimaryNhiNo, c.PrimaryDOB, c.PrimaryURNo, c.Primaryhospitalid, c.Primaryaddr, c.Primarysub, c.PrimaryStateId, c.Primarypcode, c.PrimaryPriSiteId,
		PrimaryPriSurgId, c.PrimaryHomePh, c.PrimaryMobPh, c. PrimaryIndiStatusId, c.PrimaryHStatId, c.PrimaryOptOffStatId, c.PrimaryTitleId, c.
		Secondarypatid, c.Secondaryfname, c.Secondarylastname, c.SecondarycountryId, c.SecondaryMcareNo, c.SecondaryIHI, c.SecondaryDvaNo, c.SecondaryGenderId,
		SecondaryNhiNo, c.SecondaryDOB, c.SecondaryURNo, c.Secondaryhospitalid, c.Secondaryaddr, c.Secondarysub, c.SecondaryStateId, c.Secondarypcode, c.SecondaryPriSiteId, c.SecondaryPriSurgId, c.SecondaryHomePh, c.SecondaryMobPh, c.SecondaryIndiStatusId, c.SecondaryHStatId,
		SecondaryOptOffStatId, c.SecondaryTitleId, c.Identifier, c.filter, c.MatchRank, c.CleaningMatchRow, c.MatchRow  
	from CleanedData c

	--Retrieve the total number of patients found
	set @RecordsReturned = (select top 1 MatchRow from @SourceData order by MatchRow desc)

	--This section will add all the additional data to the results
	;with FirstOperation as (
		select min(opdate) "MinDate", PatientId 
		from tbl_PatientOperation 
		where ProcAban = 0
		group by PatientId
	)
	, RecordWithOperation as (
		select 
			c.*,
			po1.OpDate "PrimaryOpDate", po1.OpType "PrimaryOpType", po1.Hosp "PrimaryHosp", po1.ProcAban "PrimaryProcAban", pr1.Description "PrimaryOpProc", ot1.Description "PrimaryOperationType", st1.SiteName "PrimaryOperationHospital",
			po2.OpDate "SecondaryOpDate", po2.OpType "SecondaryOpType", po2.Hosp "SecondaryHosp", po2.ProcAban "SecondaryProcAban", pr2.Description "SecondaryOpProc", ot2.Description "SecondaryOperationType", st2.SiteName "SecondaryOperationHospital"
		from @SourceData c
			left join FirstOperation o1 on Primarypatid= o1.PatientId
			left join tbl_PatientOperation po1 on o1.PatientId = po1.PatientId and po1.OpDate = o1.MinDate
			left join tlkp_OperationStatus ot1 on ot1.Id = po1.OpStat
			left join tlkp_Procedure pr1 on pr1.Id = case when po1.OpStat = 0 then po1.OpType else po1.OpRevType end
			left join tbl_site st1 on st1.siteid = po1.Hosp

			left join FirstOperation o2 on  Secondarypatid= o2.PatientId 
			left join tbl_PatientOperation po2 on o2.PatientId = po2.PatientId and po2.OpDate = o2.MinDate
			left join tlkp_OperationStatus ot2 on ot2.Id = po2.OpStat
			left join tlkp_Procedure pr2 on pr2.Id = case when po2.OpStat = 0 then po2.OpType else po2.OpRevType end
			left join tbl_site st2 on st2.siteid = po2.Hosp
			where (@Row_Cnt = -1 or (@Row_Cnt <> -1 and MatchRow = @Row_Cnt))
	)
	, AddExtraData as (
		select 
			r.*,
			isnull(i1.Description, a1.Description) "PrimaryIndigenousDescription", c1.Description "PrimaryCountryName", stt1.Description "PrimaryStateName", t1.Description "PrimaryHonourific", h1.Description "PrimaryHealthStatus", o1.Description "PrimaryOptoffStatus", g1.Description "PrimaryGenderLabel", st1.SiteName "PrimaryConsentSiteName",
			isnull(i2.Description, a2.Description) "SecondaryIndigenousDescription", c2.Description "SecondaryCountryName", stt2.Description "SecondaryStateName", t2.Description "SecondaryHonourific", h2.Description "SecondaryHealthStatus", o2.Description "SecondaryOptoffStatus", g2.Description "SecondaryGenderLabel", st2.SiteName "SecondaryConsentSiteName"
		from 
			RecordWithOperation r
			left join tlkp_IndigenousStatus i1 on i1.Id = PrimaryIndiStatusId
			left join tlkp_IndigenousStatus i2 on i2.Id = SecondaryIndiStatusId
			left join tlkp_AboriginalStatus a1 on a1.Id = PrimaryIndiStatusId
			left join tlkp_AboriginalStatus a2 on a1.Id = SecondaryIndiStatusId
			left join tlkp_Country c1 on c1.Id = PrimaryCountryId
			left join tlkp_Country c2 on c2.Id = SecondaryCountryId
			left join tlkp_Title t1 on t1.Id = PrimaryTitleId
			left join tlkp_Title t2 on t2.Id = SecondaryTitleId
			left join tlkp_State stt1 on stt1.Id = PrimaryStateId
			left join tlkp_State stt2 on stt2.Id = SecondaryStateId
			left join tlkp_HealthStatus h1 on h1.Id = PrimaryHStatId
			left join tlkp_HealthStatus h2 on h2.Id = SecondaryHStatId
			left join tlkp_OptOffStatus o1 on o1.Id = PrimaryOptOffStatId
			left join tlkp_OptOffStatus o2 on o2.Id = SecondaryOptOffStatId
			left join tbl_site st1 on st1.SiteId = PrimaryPriSiteId
			left join tbl_site st2 on st2.SiteId = SecondaryPriSiteId
			left join tlkp_gender g1 on g1.Id = PrimaryGenderId
			left join tlkp_gender g2 on g2.Id = SecondaryGenderId
	)
	insert into @ResultData
	select 	Primarypatid, PrimaryURNo, Primarylastname, Primaryfname, PrimaryDOB, PrimaryGenderId, PrimaryGenderLabel, PrimaryMcareNo, PrimaryDvaNo, PrimaryIHI, PrimaryNhiNo, PrimaryConsentSiteName, PrimaryPriSurgId, Primaryaddr, Primarysub, PrimaryStateName, Primarypcode, PrimaryCountryName,
		PrimaryOpDate, PrimaryOperationType, PrimaryOperationHospital, PrimaryHomePh,  PrimaryMobPh, PrimaryIndigenousDescription, PrimaryHealthStatus, PrimaryOptoffStatus, PrimaryHonourific, Primaryopproc, Primaryprocaban, 
		Secondarypatid, SecondaryURNo, Secondarylastname,  Secondaryfname, SecondaryDOB, SecondaryGenderId, SecondaryGenderLabel, SecondaryMcareNo, SecondaryDvaNo, SecondaryIHI, SecondaryNhiNo, SecondaryConsentSiteName, SecondaryPriSurgId, Secondaryaddr, Secondarysub,
		SecondaryStateName, Secondarypcode, SecondaryCountryName, SecondaryOpDate, SecondaryOperationType, SecondaryOperationHospital, SecondaryHomePh, SecondaryMobPh, SecondaryIndigenousDescription, SecondaryHealthStatus, SecondaryOptoffStatus, SecondaryHonourific,
		Secondaryopproc, Secondaryprocaban, Identifier 
	from AddExtraData


	insert into @matching_patient
	select 
		Primarypatid as "PatId", PrimaryURNo as "PatientURN", Primarylastname as "LastName", Primaryfname as "FName", PrimaryDOB as "DOB", PrimaryGenderId as "GenderId", PrimaryGenderLabel as "Gender", 
		PrimaryMcareNo as "McareNo", PrimaryDvaNo as "DvaNo", Primaryihi as "IHI", PrimaryNHIno as "NhiNo"
		, PrimaryConsentSiteName as "PriSite", PrimaryPriSurgId as "PriSurg", 
		PrimaryAddr "addr",PrimarySub "sub", PrimaryStateName "Patstate", PrimaryPcode "pcode", PrimaryCountryName "Country", Identifier, null "IdentifierNo",
		PrimaryOpDate "OperationDate", PrimaryOperationType "OperationType", PrimaryOperationHospital "OperationHospital",
		PrimaryHomePh "HomePh", PrimaryMobPh "MobPh", PrimaryIndigenousDescription "IndigenousSts" , PrimaryHealthStatus "HealthSts", PrimaryOptoffStatus "OptOffSts", PrimaryHonourific "Title",
		Primaryopproc "OpProc", Primaryprocaban "ProcAban", @RecordsReturned
	from 
		@ResultData
					
	union all
	select 
		Secondarypatid, SecondaryURNo, Secondarylastname, Secondaryfname, SecondaryDOB, SecondaryGenderId, SecondaryGenderLabel, 
		SecondaryMcareNo, SecondaryDvaNo, Secondaryihi, SecondaryNHIno, SecondaryConsentSiteName, SecondaryPriSurgId, 
		SecondaryAddr,SecondarySub, SecondaryStateName, SecondaryPcode, SecondaryCountryName, Identifier, null,
		SecondaryOpDate, SecondaryOperationType, PrimaryOperationHospital,
		SecondaryHomePh, SecondaryMobPh, SecondaryIndigenousDescription, SecondaryHealthStatus, SecondaryOptoffStatus, SecondaryHonourific, Secondaryopproc, Secondaryprocaban, @RecordsReturned 
	from 
		@ResultData

	RETURN 

END










