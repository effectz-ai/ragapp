REM Set environment variables
set PYTHONPATH="./;./create_llama/backend;./create_llama/backend/*"
set CREATE_LLAMA_VERSION=0.1.9
set NEXT_PUBLIC_API_URL=/api/chat

REM Remove the directory if it exists
rd /s /q create_llama

REM Run the npx command
npx -y create-llama@%CREATE_LLAMA_VERSION% --framework fastapi --template streaming --engine context --frontend --ui shadcn --observability none --open-ai-key none --tools none --post-install-action none --no-llama-parse --no-files --vector-db chroma -- create_llama

REM We don't need the example data and default .env files
rd /s /q create_llama\backend\data
del create_llama\backend\.env
del create_llama\frontend\.env

REM Copy the patch files to the create_llama directory
xcopy .\patch\* .\create_llama\ /E /I /Y

REM Building Chat UI...
cd .\create_llama\frontend
npm install
npm run build
cd ../..

REM Copying Chat UI to static folder...
if not exist .\static mkdir .\static
xcopy .\create_llama\frontend\out\* .\static\ /E /I /Y

REM Building Admin UI...
cd .\admin
npm install
npm run build
cd ..

@echo.

REM Copying Admin UI to static folder...
if not exist .\static\admin mkdir .\static\admin
xcopy .\admin\out\* .\static\admin\ /E /I /Y

@echo.

REM Set environment variable
set ENVIRONMENT=dev

@REM REM Start the Python script and the npm development server concurrently
@REM start "" cmd /c "poetry run python main.py"
@REM start "" cmd /c "npm run dev --prefix .\admin"
@REM
@REM REM Wait for both processes to finish
@REM wait