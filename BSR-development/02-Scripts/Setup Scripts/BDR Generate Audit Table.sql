-- Create table for tbl_Device
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_Device_Audit')
		BEGIN
		  DROP TABLE dbo.[tbl_Device_Audit] 
		END 


		IF NOT EXISTS(SELECT * FROM
					sys.tables WHERE name = 'tbl_Device_Audit')
		BEGIN
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			INTO dbo.[tbl_Device_Audit]
			FROM dbo.[tbl_Device] 
			UNION ALL
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			FROM dbo.[tbl_Device] 
			
		END 
 
-- Create table for tbl_Language
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_Language_Audit')
		BEGIN
		  DROP TABLE dbo.[tbl_Language_Audit] 
		END 


		IF NOT EXISTS(SELECT * FROM
					sys.tables WHERE name = 'tbl_Language_Audit')
		BEGIN
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			INTO dbo.[tbl_Language_Audit]
			FROM dbo.[tbl_Language] 
			UNION ALL
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			FROM dbo.[tbl_Language] 
			
		END 
 
-- Create table for tbl_Patient
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_Patient_Audit')
		BEGIN
		  DROP TABLE dbo.[tbl_Patient_Audit] 
		END 


		IF NOT EXISTS(SELECT * FROM
					sys.tables WHERE name = 'tbl_Patient_Audit')
		BEGIN
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			INTO dbo.[tbl_Patient_Audit]
			FROM dbo.[tbl_Patient] 
			UNION ALL
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			FROM dbo.[tbl_Patient] 
			
		END 
 
-- Create table for tbl_PatientNOK
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_PatientNOK_Audit')
		BEGIN
		  DROP TABLE dbo.[tbl_PatientNOK_Audit] 
		END 


		IF NOT EXISTS(SELECT * FROM
					sys.tables WHERE name = 'tbl_PatientNOK_Audit')
		BEGIN
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			INTO dbo.[tbl_PatientNOK_Audit]
			FROM dbo.[tbl_PatientNOK] 
			UNION ALL
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			FROM dbo.[tbl_PatientNOK] 
			
		END 
 
-- Create table for tbl_PatientOperation
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_PatientOperation_Audit')
		BEGIN
		  DROP TABLE dbo.[tbl_PatientOperation_Audit] 
		END 


		IF NOT EXISTS(SELECT * FROM
					sys.tables WHERE name = 'tbl_PatientOperation_Audit')
		BEGIN
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			INTO dbo.[tbl_PatientOperation_Audit]
			FROM dbo.[tbl_PatientOperation] 
			UNION ALL
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			FROM dbo.[tbl_PatientOperation] 
			
		END 
 
-- Create table for tbl_PatientOperationBSideDtls
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_PatientOperationBSideDtls_Audit')
		BEGIN
		  DROP TABLE dbo.[tbl_PatientOperationBSideDtls_Audit] 
		END 


		IF NOT EXISTS(SELECT * FROM
					sys.tables WHERE name = 'tbl_PatientOperationBSideDtls_Audit')
		BEGIN
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			INTO dbo.[tbl_PatientOperationBSideDtls_Audit]
			FROM dbo.[tbl_PatientOperationBSideDtls] 
			UNION ALL
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			FROM dbo.[tbl_PatientOperationBSideDtls] 
			
		END 
 
-- Create table for tbl_PatientSite
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_PatientSite_Audit')
		BEGIN
		  DROP TABLE dbo.[tbl_PatientSite_Audit] 
		END 


		IF NOT EXISTS(SELECT * FROM
					sys.tables WHERE name = 'tbl_PatientSite_Audit')
		BEGIN
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			INTO dbo.[tbl_PatientSite_Audit]
			FROM dbo.[tbl_PatientSite] 
			UNION ALL
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			FROM dbo.[tbl_PatientSite] 
			
		END 
 
-- Create table for tbl_Site
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_Site_Audit')
		BEGIN
		  DROP TABLE dbo.[tbl_Site_Audit] 
		END 


		IF NOT EXISTS(SELECT * FROM
					sys.tables WHERE name = 'tbl_Site_Audit')
		BEGIN
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			INTO dbo.[tbl_Site_Audit]
			FROM dbo.[tbl_Site] 
			UNION ALL
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			FROM dbo.[tbl_Site] 
			
		END 
 
-- Create table for tbl_User
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_User_Audit')
		BEGIN
		  DROP TABLE dbo.[tbl_User_Audit] 
		END 


		IF NOT EXISTS(SELECT * FROM
					sys.tables WHERE name = 'tbl_User_Audit')
		BEGIN
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			INTO dbo.[tbl_User_Audit]
			FROM dbo.[tbl_User] 
			UNION ALL
			SELECT TOP 0 CAST(0 as nvarchar(50)) [AuditUserName], getdate() [AuditDate], *
			FROM dbo.[tbl_User] 
			
		END 
 
-- Create trigger for tbl_Device
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_Device_Audit')
	BEGIN
	IF EXISTS(SELECT * FROM
				sys.triggers  WHERE name = 'updated_Audit_tbl_Device')
		BEGIN 
			DROP TRIGGER updated_Audit_tbl_Device;
		END
	END
	GO 
		CREATE trigger [dbo].[updated_Audit_tbl_Device]
		on [dbo].[tbl_Device] 
		FOR
		UPDATE, DELETE AS
		BEGIN
			DECLARE @sUsername varchar(50)
			Select @sUsername = LastUpdatedBy from inserted INSERT INTO dbo.tbl_Device_Audit 
					   SELECT @sUsername, getdate(), * 
					   FROM deleted
					   
	   END
	   GO 
 
-- Create trigger for tbl_Language
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_Language_Audit')
	BEGIN
	IF EXISTS(SELECT * FROM
				sys.triggers  WHERE name = 'updated_Audit_tbl_Language')
		BEGIN 
			DROP TRIGGER updated_Audit_tbl_Language;
		END
	END
	GO 
		CREATE trigger [dbo].[updated_Audit_tbl_Language]
		on [dbo].[tbl_Language] 
		FOR
		UPDATE, DELETE AS
		BEGIN
			DECLARE @sUsername varchar(50)
			Select @sUsername = SYSTEM_USER from inserted INSERT INTO dbo.tbl_Language_Audit 
					   SELECT @sUsername, getdate(), * 
					   FROM deleted
					   
	   END
	   GO 
 
-- Create trigger for tbl_Patient
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_Patient_Audit')
	BEGIN
	IF EXISTS(SELECT * FROM
				sys.triggers  WHERE name = 'updated_Audit_tbl_Patient')
		BEGIN 
			DROP TRIGGER updated_Audit_tbl_Patient;
		END
	END
	GO 
		CREATE trigger [dbo].[updated_Audit_tbl_Patient]
		on [dbo].[tbl_Patient] 
		FOR
		UPDATE, DELETE AS
		BEGIN
			DECLARE @sUsername varchar(50)
			Select @sUsername = LastUpdatedBy from inserted INSERT INTO dbo.tbl_Patient_Audit 
					   SELECT @sUsername, getdate(), * 
					   FROM deleted
					   
	   END
	   GO 
 
-- Create trigger for tbl_PatientNOK
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_PatientNOK_Audit')
	BEGIN
	IF EXISTS(SELECT * FROM
				sys.triggers  WHERE name = 'updated_Audit_tbl_PatientNOK')
		BEGIN 
			DROP TRIGGER updated_Audit_tbl_PatientNOK;
		END
	END
	GO 
		CREATE trigger [dbo].[updated_Audit_tbl_PatientNOK]
		on [dbo].[tbl_PatientNOK] 
		FOR
		UPDATE, DELETE AS
		BEGIN
			DECLARE @sUsername varchar(50)
			Select @sUsername = LastUpdatedBy from inserted INSERT INTO dbo.tbl_PatientNOK_Audit 
					   SELECT @sUsername, getdate(), * 
					   FROM deleted
					   
	   END
	   GO 
 
-- Create trigger for tbl_PatientOperation
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_PatientOperation_Audit')
	BEGIN
	IF EXISTS(SELECT * FROM
				sys.triggers  WHERE name = 'updated_Audit_tbl_PatientOperation')
		BEGIN 
			DROP TRIGGER updated_Audit_tbl_PatientOperation;
		END
	END
	GO 
		CREATE trigger [dbo].[updated_Audit_tbl_PatientOperation]
		on [dbo].[tbl_PatientOperation] 
		FOR
		UPDATE, DELETE AS
		BEGIN
			DECLARE @sUsername varchar(50)
			Select @sUsername = LastUpdatedBy from inserted INSERT INTO dbo.tbl_PatientOperation_Audit 
					   SELECT @sUsername, getdate(), * 
					   FROM deleted
					   
	   END
	   GO 
 
-- Create trigger for tbl_PatientOperationBSideDtls
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_PatientOperationBSideDtls_Audit')
	BEGIN
	IF EXISTS(SELECT * FROM
				sys.triggers  WHERE name = 'updated_Audit_tbl_PatientOperationBSideDtls')
		BEGIN 
			DROP TRIGGER updated_Audit_tbl_PatientOperationBSideDtls;
		END
	END
	GO 
		CREATE trigger [dbo].[updated_Audit_tbl_PatientOperationBSideDtls]
		on [dbo].[tbl_PatientOperationBSideDtls] 
		FOR
		UPDATE, DELETE AS
		BEGIN
			DECLARE @sUsername varchar(50)
			Select @sUsername = LastUpdatedBy from inserted INSERT INTO dbo.tbl_PatientOperationBSideDtls_Audit 
					   SELECT @sUsername, getdate(), * 
					   FROM deleted
					   
	   END
	   GO 
 
-- Create trigger for tbl_PatientSite
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_PatientSite_Audit')
	BEGIN
	IF EXISTS(SELECT * FROM
				sys.triggers  WHERE name = 'updated_Audit_tbl_PatientSite')
		BEGIN 
			DROP TRIGGER updated_Audit_tbl_PatientSite;
		END
	END
	GO 
		CREATE trigger [dbo].[updated_Audit_tbl_PatientSite]
		on [dbo].[tbl_PatientSite] 
		FOR
		UPDATE, DELETE AS
		BEGIN
			DECLARE @sUsername varchar(50)
			Select @sUsername = LastUpdatedBy from inserted INSERT INTO dbo.tbl_PatientSite_Audit 
					   SELECT @sUsername, getdate(), * 
					   FROM deleted
					   
	   END
	   GO 
 
-- Create trigger for tbl_Site
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_Site_Audit')
	BEGIN
	IF EXISTS(SELECT * FROM
				sys.triggers  WHERE name = 'updated_Audit_tbl_Site')
		BEGIN 
			DROP TRIGGER updated_Audit_tbl_Site;
		END
	END
	GO 
		CREATE trigger [dbo].[updated_Audit_tbl_Site]
		on [dbo].[tbl_Site] 
		FOR
		UPDATE, DELETE AS
		BEGIN
			DECLARE @sUsername varchar(50)
			Select @sUsername = LastUpdatedBy from inserted INSERT INTO dbo.tbl_Site_Audit 
					   SELECT @sUsername, getdate(), * 
					   FROM deleted
					   
	   END
	   GO 
 
-- Create trigger for tbl_User
IF EXISTS(SELECT * FROM
				sys.tables WHERE name = 'tbl_User_Audit')
	BEGIN
	IF EXISTS(SELECT * FROM
				sys.triggers  WHERE name = 'updated_Audit_tbl_User')
		BEGIN 
			DROP TRIGGER updated_Audit_tbl_User;
		END
	END
	GO 
		CREATE trigger [dbo].[updated_Audit_tbl_User]
		on [dbo].[tbl_User] 
		FOR
		UPDATE, DELETE AS
		BEGIN
			DECLARE @sUsername varchar(50)
			Select @sUsername = LastUpdatedBy from inserted INSERT INTO dbo.tbl_User_Audit 
					   SELECT @sUsername, getdate(), * 
					   FROM deleted
					   
	   END
	   GO 
 
