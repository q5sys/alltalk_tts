@echo off
cd /D "%~dp0"

set PATH=%PATH%;%SystemRoot%\system32

@rem Check if curl is available
curl --version >nul 2>&1
if "%ERRORLEVEL%" NEQ "0" (
    echo curl is not available on this system. Please install curl then re-run the script https://curl.se/ 
	echo or perform a manual installation of a Conda Python environment.
    goto end
)

:MainMenu
cls
echo.
echo Welcome to the AllTalk Setup Utility
echo.
echo Please select an option:
echo.
echo      1) I am using AllTalk as part of Text-generation-webui
echo      2) I am using AllTalk as a Standalone Application
echo.
echo      9) Exit/Quit
echo.
set /p UserOption="Enter your choice: "

if "%UserOption%"=="1" goto WebUIMenu
if "%UserOption%"=="2" goto StandaloneMenu
if "%UserOption%"=="9" goto End
goto MainMenu

:WebUIMenu
cls
echo.
echo You have selected Text-generation-webui.
echo.
echo Please ensure you have started your Text-generation-webui Python environment. If you have NOT done this,
echo please run "cmd_windows.bat" in the text-generation-webui folder and then re-run "atsetup.bat"
echo.
echo      1) Install the requirements for a Nvidia machine.
echo      2) Install the requirements for a AMD or MAC machine.
echo      3) Install the Finetuning requirements.
echo      4) Install "DeepSpeed v11.2 for CUDA 11.8 & Python 3.11.x".
echo      5) Install "DeepSpeed v11.2 for CUDA 12.1 & Python 3.11.x".
echo      6) Uninstall DeepSpeed.
echo      7) Generate a diagnostics file.
echo.
echo      9) Exit/Quit
echo.
set /p WebUIOption="Enter your choice: "
if "%WebUIOption%"=="1" goto InstallNvidiaTextGen
if "%WebUIOption%"=="2" goto InstallOtherTextGen
if "%WebUIOption%"=="3" goto InstallFinetuneTextGen
if "%WebUIOption%"=="4" goto InstallDeepSpeed118TextGen
if "%WebUIOption%"=="5" goto InstallDeepSpeed121TextGen
if "%WebUIOption%"=="6" goto UnInstallDeepSpeed
if "%WebUIOption%"=="7" goto GenerateDiagsTextGen
if "%WebUIOption%"=="9" goto End
goto WebUIMenu

:StandaloneMenu
cls
echo.
echo You have selected Standalone Application Setup.
echo.
echo      1) Install AllTalk's custom Python environment (Setup AllTalk as a standalone Application)
echo      2) Delete AllTalk's custom Python environment (You will need to run 1 again after)
echo      3) Install the Finetuning requirements (You need to have created the AllTalk custom environment)
echo      4) Generate a diagnostics file (You need to have created the AllTalk custom environment)
echo.
echo      9) Exit/Quit
echo.
set /p StandaloneOption="Enter your choice: "
if "%StandaloneOption%"=="1" goto InstallCustomStandalone
if "%StandaloneOption%"=="2" goto DeleteCustomStandalone
if "%StandaloneOption%"=="3" goto InstallFinetuneStandalone
if "%StandaloneOption%"=="4" goto GenerateDiagsStandalone
if "%StandaloneOption%"=="9" goto End
goto StandaloneMenu

:InstallNvidiaTextGen
pip install -r requirements_nvidia.txt
if %ERRORLEVEL% neq 0 (
    echo.
    echo      There was an error installing the Nvidia requirements.
    echo      Press any key to return to the menu.
    echo.
    pause
    goto WebUIMenu
)
Echo.
echo *************************************************************************************
echo.
Echo               Nvidia machine requirements installed successfully.
Echo. 
echo *************************************************************************************
pause
goto WebUIMenu

:InstallOtherTextGen
pip install -r requirements_other.txt
if %ERRORLEVEL% neq 0 (
    echo. 
    echo      There was an error installing the Other requirements.
    echo      Press any key to return to the menu.
    echo.
    pause
    goto WebUIMenu
)
Echo.
echo *************************************************************************************
echo.
Echo               Other machine requirements installed successfully.
Echo. 
echo *************************************************************************************
pause
goto WebUIMenu

:InstallFinetuneTextGen
pip install -r requirements_finetune.txt
if %ERRORLEVEL% neq 0 (
    echo.
    echo      There was an error installing the Finetune requirements.
    echo      Press any key to return to the menu.
    echo.
    pause
    goto WebUIMenu
)
Echo.
Echo ******************************************************************************************************
Echo.
Echo Finetune requirements installed successfully. Please ensure you have installed CUDA 11.8 requirements.
Echo Finetune needs access to cublas64_11.dll and will error if this is not setup correctly.
Echo Please see here for details https://github.com/erew123/alltalk_tts#-finetuning-a-model
Echo.
Echo ******************************************************************************************************
pause
goto WebUIMenu

:InstallDeepSpeed118TextGen
echo Downloading DeepSpeed...
curl -LO https://github.com/erew123/alltalk_tts/releases/download/deepspeed/deepspeed-0.11.2+cuda118-cp311-cp311-win_amd64.whl
if %ERRORLEVEL% neq 0 (
    echo.
    echo      Failed to download DeepSpeed wheel file.
    echo      Please check your internet connection or try again later.
    echo      Press any key to return to the menu.
    echo.
    pause
    goto WebUIMenu
)
echo DeepSpeed wheel file downloaded successfully.
echo Installing DeepSpeed...
pip install deepspeed-0.11.2+cuda118-cp311-cp311-win_amd64.whl
if %ERRORLEVEL% neq 0 (
    echo. 
    echo      Failed to install DeepSpeed.
    echo      Please check if the wheel file is compatible with your system.
    echo      Press any key to return to the menu.
    echo.
    pause
    goto WebUIMenu
)
Echo.
echo *************************************************************************************
echo.
Echo                        DeepSpeed installed successfully.
Echo. 
echo *************************************************************************************
del deepspeed-0.11.2+cuda118-cp311-cp311-win_amd64.whl
pause
goto WebUIMenu

:InstallDeepSpeed121TextGen
echo Downloading DeepSpeed...
curl -LO https://github.com/erew123/alltalk_tts/releases/download/deepspeed/deepspeed-0.11.2+cuda121-cp311-cp311-win_amd64.whl
if %ERRORLEVEL% neq 0 (
    echo.
    echo      Failed to download DeepSpeed wheel file.
    echo      Please check your internet connection or try again later.
    echo      Press any key to return to the menu.
    echo.
    pause
    goto WebUIMenu
)
echo DeepSpeed wheel file downloaded successfully.
echo Installing DeepSpeed...
pip install deepspeed-0.11.2+cuda121-cp311-cp311-win_amd64.whl
if %ERRORLEVEL% neq 0 (
    echo. 
    echo      Failed to install DeepSpeed.
    echo      Please check if the wheel file is compatible with your system.
    echo      Press any key to return to the menu.
    echo.
    pause
    goto WebUIMenu
)
Echo.
echo *************************************************************************************
echo.
Echo                        DeepSpeed installed successfully.
Echo. 
echo *************************************************************************************
del deepspeed-0.11.2+cuda121-cp311-cp311-win_amd64.whl
pause
goto WebUIMenu

:UnInstallDeepSpeed
pip uninstall deepspeed
if %ERRORLEVEL% neq 0 (
    echo. 
    echo      There was an error uninstalling DeepSpeed.
    echo      Press any key to return to the menu.
    echo.
    pause
    goto WebUIMenu
)
echo *************************************************************************************
echo.
Echo                        DeepSpeed uninstalled successfully.
Echo. 
echo *************************************************************************************
pause
goto WebUIMenu

:GenerateDiagsTextGen
Python diagnostics.py
if %ERRORLEVEL% neq 0 (
    echo.
    echo      There was an error running diagnostics. Have you correctly started your 
    echo      Text-generation-webui Python environment with "cmd_windows.bat"?
    pause
    goto WebUIMenu
)
Echo.
echo *************************************************************************************
echo.
Echo         Diagnostics.log generated. Please scroll up to look over the log.
Echo. 
echo *************************************************************************************
pause
goto WebUIMenu

:InstallCustomStandalone
set PATH=%PATH%;%SystemRoot%\system32

@rem Check if curl is available
curl --version >nul 2>&1
if "%ERRORLEVEL%" NEQ "0" (
    echo curl is not available on this system. Please install curl then re-run the script https://curl.se/ 
	echo or perform a manual installation of a Conda Python environment.
    goto end
)
echo "%CD%"| findstr /C:" " >nul && echo This script relies on Miniconda which can not be silently installed under a path with spaces. Please correct your folder names and re-try installation. && goto exit

@rem Check for special characters in installation path
set "SPCHARMESSAGE=WARNING: Special characters were detected in the installation path! This can cause the installation to fail!"
echo "%CD%"| findstr /R /C:"[!#\$%&()\*+,;<=>?@\[\]\^`{|}~]" >nul && (
    call :PrintBigMessage %SPCHARMESSAGE%
)
set SPCHARMESSAGE=

@rem fix failed install when installing to a separate drive
set TMP=%cd%\alltalk_environment
set TEMP=%cd%\alltalk_environment

@rem deactivate existing conda envs as needed to avoid conflicts
(call conda deactivate && call conda deactivate && call conda deactivate) 2>nul

@rem config
set INSTALL_DIR=%cd%\alltalk_environment
set CONDA_ROOT_PREFIX=%cd%\alltalk_environment\conda
set INSTALL_ENV_DIR=%cd%\alltalk_environment\env
set MINICONDA_DOWNLOAD_URL=https://repo.anaconda.com/miniconda/Miniconda3-py310_23.3.1-0-Windows-x86_64.exe
set conda_exists=F

@rem figure out whether git and conda need to be installed
call "%CONDA_ROOT_PREFIX%\_conda.exe" --version >nul 2>&1
if "%ERRORLEVEL%" EQU "0" (
    set conda_exists=T
    call "%CONDA_ROOT_PREFIX%\condabin\conda.bat" activate "%INSTALL_ENV_DIR%"
    goto RunScript
)

@rem download and install conda if not installed
echo Downloading Miniconda from %MINICONDA_DOWNLOAD_URL% to %INSTALL_DIR%\miniconda_installer.exe
mkdir "%INSTALL_DIR%"
call curl -Lk "%MINICONDA_DOWNLOAD_URL%" > "%INSTALL_DIR%\miniconda_installer.exe" || ( echo. && echo Miniconda failed to download. && goto end )
echo Installing Miniconda to %CONDA_ROOT_PREFIX%
start /wait "" "%INSTALL_DIR%\miniconda_installer.exe" /InstallationType=JustMe /NoShortcuts=1 /AddToPath=0 /RegisterPython=0 /NoRegistry=1 /S /D=%CONDA_ROOT_PREFIX%
echo Miniconda version:
call "%CONDA_ROOT_PREFIX%\_conda.exe" --version || ( echo. && echo Miniconda not found. && goto end )

@rem create the installer env
echo Packages to install: %PACKAGES_TO_INSTALL%
call "%CONDA_ROOT_PREFIX%\_conda.exe" create --no-shortcuts -y -k --prefix "%INSTALL_ENV_DIR%" python=3.11 || ( echo. && echo Conda environment creation failed. && goto end )

@rem check if conda environment was actually created
if not exist "%INSTALL_ENV_DIR%\python.exe" ( echo. && echo Conda environment is empty. && goto end )

@rem activate installer env
call "%CONDA_ROOT_PREFIX%\condabin\conda.bat" activate "%INSTALL_ENV_DIR%" || ( echo. && echo Miniconda hook not found. && goto end )

@rem Ask user for the type of requirements to install
echo *************************************************************************************
echo.
echo Choose the type of requirements to install (this will take 10-20 minutes to install):
echo.
echo                         1. Nvidia graphics card machines
echo                         2. Other machines (mac, amd, etc)
echo.
echo *************************************************************************************
set /p UserChoice="Enter your choice (1 or 2): "

@rem Install requirements based on user choice
if "%UserChoice%" == "1" (
    echo.
    echo Installing Nvidia requirements...
    echo Downloading Pytorch with CUDA..
    pip install torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 --upgrade --force-reinstall --index-url https://download.pytorch.org/whl/cu121
    pip install numpy==1.24.4
    pip install typing-extensions>=4.8.0
    pip install networkx<3.0.0,>=2.5.0
    pip install fsspec>=2023.6.0
    pip install soundfile==0.12.1
    pip install uvicorn==0.24.0.post1
    pip install TTS==0.21.3
    pip install fastapi==0.104.1
    pip install Jinja2==3.1.2
    pip install requests==2.31.0
    pip install tqdm==4.66.1
    pip install importlib-metadata==4.8.1
    pip install packaging==23.2
    pip install pydantic==1.10.13
    pip install sounddevice==0.4.6
    pip install python-multipart==0.0.6
    echo Downloading DeepSpeed...
    curl -LO https://github.com/erew123/alltalk_tts/releases/download/DeepSpeed-12.7/deepspeed-0.12.7+d058d4b-cp311-cp311-win_amd64.whl
    echo Installing DeepSpeed...
    pip install deepspeed-0.12.7+d058d4b-cp311-cp311-win_amd64.whl
    del deepspeed-0.12.7+d058d4b-cp311-cp311-win_amd64.whl
) else (
    echo Installing requirements for other machines...
    pip install -r requirements_other.txt
)

@rem Create start_alltalk.bat to run AllTalk
echo @echo off > start_alltalk.bat
echo cd /D "%~dp0" >> start_alltalk.bat
echo set CONDA_ROOT_PREFIX=%cd%\alltalk_environment\conda >> start_alltalk.bat
echo set INSTALL_ENV_DIR=%cd%\alltalk_environment\env >> start_alltalk.bat
echo call "%CONDA_ROOT_PREFIX%\condabin\conda.bat" activate "%INSTALL_ENV_DIR%" >> start_alltalk.bat
echo call python script.py >> start_alltalk.bat
echo exit >> start_alltalk.bat
Echo.
Echo *************************************************************************************
Echo.
Echo                      "start_alltalk.bat" has been created.
Echo.
Echo                You can now start AllTalk with "start_alltalk.bat"
Echo.
Echo *************************************************************************************
Echo.
pause
goto StandaloneMenu

:DeleteCustomStandalone
@rem Check if the alltalk_environment directory exists
if not exist "%cd%\alltalk_environment\" (
    echo.
    echo      "alltalk_environment" directory does not exist. No need to delete.
    echo.
    pause
    goto StandaloneMenu
)
@rem Check if a Conda environment is active
if not defined CONDA_PREFIX goto NoCondaEnvDeleteCustomStandalone
@rem Deactivate Conda environment if it's active
Echo Exiting the Conda Environment. Please run "atsetup.bat" again and delete the environment.
conda deactivate
:NoCondaEnvDeleteCustomStandalone
echo Deleting "alltalk_environment". Please wait.
rd /s /q "alltalk_environment"
del start_alltalk.bat
if %ERRORLEVEL% neq 0 (
    echo.
    echo      Failed to delete "alltalk_environment" folder.
    echo      Please make sure it is not in use and try again.
    echo.
    pause
    goto StandaloneMenu
)
echo.
Echo *************************************************************************************
Echo.
echo    Environment "alltalk_environment" deleted. Please set up the environment again.
Echo.
Echo *************************************************************************************
pause
goto StandaloneMenu

:InstallFinetuneStandalone
cd /D "%~dp0"
set CONDA_ROOT_PREFIX=%cd%\alltalk_environment\conda
set INSTALL_ENV_DIR=%cd%\alltalk_environment\env
@rem Check if the Conda environment exists
if not exist "%INSTALL_ENV_DIR%\python.exe" (
    echo.
    echo      The Conda environment at "%INSTALL_ENV_DIR%" does not exist.
    echo      Please install the environment before proceeding.
    echo.
    pause
    goto StandaloneMenu
)
@rem Attempt to activate the Conda environment
call "%CONDA_ROOT_PREFIX%\condabin\conda.bat" activate "%INSTALL_ENV_DIR%"
if errorlevel 1 (
    echo. 
    echo      Failed to activate the Conda environment.
    echo      Please check your installation and try again.
    echo.
    pause
    goto StandaloneMenu
)
@rem Proceed with installing requirements
pip install -r requirements_finetune.txt
if %ERRORLEVEL% neq 0 (
    echo. 
    echo      There was an error installing the Finetune requirements.
    echo      Press any key to return to the menu.
    echo.
    pause
    goto StandaloneMenu
)
Echo.
Echo ******************************************************************************************************
Echo.
Echo Finetune requirements installed successfully. Please ensure you have installed CUDA 11.8 requirements.
Echo Finetune needs access to cublas64_11.dll and will error if this is not setup correctly.
Echo Please see here for details https://github.com/erew123/alltalk_tts#-finetuning-a-model
Echo.
Echo ******************************************************************************************************
pause
goto StandaloneMenu

:GenerateDiagsStandalone
cd /D "%~dp0"
set CONDA_ROOT_PREFIX=%cd%\alltalk_environment\conda
set INSTALL_ENV_DIR=%cd%\alltalk_environment\env
@rem Check if the Conda environment exists
if not exist "%INSTALL_ENV_DIR%\python.exe" (
    echo.
    echo      The Conda environment at "%INSTALL_ENV_DIR%" does not exist.
    echo      Please install the environment before proceeding.
    echo. 
    pause
    goto StandaloneMenu
)
@rem Attempt to activate the Conda environment
call "%CONDA_ROOT_PREFIX%\condabin\conda.bat" activate "%INSTALL_ENV_DIR%"
if errorlevel 1 (
    echo. 
    echo      Failed to activate the Conda environment.
    echo      Please check your installation and try again.
    echo.
    pause
    goto StandaloneMenu
)
@rem Run diagnostics
Python diagnostics.py
if %ERRORLEVEL% neq 0 (
    echo.
    echo      There was an error running diagnostics.
    echo      Press any key to return to the menu.
    echo.
    pause
    goto StandaloneMenu
)
Echo.
Echo *************************************************************************************
Echo.
Echo          Diagnostics.log generated. Please scroll up to look over the log.
Echo.
Echo *************************************************************************************
pause
goto StandaloneMenu

:End
echo Exiting AllTalk Setup Utility...
exit /b