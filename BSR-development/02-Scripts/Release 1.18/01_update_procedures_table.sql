--Alter the existing reversal to give it more detail  
UPDATE
	tlkp_procedure
SET 
	[description] = 'Surgical reversal gastic band'
WHERE
	id = 11


--Insert the new procedures
INSERT INTO 
	tlkp_procedure (id,description)
VALUES 
	(12, 'Surgical reversal Bypass')
	,(13, 'Lavage/ washout ± Drainage')
	,(14, 'Stent (insertion or removal)')
	,(15, 'Dilatation of Stricture')
	,(16, 'Division of Adhesions')
	,(17, 'Control of Post-Op Bleeding')
	,(18, 'Sub-total gastrectomy')
