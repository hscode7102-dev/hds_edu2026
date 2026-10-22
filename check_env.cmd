@echo off
rem Lab laptop check v01 - run from the student account (double-click or cmd)
rem v01: Maven libraries and Maven itself are inside C:\hds-llm-lab-spring (not in the user profile)
rem NOTE: keep this file ASCII-only. cmd.exe parses .cmd files in the OEM code page (CP949).

echo account=%USERNAME%
echo.

echo === 1. Java ===
java -version
echo JAVA_HOME=%JAVA_HOME%
echo JAVA_TOOL_OPTIONS=%JAVA_TOOL_OPTIONS%
echo.

echo === 2. Git ===
git --version
echo.

echo === 3. VS Code extensions ===
call code --list-extensions | findstr /i "vscjava.vscode-java-pack vmware.vscode-boot-dev-pack"
echo.

echo === 4. Lab folder ===
if exist C:\hds-llm-lab\README.md (echo OK C:\hds-llm-lab) else (echo MISSING C:\hds-llm-lab)
if exist C:\hds-llm-lab\ch0_setup\Step00Check.java (echo OK lab code v01 layout) else (echo MISSING C:\hds-llm-lab\ch0_setup - old or wrong hds-llm-lab.zip)
echo.

echo === 5. Spring project, libraries, Maven ===
set SP=C:\hds-llm-lab-spring
if exist %SP%\pom.xml (echo OK %SP%) else (echo MISSING %SP%)
if exist %SP%\.mvn\maven.config (echo OK maven.config) else (echo MISSING %SP%\.mvn\maven.config - old hds-llm-lab-spring.zip)
if exist %SP%\repository\org\springframework\boot\spring-boot-starter-parent\3.5.16\spring-boot-starter-parent-3.5.16.pom (echo OK libraries in %SP%\repository) else (echo MISSING %SP%\repository)
if exist %SP%\.mvn\wrapper\apache-maven-3.9.16-bin.zip (echo OK Maven 3.9.16 package) else (echo MISSING %SP%\.mvn\wrapper\apache-maven-3.9.16-bin.zip)
if exist %SP%\pom.xml (
  pushd %SP%
  call mvnw.cmd -o -q validate && (echo OK offline Maven build) || (echo FAIL offline Maven build - send this screen)
  popd
)
echo.

echo === 6. Write permission ===
call :canwrite C:\hds-llm-lab
call :canwrite C:\hds-llm-lab-spring
echo.

echo === 7. Network ===
curl.exe -s -o nul -w "openrouter.ai HTTP %%{http_code}\n" https://openrouter.ai/api/v1/models
echo.
pause
goto :eof

:canwrite
if not exist "%~1" (echo SKIP write %~1 ^(folder missing^) & goto :eof)
(echo test> "%~1\_write_test.tmp") 2>nul && (del "%~1\_write_test.tmp" & echo OK write %~1) || (echo NO WRITE %~1)
goto :eof
