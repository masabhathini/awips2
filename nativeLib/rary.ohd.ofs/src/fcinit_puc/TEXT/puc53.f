C MODULE PUC53
C-----------------------------------------------------------------------
C
C@PROCESS LVL(77)
C
      SUBROUTINE PUC53 (P)

C     THIS IS THE CARD PUNCH ROUTINE FOR SSARR 3-VARIABLE LOOKUP

C     THIS ROUTINE ORIGINALLY WRITTEN BY
C        RAY FUKUNAGA - NWRFC  AUGUST 1995
C
C     ADDED ALGORITHM TO CONVERT METRIC TABLE VARIABLES TO ENGLISH
C     WHEN ENGLISH UNITS SPECIFIED
C        TIM SWEENEY, HRL                               MAR 1998
C
C     ADDED CAPABILITY TO PUNCH MULTI VALUE DATA TYPES
C        DARRIN SHARP, RIVERSIDE TECHNOLOGY             AUG 2007
C
C
C     POSITION   CONTENTS OF P ARRAY
C      1         VERSION NUMBER OF OPERATION
C      2-19      DESCRIPTION - TITLE
C     20         # OF POINTS IN THE P ARRAY

C     21-22      1ST INDEPENDENT VARIABLE (X) TIME SERIES IDENTIFIER
C     23         1ST INDEPENDENT VARIABLE (X) TIME SERIES DATA TYPE CODE
C     24         1ST INDEPENDENT VARIABLE (X) TIME SERIES TIME INTERVAL
C                (DECIMAL PORTION HOLDS MULTIVALUE INDEX WHEN APPLICABLE)

C     25-26      2ND INDEPENDENT VARIABLE (Z) TIME SERIES IDENTIFIER
C     27         2ND INDEPENDENT VARIABLE (Z) TIME SERIES DATA TYPE CODE
C     28         2ND INDEPENDENT VARIABLE (Z) TIME SERIES TIME INTERVAL
C                (DECIMAL PORTION HOLDS MULTIVALUE INDEX WHEN APPLICABLE)

C     29-30      RESULTANT (Y) TIME SERIES IDENTIFIER
C     31         RESULTANT (Y) TIME SERIES DATA TYPE CODE
C     32         RESULTANT (Y) TIME SERIES TIME INTERVAL

C                Z SEGMENTS (Z1,X11,Y11,X12,Y12,Z2,X21,Y21,X22,Y22,ETC)
C     33         THE UNITS THAT THE  USER ENTERS THE Z SEGMENT ARRAY
C                'ENGL' OR 'METR' (DEFAULT)
C     34         NUMBER OF POINTS IN THE Z SEGMENT ARRAY
C     35+        Z SEGMENT ARRAY

C     THEREFORE THE NUMBER OF ELEMENTS REQUIRED IN THE P ARRAY IS
C        34 + NUMBER OF POINTS IN THE Z SEGMENT ARRAY

      CHARACTER *72 CTITLE
      CHARACTER * 8 C1XTS,C2ZTS,CRYTS,XMVDT,ZMVDT,BLANK
      CHARACTER * 4 C1XCOD,C2ZCOD,CRYCOD,C1XDIM,C2ZDIM,CRYDIM
      CHARACTER * 4 CXMET,CZMET,CRMET,CDIM,CTSCAL
      CHARACTER * 4 CXENG,CUNIT
CC    CHARACTER * 4 CZENG,CRENG
C     X AND Z MVINDX ARE THE INTEGER VALUE HELD IN THE
C     DECIMAL PORTION OF P(24) OR P(28). E.G. IF P(24)=
C     X.7 XMVINDX WILL BE 7.
      INTEGER XMVINDX,ZMVINDX
      DIMENSION R1XTS(2),R2ZTS(2),RRYTS(2),RTITLE(18)
      DIMENSION P(*)

C     ***
C     *NOTE AUG 2007* LOOKUP BY DATE HAS BEEN PARTIALLY CODED
C     BUT NOT TURNED ON OR TESTED.
C     ***
      LOGICAL DATELU
      DATA DATELU /.FALSE./

      EQUIVALENCE (C1XTS,R1XTS),(C2ZTS,R2ZTS),(CRYTS,RRYTS)
      EQUIVALENCE (C1XCOD,R1XCOD),(C2ZCOD,R2ZCOD),(CRYCOD,RRYCOD)
      EQUIVALENCE (CTITLE,RTITLE)
      EQUIVALENCE (CUNIT,RUNIT)

C     COMMON BLOCKS

      INCLUDE 'common/fdbug'
      INCLUDE 'common/ionum'
      INCLUDE 'common/pudflt'

      DATA BLANK/4H    /
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/pda/users/sharpd/devl/src/fcinit_puc/myRCS/puc53.f,v $
     . $',                                                             '
     .$Id: puc53.f,v 1.2 2007/06/27 17:17:09 sharpd Exp $
     . $' /
C    ===================================================================
C
C
C SAMPLE INPUT DECK
C
C ST MARIES (CLDI ROUTED COEI HF > ST MARIES STAGE)
C CLDIR SQIN 6
C COEI  SPEL 6
C SJMI  SSTG 6
C ENGL
C   0000  2120.00    20.00  2150.00    50.00 99999.99 9999999.99
C   1000  2122.00    23.00  2126.00    26.50  2149.90    50.00
C   5000  2122.00    26.25  2124.00    26.75  2126.00    27.75
C   5000  2130.00    30.75  2149.80    50.00
C  10000  2122.00    28.75  2126.00    30.25  2130.00    32.50
C  10000  2134.00    35.25  2138.00    38.75  2149.25    50.00
C  15000  2122.00    31.75  2126.00    33.25  2130.00    35.25
C  15000  2134.00    37.50  2149.00    50.00
C  20000  2122.00    34.00  2128.00    36.50  2132.00    38.00
C  20000  2148.00    50.00
C  30000  2122.00    37.00  2126.00    38.50  2147.00    50.00
C  40000  2122.00    40.00  2126.00    41.00  2146.00    50.00
C 100000  2122.00    47.00  2145.00    50.00

C     ***
C     *NOTE AUG 2007* LOOKUP BY DATE HAS BEEN PARTIALLY CODED
C     BUT NOT TURNED ON OR TESTED.
C     ***
      IF (C1XCOD.EQ.'DATE') THEN
         DATELU=.TRUE.
      ELSE
         DATELU=.FALSE.
      END IF

      CALL FPRBUG ('PUC53   ',1,53,IBUG)
      IERROR = 0

      WRITE(IPU,500) (P(II),II=2,19)
 500  FORMAT(18A4)

      R1XTS(1) = P(21)
      R1XTS(2) = P(22)
      R1XCOD   = P(23)
C     TRUNCATE TO INT WHOLE NUMBER IN ORDER
C     TO DISCARD THE MULTIVALUE INDEX (IF
C     PRESENT) THAT IS IN THE DECIMAL PORTION
      I1XINT   = INT(P(24))
      R2ZTS(1) = P(25)
      R2ZTS(2) = P(26)
      R2ZCOD   = P(27)
C     TRUNCATE TO INT WHOLE NUMBER IN ORDER
C     TO DISCARD THE MULTIVALUE INDEX (IF
C     PRESENT) THAT IS IN THE DECIMAL PORTION
      I2ZINT   = INT(P(28))
      RRYTS(1) = P(29)
      RRYTS(2) = P(30)
      RRYCOD   = P(31)
      IRYINT   = P(32)

      XMVDT=BLANK
      ZMVDT=BLANK

C     IF THERE ARE X OR Z MULTIVALUE INDICES, INDICATED
C     BY P (24) OR (28) HAVING A DECIMAL PORTION,
C     CONVERT THE INDEX (NUMERIC) TO AN ALPHA DATA TYPE

C     ***
C     *NOTE AUG 2007* LOOKUP BY DATE HAS BEEN PARTIALLY CODED
C     BUT NOT TURNED ON OR TESTED.
C     ***
      IF (((P(24)-I1XINT).NE.0).AND.(.NOT.DATELU)) THEN
C        CONVERT DECIMAL PORTION TO A WHOLE INT
         XMVINDX=NINT((P(24)-I1XINT)*10)
         CALL CVTIDX(C1XCOD,XMVINDX,XMVDT)
         IF (XMVDT.EQ.'INVALID') THEN
            IERROR = 1
            WRITE(IPR,401) C1XTS,C1XCOD,I1XINT
         ENDIF
      ENDIF

      IF ((P(28)-I2ZINT).NE.0) THEN
C        CONVERT DECIMAL PORTION TO A WHOLE INT
         ZMVINDX=NINT((P(28)-I2ZINT)*10)
         CALL CVTIDX(C2ZCOD,ZMVINDX,ZMVDT)
         IF (ZMVDT.EQ.'INVALID') THEN
            IERROR = 1
            WRITE(IPR,401) CZ2TS,C2ZCOD,I2ZINT
         ENDIF
      ENDIF

 401  FORMAT(//,10X,'*** ERROR WITH MULTIVALUE TIME SERIES ',
     +      10X,'TS SHOULD HAVE MULTIVALUE DATA TYPE',/,
     +      10X,'TIME SERIES: ',A8,A8,I6)

      WRITE(IPU,501)  C1XTS,C1XCOD,I1XINT,XMVDT,
     +                C2ZTS,C2ZCOD,I2ZINT,ZMVDT,
     +                CRYTS,CRYCOD,IRYINT
 501  FORMAT(2(A8,1X,A4,I6,1X,A8,/),A8,1X,A4,I6)

      RUNIT = P(33)
      WRITE(IPU,5015) CUNIT
 5015 FORMAT(A4)
C
      IF(CUNIT.EQ.'ENGL') THEN

C     CHECK 1ST INDEPENDENT VARIABLE (X) TIME SERIES INFORMATION
      CALL CHEKTS (C1XTS,C1XCOD,I1XINT,0,C1XDIM,0,1,IERFLG)
      IF (IERFLG.NE.0) THEN
         IERROR = 1
         WRITE(IPR,601) C1XTS,C1XCOD,I1XINT
 601     FORMAT(//,10X,'*** ERROR *** ERROR WITH TIME SERIES ',
     +            'INFORMATION',/,
     +             10X,'TIME SERIES:  ',2A,I6)
      ENDIF

C     CHECK 2ND INDEPENDENT VARIABLE (Z) TIME SERIES INFORMATION
      CALL CHEKTS (C2ZTS,C2ZCOD,I2ZINT,0,C2ZDIM,0,1,IERFLG)
      IF (IERFLG.NE.0) THEN
         IERROR = 1
         WRITE(IPR,601) C2ZTS,C2ZCOD,I2ZINT
      ENDIF


C     CHECK RESULTANT (Y) TIME SERIES INFORMATION
      CALL CHEKTS (CRYTS,CRYCOD,IRYINT,0,CRYDIM,0,1,IERFLG)
      IF (IERFLG.NE.0) THEN
         IERROR = 1
         WRITE(IPR,601) CRYTS,CRYCOD,IRYINT
      ENDIF

         CALL FDCODE (C1XCOD,CXMET,CDIM,IMISS,NVAL,CTSCAL,NADD,IERFLG)
         IF (IERFLG.NE.0) THEN
            IERROR = 1
            WRITE(IPR,3100) C1XCOD
 3100       FORMAT(//,10X,'*** ERROR *** ERROR IN FDCODE CALL FOR TS ',
     +                    'CODE: ',A)
         ENDIF
         IF (IBUG.GE.1) WRITE(IODBUG,31) C1XCOD,CXMET
 31      FORMAT('PUC53: C1XCOD,CXMET:',A,1X,A)
         CALL FCONVT (CXMET,C1XDIM,CXENG,RXMF,RXCF,IERFLG)
         IF (IERFLG.NE.0) THEN
            IERROR = 1
            WRITE(IPR,3105) CXMET,C1XDIM
 3105       FORMAT(//,10X,'*** ERROR *** ERROR IN FCONVT CALL FOR ',
     +                    'METRIC UNITS AND DIMENSION: ',A,1X,A)
         ENDIF
         IF (IBUG.GE.1) WRITE(IODBUG,32) CXMET,C1XDIM,RXMF,RXCF
 32      FORMAT('PUC53: CXMET,C1XDIM,RXMF,RXCF: ',A,1X,A,2F10.2)

         CALL FDCODE (C2ZCOD,CZMET,CDIM,IMISS,NVAL,CTSCAL,NADD,IERFLG)
         IF (IERFLG.NE.0) THEN
            IERROR = 1
            WRITE(IPR,3100) C2ZCOD
         ENDIF
         IF (IBUG.GE.1) WRITE(IODBUG,33) C2ZCOD,CZMET
 33      FORMAT('PUC53: C2ZCOD,CZMET: ',A,1X,A)
         CALL FCONVT (CZMET,C2ZDIM,CZEND,RZMF,RZCF,IERFLG)
         IF (IERFLG.NE.0) THEN
            IERROR = 1
            WRITE(IPR,3105) CZMET,C2ZDIM
         ENDIF
         IF (IBUG.GE.1) WRITE(IODBUG,34) CZMET,C2ZDIM,RZMF,RZCF
 34      FORMAT('PUC53: CZMET,C2ZDIM,RZMF,RZCF: ',A,1X,A,2F10.2)

         CALL FDCODE (CRYCOD,CRMET,CDIM,IMISS,NVAL,CTSCAL,NADD,IERFLG)
         IF (IERFLG.NE.0) THEN
            IERROR = 1
            WRITE(IPR,3100) CRYCOD
         ENDIF
         IF (IBUG.GE.1) WRITE(IODBUG,35) CRYCOD,CRMET
 35      FORMAT('PUC53: CRYCOD,CRMET: ',A,1X,A)
         CALL FCONVT (CRMET,CRYDIM,CREND,RRMF,RRCF,IERFLG)
         IF (IERFLG.NE.0) THEN
            IERROR = 1
            WRITE(IPR,3105) CRMET,CRYDIM
         ENDIF
         IF (IBUG.GE.1) WRITE(IODBUG,36) CRMET,CRYDIM,RRMF,RRCF
 36      FORMAT('PUC53: CRMET,CRYDIM,RRMF,RRCF: ',A,1X,A,2F10.2)
       ENDIF
C
      IF(CUNIT.NE.'ENGL'.OR.IERROR.GE.1) THEN
         RZMF = 1.0
         RXMF = 1.0
         RRMF = 1.0
         RZCF = 0.0
         RXCF = 0.0
         RRCF = 0.0
      ENDIF
C
      DO 100 I=35,NINT(P(20)),7

         IF(P(I).LE.-999.) THEN
            Z = P(I)
         ELSE
            Z = P(I)*RZMF + RZCF
         ENDIF

         IF(P(I+1).LE.-999.) THEN
            X1 = P(I+1)
         ELSE
            X1 = P(I+1)*RXMF + RXCF
         ENDIF

         IF(P(I+2).LE.-999.) THEN
            Y1 = P(I+2)
         ELSE
            Y1 = P(I+2)*RRMF + RRCF
         ENDIF

         IF(P(I+3).LE.-999.) THEN
            X2 = P(I+3)
         ELSE
            X2 = P(I+3)*RXMF + RXCF
         ENDIF

         IF(P(I+4).LE.-999.) THEN
            Y2 = P(I+4)
         ELSE
            Y2 = P(I+4)*RRMF + RRCF
         ENDIF

         IF(P(I+5).LE.-999.) THEN
            X3 = P(I+5)
         ELSE
            X3 = P(I+5)*RXMF + RXCF
         ENDIF

         IF(P(I+6).LE.-999.) THEN
            Y3 = P(I+6)
         ELSE
            Y3 = P(I+6)*RRMF + RRCF
         ENDIF

         WRITE(IPU,502) Z,X1,Y1,X2,Y2,X3,Y3
 502     FORMAT(7(F10.2,1X))

 100  CONTINUE

C  INSERT LAST RECORD
      Z  = -999.
      X1 = -999.
      Y1 = -999.
      X2 = -999.
      Y2 = -999.
      X3 = -999.
      Y3 = -999.
      WRITE(IPU,502) Z,X1,Y1,X2,Y2,X3,Y3

      IF (ITRACE.GE.1) WRITE(IODBUG,90)
 90   FORMAT('  *** EXIT PUC53 ***')

      RETURN
      END
