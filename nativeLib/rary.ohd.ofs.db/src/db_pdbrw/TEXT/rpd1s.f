C MODULE RPD1S
C-----------------------------------------------------------------------
C
       SUBROUTINE RPD1S (ISTAID,IDTYPE,NTYPES,IDATYP,IFDAY,LDAY,
     *    LTYPE,IRTYPE,MTYPES,
     *    LDATA,DATA,LDFILL,IDELT,NVPDT,MSNG,ISTAT)
C
C    THIS ROUTINE READS OBSERVED NON-RRS DATA FROM THE PPDB FOR THE
C    DAYS SPECIFIED.  DOES NOT READ MDR6,PPSR
C    READS FOR 1 STATION.
C
C          ARGUMENT LIST:
C
C         NAME    TYPE  I/O   DIM   DESCRIPTION
C
C       ISTAID    A8 OR I I   1 OR 2  STATION ID OR NUMERIC ID
C       IDTYPE     I     I     1     =0 STAID IS CHARS
C                                    =1 ISTAID IS INTEGER
C       NDTYPE     I     I     1     NUMBER OF DATA TYPES
C       IDATYP   A4      I   NDTYPE  DATA TYPES
C       IFDAY     I      I     1    JULIAN DAY OF FIRST DATA
C       LDAY      I      I     1    JULIAN DAY OF LAST DATA
C                                    DAY CAN BE RESET IF NOT FOUND
C       LTYPE     I       I     1    LENGTH OF IRTYPE
C       IRTYPE    A4      O   LTYPE  DATA TYPE CODES RETURNED
C       MTYPES    I       O     1    NUMBER OF DATA TYPES RETURNED
C       LDATA     I      I     1     LENGTH OF DATA ARRAY
C       DATA    I*2      O   LDATA   DATA ALL DAYS FOR EACH TYPE
C       LDFILL    I      O   NUMBER OF I*2 WORDS FILLED IN DATA
C       IDELT     I*4     O    1      TIME INTERVAL FOR DATA TYPE
C       NVDPT     I*4     O     1      # OF DATA VALUES PER TIME
C       MSNG      I*2     O     1     VALUE FOR MISSING DATA
C        ISTAT     I      O     1     STATUS 0=OK, 1 IRTYPE TOO SMALL
C                                       2=DATA TOO SMALL LDATA RETURNED
C                                       3=ISTAID NOT FOUNDS NOT GOOD
C                                       4=1 OR MORE DATA TYPES NOT FUND
C                                       5=NO VLAUES ON FILE FOR DAYS
C                                  6= FDAY OR LDAY RESET TO FIT PREIOD
C                                  7=SYSTEM ERROR
C
      INCLUDE 'uiox'
      INCLUDE 'udsi'
      INCLUDE 'udebug'
      INCLUDE 'pdbcommon/pdunts'
      INCLUDE 'pdbcommon/pddtdr'
      INCLUDE 'pdbcommon/pdsifc'
      INCLUDE 'pdbcommon/pdbdta'
C
      DIMENSION ISTAID(1),IRTYPE(1),IDELT(1),NVPDT(1),IDATYP(1)
      INTEGER*2 DATA(1),MSNG(1)
      INTEGER*2 ISIBUF(128),ITMPTY(2)
      INTEGER*2 IDTREC(32)
      INTEGER*2 LVR,LPP,LTA
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/db_pdbrw/RCS/rpd1s.f,v $
     . $',                                                             '
     .$Id: rpd1s.f,v 1.2 2002/02/11 20:52:04 dws Exp $
     . $' /
C    ===================================================================
C
      DATA LPPSR/4hPPSR/,LMDR6/4hMDR6/
      DATA LPP24/4hPP24/
      DATA LTA/2hTA/
      DATA LALL/4hALL /
      DATA LVR/2hVR/
      DATA LPP/2hPP/
C
C
      IF (IPDTR.GT.0) WRITE (IOGDB,*) 'ENTER RPD1S'
C
      ISTAT=0
      JDATA=0
      LSIBUF=128
      CALL UMEMST (0,IRTYPE,LTYPE)
      CALL UMEMST (0,IDELT,LTYPE)
      CALL UMEMST (0,NVPDT,LTYPE)
      LRCPD2=LRCPDD*2
C
C  CHECK IF STATION EXISTS
      IFIND=0
      IF (IDTYPE.EQ.0)
     *   CALL PDFNDR (ISTAID,LSIBUF,IFIND,ISIREC,ISIBUF,IFREE,ISTAT)
      IF (IDTYPE.EQ.1)
     *   CALL PDFNDI (ISTAID,LSIBUF,IFIND,ISIREC,ISIBUF,IFREE,ISTAT)
      IF (ISTAT.NE.0) GO TO 900
      IF (IFIND.NE.0) GO TO 10
      ISTAT=3
      GO TO 999
C
C  CHECK IF ANY TYPES SPECIFIED
10    IF (NTYPES.LE.0) GO TO 910
C
C  CHECK IF ALL OR INDIVIDUAL DATA TYPES TO BE READ
      IALLFG=0
      IF (IDATYP(1).EQ.LALL) IALLFG=1
C
C  CHECK DATES FOR VALID RANGE FOR ALL TYPES REQUESTED AND SEE IF
C  IFDAY OR LDAY NEED TO BE RESET
C  ALSO FILL IRTYPE WITH DATA TYPES FROM ISIBUF OR IDATYP, SET MTYPES
C  TO CORRECT VALUE - IF TOO SMALL SET TO LTYPE
      CALL PDRSDT (IFDAY,LDAY,NTYPES,IDATYP,IALLFG,ISIBUF,
     *    LTYPE,IRTYPE,MTYPES,ISAVE)
      IF (ISAVE.NE.0.AND.ISAVE.NE.6.AND.ISAVE.NE.1) GO TO 300
      IF (MTYPES.LT.1) GO TO 300
C
      NDAYS=LDAY-IFDAY+1
C
C  LOOP ON EACH DATA TYPE
      IT=1
C
C  MAKE SURE THIS IS A DAILY TYPE THAT CAN BE READ BY THIS ROUTINE
20    IF (IRTYPE(IT).EQ.LMDR6.OR.IRTYPE(IT).EQ.LPPSR) GO TO 28
      ITX=IPDCKD(IRTYPE(IT))
      ITXNEW=0
      IF (ITX.EQ.0) GO TO 28
C
C NDTWDS IS NUMBER OF WORDS FOR 1 DAY IN DATA BASE
      NDTWDS=IDDTDR(6,ITX)
C
C  SET DATA TIME INTERVAL AND NVPDT
      IDELT(IT)=24
      NVPDT(IT)=NDTWDS
      MSNG(IT)=MISSNG
      IF (IRTYPE(IT).EQ.LPP24) MSNG(IT)=MISSPP
C
C  RESET IF A LESS THAN 24 HOUR
      IF (IDDTDR(3,ITX).NE.LVR) GO TO 21
         IIXX=IPDCDW(IRTYPE(IT))
         NDTWDS=IDDTDR(6,IIXX)
         NVPDT(IT)=1
         IDELT(IT)=IDDTDR(5,IIXX)
C
C  DATA TYPE IS OK, MAKE SURE IN STATION
C  IFIXDT IS THE AMOUNT TO SKIP FOR EACH DATA WORD
21    IFIXDT=1
C
C  IPOINT IS POINTER TO DATA IN PPDB
      IPOINT=IPDFDT(ISIBUF,IRTYPE(IT))
      IF (IPOINT.NE.0) GO TO 70
C
C  TYPE IS NOT IN RECORD - CHECK IF A WRITE ONLY TYPE OR PPVR OR TAVR
C  ITXNEW WILL BE THE SUBSCRIPT OF THE ACTUAL DATA TYPE IN DIRECTORY
      ITXNEW=IPDCDW(IRTYPE(IT))
      IF (ITXNEW.EQ.0) GO TO 28
      IF (IPDDB.GT.0) WRITE (IOGDB,2003) (IDDTDR(K,ITXNEW),K=1,6)
2003  FORMAT (' IDDTDR(K,ITXNEW)=',I3,2A2,3I5)
C
C  FIND THE READ TYPE IN THE DATA RECORD
      ITXPDB=ITXNEW
       CALL UMEMOV(IDDTDR(2,ITX),JDDTDR,1)
      IPOINT=IPDFDT(ISIBUF,JDDTDR)
CZ    IPOINT=IPDFDT(ISIBUF,IDDTDR(2,ITX))
      IF (IPOINT.NE.0) GO TO 70
C
C STILL NOT THERE
C NOW CHECK IF IT IS A BIGGER DATA TIME INTERVAL
      IF (IDDTDR(3,ITX).NE.LVR) GO TO 28
C
C  LOOK FOR THE SAME FIRST LETTERS IN STATION INFORMATION REC
      CALL UMEMOV (IRTYPE(IT),ITMPTY,1)
      N=ISIBUF(10)
      J=11
      DO 22 I=1,N
         IF (ISIBUF(J).EQ.ITMPTY(1)) GO TO 25
         J=J+3
22       CONTINUE
      GO TO 28
C
C  FOUND TYPE - CHECK IF DATA TIME INTERVAL IS BIGGER
25    IFIXDT=0
C
C  IF DESIRED TYPE IS VR (IDDTDR(6,ITXNEW)=-1) USE DATA TIME INTERVAL
C  OF PPDB
      ITXPDB=IPDCDW(ISIBUF(J))
      IFIXDT=IDDTDR(5,ITXNEW)/IDDTDR(5,ITXPDB)
      IPOINT=ISIBUF(J+2)
C
C  IF TA DATA, FIX IPOINT TO START IN CORRECT SLOT
      IF (IDDTDR(2,ITXNEW).EQ.LTA.AND.IFIXDT.GT.1)
     *   IPOINT=IPOINT+IFIXDT-1
      IF (IDDTDR(6,ITXNEW).EQ.-1) IFIXDT=1
      IF (IFIXDT.NE.0) GO TO 80
C
28    ISAVE=4
C
C  MUST MOVE UP REST OF TYPES
      MTYPES=MTYPES-1
      IF (IT.GT.MTYPES) GO TO 300
      DO 35 K=IT,MTYPES
         IRTYPE(K)=IRTYPE(K+1)
35       CONTINUE
         GO TO 20
C
70    IF (IPDDB.GT.0) WRITE (IOGDB,2002) (IDDTDR(K,ITX),K=1,24)
2002  FORMAT (' IDDTDR(K,ITX)=',I3,2A2,21I5)
C
C  ADJUST POINTERS IN CASE WHERE THIS IS A WRITE ONLY TYPE AND NOT
C  READING ALL PPDB WORDS
C  THIS WOULD BE FOR TN24,TX24,AND ALL PARTS OF EA24
      IF (ITXNEW.EQ.0) GO TO 80
C
C  MOVE IPOINT TO CORRECT WORD IN RECORD
      IPOINT=IPOINT+IDDTDR(5,ITXNEW)
C
C  RESET NUMBER OF DATA WORDS IN PPDB
      NDTWDS=IDDTDR(6,ITXNEW)
      NVPDT(IT)=NDTWDS
C
80    CALL UMEMOV (IDDTDR(8,ITX),IEDATE,1)
      CALL UMEMOV (IDDTDR(11,ITX),LDATE,1)
C
C  SET UP WORDS AND RECORDS FOR READ
      CALL PDVALS (ITX,NREC1D,NRECAL,LSTREC)
      IFILE=IDDTDR(4,ITX)
C
C  READY TO READ THE DATA
100   CONTINUE
      IF (IPDDB.GT.0) WRITE (IOGDB,2002) (IDDTDR(K,ITX),K=1,24)
C
C  CHECK IF WE ARE READING THE FIRST DAY
      NUMDAY=IFDAY
C
C  GET RECORD NUMBER
      CALL PDCREC (IFDAY,IEDATE,ITX,IREC)
C
C  READ A DAY OF DATA - GET WHICH LOGICAL RECORD HAS THIS STATION
110   IRCOFS=IUNRCD(IPOINT,LRCPD2)
      IDXSAV=IPOINT-(IRCOFS-1)*LRCPD2
C
120   IRCRED=IREC+IRCOFS-1
      IDX=IDXSAV
      IF (IPDDB.GT.0)
     *   WRITE (IOGDB,2004) IREC,IRCOFS,IPOINT,IRCRED,IDX,JDATA
2004  FORMAT (' IREC=',I6,3X,'IRCOFS=',I6,3X,'IPOINT=',I6,3X,
     *   'IRCRED=',I6,3X,'IDX=',I6,3X,'JDATA=',I6)
      CALL UREADT (KPDDDF(IFILE),IRCRED,IDTREC,ISTAT)
      IF (ISTAT.NE.0) GO TO 900
C
C  MOVE THE DATA
      I=1
C
C  IF PPVR AND NOT SAVE DATA TIME INTERVAL MUST SUM
130   IF (IDDTDR(2,ITX).NE.LPP.OR.IFIXDT.EQ.1) GO TO 140
C
      JDATA=JDATA+1
      IF (JDATA.GT.LDATA) GO TO 920
      DATA(JDATA)=IDTREC(IDX)
      DO 135 J=2,IFIXDT
         IF (IDX.LT.LRCPD2) GO TO 133
C     MUST READ NEXT RECORD
            IRCRED=IRCRED+1
            CALL UREADT (KPDDDF(IFILE),IRCRED,IDTREC,ISTAT)
            IF (ISTAT.NE.0) GO TO 900
            IDX=0
133         IDX=IDX+1
            IF (IDTREC(IDX).EQ.MISSNG) GO TO 135
               JDATA=JDATA+1
               IF (JDATA.GT.LDATA) GO TO 920
               DATA(JDATA)=DATA(JDATA)+IDTREC(IDX)
135      CONTINUE
         IDX=IDX+1
         GO TO 145
C
140   JDATA=JDATA+1
      IF (JDATA.GT.LDATA) GO TO 920
      DATA(JDATA)=IDTREC(IDX)
      IDX=IDX+IFIXDT
C
145   IF (I.EQ.NDTWDS) GO TO 150
      I=I+1
C
C  CHECK IDX FOR NEXT RECORD
      IF (IDX.LE.LRCPD2) GO TO 130
      IRCRED=IRCRED+1
      CALL UREADT (KPDDDF(IFILE),IRCRED,IDTREC,ISTAT)
      IF (ISTAT.NE.0) GO TO 900
      IDX=IDX-LRCPD2
      GO TO 130
C
C  CHECK IF ALL DAYS PROCESSED
150   IF (NUMDAY.EQ.LDAY) GO TO 200
         NUMDAY=NUMDAY+1
         IREC=IREC+NREC1D
         IF (IREC.GT.LSTREC) IREC=IDDTDR(15,ITX)
         IDX=IDXSAV
         GO TO 120
C
C  CHECK IF ALL TYPES PROCESSED
200   IF (IT.EQ.MTYPES) GO TO 300
         IT=IT+1
         GO TO 20
C
C  ALL DONE
300   LDFILL=JDATA
      IF (ISTAT.EQ.0) ISTAT=ISAVE
      GO TO 999
C
C  READ/WRITE ERROR
900   ISTAT=7
      GO TO 999
C
910   ISTAT=4
      GO TO 999
C
920   ISTAT=2
      LDFILL=JDATA
      MTYPES=IT
C
999   IF (IPDTR.GT.0) WRITE (IOGDB,2001) (ISIBUF(I),I=2,5),ISTAT
2001  FORMAT (' EXIT RPD1S : STATION=',4A2,' ISTAT=',I4)
C
      RETURN
C
      END
