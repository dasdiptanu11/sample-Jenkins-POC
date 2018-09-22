


echo ON
set ASPNET_REQSQL_PATH=C:\Windows\Microsoft.NET\Framework\v4.0.30319\
set SERVER=FC33-DBPRDCRTI1
set DATABASE=MNHS-Registry-BSR
echo ON


sqlcmd -S %SERVER% -d %DATABASE% -i Common.sql 
pause