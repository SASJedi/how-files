%macro setUpDataDiagnosics(localPath);
%local MSGTYPE;
%let MsgType=NOTE;
%if %SUPERQ(localPath)= ? %then %do;
%Syntax:
   %put &MsgType- ;
   %put &MsgType: &SYSMACRONAME documentation:;
   %put &MsgType- ;
   %put &MsgType- Purpose: Download, unzip, and set up the files for the;
   %put &MsgType-          Data Diagnositcs with Base SAS HOW.;
   %put &MsgType- ;
   %put &MsgType- Syntax: %nrstr(%%)&SYSMACRONAME(localPath);
   %put &MsgType- ;
   %put &MsgType- localPath: fully-qualified path to the folder where the workshop;
   %put &MsgType- top-level data-diagnositcs folder will be created. Workshop files;
   %put &MsgType- will be downloaded and unzipped there. Default is ~/SESUG2024;
   %put &MsgType- ;
   %put &MsgType- Examples: ;
   %put &MsgType- %nrstr(%%)&SYSMACRONAME(c:/workshop);
   %put &MsgType- %nrstr(%%)&SYSMACRONAME(~/HOWs);
   %put &MsgType- ;
   %put &MsgType- ;
   %return;
%end; 
%if %SUPERQ(localPath)= %then %do;
   %put &MsgType- ;
   %put &MsgType: Using ~/SESUG2024 as roo directory;
   %put &MsgType- ;
   %put &MsgType- ;
	%let path=~/SESUG2024;
	options dlcreatedir;
	libname path "&path";
	options dlcreatedir;
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

%let localPath=%translate(%superq(localPath),/,\);
%let path=%qsysfunc(DCREATE(data-diagnostics),%superq(localpath))
%if %fileexist(%superq(localpath)/data_diagnostics) %then %do;
	%PUT NOTE: Directory %superq(localpath)/data_diagnostics exists. Deleting all content.;
	%deletetree(%superq(localpath)/data_diagnostics)
%end;

%let path=%qsysfunc(DCREATE(data_diagnostics,~/SESUG2024));
%let path=%superq(localpath)/data_diagnostics;
%put NOTE: &=path;
filename zipfile "&path/DataDiagnosticsWithBaseSAS.zip";
proc http 
   url="https://raw.githubusercontent.com/SASJedi/how-files/master/DataDiagnosticsWithBaseSAS.zip"
   out=zipfile;
run;

filename zipfile clear;

options dlcreatedir;
libname path "~/SESUG2024";
libname path "&path/autocall";
libname path "&path";
libname path "&path/autocall";
libname cleanme "&path/data";
libname backup  "&path/data/backup";
libname clean   "&path/data/clean";
libname path "&path/demos";
libname path "&path/practices";
libname path clear;
options nodlcreatedir;

%mp_unzip(ziploc="&path/DataDiagnosticsWithBaseSAS.zip",outdir=~/SESUG2024);
filename zipfile "&path/DataDiagnosticsWithBaseSAS.zip";
%let rc=%qsysfunc(fdelete(zipfile));

%include "&path/data/setup.sas";
%mend;


%setUpDataDiagnosics(?)
