echo OFF
set ASPNET_REQSQL_PATH=C:\Windows\Microsoft.NET\Framework\v4.0.30319\
set SERVER=ocio-fc10-sql01.ad.monash.edu
set DATABASE=MNHS-Registry-BDR-DEV

echo ON

%ASPNET_REQSQL_PATH%aspnet_regsql.exe -S %SERVER% -d %DATABASE% -sqlexportonly CreateMembershipSchemaDEV.sql -A all
pause