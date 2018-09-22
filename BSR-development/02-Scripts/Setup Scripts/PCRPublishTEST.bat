@echo off
SET DestPath=C:\Projects\PCR\Test\Publish\
SET SrcPath=C:\Projects\PCR\Development\01-Code\PCR\App.UI.Web\
SET ProjectName=App.UI.Web

SET Configuration=Release

:: clear existed directory
RD /S /Q "%DestPath%"

:: build and publish project

C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild  /t:Build;PipelinePreDeployCopyAllFilesToOneFolder /p:Configuration=Release;_PackageTempDir=\\mnhs-web31-v02.med.monash.edu\PCR\Publish\;AutoParameterizationWebConfigConnectionStrings=false C:\Projects\PCR\Development\01-Code\PCR\App.UI.Web\App.UI.Web.csproj