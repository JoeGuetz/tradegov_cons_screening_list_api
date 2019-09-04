# tradegov_cons_screening_list_api
IBM i ILE RPG service program to use trade.gov Consolidated Screening List API for address verification
from IBM i ILE programming languages.

# tradegov_cons_screening_list_api
IBM i ILE RPG service program to use trade.gov Consolidated Screening List API for address verification
from IBM i ILE programming languages.

The most important information at first: this solution will not run in jobs with CCSID 65535!

So make sure your job runs with a proper CCSID!


The solution is developed, compiled and tested residing in and based on library IXPERTOSS.

The IBM i OS Version used for development, compile and testing was V7R2.

The project has so far not been tested under another version.


Include and Copy statements in source code refer to library IXPERTOSS.

If you want to use another library, you need to adjust the source code to compile.

You also need to make adjustments to the SQL DDL in QSQLSRC


Our policy is to store

RPG in QRPGLESRC, DDS in QDDSSRC, CL in QCLPSRC, SRVPGM ExportDefs in QSRVSRC ... you get the idea!

First step:

Go to trade.gov website an apply for an ApiKey. Our apikey is stored in file-member IXPERTOSSS/QINCLUDELE,TRDGOVKEY
This member is referenced in the test-program. Unless you either create the member (notice the library name with three S)
or remark the copy statement in the program, the program will not compile correctly! 

Installation path 1:

CRTLIB IXPERTOSS

CRTSRCPF FILE(IXPERTOSS/QRPGLESRC) RCDLEN(112)

CRTSRCPF FILE(IXPERTOSS/QINCLUDELE) RCDLEN(112)

CRTSRCPF FILE(IXPERTOSS/QSRVSRC) RCDLEN(112)

CRTSRCPF FILE(IXPERTOSS/QSQLSRC) RCDLEN(112)


as a preliminary consideration also create

CRTSRCPF FILE(IXPERTOSS/QDDSSRC) RCDLEN(112)

CRTSRCPF FILE(IXPERTOSS/QCLPSRC) RCDLEN(112)


transfer the source content from here to the according source members

CHGCURLIB IXPERTOSS

CRTBNDDIR IXPERTOSS/TRDGOVBND

ADDBNDDIRE BNDDIR(IXPERTOSS/TRDGOVBND) OBJ((*LIBL/TRDGOVCSL *SRVPGM))

 
Compile the source code TRDGOVCSL with SEU Option 15 on member IXPERTOSS/TRDGOVCSL

Create the SRVPGM (make sure to reference the ExportDefs!)

CRTSRVPGM SRVPGM(IXPERTOSS/TRDGOVCSL) SRCFILE(IXPERTOSS/QSRVSRC)

Compile the test program T$TGSSRCH with SEU Option 14 on member IXPERTOSS/T$TGSSRCH

(remember to do something with the copy for the apikey) 
