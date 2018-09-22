


echo ON
set ASPNET_REQSQL_PATH=C:\Windows\Microsoft.NET\Framework\v4.0.30319\
set SERVER=ocio-fc10-sql01.ad.monash.edu
set DATABASE=MNHS-Registry-BSR-DEV
echo ON


REM Comment out the following line after first time to retain already created users 
REM sqlcmd -S %SERVER% -d %DATABASE%  -i CreateMembershipSchemaDEV.sql
REM sqlcmd -S %SERVER% -d %DATABASE%  -i TestMembership.sql

sqlcmd -S %SERVER% -d %DATABASE% -i Common.sql 
pause