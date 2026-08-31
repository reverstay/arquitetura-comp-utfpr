@echo off
REM ------------------------------------------------------------------
REM EqNN-make.bat
REM Compila e simula a ULA (EqNN-ULA.vhd + EqNN-ULA_tb.vhd) com o GHDL,
REM gerando a forma de onda EqNN-ULA.ghw.
REM
REM Requisitos: GHDL instalado e disponivel no PATH do Windows.
REM Uso: coloque este .bat na mesma pasta dos arquivos .vhd e execute.
REM ------------------------------------------------------------------

setlocal

echo [1/3] Limpando artefatos antigos...
if exist work-obj08.cf del /q work-obj08.cf
if exist EqNN-ULA.ghw del /q EqNN-ULA.ghw

echo [2/3] Compilando (ghdl -a)...
ghdl -a --std=08 EqNN-ULA.vhd EqNN-ULA_tb.vhd
if errorlevel 1 goto erro

echo [2/3] Elaborando (ghdl -e)...
ghdl -e --std=08 EqNN_ULA_tb
if errorlevel 1 goto erro

echo [3/3] Simulando (ghdl -r) e gerando EqNN-ULA.ghw...
ghdl -r --std=08 EqNN_ULA_tb --wave=EqNN-ULA.ghw
if errorlevel 1 goto erro

echo.
echo Concluido com sucesso. Abra EqNN-ULA.ghw no GTKWave para ver a forma de onda.
goto fim

:erro
echo.
echo ERRO durante compilacao/simulacao. Verifique as mensagens acima.
exit /b 1

:fim
endlocal
