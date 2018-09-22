


echo ON
set ASPNET_REQSQL_PATH=C:\Windows\Microsoft.NET\Framework\v4.0.30319\
set SERVER=ocio-fc11-sql01.ad.monash.edu
set DATABASE=MNHS-Registry-BSR-TEST
echo ON


REM Comment out the following line after first time to retain already created users 
sqlcmd -S %SERVER% -d %DATABASE%  -i CreateMembershipSchemaTEST.sql
sqlcmd -S %SERVER% -d %DATABASE%  -i TestMembership.sql

sqlcmd -S %SERVER% -d %DATABASE% -i Common.sql 
pause