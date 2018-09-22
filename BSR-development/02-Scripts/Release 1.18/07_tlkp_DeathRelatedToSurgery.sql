CREATE TABLE tlkp_DeathRelatedToSurgery
(
	Id INT NOT NULL,
	[Description] VARCHAR(100) NULL,
	CONSTRAINT [PK_tlkp_DeathRelatedToSurgery] PRIMARY KEY CLUSTERED (Id ASC)
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

INSERT INTO tlkp_DeathRelatedToSurgery(Id, [Description]) 
VALUES
	(0, 'Not yet determined'),
	(1, 'Unrelated '),
	(2, 'Possibly Related'),
	(3, 'Probably Related'),
	(4, 'Definitely Related')
GO