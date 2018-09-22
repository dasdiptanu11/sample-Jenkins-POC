use [MNHS-Registry-PCR-DEV]
DECLARE @ROWS_TO_INSERT as integer
SET @ROWS_TO_INSERT = 5

DECLARE  @i integer, @j integer, @Site integer, @SEX integer, @ptId integer, @ptInstId integer
DECLARE  @NM varchar(40) , @LSTNM varchar(10), @X as nvarchar(10)
DECLARE @UR_NO integer;
SET @i = 0;
SET @ptInstId  = 0

WHILE @i < @ROWS_TO_INSERT
BEGIN
		
	SET @NM = 'Jones' + '_' + CAST(@i as nvarchar(10))
	SET @LSTNM = 'Peter' + '_' + CAST(@i as nvarchar(10))
	INSERT [dbo].[tbl_Demographic] ([GenNote],  [PtIHI], [Nm], [MddleNm], [LstNm], [DOB], [DOBAcc], [Dth], [DOD], [DODAcc], [CODth], [ATSI], [CountryBirth], [Street], [AddNK], [NOFXAdd], [Suburb], [Pcode], [State], [Country], [PtEmail], [PtMobPh], [PtHomPh], [PtWorkPh], [PtPhNo], [WrHmPh], [WrmobPh], [WrWkPh], [Medicare], [NoMedicare], [DVA], [DVAno], [NOKStat], [NOKNm], [NOKNmNo], [NOKLstNm], [NOKLstNmNo], [NOKRel], [NOKOth], [NOKAddSt], [NOKStreet], [NOKSuburb], [NOKPcode], [NOKPcodeNo], [NOKState], [NOKMobPh], [NOKHomPh], [NOKWrkPh], [GPStatus], [GPNm], [GPNmNo], [GPLstNm], [GPLstNmNo], [GPAdd], [GPPcode], [GPPcodeNo], [GPState], [GPWrkPh], [GPWrkPhNS], [DemDc], [DemDcDt], [DemVal], [LastSavedBy], [LastSavedDate], [CreatedBy], [CreatedDate]) VALUES (NULL,  NULL, @NM, N'Andrew', @LSTNM, CAST(0x00004F8500000000 AS DateTime), 1, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	set @ptId = @@IDENTITY 
	SELECT @@IDENTITY
	INSERT [dbo].[tbl_PatientInstitute] ( [PtID], [InstID], [UR], [DataRight], [LastSavedBy], [LastSavedDate], [CreatedBy], [CreatedDate]) VALUES (  @ptId, 2, N'0103', 0, N'cidmu', CAST(0x0000A151011656E9 AS DateTime), N'cidmu', CAST(0x0000A15100F93BC5 AS DateTime))
	set @ptInstId = @@IDENTITY 
	INSERT [dbo].[tbl_PatientAdmin] ([PtID], [AdminCom], [NotInst], [DiagDtVCR], [ImportDt], [Consent], [OptOffDt], [OptOffReas], [OptOffOth], [HSChk1], [HSDt1], [NotClin], [PrefLan], [TURPStatus], [ClinConDt], [ClinResDt], [HSChk24], [HSDt24], [HSChk60], [HSDt60], [MailSentDt1], [MailRetDt1], [Street1], [Suburb1], [Pcode1], [State1], [Preflan1], [MailSentDt2], [MailRetDt2], [Street2], [Suburb2], [Pcode2], [State2], [Preflan2], [MailSentDt3], [MailRetDt3], [Street3], [Suburb3], [Pcode3], [State3], [Preflan3], [ResendLtr2], [ResendLtr3], [LastSavedBy], [LastSavedDate], [CreatedBy], [CreatedDate]) VALUES ( @ptId, N'', @ptInstId, CAST(0x0000A11900000000 AS DateTime), CAST(0x0000A15800000000 AS DateTime), NULL, NULL, NULL, N'', 1, CAST(0x0000A15800000000 AS DateTime), NULL, 1201, 1, CAST(0x0000A15800000000 AS DateTime), NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'', N'', N'', NULL, NULL, NULL, NULL, N'', N'', N'', NULL, NULL, NULL, NULL, N'cidmu', CAST(0x0000A17900F40572 AS DateTime), N'cidmu', CAST(0x0000A17800DF5423 AS DateTime))
	INSERT [dbo].[tbl_Diagnosis] ( [PtId], [GenNote], [DiagInst], [VCRDiagInst], [DiagClin], [RefClin], [DiagPSA], [DiagDt], [DiagDtAcc], [AgeDiag], [YrsPrCa], [YrsPrCaDth], [DiagMeth], [DiagMethOth], [ClinInType1], [ClinInType2], [ClinInType3], [ClinInType4], [ClinInOth], [MetHisType], [MetHistoth], [DiagMorph1], [DiagMorph2], [DiagMorph3], [MorphMis1], [DiagGle1], [DiagGle2], [DiagGleSum], [DiagTerSc], [DiagCasPos], [DiagCasTot], [DiagCasPerPos], [PeriNeuYN], [LymvasYN], [ExtProsYN], [SVInvYN], [PathRepmis], [ClinTYN], [DRENote], [DiagcT], [DiagcN], [DiagcNMeth], [DiagcNsMethOth], [DiagcM], [DiagcMMeth1], [DiagcMMeth2], [DiagcMMeth3], [DiagcMMeth4], [DiagcMMeth5], [DiagcMMeth6], [DiagcMMethOth], [CAPRA], [NCCN], [CurCa1], [CurCa2], [CurCa3], [CurCa4], [CurCa5], [CurCa6], [CurCa7], [CurCa8], [CurCa9], [CurCa10], [CurCa11], [CurCa12], [CurCaOTH], [DiagVal], [DiagDc], [DiagrDcDt], [LastSavedBy], [LastSavedDate], [CreatedBy], [CreatedDate]) VALUES ( @ptId, N'general notes go here', @ptInstId, N'1', 1, 1, NULL, CAST(0xB8360B00 AS Date), 1, CAST(18.00 AS Decimal(10, 2)), CAST(20.00 AS Decimal(10, 2)), CAST(30.00 AS Decimal(10, 2)), 1, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 2, 3, 5, 10, 20, 10, 1, 1, 1, 1, 10, 1, N'Note here1', 1, 1, 2, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL, CAST(0xB3360B00 AS Date), NULL, CAST(0x0000A17200000000 AS DateTime), N'cidmu', CAST(0x0000A17200000000 AS DateTime))

	SET @i = @i + 1
END

