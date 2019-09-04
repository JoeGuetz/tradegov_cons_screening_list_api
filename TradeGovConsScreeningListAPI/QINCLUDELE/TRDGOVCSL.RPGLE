000100190830      ****************************************************************
000200190830      *
000300190830      *    IBM i Open Source Collection
000400190830      *
000500190830      *    Copyright SNS GmbH, Bayreuth, Germany
000600190830      *    Published under GNU GPLv3 License
000700190830      *
000800190903      *    Author: Joe Guetzlaff, 08.19
000900020708      ****************************************************************
001000131030
001100190902     D g_apikey        S             30    Varying
001200190830
001300190901     D trdgovcsl_search_crit_T...
001400190830     D                 DS                  Qualified Template Inz
001500190830     D  keyword                    1000    Varying
001600190830     D  sources                      50    Varying
001700190830     D  countries                   200    Varying
001800190830     D  address                     100    Varying
001900190830     D  name                        100    Varying
002000190830     D  fuzzy_name                     N
002100190830     D  type                         20    Varying
002200190830
002300190901     D trdgovcsl_search_rowdata_T...
002400190830     D                 DS                  Qualified Template Inz
002500190830     D  id                           50    Varying
002600190830     D  name                        100    Varying
002700190830     D  altname                     100    Varying
002800190830     D  zip                          10    Varying
002900190830     D  city                         30    Varying
003000190830     D  state                        30    Varying
003100190830     D  country                      10    Varying
003200190830
003300190901     D trdgovcsl_search_on_rowdata...
003400190830     D                 PR
003500190901     D  e                                  LikeDs(trdgovcsl_search_rowdata_T)
003600190830
003700190901     D trdgovcsl_search_do...
003800190830     D                 PR              N
003900190830     D  apikey                       30    Varying Const
004000190901     D  criteria                           LikeDs(trdgovcsl_search_crit_T)
004100190830     D  cbProc                         *   ProcPtr Const
004200140622
004300190901     D trdgovcsl_dispose...
004400190830     D                 PR
004500190830
