C MODULE FPRRC
C-----------------------------------------------------------------------
C DESC - PRINTS CONTENTS OF COMMON /FRATNG/ THE RATING CURVE CB
C
C SUBROUTINE FPRRC PRINTS IN TABULAR FORM THE CONTENTS OF THE
C RATING CURVE COMMON BLOCK /FRATNG/.
C IT WILL CONVERT TO ENGLISH UNITS WHEN REQUESTED.
C
C ARGUMENT LIST
C   OPTN - UNITS TO PRINT OUTPUT IN
C            ='METR' FOR METRIC
C            ='ENGL' FOR ENGLISH
C            ='    ' (BLANK) TO DEFAULT TO UNITS ORIGINALLY USED
C            ='HARC' FOR HARRISBURG RC PRINTOUT
C.......................................................................
C SUBROUTINE ORIGINALLY BY JONATHAN WETMORE - HRL - 801031
C MODIFICATIONS:
C EJV 1/83 - TO ACCOMODATE NEW FORMAT OF /FRATNG/
C EJV 2/87 - TO HANDLE USGS OFFSET VALUES
C.......................................................................
      SUBROUTINE FPRRC(OPTN)
C
      LOGICAL ENGUNT
C
      CHARACTER*8 UNELEV,UNAREA,UNVOL,UNLNTH,UNAREK,
     * ENGELV,ENGARE,ENGVOL,ENGLEN,ENGARK,
     * CMTELV,CMTARE,CMTVOL,CMTLEN,CMTARK,
     * NONE,CODES1(7),CODES2(4),CODES3(8),CODES4(9),
     * EXLOW,EXUPER,EXLOG,EXLIN,EXHDR,EXLOOP,
     * OPTFMT(4),OPFT31,OPFT32,OPFT34,OPFT35,OPFT41,OPCODE(12)
C
      DIMENSION SUBNAM(2),OLDSUB(2),NOYES(2),
     * FCRR(4),FCRV(2),FCEX(3),FCFF(3)
       DIMENSION DELT(10),IQ(10),NUNT(4)
C
      CHARACTER*4  FMT(5),FMT1(2),FMT2(3),FMT3(2),FMT4(2)
C
      INCLUDE 'common/ionum'
      INCLUDE 'common/fprog'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/where'
      INCLUDE 'common/fratng'
      INCLUDE 'common/fxsctn'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_top/RCS/fprrc.f,v $
     . $',                                                             '
     .$Id: fprrc.f,v 1.7 2004/06/17 12:49:18 jgofus Exp $
     . $' /
C    ===================================================================
C
C
C
C
      DATA DELT/.00,.01,.02,.03,.04,.05,.06,.07,.08,.09/
      DATA HARC/4HHARC/
C
      DATA AMETR,BLANK/4HMETR,4H    /,
     * RTCV,SUBNAM/4HRTCV,4HFPRR,4HC   /,
     * CMTELV,CMTARE,CMTVOL,CMTLEN/'(M. MSL)','(SQ. M.)',' (CMS)  ',
     * '(METERS)'/,CMTARK/'(SQ. KM)'/,AP,AT/4HP   ,4HT   /,
     * ENGELV,ENGARE,ENGVOL,ENGLEN/'(FT MSL)','(SQ. FT)',' (CFS)  ',
     * ' (FEET) '/,ENGARK/'(SQ. MI)'/,
     * NOYES/4HNO  ,4HYES /,NONE/'NOT USED'/,
     $ NUNT/3H(FT,4HCFS),3H (M,4HCMS)/
C
      DATA FCRR/4HDAOP,4HDAMA,4HFLUD,4HSPRT/,FCRV/4HRSQ ,4HINF /,
     * FCEX/4HSOOP,4HSOMA,4HWSUP/,FCFF/4HHWFF,4HFFON,4HHWON/,
     * CODES1/'OPTIONAL',' DAILY  ','MANDATOR','Y DAILY ','FLOOD ON',
     * 'LY      ','SUPPORT '/,
     * CODES2/'ELEVATIO','N+INFLOW','INFLOW O','NLY     '/,
     * CODES3/'SPRING O','UTLOOK-O','PTIONAL ','SPRING O','UTLOOK-M',
     * 'ANDATORY','WATER SU','PPLY    '/,
     * CODES4/'HEADWATE','R+FLASH ','FLOOD   ','FLASH FL','OOD INDE',
     *        'X ONLY  ','HEADWATE','R TABLE ','ONLY    '/
C
      DATA  FMT(5) / '3A8)' /
      DATA  FMT1 / '( 1X','(1H+' /
      DATA  FMT2 / ',27X',',54X',',85X' /
      DATA  FMT3 / ',A4,',',A8,' /
      DATA  FMT4 / ' 1X,','1H-,' /
      DATA  EXLOG,EXLIN  / 'LOG-LOG ','LINEAR  ' /
      DATA  EXHDR,EXLOOP / 'HYDRAULC','LOOPRATI' /
C
      DATA OPTFMT(1),OPTFMT(2),OPFT31,OPFT41,OPFT32,OPFT34,OPFT35
     * /'(2X,I10,','2A8,2X, ','20A4/(30','X,20A4))',
     *  '  2A4)  ',' F10.2) ',' I10)   '/
      DATA OPCODE/'        ',
     * ' COMMENT',' USGS-ID','  NWS-ID','    BANK','FULL-STG',
     * '       R','IVER-LOC',' MOB-STG','  HSA-ID','E-19    ',
     * 'E-19A   '/
C
C SET /WHERE/ INFO
C
      EXUPER=EXLOG
      IF(EMPTY(4) .GE. 1.0) EXUPER=EXLIN
C
C SET COMMON /WHERE/
        OLDSUB(1) = OPNAME(1)
        OLDSUB(2) = OPNAME(2)
        OPNAME(1) = SUBNAM(1)
        OPNAME(2) = SUBNAM(2)
        IOLDOP=IOPNUM
        IOPNUM=0
C
C  SET ARRAY INDEX
      LH1=LOCH
      LHN=LH1+NRCPTS-1
      LQ1=LOCQ
      LQN=LQ1+NRCPTS-1
      LXE1=LXELEV
      LXEN=LXE1+NCROSS-1
      LXT1=LXTOPW
      LXTN=LXT1+NCROSS-1
      RCMXH=XRC(LHN)
      RCMXEL=RCMXH+GZERO
C
C SET DEBUG
C
      IBUG=0
      IF (IFBUG(RTCV).EQ.1) IBUG=1
      IF (ITRACE.GE.1) WRITE(IODBUG,810)
C
C..............DEBUG TIME...............................................
C
      IF (IBUG.EQ.0) GO TO 20
C
      WRITE(IODBUG,1100) RTCVID,RIVERN,RIVSTA,RLAT,RLONG,
     *  FPTYPE,AREAT,AREAL,FLDSTG,FLOODQ,PVISFS,SCFSTG,
     *  WRNSTG,GZERO,NRCPTS,LOCQ,LOCH,STGMIN,NCROSS,LXTOPW,
     *  LXELEV,ABELOW,FLOODN,SLOPE,FRLOOP,SHIFT,OPTION,
     *  LASDAY,IPOPT,RFSTG,RFQ,IRFDAY,RFCOMT
      WRITE(IPR,1110) EMPTY
      WRITE(IPR,1120) XRC
C......................................................................
C
C SET CONVERSION FACTORS FOR UNITS
C
20    ENGUNT=.TRUE.
      IF (OPTN.EQ.AMETR) ENGUNT=.FALSE.
      IF (OPTN.EQ.BLANK .AND. OPTION.EQ.AMETR) ENGUNT=.FALSE.
      IF (OPTN.EQ.HARC) ENGUNT=.TRUE.
C
      FACLEN=1.0
      FACVOL=1.0
      FACMKM=1.0
      COEFMN=1.0
      IF(ENGUNT) THEN
         COEFMN=1.486
         CALL FRCUN(FACLEN,FACVOL,FACMKM,IER)
      ENDIF
30    FACARE=FACLEN**2
      FACSKM=FACMKM**2
C
C SET UNITS IN FORMAT STMTS TO ENGLISH IF NECESSARY
C
      UNELEV=CMTELV
      UNAREA=CMTARE
      UNVOL=CMTVOL
      UNLNTH=CMTLEN
      UNAREK=CMTARK
      IF (.NOT.ENGUNT) GO TO 40
      UNELEV=ENGELV
      UNAREA=ENGARE
      UNVOL = ENGVOL
      UNLNTH=ENGLEN
      UNAREK=ENGARK
      SHIFT=SHIFT*FACLEN
      EMPTY(3)=EMPTY(3)*FACLEN
      HSMIN=EMPTY(3)
C
C PRINT OUT RATING CURVE DATA
C
40    CONTINUE
      IF (OPTN.NE.HARC)
     $ WRITE(IPR,820) RTCVID
C
C WRITE STATION LOCATION INFO AND CHARACTERISTICS
C
      AREAT=AREAT*FACSKM
      AREAL=AREAL*FACSKM
      IF (OPTN.NE.HARC)
     $ WRITE(IPR,830) UNAREK,UNAREK,RIVERN,RIVSTA,RLAT,RLONG,AREAT,
     * AREAL,OPTION
C
C WRITE FLOOD AND WARNING STAGE INFO
C
      IF (IFMSNG(FLDSTG).EQ.0) FLDSTG=FLDSTG*FACLEN
      IF (IFMSNG(FLOODQ).EQ.0) FLOODQ=FLOODQ*FACVOL
      IF (IFMSNG(STGMIN).EQ.0) STGMIN=STGMIN*FACLEN
      IF (IFMSNG(GZERO).EQ.0) GZERO=GZERO*FACLEN
      IF (IFMSNG(SCFSTG).EQ.0) SCFSTG=SCFSTG*FACLEN
      IF (IFMSNG(WRNSTG).EQ.0) WRNSTG=WRNSTG*FACLEN
C
      IF (OPTN.NE.HARC)
     $ WRITE(IPR,880) UNLNTH,UNVOL,UNLNTH,UNELEV,UNLNTH,UNLNTH,
     * FLDSTG,FLOODQ,STGMIN,GZERO,SCFSTG,WRNSTG
      IF (OPTN.NE.HARC .AND.
     $ PVISFS.EQ.AP) WRITE(IPR,890)
      IF (OPTN.NE.HARC .AND.
     $ PVISFS.EQ.AT) WRITE(IPR,900)
C
C WRITE RECORD FLOOD INFORMATION
C
      IF (IFMSNG(RFSTG).EQ.0) RFSTG=RFSTG*FACLEN
      IF (IFMSNG(RFQ).EQ.0) RFQ=RFQ*FACVOL
      IF (IRFDAY.EQ.-999) GO TO 50
      MO=0
      IDAY=0
      IYR=0
      MO=IRFDAY/1000000
      IYR=MOD(IRFDAY,10000)
      IDAY=IRFDAY/10000
      IDAY=MOD(IDAY,100)
      IF (OPTN.NE.HARC)
     $ WRITE(IPR,850) UNLNTH,UNVOL
       IF (OPTN.NE.HARC)
     $ WRITE(IPR,860) MO,IDAY,IYR,RFSTG,RFQ,RFCOMT
      GO TO 70
C
C MISSING DATE-CHECK FOR RFQ AND RFSTG BOTH MISSING
50    IF (IFMSNG(RFSTG).EQ.0 .OR. IFMSNG(RFQ).EQ.0) GO TO 60
      IF (OPTN.NE.HARC)
     $ WRITE(IPR,840)
      GO TO 70
60    CONTINUE
      IF (OPTN.NE.HARC)
     $ WRITE(IPR,850) UNLNTH,UNVOL
      IF (OPTN.NE.HARC)
     $ WRITE(IPR,870) RFSTG,RFQ,RFCOMT
C
70    CONTINUE
      IF (OPTN.NE.HARC) GO TO 350
C
CCC *** HAR PRINOUT
C
C  SET VARIABLES TO ENGLISH
      IF (XRC(LQ1).LE.0.00) XRC(LQ1)=0.0001*FACLEN
      DO 80 I=1,NRCPTS
        XRC(LH1+I-1)=XRC(LH1+I-1)*FACLEN
        XRC(LQ1+I-1)=XRC(LQ1+I-1)*FACVOL
80    CONTINUE
      LXOFF=EMPTY(2)
      IF (LXOFF.EQ.0) GO TO 100
      NGSOFF=XRC(LXOFF)
      N=NGSOFF*2
      DO 90 I=1,N
        XRC(LXOFF+I)=XRC(LXOFF+I)*FACLEN
90    CONTINUE
100   CONTINUE
C INITIALIZE DELT
      DELT(1)=0.00
      DO 110 I=2,10
        DELT(I)=DELT(I-1)+0.010
110   CONTINUE
C SET THE BASEH TO NEAREST 0.1 OF 1ST H VALUE
C SET START POSTION (I1) TO HOW MANY PLACES ABOVE .0 OR .5 IT IS
C EG. IF 1ST H VAL =1.72 THEN BASEH=1.70 AND I1=3
C                  =1.50           =1.50       =1
C                  =1.11           =1.10       =1
      BASEH=XRC(LH1)
      BASEH=AINT(BASEH*10.)/10.
      I1=BASEH*10.+0.001
      I1=MOD(I1,10)
      IF (I1.GE.5) I1=I1-5
      IF (BASEH.LT.0. .AND. XRC(LQ1).LE.1.0) BASEH=BASEH+0.1
      IF (BASEH.GE.0.) GO TO 120
      K1=BASEH*10.-0.001
      K1=IABS(MOD(K1,10))
      I1=5-K1
      IF (K1.GT.5) I1=5-(K1-5)
      IF (K1.EQ.0) I1=0
120   I1=I1+1
C SET NUMBER OF PAGES(NPGS)
C 1ST PAGE HAS 8 BLOCKS OF 5 LINES AMOUNTING TO H DELT OF 4.0 FT.
C AFTERWARDS HAVE 9 BLOCKS OF 5 LINES AMOUNTING TO HDELT OF 4.5 FT
C     ON EVERY PAGE.
C ALSO ADD RC EXTENSION TO RFSTG AMOUNTING TO HDELT OF 45 FT PER PAGE.
C SET NPGS INITIALLY BY TAKING OUT 4.0 AND DIVIDING BY 4.5
C   BUT THEN MUST ADD 1 FOR 1ST PAGE AND 1 XTRA UNLESS DIFFERENCE
C   IS EXACT FACTOR OF 4.5
      HMIN=XRC(LH1)
      HMAX=XRC(LHN)
      DIFF=HMAX-HMIN-4.0
      IF (DIFF.LT.0.0) DIFF=0.0
      NPGS=1
      NPGS=NPGS+DIFF/4.5
      XTRA=AMOD(DIFF,4.5)
      IXTRA=0
      IF (XTRA.GT.0.) IXTRA=1
      IF (DIFF.GT.0.0 .AND. DIFF.LT.4.5) IXTRA=1
      NPGS=NPGS+IXTRA
C  EXTENSION
      IF (RFSTG.LE.0.) GO TO 130
      BASEXT=AINT(HMAX)
      EDIFF=RFSTG-BASEXT
      NEPGS=0
      IF (EDIFF.GT.0.) NEPGS=1+EDIFF/45.
      NPGS=NPGS+NEPGS
130   CONTINUE
C INITIALIZE SOME VARIABLES AS INTEGERS
      IFH=FLDSTG + 0.5
      IFH2=SCFSTG + 0.5
      LAT=AINT(RLAT)*100.+AMOD(RLAT,1.0)*60. + 0.5
      LON=AINT(RLONG)*100.+AMOD(RLONG,1.0)*60. + 0.5
      ITAREA=AREAT + 0.5
      ILAREA=AREAL + 0.5
      IRFQ=RFQ + 0.5
C  SET FLAG TO 0 FOR RC EXTENSION BETWEEN HMAX AND RFSTG
      IEXT=0
C  SET STAGE INCREMENT FOR EACH LINE TO 0.10
      HINC=0.10
C SET NUMBER OF BLOCKS TO 8 FOR 1ST PAGE, AFTER WILL BE 9
      NBLOKS=8
C LOOP THRU EACH PAGE
      DO 210 IPG=1,NPGS
        WRITE(IPR,220)
        IF (IEXT.EQ.0) WRITE(IPR,240) IPG,NPGS
        IF (IEXT.EQ.1) WRITE(IPR,250) IPG,NPGS
        WRITE(IPR,260) RTCVID
        IF (IPG.EQ.1) WRITE(IPR,270) RIVERN,RIVSTA,LAT,LON
        IF (IPG.NE.1) WRITE(IPR,280) RIVERN,RIVSTA
        WRITE(IPR,230)
        IF (IPG.EQ.1) WRITE(IPR,290) IFH,IFH2,ITAREA,ILAREA,GZERO
        IF (IPG.EQ.1) WRITE(IPR,300) RFSTG,IRFQ,MO,IDAY,IYR,RFCOMT
        WRITE(IPR,230)
        IF (BASEH.GE.0.) WRITE(IPR,310)
        IF (BASEH.LT.0.) WRITE(IPR,320)
        WRITE(IPR,330) DELT
C LOOP THRU EACH BLOCK OF 5 LINES
        DO 180 IBLK=1,NBLOKS
          WRITE(IPR,230)
C LOOP THRU THE 5 LINES IN THE BLOCK, EACH HINC APART
          DO 170 ILINE=I1,5
C LOOP THRU EACH DELT OF 0.01 (10 OF THEM) AND CONVERT TO STAGE
            DO 140 IDELT=1,10
              HVAL=BASEH+DELT(IDELT)
C jgg  changed for bug 24-37 5/04	      
C jgg              IF (IDELT.NE.1 .AND. BASEH.LT.0.) HVAL=BASEH-DELT(IDELT)
              IF (IDELT.NE.1.AND.BASEH.LT.-0.001) HVAL=BASEH-DELT(IDELT)
C jgg end	      
              CALL FHQS1(HVAL,QVAL,1,0,IDUM,JDUM,KDUM,LDUM,MDUM,NDUM,
     $           DUMMY)
C jgg implemented a very simple rounding tech. for bug 24-37 
              QVAL=QVAL+0.49 
C jgg end	          
              IQ(IDELT)=QVAL
140         CONTINUE
            WRITE(IPR,340) BASEH,IQ
            IF (BASEH.GT.-0.09 .OR. BASEH.LT.-0.11) GO TO 160
            DO 150 IDELT=1,10
              HVAL=-DELT(IDELT)
              CALL FHQS1(HVAL,QVAL,1,0,IDUM,JDUM,KDUM,LDUM,MDUM,NDUM,
     $           DUMMY)
              IQ(IDELT)=QVAL
150         CONTINUE
            BBBHH=-0.000001
C jgg changed for bug 24-37  5/04	    
C jgg            WRITE(IPR,340) BBBHH,IQ
            WRITE(IPR,341) BBBHH,IQ
C jgg end	    
160         BASEH=BASEH + HINC
            IF (BASEH.GT.HMAX) GO TO 190
170       CONTINUE
          I1=1
180     CONTINUE
        NBLOKS=9
        GO TO 210
190     CONTINUE
        IEXT=1
        HMAX=99999.
        IF (RFSTG.GT.0.) HMAX=RFSTG
        BASEH=BASEXT
        NBLOKS=9
        DO 200 I=1,10
200     DELT(I)=(I-1)*0.10
        HINC=1.0
210   CONTINUE
      WRITE(IPR,220)
      GO TO 800
C
220   FORMAT(1H1,1X)
230   FORMAT(1X)
240   FORMAT(/18X,'STAGE-DISCHARGE RATING TABLE',15X,'PAGE',
     $ I2,' OF ',I2)
250   FORMAT(/18X,'STAGE-DISCHARGE RATING TABLE EXTENSION',5X,'PAGE',
     $ I2,' OF ',I2)
260   FORMAT(1X,2A4)
270   FORMAT(1X,5A4,1X,5A4,10X,'LAT,LON=',I5,I6)
280   FORMAT(1X,5A4,1X,5A4)
C jgg changed following to fix HSD r24-37, 5/04
C 290   FORMAT(3X,'FL.H=',I4,' 2NDFL.H=',I4,
C     $ '  TOT SQMI=',I5,' LOCAL SQMI=',I5,
C     $ '  GAGEZERO=',F7.2)
290   FORMAT(3X,'FL.H=',I4,' 2NDFL.H=',I4,
     $ '  TOT SQMI=',I6,' LOCAL SQMI=',I5,
     $ '  GAGEZERO=',F7.2)
C jgg end
300   FORMAT(3X,'RECORD MAX=',F7.2,' FT',I8,' CFS',
     $ I3.2,'/',I2.2,'/',I4.4,1X,5A4)
310   FORMAT(1X,'STAGE',24X,'DISCHARGE (CFS)' )
320   FORMAT(1X,'STAGE',5X,
     $ 'DISCHARGE (CFS) **CAUTION** .01 S ARE ADDED TO (-) STAGES')
C jgg changed following to fix HSD r24-37, 5/04
C 330   FORMAT(1X,'FEET',F7.1,'0',9F7.2)
330   FORMAT(1X,'FEET',1X,F7.1,'0',9F7.2)
C 340   FORMAT(1X,F5.1,10I7)
340   FORMAT(1X,F6.1,10I7)
341   FORMAT(3X,'-',F3.1,10I7)
C the preceding line accomodates a usgs convention
C jgg end
C
CCC *** END HAR PRINTOUT
C TO GEORGE: CAN U FIGURE THIS OUT --> psu is # 1
C
C WRITE LOOP INFO AND TYPE OF EXTENSION; ALSO, OTHER INFO ONLY IF
C NCROSS NE 0.
C STEPS INVOLVED ARE:
C   A. DETERMINE IF LOOP IS ON
C   B. DETERMINE TYPE OF EXTENSION USED
C   C. WRITE OUT INFO WITH OR WITHOUT X.S. INFO
C   D. WRITE OUT FRLOOP AND SHIFT IF USED
C
C STEP A
350   CONTINUE
      IF (NRCPTS.EQ.0) GO TO 360
      EXLOW=EXLOG
      IF (EMPTY(4) .GE. 1.0) EXLOW=EXLIN
C STEP B
      LOOP=1
      IF(NCROSS.GE.1) THEN
        EXUPER=EXHDR
        IF (IFMSNG(FRLOOP).EQ.0) THEN
          LOOP=2
          EXUPER=EXLOOP
        END IF
      END IF
C STEP C
      WRITE(IPR,910) NOYES(LOOP),EXLOW,EXUPER
      IF (EMPTY(4).LT.0.9) WRITE(IPR,940) SHIFT,HSMIN
      IF (NCROSS.GE.1) THEN
        ABELOW=ABELOW*FACARE
        WRITE(IPR,920) ABELOW,SLOPE,FLOODN
      END IF
C STEP D
      IF (IFMSNG(FRLOOP).NE.0) GO TO 360
      LOCFR=EMPTY(1)
      XRC(LOCFR+1)=XRC(LOCFR+1)*FACVOL
      XRC(LOCFR+2)=XRC(LOCFR+2)*FACVOL
      XRC(LOCFR+3)=XRC(LOCFR+3)*FACLEN
      XRC(LOCFR+4)=XRC(LOCFR+4)*FACLEN
      XRC(LOCFR+5)=XRC(LOCFR+5)*FACVOL
      XRC(LOCFR+6)=XRC(LOCFR+6)*FACLEN
      WRITE(IPR,930) FRLOOP,(XRC(LOCFR+I-1),I=1,7)
C
C WRITE LASDAY IF CALIBRATION RUN. CHECK IF MISSING.
C
360   IF (MAINUM.LT.3) GO TO 380
      WRITE(IPR,950)
      IF (IFMSNG(LASDAY).NE.0) GO TO 370
C
      CALL MDYH1(LASDAY,1,MO,IDAY,IYR,IDUM,24,0,IDUM)
      WRITE(IPR,960) MO,IDAY,IYR
      GO TO 380
C
370   WRITE(IPR,970) NONE
C
C GO THRU EACH FORECAST POINT TYPE(FPTYPE(4))
C AND WRITE OUT THE PRODUCT GENERATED OR CODE USING VARAIBLE FORMAT.
C
C THE STEPS USED TO PERFORM THIS ARE THE SAME FOR EACH FPTYPE AND ARE:
C   A. SEE IF 4 CHARACTER CODE IS BLANK. IF SO WRITE OUT 'NOT USED'.
C   B. IF CODE NOT BLANK THEN LOOP THRU EACH SUGGESTED CODE TO SEE
C      WHICH ONE IT IS.
C   C. IF NO MATCH FOUND, THEN WRITE 4 CARACTER CODE ONLY.
C   D. OTHERWISE WRITE OUT THE FULL NAME WITH THE 4 CHAR SUGGESTED CODE.
C
C FIRST WRITE OUT THE HEADERS
C
380   WRITE(IPR,980)
C
C INITIALIZE VARIABLE FMT
C
      FMT(1)=FMT1(1)
      FMT(2)='    '
      FMT(3)=FMT3(1)
      FMT(4)=FMT4(1)
C
C NOW DO FPTYPE(1) - REGULAR RIVER FORECAST
C
C STEP A
      IF=1
      IF (FPTYPE(IF).NE.BLANK) GO TO 390
      FMT(3)=FMT3(2)
      WRITE(IPR,FMT) NONE
      GO TO 420
C STEP B
390   J=1
      DO 400 I=1,4
      IF (FPTYPE(IF).EQ.FCRR(I)) GO TO 410
      J=J+2
400   CONTINUE
C STEP C
      WRITE(IPR,FMT) FPTYPE(IF)
      GO TO 420
C STEP D
410   K=J+1
      IF (K.GT.7) K=7
      FMT(4)=FMT4(2)
      WRITE(IPR,FMT) FPTYPE(IF),(CODES1(I),I=J,K)
C
C CHANGE FMT(1) TO 1H+
C
420   FMT(1)=FMT1(2)
C
C NOW DO FPTYPE(2) - RESERVOIR
C
C STEP A
      IF=IF+1
      FMT(2)=FMT2(IF-1)
      FMT(3)=FMT3(1)
      FMT(4)=FMT4(1)
      IF (FPTYPE(IF).NE.BLANK) GO TO 430
      FMT(3)=FMT3(2)
      WRITE(IPR,FMT) NONE
      GO TO 460
C STEP B
430   J=1
      DO 440 I=1,2
      IF (FPTYPE(IF).EQ.FCRV(I)) GO TO 450
      J=J+2
440   CONTINUE
C STEP C
      WRITE(IPR,FMT) FPTYPE(IF)
      GO TO 460
C STEP D
450   K=J+1
      FMT(4)=FMT4(2)
      WRITE(IPR,FMT) FPTYPE(IF),(CODES2(I),I=J,K)
C
C NOW DO FPTYPE(3) - EXTENDED FORECAST
C
C STEP A
460   IF=IF+1
      FMT(2)=FMT2(IF-1)
      FMT(3)=FMT3(1)
      FMT(4)=FMT4(1)
      IF (FPTYPE(IF).NE.BLANK) GO TO 470
      FMT(3)=FMT3(2)
      WRITE(IPR,FMT) NONE
      GO TO 500
C STEP B
470   J=1
      DO 480 I=1,3
      IF (FPTYPE(IF).EQ.FCEX(I)) GO TO 490
      J=J+3
480   CONTINUE
C STEP C
      WRITE(IPR,FMT) FPTYPE(IF)
      GO TO 500
C STEP D
490   K=J+2
      IF (K.GT.8) K=8
      FMT(4)=FMT4(2)
      WRITE(IPR,FMT) FPTYPE(IF),(CODES3(I),I=J,K)
C
C NOW DO FPTYPE(4) - FLASH FLOOD
C
C STEP A
500   IF=IF+1
      FMT(2)=FMT2(IF-1)
      FMT(3)=FMT3(1)
      FMT(4)=FMT4(1)
      IF (FPTYPE(IF).NE.BLANK) GO TO 510
      FMT(3)=FMT3(2)
      WRITE(IPR,FMT) NONE
      GO TO 540
C STEP B
510   J=1
      DO 520 I=1,3
      IF (FPTYPE(IF).EQ.FCFF(I)) GO TO 530
      J=J+3
520   CONTINUE
C STEP C
      WRITE(IPR,FMT) FPTYPE(IF)
      GO TO 540
C STEP D
530   K=J+2
      FMT(4)=FMT4(2)
      WRITE(IPR,FMT) FPTYPE(IF),(CODES4(I),I=J,K)
C
C PRINT OUT RATING CURVE POINTS
C
540   IF (NRCPTS.NE.0) GO TO 550
      WRITE(IPR,990)
      GO TO 660
C
550   WRITE(IPR,1000) NRCPTS,EXUPER,UNLNTH,UNVOL
      J=LH1
      K=LQ1
      DO 560 I=1,NRCPTS
      XRC(J)=XRC(J)*FACLEN
      XRC(K)=XRC(K)*FACVOL
      WRITE(IPR,1010) I,XRC(J),XRC(K)
      J=J+1
      K=K+1
560   CONTINUE
C
C USGS OFFSET POINTS
C
      LXOFF=EMPTY(2)
      NGSOFF=XRC(LXOFF)
      IF (NGSOFF.EQ.0) WRITE(IPR,570)
      IF (NGSOFF.EQ.0) GO TO 600
570   FORMAT(10X,'NO USGS OFFSET POINTS WERE USED.')
      WRITE(IPR,580)
580   FORMAT(///10X,'USGS OFFSET PAIRS USED TO SHIFT STAGES FOR LOG-LOG'
     $, ' INTERPOLATION'
     $ /15X,'(THE Y-VALUE IS THE LOWEST STAGE TO WHICH THE OFFSET',
     $ ' IS APPLIED)'
     $ //15X,'    Y-VALUE         OFFSET'
     $  /15X,'    -------         ------')
      DO 590 I=1,NGSOFF
        YVAL=XRC(LXOFF+I)*FACLEN
        OFFSET=XRC(LXOFF+I+NGSOFF)*FACLEN
        WRITE(IPR,610) I,YVAL,OFFSET
590   CONTINUE
600   CONTINUE
610   FORMAT(10X,I3,1H.,1X,F10.2,6X,F10.2)
C
C PRINT OUT CROSS SECTION POINTS
C
      IF (NCROSS.NE.0) GO TO 620
      WRITE(IPR,1020)
      GO TO 660
C
620   WRITE(IPR,1030) NCROSS,UNLNTH,UNLNTH
C
      J=LXE1
      K=LXT1
      DO 630 I=1,NCROSS
      XRC(J)=XRC(J)*FACLEN
      XRC(K)=XRC(K)*FACLEN
      WRITE(IPR,1060) I,XRC(J),XRC(K)
      J=J+1
      K=K+1
630   CONTINUE
C
C PRINT OUT OFF-CHANNEL CROOSS SECTION POINTS
C
      IF(IFMSNG(FRLOOP).NE.0) GO TO 660
      NOCS=XRC(LOCFR+7)
      IF (NOCS.NE.0) GO TO 640
      WRITE(IPR,1040)
      GO TO 660
C
640   WRITE(IPR,1050) NOCS,UNLNTH,UNLNTH
C
      J=LOCFR+8
      K=J+NOCS
      DO 650 I=1,NOCS
      XRC(J)=XRC(J)*FACLEN
      XRC(K)=XRC(K)*FACLEN
      WRITE(IPR,1060) I,XRC(J),XRC(K)
      J=J+1
      K=K+1
650   CONTINUE
C
C GO THRU THE OPTIONAL INFORMATION.
C STEPS INVOLVED ARE:
C   A. SEE IF ANY OPTIONAL INFO EXISTS (1ST LOCATION NE -1)
C   B. RESET NEXT LOCATION, SEE WHAT CODE NUMBER IT IS AND GO TO
C      PROPER PLACE
C   D. FOR EACH CODE SET VARIABLE FORMAT (OPTFMT 3 AND 4) AND
C      NOP WHICH IS THE OPCODE LOCATION TO WRITE
C   D. WRITE OUT INFO, GO BACK TO STEP B...STOP WHEN NEXT LOC=-1
C
660   LOCXRC=IPOPT
C STEP A
      IF (XRC(IPOPT).GT.-1.) GO TO 670
      WRITE(IPR,1070)
      GO TO 800
C
670   WRITE(IPR,1080)
C STEP B
680   I=XRC(LOCXRC)
      IF (I.EQ.-1) GO TO 800
      J=LOCXRC+2
      LOCXRC=XRC(LOCXRC+1)
      K=LOCXRC-1
      GO TO (690,700,710,720,730,740,750,760,770),I
      WRITE(IPR,1090)
      CALL ERROR
      GO TO 800
C NUMBER CODE = 1, THEREFORE HAVE A COMMENT
C STEP C
690   OPTFMT(3)=OPFT31
      OPTFMT(4)=OPFT41
      NOP1=1
      NOP2=2
      GO TO 790
C NUMBER CODE = 2, THEREFORE HAVE A USGS-ID
C STEP C
700   OPTFMT(3)=OPFT32
      OPTFMT(4)=OPCODE(1)
      NOP1=1
      NOP2=3
      GO TO 790
C NUMBER CODE = 3, THEREFORE HAVE A NWS-ID
C STEP C
710   OPTFMT(3)=OPFT32
      OPTFMT(4)=OPCODE(1)
      NOP1=1
      NOP2=4
      GO TO 790
C NUMBER CODE = 4, THEREFORE HAVE A BANKFULL-STG
C STEP C
720   OPTFMT(3)=OPFT34
      OPTFMT(4)=OPCODE(1)
      NOP1=5
      NOP2=6
      K=J
      XRC(J) = XRC(J) * FACLEN
      GO TO 790
C NUMBER CODE = 5, THEREFORE HAVE A RIVER-LOC
C STEP C
730   OPTFMT(3)=OPFT34
      OPTFMT(4)=OPCODE(1)
      K=J
      XRC(J) = XRC(J) * FACMKM
      NOP1=7
      NOP2=8
      GO TO 790
C NUMBER CODE = 6, THEREFORE HAVE A MOB-STG
C STEP C
740   OPTFMT(3)=OPFT34
      OPTFMT(4)=OPCODE(1)
      K=J
      XRC(J) = XRC(J) * FACLEN
      NOP1=1
      NOP2=9
      GO TO 790
C NUMBER CODE = 7, THEREFORE HAVE A HSA-ID
C STEP C
750   OPTFMT(3)=OPFT32
      OPTFMT(4)=OPCODE(1)
      NOP1=1
      NOP2=10
      GO TO 790
C NUMBER CODE = 8, THEREFORE HAVE A E-19
C STEP C
760   OPTFMT(3)=OPFT35
      OPTFMT(4)=OPCODE(1)
      NOP1=1
      NOP2=11
      GO TO 780
C NUMBER CODE = 9, THEREFORE HAVE A E-19A
C STEP C
770   OPTFMT(3)=OPFT35
      OPTFMT(4)=OPCODE(1)
      NOP1=1
      NOP2=12
780   IDATE=XRC(J)
C STEP D
      WRITE(IPR,OPTFMT) I,OPCODE(NOP1),OPCODE(NOP2),IDATE
      GO TO 680
C WRITE OUT FOR ALL CODES
790   WRITE(IPR,OPTFMT) I,OPCODE(NOP1),OPCODE(NOP2),(XRC(I),I=J,K)
      GO TO 680
C
800   CONTINUE
C
C NOW PRINT OUT COMPUTED MANNING N VALUES(CMN) FOR EACH STAGE AND
C ELEVATION. GET 'N' FROM CONVEYANCE(CKARAY).
C USE H1 AS THE STAGE VALUE
C
      IF (NCROSS.EQ.0) GO TO 7590
      K=3
      IF (ENGUNT) K=1
C
      IF (FLOODN.GE.1.0) THEN
      WRITE(IPR,8231) NUNT(K)
      I=LXE1-1
        DO 804 N=1,NCROSS
          I=I+1
          H1=XRC(I)-GZERO
          II=I+2*NCROSS
          WRITE(IPR,8233) XRC(I),H1,XRC(II)
804     CONTINUE
        GO TO 7590
      ENDIF
C
      CALL FMNING(IX,IBUG,COEFMN)
      WRITE(IPR,8227) NUNT(K),NUNT(K+1)
      I=LQ1-1
      DO 7570 N=1,NRCPTS
      CMN=(COEFMN/CKARAY(N)) * SQRT(SLOPE)
C DONT NEED TO SUBTRACT SHIFT CAUSE FPRRC DID SO.
      H1=XRC(N)
      I=I+1
      WRITE(IPR,8229) H1,XRC(I),CMN
7570  CONTINUE
C NOW PRINT OUT COMPUTED MANNING N VALUES(CMN) FOR EACH X.S. ELEVATION.
C USE H1 AS THE ELEVATION
      WRITE(IPR,8231) NUNT(K)
      I=LXE1-1
      IW=LXT1-1
      RCMXH=XRC(LHN)
c      H1=XRC(I)-GZERO
c      WRITE(IPR,8233) XRC(I),H1,CMN
c      DO 7580 N=2,NCROSS
      DO 7580 N=1,NCROSS
      I=I+1
      IW=IW+1
      H1=XRC(I)-GZERO
      IF (H1.LE.RCMXH .OR. FLOODN.LE.0.0)  GO TO 7574
      B1=XRC(IW)
      CKVAL=CKARAY(NRCPTS)
      CMNTOP=(COEFMN/CKVAL) * SQRT(SLOPE)
      RCMXEL=RCMXH+GZERO
      IF(RCMXEL.LE.XRC(LXEN))
     * CALL FTERPL(RCMXEL,XRC(LXE1),NCROSS,XRC(LXT1),RCMXW,IBUG)
      IF(RCMXEL.GT.XRC(LXEN)) RCMXW=XRC(LXTN)
      SQUARN=RCMXW*CMNTOP*CMNTOP+(B1-RCMXW)*FLOODN*FLOODN
      CMN=SQRT(SQUARN/B1)
      GO TO 7575
7574  CONTINUE
      IF (H1.LT.XRC(LH1)) CKVAL=CKARAY(1)
      IF (H1.GE.XRC(LH1) .AND. H1.LE.RCMXH)
     * CALL FTERPL(H1,XRC(LH1),NRCPTS,CKARAY,CKVAL,IBUG)
      IF (H1.GT.RCMXH)  CKVAL=CKARAY(NRCPTS)
      CMN=(COEFMN/CKVAL) * SQRT(SLOPE)
7575  WRITE(IPR,8233) XRC(I),H1,CMN
7580  CONTINUE
C
7590  CONTINUE
C
C RESET COMMON /WHERE/
        OPNAME(1)=OLDSUB(1)
        OPNAME(2)=OLDSUB(2)
        IOPNUM=IOLDOP
C
      RETURN
C
C
C***************FORMAT STATEMENTS***************************************
C
810   FORMAT(1H0,18H ** ENTER FPRRC **)
C
820   FORMAT(//// 1X,17(1H*),28H RATING CURVE FILE CONTENTS ,17(1H*)
     * // 25X,15HRATING CURVE ID // 25X,15(1H*)
     * / 25X,1H*,13X,1H* / 25X,1H*,2X,2A4,3X,1H*
     * / 25X,1H*,13X,1H* / 25X,15(1H*)
     * // 1X,48HMISSING DATA IS INDICATED AS SUCH OR WITH A -999)
C
830   FORMAT(// 1X,78X,10HTOTAL AREA,2X,10HLOCAL AREA,3X,8HORIGINAL
     * / 6X,10HRIVER NAME,12X,12HSTATION NAME,12X,8HLATITUDE,8X,
     * 9HLONGITUDE,3X,A8,4X,A8,3X,10HUNITS USED
     * / 1X,20(1H-),2X,20(1H-),7X,10(1H-),7X,10(1H-),3(2X,10(1H-))
     * / 1X,5A4,2X,5A4,7X,F10.2,7X,F10.2,2(2X,F10.2),6X,A4)
C
840   FORMAT(// 1X,38HFLOOD OF RECORD INFO IS NOT AVAILABLE.)
850   FORMAT(// 26X,27HFLOOD OF RECORD INFORMATION
     * // 10X,4HDATE,16X,5HSTAGE,1X,A8,1X,9HDISCHARGE,A8,10X,7HCOMMENT
     * / 1X,20(1H-),5X,2(2X,15(1H-)),2X,20(1H-))
860   FORMAT(/ 6X,2(I2.2,'-'),I4.4,17X,F10.2,7X,F10.2,2X,5A4)
870   FORMAT(/ 6X,7HMISSING,20X,F10.2,7X,F10.2,2X,5A4)
C
880   FORMAT(// 48X,13HMINIMUM STAGE,18X,9HSECONDARY,4X,7HWARNING
     * / 5X,11HFLOOD STAGE,17X,10HFLOOD FLOW,
     * 8X,9HALLOWABLE,7X,9HGAGE ZERO,2X,11HFLOOD STAGE,4X,5HSTAGE
     * / 6X,A8,19X,A8,10X,A8,9X,A8,4X,A8,4X,A8
     * / 1X,20(1H-),9X,13(1H-),4X,13(1H-),7X,10(1H-),2(2X,10(1H-))
     * / 5X,F10.2,17X,F10.2,7X,F10.2,4X,3(2X,F10.2))
890   FORMAT(1H0,33HNOTE: FLOOD STAGE IS PROVISIONAL.)
900   FORMAT(1H0,37HNOTE: RATING CURVE IS FOR TAIL WATER.)
C
910   FORMAT(// 23X,17HTYPE OF EXTENSION,35X,'TYPE OF EXTENSION',
     * / 1X,20HIS LOOP RATING USED?,2X,17HUSED AT LOWER END
     * ,35X,17HUSED AT UPPER END,
     * / 1X,20(1H-),2X,50(1H-),2X,20(1H-)
     * / 9X,A4,15X,A8,45X,A8 )
920   FORMAT(/5X,'AREA BELOW FIRST X.S. ELEV=',F10.2,
     * 5X,'CHANNEL BOTTOM SLOPE=',F9.6,
     * 5X,'MANNING N FOR FLOOD PLAIN=',F10.4)
930   FORMAT(
     & //1X,'RATIO OF BOTTOM SLOPE TO AVE WAVE SLOPE ',
     $ '(TYPICAL RANGE FROM 10 TO 100)=',F10.2,
     $ / 1X,19HTYPICAL FLOOD INFO:
     $ / 3X,'PEAK TIME (DAY)  =',F10.3,
     $ / 3X,18HINITIAL DISCHARGE=,F10.2,
     $ / 3X,18HPEAK DISCHARGE   =,F10.2,
     $ / 3X,18HINITIAL STAGE    =,F10.2,
     $ / 3X,18HPEAK STAGE       =,F10.2,
     & //1X,'MINIMUM DISCHARGE BELOW WHICH LOOP EFFECTS ',
     & 'WILL BE IGNORED=',F10.2,
     &  /1X,'MINIMUM STAGE BELOW WHICH LOOP EFFECTS ',
     & 'WILL BE IGNORED=',F10.2)
940   FORMAT(/22X,13HSHIFT FACTOR=,F7.2,' USED BELOW STAGE=',F7.2)
C
950   FORMAT(// 1X,38HLAST DAY RATING CURVE IS APPLICABLE : )
960   FORMAT(1H+,38X,I2.2,'-',I2.2,'-',I4.4)
970   FORMAT(1H+,38X,A8)
C
980   FORMAT(// 11X,43HFORECAST PRODUCT GENERATED FOR EACH GENERAL,
     * 17H TYPE OF FORECAST
     * // 1X,23H REGULAR RIVER FORECAST,7X,18HRESERVOIR FORECAST,10X,
     * 17HEXTENDED FORECAST,10X,11HFLASH FLOOD
     * / 1X,25(1H-),2X,25(1H-),2(2X,29(1H-)))
C
990   FORMAT(// 11X,36HNO RATING CURVE POINTS WERE DEFINED.)
1000  FORMAT(// 10X,39HRATING CURVE POINTS - NUMBER OF POINTS=,I3,
     * /10X,A8,'INTERPOLATION USED BETWEEN POINTS',
     * // 20X,5HSTAGE,9X,5H FLOW
     * / 19X,A8,6X,A8
     * / 17X,13(1H-),2X,10(1H-) /)
1010  FORMAT(10X,I3,1H.,1X,F10.2,6X,F10.2)
C
1020  FORMAT(// 11X,39HNO CROSS SECTION DATA WAS USED FOR THIS,
     * 14H RATING CURVE.)
1030  FORMAT(// 16X,40HCROSS SECTION POINTS - NUMBER OF POINTS=,I3
     * / 16X,41(1H.)
     * / 16X,9HELEVATION,7X,9HTOP WIDTH
     * / 17X,A8,8X,A8
     * / 16X,10(1H-),6X,10(1H-) /)
1040  FORMAT(// 11X,'NO OFF-CHANNEL CROSS SECTION DATA WAS USED.')
1050  FORMAT(// 16X,'OFF-CHANNEL CROSS SECTION - NUMBER OF POINTS=',I3,
     * / 16X,41(1H.)
     * / 16X,9HELEVATION,7X,9HTOP WIDTH
     * / 17X,A8,8X,A8
     * / 16X,10(1H-),6X,10(1H-) /)
1060  FORMAT(10X,I3,1H.,1X,F10.2,7X,F9.1)
C
1070  FORMAT(// 11X,39HNO OPTIONAL INFORMATION EXISTS FOR THIS,
     * 14H RATING CURVE.)
1080  FORMAT(// 1X,29HOPTIONAL INFORMATION FOLLOWS:
     * / 1X,11HNUMBER CODE,2X,14HCHARACTER CODE,2X,4HITEM
     * / 1X,11(1H-),2X,14(1H-),2X,30(1H-) /)
C
1090  FORMAT(1HO,10X,40H**ERROR** IMPOSSIBLE LOCATION AFTER GOTO,
     * 10H IN FPRRC.)
C
1100  FORMAT(1H0,32HCONTENTS OF COMMON FRATNG FOLLOW
     * / 1X,10(9X,1H+)
     * / 1X,2A4,2X,10A4,2F10.2,5A4,3F10.2
     * / 1X,F10.2,6X,A4,3F10.2,3I10,F10.2,3I10
     * / 1X,2F10.2,F10.6,2F10.2,6X,A4,2I10,2F10.2
     * / 1X,I10,5A4)
1110  FORMAT(' EMPTY=' / (1X,10F10.2))
1120  FORMAT(' XRC=' / (1X,10F10.2))
C
8227  FORMAT(//5X,'FOLLOWING IS TABLE OF COMPUTED MANNING N VALUES ',
     * '(ALLOWABLE 0.01-0.3) ASSOCIATED WITH EACH STAGE.',
     * /5X,'TRY TO KEEP MANNING N BETWEEN 0.02-0.16 IF POSSIBLE BY',
     * ' CHANGING CROSS SECTIONAL DATA OR CHANNEL SLOPE.',
     * // 18X,5HSTAGE,A3,1H),10X,6HFLOW (,A3,1H),10X,10HMANNINGS N
     * / 18X,9(1H-),10X,10(1H-),10X,10(1H-) )
8229  FORMAT(17X,F10.2,10X,F10.2,10X,F10.5)
8231  FORMAT(//5X,'MANNING N VALUES ASSOCIATED WITH EACH X.S. ',
     * 'ELEVATIONS AND STAGES',
     * // 14X,5HELEV.,A3,5H MSL),4X,21HSTAGE (WRT GAGE ZERO),5X,
     * 10HMANNINGS N
     * / 14X,13(1H-),4X,21(1H-),5X,10(1H-) )
8233  FORMAT(17X,F10.2,10X,F10.2,10X,F10.5)
C
C***********************************************************************
C
      END
