C MEMBER PLOTWB
C  (from old member MCEX40)
C
      SUBROUTINE PLOTWB(PO,VAL,SUM,MON,IMONTH,MONTH,KWY,KYR,I1,WT,IAPI,I
     &SV,IFI)
C***************************************
C
C     THIS SUBROUTINE GENERATES THE YEARLY WATER BALANCES. THREE TABLES
C     ARE GENERATED.
C
C     THIS SUBROUTINE WAS INITIALLY WRITTEN BY:
C     ROBERT M. HARPER     HRL         MAY 1991
C***************************************
C
      DIMENSION PO(1),VAL(30,1),SUM(1),MON(12)
      DIMENSION SIKM(2),ENGMI(2),SQ2(2),SNAME(2),FICH(2),SVCH(2)
C
      INCLUDE 'common/fdbug'
      INCLUDE 'common/ionum'
      INCLUDE 'common/fengmt'
C
      DATA EOM/' N/A'/
      DATA SIMM/'MM  '/,ENGIN/'IN  '/
      DATA SIKM/'(SQ ','KM) '/,ENGMI/'(SQ ','MI) '/
      DATA SNAME/'PLOT','WB  '/
      DATA BLANK/'    '/,CHFI/'    '/
      DATA SVAEI/' AEI'/,SVATI/' ATI'/
C
      EQUIVALENCE(WY,TABLE)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/calb/src/calb_waterbal/RCS/plotwb.f,v $
     . $',                                                             '
     .$Id: plotwb.f,v 1.3 1999/01/19 16:42:27 page Exp $
     . $' /
C    ===================================================================
C
C***************************************
C
C     TRACE LEVEL=1, NO DEBUG OUTPUT
      IF(ITRACE .GE. 1) WRITE(IODBUG,900) SNAME
  900 FORMAT(/,1X,'** ',2A4,' ENTERED')
C***************************************
C
C     CONTROL VARIABLES
      NAM=I1+4
      IFLAG=PO(15)
      NVAL=21
      IF(IAPI .EQ. 1) NVAL=9
C
      FICH(1)=BLANK
      FICH(2)=BLANK
      SVCH(1)=BLANK
      SVCH(2)=BLANK
C***************************************
C
C     DETERMINE HOW MANY MONTHS ARE TO BE SUMMED. IS WATER YEAR COMPLETE
      KMO=MONTH
      MOWY=KMO+3
      IF(MOWY .GT. 12) MOWY=MOWY-12
C
      DO 5 I=1,NVAL
        SUM(I)=0.0
    5 CONTINUE
C
C     COMPUTE APPROPRIATE YEARLY TOTALS
      DO 10 I=1,NVAL
        DO 20 J=1,MOWY
          SUM(I)=SUM(I)+VAL(I,J)
   20   CONTINUE
   10 CONTINUE
C***************************************
C
C     COMPUTE THE AREA OF THE CURRENT SUBAREA.
      IF(METRIC .EQ. 0) GO TO 30
      AREA=PO(13)*WT
      UNITS=SIMM
      SQ2(1)=SIKM(1)
      SQ2(2)=SIKM(2)
      GO TO 40
C
C     CONVERT AREA TO ENGLISH UNITS.
   30 AREA=(PO(13)*WT)*0.3861
      UNITS=ENGIN
      SQ2(1)=ENGMI(1)
      SQ2(2)=ENGMI(2)
C***************************************
C
   40 IF(IAPI .EQ. 1) GO TO 160
C
C     SACRAMENTO MODEL
C     PRINT TABLE (1)
      WRITE(IPR,500) (PO(I),I=I1,NAM),KWY,(SQ2(I),I=1,2),AREA,UNITS
      KMO=IMONTH
      IEND=0
      J=1
   70 MOWY=KMO+3
      IF(MOWY .GT. 12) MOWY=MOWY-12
      IF(KMO .NE. MONTH) GO TO 50
      IEND=1
   50 IF(METRIC .EQ. 0) GO TO 55
      WRITE(IPR,510) MON(KMO),(VAL(I,J),I=1,14)
      GO TO 65
   55 WRITE(IPR,515) MON(KMO),(VAL(I,J),I=1,14)
   65 IF(IEND .EQ. 1) GO TO 60
      J=J+1
      KMO=KMO+1
      IF(KMO .LT. 13) GO TO 70
      KMO=1
      GO TO 70
   60 WRITE(IPR,520)
      IF(METRIC .EQ. 0) GO TO 75
      WRITE(IPR,530) (SUM(I),I=1,3),EOM,(SUM(I),I=5,14)
      GO TO 85
   75 WRITE(IPR,535) (SUM(I),I=1,3),EOM,(SUM(I),I=5,14)
C
C     PRINT TABLE (2)
   85 WRITE(IPR,540)
      KMO=IMONTH
      IEND=0
      J=1
  100 MOWY=KMO+3
      IF(MOWY .GT. 12) MOWY=MOWY-12
      IF(KMO .NE. MONTH) GO TO 80
      IEND=1
   80 IF(METRIC .EQ. 0) GO TO 95
      WRITE(IPR,550) MON(KMO),(VAL(I,J),I=15,21)
      GO TO 105
   95 WRITE(IPR,555) MON(KMO),(VAL(I,J),I=15,21)
  105 IF(IEND .EQ. 1) GO TO 90
      J=J+1
      KMO=KMO+1
      IF(KMO .LT. 13) GO TO 100
      KMO=1
      GO TO 100
   90 WRITE(IPR,560)
      IF(METRIC .EQ. 0) GO TO 115
      WRITE(IPR,570) (SUM(I),I=15,21)
      GO TO 125
  115 WRITE(IPR,575) (SUM(I),I=15,21)
C
C     PRINT TABLE (3)
  125 WRITE(IPR,580)
      KMO=IMONTH
      IEND=0
      J=1
  130 MOWY=KMO+3
      IF(KMO .GT. 12) MOWY=MOWY-12
      IF(KMO .NE. MONTH) GO TO 110
      IEND=1
  110 IF(METRIC .EQ. 0) GO TO 135
      WRITE(IPR,590) MON(KMO),(VAL(I,J),I=22,30)
      GO TO 145
  135 WRITE(IPR,595) MON(KMO),(VAL(I,J),I=22,30)
  145 IF(IEND .EQ. 1) GO TO 120
      J=J+1
      KMO=KMO+1
      IF(KMO .LT. 13) GO TO 130
      KMO=1
      GO TO 130
  120 WRITE(IPR,600)
      GO TO 150
C
C     CONTINUOUS API MODEL
C     PRINT TABLE (1)
  160 WRITE(IPR,610) (PO(I),I=I1,NAM),KWY,(SQ2(I),I=1,2),AREA,UNITS
      KMO=IMONTH
      IEND=0
      J=1
  210 MOWY=MOWY+3
      IF(MOWY .GT. 12) MOWY=MOWY-12
      IF(KMO .NE. MONTH) GO TO 170
      IEND=1
  170 IF(METRIC .EQ. 0) GO TO 180
      WRITE(IPR,620) MON(KMO),(VAL(I,J),I=1,9)
      GO TO 190
  180 WRITE(IPR,630) MON(KMO),(VAL(I,J),I=1,9)
  190 IF(IEND .EQ. 1) GO TO 200
      J=J+1
      KMO=KMO+1
      IF(KMO .LT. 13) GO TO 210
      KMO=1
      GO TO 210
  200 WRITE(IPR,615)
      IF(METRIC .EQ. 0) GO TO 220
      WRITE(IPR,640) (SUM(I),I=1,3),EOM,(SUM(I),I=5,9)
      GO TO 230
  220 WRITE(IPR,650) (SUM(I),I=1,3),EOM,(SUM(I),I=5,9)
C
C     PRINT TABLE (2)
  230 WRITE(IPR,660)
      IF(IFI .EQ. 0) GO TO 240
      FICH(1)=CHFI
  240 IF(ISV .EQ. 1) SVCH(1)=SVAEI
      IF(ISV .EQ. 2) SVCH(1)=SVATI
      WRITE(IPR,670) FICH(1),SVCH(1)
      KMO=IMONTH
      IEND=0
      J=1
  310 MOWY=KMO+3
      IF(MOWY .GT. 12) MOWY=MOWY-12
      IF(KMO .NE. MONTH) GO TO 250
      IEND=1
  250 IF(IFI .EQ. 0) GO TO 260
C     FROST INDEX
      FI=VAL(15,J)
      CALL URELCH(FI,8,FICH,1,NC,ISTAT)
  260 IF(ISV .EQ. 0) GO TO 270
      SV=VAL(16,J)
      IF(ISV .EQ. 2) GO TO 265
C     EVAPORATION INDEX
      IF(METRIC .EQ. 0) GO TO 255
      CALL URELCH(SV,8,SVCH,1,NC,ISTAT)
      GO TO 270
  255 CALL URELCH(SV,8,SVCH,2,NC,ISTAT)
      GO TO 270
C     TEMPERATURE INDEX
  265 CALL URELCH(SV,8,SVCH,1,NC,ISTAT)
  270 IF(METRIC .EQ. 0) GO TO 280
      WRITE(IPR,680) MON(KMO),(VAL(I,J),I=10,14),(FICH(I),I=1,2),(SVCH(I
     &),I=1,2)
      GO TO 290
  280 WRITE(IPR,690) MON(KMO),(VAL(I,J),I=10,14),(FICH(I),I=1,2),(SVCH(I
     &),I=1,2)
  290 IF(IEND .EQ. 1) GO TO 300
      J=J+1
      KMO=KMO+1
      IF(KMO .LT. 13) GO TO 310
      KMO=1
      GO TO 310
  300 WRITE(IPR,700)
C***************************************
C
  500 FORMAT(1H1,/43X,'WATER BALANCE SUMMARY FOR ',5A4,//16X,'WATER YEAR
     &',I5,23X,'AREA ',2A4,'= ',F10.1,25X,'UNITS ARE ',A4,//27X,'PRECIPI
     &TATION AND SOIL MOISTURE BALANCE',28X,'EVAPOTRANSPIRATION',/32X,'R
     &AIN+',3X,'EOM',4X,'CHANGE',9X,'CHANGE',2X,'RECHARGE',1X,'ET',6X,
     &'ET',/7X,'MONTH',4X,'RAIN',4X,'SNOW',4X,'MELT',4X,'(WE)',4X,'(WE)'
     &,3X,'RUNOFF',2X,'(STO)',3X,'(SIDE)',2X,'DEMAND',2X,'ACTUAL',2X,
     &'U-ZONE',2X,'L-ZONE',2X,'ADIMP',2X,'RIPARIAN',/7X,119('-'))
  510 FORMAT(8X,A4,14(2X,F6.0))
  515 FORMAT(8X,A4,14(1X,F7.2))
  520 FORMAT(7X,119('-'))
  530 FORMAT(7X,'YEAR ',3(2X,F6.0),4X,A4,10(2X,F6.0))
  535 FORMAT(7X,'YEAR ',3(1X,F7.2),4X,A4,10(1X,F7.2))
C
  540 FORMAT(//45X,'SACRAMENTO SOIL MOISTURE ACCOUNTING VOLUMES',/51X,'R
     &UNOFF COMPONENTS',26X,'BASEFLOW',/24X,'MONTH',7X,'TOTAL',5X,'IMPER
     &V',5X,'DIRECT',4X,'SURFACE',3X,'INTERFLOW',3X,'PRIMARY',3X,'SUPPLE
     &MENT'/,24X,85('-'))
  550 FORMAT(25X,A4,7(5X,F6.0))
  555 FORMAT(25X,A4,7(4X,F7.2))
  560 FORMAT(24X,85('-'))
  570 FORMAT(24X,'TOTAL',7(5X,F6.0))
  575 FORMAT(24X,'TOTAL',7(4X,F7.2))
C
  580 FORMAT(//58X,'SACRAMENTO MODEL',/45X,'END OF MONTH SOIL MOISTURE S
     &TORAGE CONTENTS',/27X,'MONTH',3X,'UZTWC',4X,'UZTD',3X,'UZFWC',3X,'
     &LZTWC',4X,'LZTD',3X,'LZFPC',3X,'LZFSC',4X,'LZDR',3X,'ADIMC',/27X,7
     &8('-'))
  590 FORMAT(28X,A4,7(2X,F6.0),2X,F6.2,2X,F6.0)
  595 FORMAT(28X,A4,9(1X,F7.2))
  600 FORMAT(27X,78('-'))
C
  610 FORMAT(1H1,/43X,'WATER BALANCE SUMMARY FOR ',5A4,//16X,'WATER YEAR
     &',I5,23X,'AREA ',2A4,'= ',F10.1,25X,'UNITS ARE ',A4,//30X,'PRECIPI
     &TATION AND SOIL MOISTURE BALANCE',27X,'RUNOFF',/47X,'RAIN+',6X,'EO
     &M',7X,'CHANGE',/13X,'MONTH',7X,'RAIN',7X,'SNOW',7X,'MELT',7X,'(WE)
     &',7X,'(WE)',6X,'RUNOFF',5X,'IMPERV',4X,'SURFACE',3X,'BASEFLOW',/13
     &X,106('-'))
  615 FORMAT(13X,106('-'))
  620 FORMAT(14X,A4,9(5X,F6.0))
  630 FORMAT(14X,A4,9(4X,F7.2))
  640 FORMAT(13X,'YEAR ',3(5X,F6.0),7X,A4,10(5X,F6.0))
  650 FORMAT(13X,'YEAR ',3(4X,F7.2),7X,A4,10(4X,F7.2))
C
  660 FORMAT(////56X,'CONTINUOUS API MODEL',/52X,'END OF MONTH STORAGE C
     &ONTENTS')
  670 FORMAT(/24X,'MONTH',7X,'API',8X,'SMI',6X,'SMI/SMIX',5X,'BFSC',7X,'
     &BFI',7X,A4,8X,A4,/24X,83('-'))
  680 FORMAT(25X,A4,2(5X,F6.0),5X,F6.2,2(5X,F6.0),2(3X,2A4))
  690 FORMAT(25X,A4,5(4X,F7.2),2(3X,2A4))
  700 FORMAT(24X,83('-'))
C
  150 RETURN
      END
