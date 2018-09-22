IF EXISTS (SELECT	* 
		   FROM		INFORMATION_SCHEMA.TABLES 
		   WHERE	TABLE_SCHEMA  = N'dbo' 
		   AND		TABLE_NAME	  = N'tbl_UserFavouriteDeviceDetails')
BEGIN
DROP TABLE [dbo].[tbl_UserFavouriteDeviceDetails]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_UserFavouriteDeviceDetails](
 FavDevId int IDENTITY(1,1),
 ParentFavDevId int,
 SurgId int,
 CountryId int,
 SiteId int,
 OpStatus int,
 OpType int,
 OpRevType int,
 DevId int,
 DevType int,
 DevBrand int,
 DevManuf int,
 PriPortRet bit,
 DevPortMethId int,
 ButtressID int not null,
 ButtTypeID int,
 LastUpdatedBy varchar(50),
 LastUpdatedDateTime datetime,
 CreatedBy varchar(50),
 CreatedDateTime datetime,
 CONSTRAINT [PK_tbl_UserFavouriteDeviceDetails] PRIMARY KEY CLUSTERED 
(
	[FavDevId] ASC
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
-------------------------
IF EXISTS (SELECT	* 
		   FROM		INFORMATION_SCHEMA.TABLES 
		   WHERE	TABLE_SCHEMA  = N'dbo' 
		   AND		TABLE_NAME	  = N'tbl_UserFavouriteDeviceDetails_Audit')
BEGIN
DROP TABLE [dbo].[tbl_UserFavouriteDeviceDetails_Audit]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_UserFavouriteDeviceDetails_Audit](
 Action nvarchar(50),
 AuditUserName nvarchar(50),
 AuditDate datetime,
 FavDevId int,
 ParentFavDevId int,
 SurgId int,
 CountryId int,
 SiteId int,
 OpStatus int,
 OpType int,
 OpRevType int,
 DevId int,
 DevType int,
 DevBrand int,
 DevManuf int,
 PriPortRet bit,
 DevPortMethId int,
 ButtressID int not null,
 ButtTypeID int,
 LastUpdatedBy varchar(50),
 LastUpdatedDateTime datetime,
 CreatedBy varchar(50),
 CreatedDateTime datetime
) ON [PRIMARY]

GO
--------------------------
IF EXISTS (SELECT *  
               FROM   sys.objects  
               WHERE  [type] = 'TR' 
               AND    [name] = 'updated_Audit_tbl_UserFavouriteDeviceDetails')  
  BEGIN 
  DROP TRIGGER [dbo].[updated_Audit_tbl_UserFavouriteDeviceDetails]
  END
  GO

IF NOT EXISTS (SELECT *  
               FROM   sys.objects  
               WHERE  [type] = 'TR' 
               AND    [name] = 'updated_Audit_tbl_UserFavouriteDeviceDetails')  
  BEGIN 
    EXEC ('CREATE TRIGGER [dbo].[updated_Audit_tbl_UserFavouriteDeviceDetails]
             ON [dbo].[tbl_UserFavouriteDeviceDetails]
             FOR INSERT, UPDATE, DELETE
           AS
             BEGIN
               SELECT 1
             END')  
  END 
GO  
 
ALTER TRIGGER [dbo].[updated_Audit_tbl_UserFavouriteDeviceDetails]  
 ON [dbo].[tbl_UserFavouriteDeviceDetails]  
 FOR INSERT, UPDATE, DELETE 
AS 
 BEGIN 
   DECLARE @Action varchar(50)
					   SET @Action = (CASE WHEN EXISTS(SELECT * FROM INSERTED)
                         AND EXISTS(SELECT * FROM DELETED)
                        THEN 'UPDATE'  -- Set Action to Updated.
                        WHEN EXISTS(SELECT * FROM INSERTED)
                        THEN 'INSERT'  -- Set Action to Insert.
                        WHEN EXISTS(SELECT * FROM DELETED)
                        THEN 'DELETE'  -- Set Action to Deleted.
                        ELSE NULL -- Skip. It may have been a "failed delete".   
						END)
		DECLARE @sUsername varchar(50)
		SELECT @sUsername = SYSTEM_USER FROM inserted
		
		IF @Action = 'INSERT' 
			BEGIN
					   INSERT INTO dbo.tbl_UserFavouriteDeviceDetails_Audit
					   SELECT  @Action, ISNULL(@sUsername,SYSTEM_USER) , getdate(), *
					   FROM INSERTED
			END
			ELSE
			BEGIN
					   INSERT INTO dbo.tbl_UserFavouriteDeviceDetails_Audit 
					   SELECT  @Action, ISNULL(@sUsername,SYSTEM_USER) , getdate(), *
					   FROM DELETED
			END	  
 END 
GO 