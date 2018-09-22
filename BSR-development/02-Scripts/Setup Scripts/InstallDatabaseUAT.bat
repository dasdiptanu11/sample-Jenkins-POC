


echo ON
set ASPNET_REQSQL_PATH=C:\Windows\Microsoft.NET\Framework\v4.0.30319\
set SERVER=ocio-fc11-sql01.ad.monash.edu
set DATABASE=MNHS-Registry-BSR-UAT
echo ON


REM Comment out the following line after first time to retain already created users 
sqlcmd -S %SERVER% -d %DATABASE% -E -i CreateMembershipSchemaUAT.sql
sqlcmd -S %SERVER% -d %DATABASE% -E -i TestMembership.sql

sqlcmd -S %SERVER% -d %DATABASE% -E -i Common.sql 


pause