/****** Object:  StoredProcedure [dbo].[usp_DeletePatient]    Script Date: 13-11-2017 03:31:50 PM ******/
DROP PROCEDURE [dbo].[usp_DeletePatient]
GO
/****** Object:  StoredProcedure [dbo].[usp_DeletePatient]    Script Date: 13-11-2017 03:31:50 PM ******/
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

	delete from tbl_FollowUpCall where FollowUpId in (select f.FUID from tbl_FollowUp f where PatientId  = @PatientID)

	delete from tbl_FollowUp  where PatientId  = @PatientID

	

	delete from tbl_PatientOperationDeviceDtls  where PatientOperationId  in 
	(select OpId  from tbl_PatientOperation  where PatientId  = @PatientID)

	delete from tbl_PatientOperation  where PatientId  = @PatientID

	delete from tbl_URN where PatientID = @PatientID

	delete from tbl_patient where patid = @PatientID

end 


GO
