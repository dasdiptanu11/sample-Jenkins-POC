
/****** Object:  StoredProcedure [dbo].[usp_DeletePatient]    Script Date: 06/02/2015 12:08:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DeletePatient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_DeletePatient]
GO

/****** Object:  StoredProcedure [dbo].[usp_DeletePatient]    Script Date: 06/02/2015 12:08:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 
CREATE PROCEDURE [dbo].[usp_DeletePatient]
@PatientID int 
 as
 
Begin 
 
	delete from tbl_PatientComplications  where FuId in 
	(select f.FUID from tbl_FollowUp f where PatientId  = @PatientID)


	delete from tbl_FollowUp  where PatientId  = @PatientID

	delete from tbl_PatientOperationDeviceDtls  where PatientOperationId  in 
	(select OpId  from tbl_PatientOperation  where PatientId  = @PatientID)

	delete from tbl_PatientOperation  where PatientId  = @PatientID

	delete from tbl_URN where PatientID = @PatientID

	delete from tbl_patient where patid = @PatientID

end 

GO


