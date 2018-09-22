
GO
DROP VIEW dbo.vw_LockedUsers;

GO
CREATE VIEW dbo.vw_LockedUsers
AS
SELECT     
	usr.UserName, mem.Email,mem.FailedPasswordAnswerAttemptWindowStart, mem.LastLockoutDate, mem.LastLoginDate
FROM    
	aspnet_Membership mem, aspnet_Users usr 
WHERE     
    mem.UserId = usr.UserId
and mem.IsLockedOut = 1;
