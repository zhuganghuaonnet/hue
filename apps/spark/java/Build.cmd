@echo off
set options=%*

if "%options%" == "" (  
  set options=-DskipTests -Dspark.version=1.5.1 package
)
set MAVEN_OPTS=-Xmx512m -XX:MaxPermSize=128m

:: Build & install zeppelin, and generate build distribution
call mvn clean %options%
if %errorlevel% neq 0  exit /b 1

:: Make zip package
set livy_version=3.10.0
set zipTargetFolder=Dist\target\livy-nao-%livy_version%

ROBOCOPY bin %zipTargetFolder%\bin *.cmd /S
ROBOCOPY conf %zipTargetFolder%\conf *.conf /S
ROBOCOPY . %zipTargetFolder% *.jar /S
ROBOCOPY ApDeployScripts %zipTargetFolder% /S