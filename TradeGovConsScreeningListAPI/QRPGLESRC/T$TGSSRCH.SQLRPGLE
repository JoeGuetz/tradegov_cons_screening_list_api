000100190830      ****************************************************************
000200190830      *
000300190830      *    IBM i Open Source Collection
000400190830      *
000500190830      *    Copyright SNS GmbH, Bayreuth, Germany
000600190830      *    Published under GNU GPLv3 License
000700190830      *
000800190903      *    Author: Joe Guetzlaff, 08.19
000900190830      ****************************************************************
001000190903     H COPYRIGHT ('Copyright © by +
001100190903     H             SNS GmbH, Bayreuth, Germany +
001200190903     H             mindstream solutions llc, Cape Coral, FL, USA +
001300190903     H             Published under GNU GPLv3 License')
001400190903
001500190830     H BNDDIR    ('TRDGOVBND':'QC2LE')
001600190830     H DFTACTGRP (*NO)
001700190830     H ACTGRP    (*NEW   )
001800190830     H ALWNULL   (*USRCTL)                                                      PGM SPECIFIC
001900190830     H FIXNBR    (*ZONED : *INPUTPACKED)                                        PGM SPECIFIC
002000190830     H OPTION    (*NOXREF : *NODEBUGIO)
002100190830     H CCSID     (*CHAR:*JOBRUN)
002200190830     H CCSID     (*UCS2:1200   )
002300140622
002400190904      /copy ixpertoss/qincludele,trdgovcsl
002500140721
002600980226      ****************************************************************
002700140622
002800140622      /free
002900190830       main();
003000190821       *inlr = *on;
003100140622      /end-free
003200140622
003300190830      ****************************************************************
003400190821     P main            B
003500190821    ?D main            PI
003600190821
003700190902     D crit            DS                  LikeDs(trdgovcsl_search_crit_T)
003800190830     D rc              S               N
003900190821
004000140720      /free
004100190904      /copy ixpertosss/qincludele,trdgovkey
004200190830       clear crit;
004300190830       crit.countries = 'PK';
004400190902       rc = trdgovcsl_search_do(g_apikey:
004500190830                                crit:
004600190902                                %paddr(trdgovcsl_search_on_rowdata));
004700190902       trdgovcsl_dispose();
004800140720      /end-free
004900190821
005000190821     P                 E
005100190828?     * ---------------------------------------------------------------
005200190828
005300190828?     * ---------------------------------------------------------------
005400190902     P trdgovcsl_search_on_rowdata...
005500190830     P                 B
005600190902     D trdgovcsl_search_on_rowdata...
005700190830     D                 PI
005800190902     D  e                                  LikeDs(trdgovcsl_search_rowdata_T)
005900190830
006000190830     D  dbg            S              1
006100190828
006200190830      /free
006300190904       dbg = *blanks;         //serves as debug breakpoint
006400190828      /end-free
006500190828
006600190828     P                 E
