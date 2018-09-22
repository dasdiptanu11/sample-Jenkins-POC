select 
PatId, LastName, FName, TitleId, DOB, DOBNotKnown, GenderId, McareNo, NoMcareNo, DvaNo, NoDvaNo, IHI, AborStatusId, IndiStatusId, NhiNo, NoNhiNo, PriSiteId, PriSurgId, Addr, AddrNotKnown, Sub, StateId, Pcode, NoPcode, CountryId, HomePh, MobPh, NoHomePh, NoMobPh, HStatId, DateDeath, DateDeathNotKnown, CauseOfDeath, DeathRelSurgId, DateESSent, Undel, OptOffStatId, OptOffDate, Legacy,
URId, HospitalID, URNo,
OpId,  Hosp, Surg, OpDate, ProcAban, OpAge, OpStat, OpType, OthPriType, OpRevType, OthRevType, LstBarProc, Ht, HtNtKnown, StWt, StWtNtKnown, StBMI, OpWt, SameOpWt, OpWtNtKnown, OpBMI, DiabStat, DiabRx, RenalTx, LiverTx, Time, OthInfoOp, OpVal,
PatientOperationDevId, PatientOperationId, ParentPatientOperationDevId, DevType, DevBrand, DevOthBrand, DevOthDesc, DevOthMode, DevManuf, DevOthManuf, DevId, DevLotNo, DevPortMethId, PriPortRet, ButtressId, IgnoreDevice,
f.FUId, OperationId, FUDate, AttmptCallId, SelfRptWt, FUVal, FUPeriodId, RecommendedLTFU, RecommendedLTFUReason, LTFU, LTFUDate, FUWt, FUBMI, PatientFollowUpNotKnown, SEId1, SEId2, SEId3, ReasonOther, DiabStatId, DiabRxId, ReOpStatId, FurtherInfoSlip, FurtherInfoPort, Othinfo, EmailSentToSurg, BatchUpdateReason,
pc.ComplicationId,
c.ProcedureId
--pur.FName + pur.LastName as Patient_PrimarySurgeon,
--psite.SiteName as Patient_PrimarySite,
--posite.SiteName as Opeartion_Site,
--urnsite.SiteName as URN_Site,
--abor.Description as Patient_AboriginalStatus,
--cont.Description as Patient_Country,
--gend.Description as Patient_Gender,
--hs.Description as Patient_HealthStatus,
--indi.Description as Patient_IndigenousStatus,
--optof.Description as Patient_OptOffStatus,
--stt.Description as Patient_State,
--ttl.Description as Patient_Title,
--lkp.Description as Opera
from tbl_Patient p 
	left outer join tbl_URN u on p.PatId = u.PatientID
	left outer join tbl_PatientOperation po on p.PatId = po.PatientId
	left outer join tbl_PatientOperationDeviceDtls podd on po.OpId = podd.PatientOperationId
	left outer join tbl_FollowUp f on po.PatientId = f.PatientId and po.OpId = f.OperationId
	left outer join tbl_PatientComplications pc on f.FUId = pc.FuId
	--left outer join tbl_User pur on p.PriSurgId = pur.UserId
	--left outer join tbl_Site psite on p.PriSiteId = psite.SiteId
	--left outer join tbl_Site posite on po.Hosp = posite.SiteId
	--left outer join tbl_Site urnsite on u.HospitalID = urnsite.SiteId
	left outer join tbl_Complications c on pc.ComplicationId = c.Id 
	--LEFT outer join tlkp_Procedure lkp on c.ProcedureId = lkp.Id
	--left outer join tbl_Device d on podd.DevId = d.DeviceId
	--left outer join tbl_DeviceBrand db on d.DeviceBrandId = db.Id
	--left outer join tlkp_AboriginalStatus abor on p.AborStatusId = abor.Id
	--left outer join tlkp_Country cont on p.CountryId = cont.Id
	--left outer join tlkp_Gender gend on p.GenderId = gend.Id
	--left outer join tlkp_HealthStatus hs on p.HStatId = hs.Id
	--left outer join tlkp_IndigenousStatus indi on p.IndiStatusId = indi.Id
	--left outer join tlkp_OptOffStatus optof on p.OptOffStatId = optof.Id
	--left outer join tlkp_State stt on p.StateId = stt.Id
	--left outer join tlkp_Title ttl on p.TitleId = ttl.Id
order by p.PatId, po.OpId, f.OperationId