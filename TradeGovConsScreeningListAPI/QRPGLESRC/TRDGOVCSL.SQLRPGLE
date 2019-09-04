000100190830      ****************************************************************
000200190830      *
000300190830      *    IBM i Open Source Collection
000400190830      *
000500190830      *    Copyright SNS GmbH, Bayreuth, Germany
000600190830      *    Published under GNU GPLv3 License
000700190830      *
000800190903      *    Author: Joe Guetzlaff, 08.19
000900190830      ****************************************************************
001000190830     H COPYRIGHT ('Copyright © by +
001100190903     H             SNS GmbH, Bayreuth, Germany +
001200190903     H             mindstream solutions llc, Cape Coral, FL, USA +
001300190830     H             Published under GNU GPLv3 License')
001400190830
001500190830     H BNDDIR    ('TRDGOVBND':'QC2LE')
001600190903     H ALWNULL   (*USRCTL)
001700190903     H FIXNBR    (*ZONED:*INPUTPACKED)
001800190903     H OPTION    (*NOXREF:*NODEBUGIO)
001900190830     H CCSID     (*CHAR:*JOBRUN)
002000190830     H CCSID     (*UCS2:1200   )
002100190830     H NOMAIN
002200140622
002300190830      ****************************************************************
002400140622
002500190830     D false           C                   *off
002600190830     D true            C                   *on
002700190830
002800190821      /free
002900190821       exec sql set option commit = *none, naming = *sql;
003000190821      /end-free
003100140721
003200190904      /copy ixpertoss/qincludele,trdgovcsl
003300190830
003400190902     D udtf_call_open...
003500190902     D                 C                   -1
003600190902     D udtf_call_fetch...
003700190902     D                 C                   0
003800190902     D udtf_call_close...
003900190902     D                 C                   1
004000190902     D udtf_parm_null...
004100190902     D                 C                   -1
004200190902     D udtf_parm_notnull...
004300190902     D                 C                   0
004400190902
004500980226      ****************************************************************
004600190830      * Procedures
004700190830      ****************************************************************
004800190830      ****************************************************************
004900190901      * trade.gov Consolidated Screening List API Search
005000190830      ****************************************************************
005100190901     P trdgovcsl_search_do...
005200190830     P                 B                   Export
005300190901     D trdgovcsl_search_do...
005400190830     D                 PI              N
005500190830     D  apikey                       30    Varying Const
005600190901     D  search                             LikeDs(trdgovcsl_search_crit_T)
005700190830     D  cbProc                         *   ProcPtr Const
005800190828
005900190830     D str             S          32000
006000190830     D url             S           1024    Varying
006100190830     D resRowCount     S              5  0
006200190828
006300190828      /free
006400190828       url = 'https://api.trade.gov/consolidated_screening_list/search' +
006500190828             '?api_key=' + apikey;
006600190828       if search.keyword <> '';
006700190828         url = url + '&q=' + search.keyword;
006800190828       endif;
006900190828       if search.sources <> '';
007000190828         url = url + '&sources=' + search.sources;
007100190828       endif;
007200190828       if search.countries <> '';
007300190828         url = url + '&countries=' + search.countries;
007400190828       endif;
007500190828       if search.address <> '';
007600190828         url = url + '&address=' + search.address;
007700190828       endif;
007800190828       if search.name <> '';
007900190828         url = url + '&name=' + search.name;
008000190828       endif;
008100190828       if search.fuzzy_name;
008200190828         url = url + '&fuzzy_name=true';
008300190828       endif;
008400190828       if search.type <> '';
008500190828         url = url + '&type=' + search.type;
008600190828       endif;
008700190828
008800190830      /if defined (read_to_str)
008900190828       exec sql
009000190828        values systools.httpgetclob(:url, '')
009100190828        into :str;
009200190830      /endif
009300190828
009400190828       exec sql
009500190901        create table qtemp.#trdgovcsl(result clob (1M) not hidden);
009600190830       if sqlcode <> 0 and sqlcode <> -601;
009700190830         return false;
009800190830       endif;
009900190828       exec sql
010000190901        delete from qtemp.#trdgovcsl;
010100190828       exec sql
010200190901        insert into qtemp.#trdgovcsl
010300190828        values systools.httpgetclob(:url, '');
010400190830       if sqlcode <> 0;
010500190830         return false;
010600190830       endif;
010700190830       exec sql
010800190830        select count(*)
010900190830        into :resRowCount
011000190901        from qtemp.#trdgovcsl;
011100190830       if resRowCount = 0;
011200190830         return false;
011300190830       endif;
011400190830       if cbProc <> *NULL;
011500190830         processResult(cbProc);
011600190830       endif;
011700190830       return true;
011800190828      /end-free
011900190828
012000190828     P                 E
012100190902      ****************************************************************
012200190902      * trade.gov Consolidated Screening List API Search UDTF
012300190902      ****************************************************************
012400190902     P trdgovcsl_search_udtf...
012500190902     P                 B                   Export
012600190902     D trdgovcsl_search_udtf...
012700190902     D                 PI
012800190902     D  i_apikey                     30    Varying Const
012900190902     D  i_keyword                  1000    Varying Const
013000190902     D  i_sources                    50    Varying Const
013100190902     D  i_countries                 200    Varying Const
013200190902     D  i_address                   100    Varying Const
013300190902     D  i_name                      100    Varying Const
013400190902     D  i_fuzzy_name                  1    Varying Const
013500190902     D  i_type                       20    Varying Const
013600190902     D  o_id                         50    Varying
013700190902     D  o_name                      100    Varying
013800190902     D  o_altname                   100    Varying
013900190902     D  o_zip                        10    Varying
014000190902     D  o_city                       30    Varying
014100190902     D  o_state                      30    Varying
014200190902     D  o_country                    10    Varying
014300190902     D  n_apikey                      5I 0 Const
014400190902     D  n_keyword                     5I 0 Const
014500190902     D  n_sources                     5I 0 Const
014600190902     D  n_countries                   5I 0 Const
014700190902     D  n_address                     5I 0 Const
014800190902     D  n_name                        5I 0 Const
014900190902     D  n_fuzzy_name                  5I 0 Const
015000190902     D  n_type                        5I 0 Const
015100190902     D  n_id                          5I 0 Const
015200190902     D  n_nameo                       5I 0 Const
015300190902     D  n_altname                     5I 0 Const
015400190902     D  n_zip                         5I 0 Const
015500190902     D  n_city                        5I 0 Const
015600190902     D  n_state                       5I 0 Const
015700190902     D  n_country                     5I 0 Const
015800190902     D  SQLSTT                        5A
015900190902     D  function                    517A   Varying Const
016000190902     D  specific                    128A   Varying Const
016100190902     D  errorMsg                     70A   Varying
016200190902     D  callType                     10I 0 Const
016300190902
016400190903     D search          DS                  LikeDs(trdgovcsl_search_crit_T)
016500190903
016600190903     D fb              DS                  LikeDs(trdgovcsl_search_rowdata_T)
016700190903     D errind          S              4B 0 Dim(10)
016800190902
016900190902      /free
017000190903       SQLSTT = '00000';
017100190902
017200190903       select;
017300190903       when callType = udtf_call_open;
017400190903         exsr doOpen;
017500190903       when callType = udtf_call_fetch;
017600190903         exsr doFetch;
017700190903       when callType = udtf_call_close;
017800190903         exsr doClose;
017900190903       other;
018000190903       endsl;
018100190903       return;
018200190902
018300190903       begsr doOpen;
018400190903       clear search;
018500190903       if n_apikey = udtf_parm_null;
018600190903         SQLSTT = '38999';
018700190903         leavesr;
018800190903       endif;
018900190903       if n_keyword = udtf_parm_null;
019000190903         SQLSTT = '38999';
019100190903         leavesr;
019200190903       endif;
019300190903       search.keyword = i_keyword;
019400190903       if n_sources = udtf_parm_null;
019500190903         SQLSTT = '38999';
019600190903         leavesr;
019700190903       endif;
019800190903       search.sources = i_sources;
019900190903       if n_countries = udtf_parm_null;
020000190903         SQLSTT = '38999';
020100190903         leavesr;
020200190903       endif;
020300190903       search.countries = i_countries;
020400190903       if n_address = udtf_parm_null;
020500190903         SQLSTT = '38999';
020600190903         leavesr;
020700190903       endif;
020800190903       search.address = i_address;
020900190903       if n_name = udtf_parm_null;
021000190903         SQLSTT = '38999';
021100190903         leavesr;
021200190903       endif;
021300190903       search.name = i_name;
021400190903       if n_fuzzy_name = udtf_parm_null;
021500190903         search.fuzzy_name = false;
021600190903       elseif i_fuzzy_name = '1' or i_fuzzy_name = 'Y';
021700190903         search.fuzzy_name = true;
021800190903       endif;
021900190903       if n_type = udtf_parm_null;
022000190903         search.type = '';
022100190903       else;
022200190903         search.type = i_type;
022300190903       endif;
022400190903       if not trdgovcsl_search_do(i_apikey:search:*null);
022500190903         sqlcode = -100;
022600190903         leavesr;
022700190903       endif;
022800190903       if not jsonReaderOpen();
022900190903         SQLSTT = '38999';
023000190903       endif;
023100190903       endsr;
023200190903
023300190903       begsr doFetch;
023400190903       exec sql fetch next from c_json_reader
023500190903         into :fb:errind;
023600190903       if sqlcode <> 0;
023700190903         SQLSTT = '02000';
023800190903         leavesr;
023900190903       endif;
024000190903       o_id = fb.id;
024100190903       o_name = fb.name;
024200190903       o_altname = fb.altname;
024300190903       o_zip = fb.zip;
024400190903       o_city = fb.city;
024500190903       o_state = fb.state;
024600190903       o_country = fb.country;
024700190903       endsr;
024800190903
024900190903       begsr doClose;
025000190903       jsonReaderClose();
025100190903       endsr;
025200190903
025300190902      /end-free
025400190902
025500190902     P                 E
025600190830      ****************************************************************
025700190830      * Dipsose and Cleanup Work
025800190830      ****************************************************************
025900190901     P trdgovcsl_dispose...
026000190830     P                 B                   Export
026100190901     D trdgovcsl_dispose...
026200190830     D                 PI
026300190830
026400190830      /free
026500190903       jsonReaderClose();
026600190901       exec sql drop table qtemp.#trdgovcsl;
026700190830      /end-free
026800190830
026900190830     P                 E
027000190830      ****************************************************************
027100190830      * Internal Data Reader
027200190830      ****************************************************************
027300190830     P processResult   B
027400190830     D processResult   PI
027500190830     D  cbProc                         *   ProcPtr Const
027600190828
027700190830      * Define Delegate for Event Handler Call
027800190830     D evResult        PR                  ExtProc(pptr)
027900190901     D  e                                  LikeDs(trdgovcsl_search_rowdata_T)
028000190830
028100190830     D pptr            S               *   ProcPtr Inz(*null)
028200190901     D fb              DS                  LikeDs(trdgovcsl_search_rowdata_T)
028300190828     D errind          S              4B 0 Dim(10)
028400190828
028500190828      /free
028600190903       if jsonReaderOpen();
028700190903         dou sqlcode = 100;
028800190903           exec sql
028900190903            fetch c_json_reader into :fb:errind;
029000190903            if sqlcode <> 100;
029100190903              if cbProc <> *NULL;
029200190903                pptr = cbProc;
029300190903                callp(e) evResult(fb);
029400190903              endif;
029500190903            endif;
029600190903         enddo;
029700190903       endif;
029800190903       jsonReaderClose();
029900190828      /end-free
030000190828
030100190828     P                 E
030200190903      ****************************************************************
030300190902      ****************************************************************
030400190903      * JSON Reader Stuff
030500190902      ****************************************************************
030600190903     P jsonReaderOpen  B
030700190903     D jsonReaderOpen  PI              N
030800190903
030900190903     D ssql            S           1024    Varying
031000190903
031100190903      /free
031200190903       jsonReaderClose();
031300190903       ssql = jsonReaderSQL();
031400190903       exec sql prepare s_json_reader from :ssql;
031500190903       exec sql declare c_json_reader cursor for s_json_reader;
031600190903       exec sql open c_json_reader;
031700190903       return (sqlcode = 0);
031800190903      /end-free
031900190903
032000190903     P                 E
032100190903      ****************************************************************
032200190903     P jsonReaderClose...
032300190903     P                 B
032400190903     D jsonReaderClose...
032500190903     D                 PI
032600190903
032700190903      /free
032800190903       exec sql close c_json_reader;
032900190903      /end-free
033000190903
033100190903     P                 E
033200190903      ****************************************************************
033300190903     P jsonReaderSQL   B
033400190903     D jsonReaderSQL   PI          1024    Varying
033500190902
033600190902     D ssql            S           1024    Varying
033700190902
033800190902      /free
033900190902       ssql =
034000190902        'select distinct t.id, t.name, t.altname, t.zip, +
034100190902                         t.city, t.state, t.country +
034200190902         from qtemp.#trdgovcsl a, +
034300190902              JSON_TABLE( +
034400190902                a.result, ''lax $.results'' +
034500190902                COLUMNS ( +
034600190902                  id varchar(50) path ''lax $.id'', +
034700190902                  name varchar(100) path ''lax $.name'', +
034800190902                  altnames varchar(1000) format json path ''lax $.alt_names'', +
034900190902                  nested path ''lax $.alt_names[*]'' +
035000190902                    COLUMNS(altname varchar(100) path ''lax $''), +
035100190902                  nested path ''lax $.addresses[*]'' +
035200190902                    COLUMNS( +
035300190902                      zip varchar(10) path ''lax $.postal_code'', +
035400190902                      city varchar(30) path ''lax $.city'', +
035500190903                      state varchar(30) path ''lax $.state'', +
035600190902                      country varchar(10) path ''lax $.country'' +
035700190903                       ))) as t +
035800190902         order by t.id';
035900190902       return ssql;
036000190902      /end-free
036100190902
036200190902     P                 E
