%macro setUpDataDiagnosics(topPath);
%local MSGTYPE;
%global path;
%let MsgType=NOTE;
%if %SUPERQ(topPath)= ? %then %do;
%Syntax:
   %put &MsgType- ;
   %put &MsgType: &SYSMACRONAME documentation:;
   %put &MsgType- ;
   %put &MsgType- Purpose: Download, unzip, and set up the files for the;
   %put &MsgType-          Data Diagnositcs with Base SAS HOW.;
   %put &MsgType- ;
   %put &MsgType- Syntax: %nrstr(%%)&SYSMACRONAME(topPath);
   %put &MsgType- ;
   %put &MsgType- topPath: fully-qualified path to the folder where the workshop;
   %put &MsgType- top-level data-diagnositcs folder will be created. Workshop files;
   %put &MsgType- will be downloaded and unzipped there. Default is ~/SESUG2024;
   %put &MsgType- ;
   %put &MsgType- Examples: ;
   %put &MsgType- %nrstr(%%)&SYSMACRONAME(c:/workshop);
   %put &MsgType- %nrstr(%%)&SYSMACRONAME(~/SESUG2024);
   %put &MsgType- ;
   %put &MsgType- ;
   %return;
%end; 

%if %SUPERQ(topPath)= %then %do;
   %put &MsgType- ;
   %put &MsgType: Using ~/SESUG2024 as top-level directory;
   %put &MsgType- ;
   %put &MsgType- ;
   %let topPath=~/SESUG2024;
%end;

filename macro url "https://raw.githubusercontent.com/SASJedi/sas-macros/master/deletetree.sas";
%include macro;
filename macro url "https://raw.githubusercontent.com/SASJedi/sas-macros/master/exist.sas";
%include macro;
filename macro url "https://raw.githubusercontent.com/SASJedi/sas-macros/master/findfiles.sas";
%include macro;
filename macro url "https://raw.githubusercontent.com/SASJedi/sas-macros/master/fileattribs.sas";
%include macro;
filename macro url "https://raw.githubusercontent.com/SASJedi/sas-macros/master/fileexist.sas";
%include macro;
filename macro url "https://raw.githubusercontent.com/SASJedi/sas-macros/master/pathname.sas";
%include macro;
filename macro url "https://raw.githubusercontent.com/SASJedi/sas-macros/master/translate.sas";
%include macro;
filename macro url "https://raw.githubusercontent.com/sasjs/core/main/all.sas";
%include macro;

%let topPath=%translate(%superq(topPath),/,\);

options dlcreatedir;
libname path "&topPath";
libname path clear;
options nodlcreatedir;

%if %fileexist(%superq(topPath)/data_diagnostics) %then %do;
	%PUT NOTE: Directory %superq(topPath)/data_diagnostics exists. Deleting all content.;
	%deletetree(%superq(topPath)/data_diagnostics)
%end;

/* Create root of folder tree */
options dlcreatedir;
%let path=&topPath/data_diagnostics;
libname path "&topPath/data_diagnostics";
libname path clear;
options nodlcreatedir;

filename zipfile "&path/DataDiagnosticsWithBaseSAS.zip";
proc http 
   url="https://raw.githubusercontent.com/SASJedi/how-files/master/DataDiagnosticsWithBaseSAS.zip"
   out=zipfile;
run;

filename zipfile clear;

%mp_unzip(ziploc="&path/DataDiagnosticsWithBaseSAS.zip",outdir=&topPath);
/*filename zipfile "&path/DataDiagnosticsWithBaseSAS.zip";
%let rc=%qsysfunc(fdelete(zipfile)); */

%include "&path/data/setup.sas";
%mend;

%setUpDataDiagnosics(?)

