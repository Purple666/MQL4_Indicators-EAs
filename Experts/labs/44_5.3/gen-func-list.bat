REM set dpath_Src=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Include

REM *************************************
REM 	<Usage> (20190114_112539)
REM 	1. update vars
REM 	2. run this batch file
REM *************************************

REM *************************************
REM 	vars : dpath source
REM *************************************
REM set dpath_Src=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Indicators\lab\obs\49_8
REM set dpath_Src=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Experts\labs\44_5.3
set dpath_Src=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Include

REM *************************************
REM 	vars : fname source
REM *************************************
REM set fname_Src=ea_44_5.3_2_up-up-buy.mq4
REM set fname_Src=obs_49_8.(copy-2).mq4
REM set fname_Src=obs_49_8.(copy).mq4
REM set fname_Src=utils.mqh
set fname_Src=lib_ea.mqh

REM *************************************
REM 	vars : dpath dst
REM *************************************
set dpath_Dst=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Experts\labs\44_5.3

REM *************************************
REM 	vars : command
REM *************************************
set command=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\utils\utils.20171123-121700.rb

REM C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\utils\utils.20171123-121700.rb %1 %2 %3

%command% %dpath_Src% %fname_Src% %dpath_Dst%

pause
