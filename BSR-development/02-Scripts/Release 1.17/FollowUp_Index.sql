IF NOT EXISTS(
       SELECT *
       FROM SYS.indexes
       WHERE
             NAME = 'IX_tbl_FollowUp_COperationID'
             AND object_id = OBJECT_ID('tbl_FollowUp')
)
BEGIN
       CREATE INDEX IX_tbl_FollowUp_COperationID 
       ON tbl_FollowUp(OperationID)
END
