
-- use [MNHS-Registry-BDR-DEV]
-- drop procedure [dbo].[sp_Consent_14Days]

CREATE PROCEDURE [dbo].[sp_Consent_14Days]
AS
BEGIN
   UPDATE  dbo.tbl_Patient  SET  ConsentId = 0 
   where  DateConsentLetterSent IS NOT NULL
   AND DATEDIFF(day,DateConsentLetterSent,GETDATE()) > 14
   AND ConsentId != 0 AND ConsentId != 1

END

GO


