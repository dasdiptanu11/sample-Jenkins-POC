update tbl_Patient
set NoDvaNo = isnull(NoDvaNo,0),
	DOBNotKnown = isnull(DOBNotKnown,0),
	NoHomePh = isnull(NoHomePh,0),
	NoMcareNo = ISNULL(NoMcareNo,0),
	NoMobPh = isnull(NoMobPh,0),
	NoNhiNo = isnull(NoNhiNo,0),
	NoPcode = isnull(NoPcode,0)