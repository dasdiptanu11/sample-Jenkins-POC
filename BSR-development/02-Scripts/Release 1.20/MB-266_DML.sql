-- Insert new procedure in look up table of Procedures
IF NOT EXISTS (SELECT * FROM [dbo].[tlkp_Procedure]
                   WHERE Id=19
                   AND [Description] = 'Ring/ Band over Bypass or Sleeve (insertion or removal)')
BEGIN
INSERT INTO [dbo].[tlkp_Procedure]
           ([Id],[Description],[IsDeviceRequired])
VALUES     (19,'Ring/ Band over Bypass or Sleeve (insertion or removal)',0)
END
GO

-- Update the procedure
UPDATE a
SET a.[Description]='One anastomosis gastric bypass'
FROM [dbo].[tlkp_Procedure] a
WHERE a.Id=4 and a.[Description]='Single anastomosis gastric bypass'
GO

-- Insert complications for new procedure
IF NOT EXISTS (SELECT * FROM [dbo].[tbl_Complications] WHERE ProcedureId = 19)
BEGIN
INSERT INTO [dbo].[tbl_Complications]
           ([ProcedureId],[ComplicationId])
VALUES     (19,1),(19,2),(19,3),
		   (19,4),(19,5),(19,9),
		   (19,10),(19,11),(19,12),
		   (19,13),(19,17),(19,18),
		   (19,24),(19,25),(19,27)
END        
GO

