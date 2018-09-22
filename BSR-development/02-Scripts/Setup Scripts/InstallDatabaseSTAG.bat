


echo ON
set ASPNET_REQSQL_PATH=C:\Windows\Microsoft.NET\Framework\v4.0.30319\
set SERVER=FC31-DBDEVCRTI1
set DATABASE=MNHS-Registry-BSR-Staging
echo ON


REM Comment out the following line after first time to retain already created users 
sqlcmd -S %SERVER% -d %DATABASE% -E -i CreateMembershipSchemaSTAG.sql


sqlcmd -S %SERVER% -d %DATABASE% -E -i Common.sql 


pause