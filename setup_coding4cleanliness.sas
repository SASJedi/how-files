%macro setupCode4Cleanliness(topPath);
%local MSGTYPE;
%global path;
%let MsgType=NOTE;
%if %SUPERQ(topPath)= ? %then %do;
%Syntax:
   %put &MsgType- ;
   %put &MsgType: &SYSMACRONAME documentation:;
   %put &MsgType- ;
   %put &MsgType- Purpose: Download, unzip, and set up the files for the;
   %put &MsgType-          Coding for Cleanliness in SAS Viya tutorial.;
   %put &MsgType- ;
   %put &MsgType- Syntax: %nrstr(%%)&SYSMACRONAME(topPath);
   %put &MsgType- ;
   %put &MsgType- topPath: (Optional) Fully-qualified path to the top-level folder under which;
   %put &MsgType-          the "coding for cleanliness" folder is to be created.;
   %put &MsgType-          All workshop files will be downloaded and unzipped there.;
   %put &MsgType-          Default is c:/tutorials for SAS on Windows, and ~/tutorials on Linux;
   %put &MsgType- ;
   %put &MsgType- Examples: ;
   %put &MsgType- %nrstr(%%)&SYSMACRONAME(c:/tutorials);
   %put &MsgType- %nrstr(%%)&SYSMACRONAME(~/tutorials);
   %put &MsgType- ;
   %put &MsgType- ;
   %return;
%end; 

%if %SUPERQ(topPath)= %then %do;
   %if &sysscp=WIN %then %let topPath=c:/tutorials;
      %else %let topPath=~/tutorials;
%put &MsgType- ;
   %put &MsgType: Using %superq(topPath) as top-level directory;
   %put &MsgType- ;
   %put &MsgType- ;
   %let topPath=~/tutorials;
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
filename macro url "https://raw.githubusercontent.com/SASJedi/sas-macros/master/whereami.sas";
%include macro;
filename macro url "https://raw.githubusercontent.com/sasjs/core/main/all.sas";
%include macro;

%let topPath=%translate(%superq(topPath),/,\);

options dlcreatedir;
libname path "&topPath";
libname path clear;
options nodlcreatedir;

%if %fileexist(%superq(topPath)/coding for cleanliness) %then %do;
	%PUT NOTE: Directory %superq(topPath)/coding for cleanliness exists. Deleting all content.;
	%deletetree(%superq(topPath)/coding for cleanliness)
%end;

/* Create root of folder tree */
options dlcreatedir;
%let path=&topPath/coding for cleanliness;
libname path "&topPath/coding for cleanliness";
libname path clear;
options nodlcreatedir;

filename zipfile "&path/coding4cleanliness.zip";
proc http 
   url="https://bit.ly/Tut-Code4Cleanliness"
   out=zipfile;
run;

filename zipfile clear;

%mp_unzip(ziploc="&path/coding4cleanliness.zip",outdir=&topPath);
/*filename zipfile "&path/DataDiagnosticsWithBaseSAS.zip";
%let rc=%qsysfunc(fdelete(zipfile)); */
%mend setupCode4Cleanliness;
%setupCode4Cleanliness(?)
