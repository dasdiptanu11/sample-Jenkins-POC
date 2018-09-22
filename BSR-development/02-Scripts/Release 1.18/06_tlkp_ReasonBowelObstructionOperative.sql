CREATE TABLE tlkp_ReasonBowelObstructionOperative
(
	Id INT NOT NULL,
	[Description] VARCHAR(100) NULL,
	CONSTRAINT [PK_tlkp_ReasonBowelObstructionOperative] PRIMARY KEY CLUSTERED (Id ASC)
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

INSERT INTO tlkp_ReasonBowelObstructionOperative(Id, [Description]) 
VALUES
	(1, 'NOS'),
	(2, 'Internal hernia'),
	(3, 'Adhesions'),
	(4, 'Port site hernia/ incisional hernia'),
	(5, 'Entero-enterostomy narrowing'),
	(6, 'Other')

GO
ALTER TABLE tbl_PatientOperation ADD OpBowelObsID INT;
ALTER TABLE tbl_PatientOperation_Audit ADD OpBowelObsID INT;