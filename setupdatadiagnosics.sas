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
   %put &MsgType- topPath: (Optional) Fully-qualified path to the top-level folder under which;
   %put &MsgType-          the "Data Diagnostics with Base SAS" folder is to be created.;
   %put &MsgType-          All workshop files will be downloaded and unzipped there.;
   %put &MsgType-          Default is c:/workshop for SAS on Windows, and ~/workshop on Linux;
   %put &MsgType- ;
   %put &MsgType- Examples: ;
   %put &MsgType- %nrstr(%%)&SYSMACRONAME(c:/workshop);
   %put &MsgType- %nrstr(%%)&SYSMACRONAME(~/workshop);
   %put &MsgType- ;
   %put &MsgType- ;
   %return;
%end; 

%if %SUPERQ(topPath)= %then %do;
   %if &sysscp=WIN %then %let topPath=c:/workshops;
      %else %let topPath=~/workshops;
%put &MsgType- ;
   %put &MsgType: Using %superq(topPath) as top-level directory;
   %put &MsgType- ;
   %put &MsgType- ;
   %let topPath=~/workshops;
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

%if %fileexist(%superq(topPath)/Data Diagnostics with Base SAS) %then %do;
	%PUT NOTE: Directory %superq(topPath)/Data Diagnostics with Base SAS exists. Deleting all content.;
	%deletetree(%superq(topPath)/Data Diagnostics with Base SAS)
%end;

/* Create root of folder tree */
options dlcreatedir;
%let path=&topPath/Data Diagnostics with Base SAS;
libname path "&topPath/Data Diagnostics with Base SAS";
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

