      SUBROUTINE UNPKBG(KFILDO,IPACK,ND5,LOC,IPOS,NVALUE,NBIT,L3264B,
     1                  IER,*)
C
C        DECEMBER 1994   GLAHN   TDL   MOS-2000
C        APRIL    1997   GLAHN   CORRECTED COMMENT FOR NBIT.
C        MAY      1997   GLAHN   MODIFIED TO USE MVBITS RATHER THAN
C                                SHIFTING AND ORING
C 
C        PURPOSE 
C            UNPACKS NBIT BITS INTO THE WORD NVALUE FROM ARRAY
C            IPACK(ND5) STARTING IN WORD LOC, BIT IPOS.  THE WORD
C            POINTER LOC AND BIT POSITION POINTER IPOS ARE UPDATED
C            AS NECESSARY.  IF NBIT EQ 0, NVALUE IS RETURNED EQ 0,
C            AND THE POINTERS ARE NOT MOVED.  THE INTEGER WORD
C            LENGTH OF THE MACHINE BEING USED IS L32B4B.  THIS PACKING
C            ROUTINE WILL WORK ON EITHER A 32- OR 64-BIT MACHINE.
C            A MAXIMUM OF 32 BITS CAN BE UNPACKED ON A SINGLE CALL.
C
C        DATA SET USE 
C           KFILDO - UNIT NUMBER FOR OUTPUT (PRINT) FILE. (OUTPUT) 
C
C        VARIABLES 
C              KFILDO = UNIT NUMBER FOR OUTPUT (PRINT) FILE.  (INPUT)
C            IPACK(J) = ARRAY TO UNPACK FROM (J=1,ND5).  (INPUT)
C                 ND5 = DIMENSION OF IPACK( ).  (INPUT)
C                 LOC = WORD IN IPACK( ) TO START UNPACKING.  UPDATED
C                       AS NECESSARY AFTER UNPACKING IS COMPLETED.
C                       (INPUT-OUTPUT)
C                IPOS = BIT POSITION (COUNTING LEFTMOST BIT IN WORD
C                       AS 1) TO START UNPACKING.  MUST BE GE 1 AND
C                       LE L3264B.  UPDATED AS NECESSARY
C                       AFTER PACKING IS COMPLETED.  (INPUT-OUTPUT)
C              NVALUE = THE RIGHTMOST NBIT BITS IN NVALUE WILL
C                       BE FILLED FROM IPACK(LOC).  IPACK(LOC+1) IS
C                       USED IF NECESSARY.  RETURNED AS ZERO IF 
C                       IER NE 0.  (OUTPUT)
C                NBIT = SEE NVALUE.  MUST BE GE 0 AND LE 32.  (INPUT)   
C              L3264B = INTEGER WORD LENGTH OF MACHINE BEING USED.
C                       (INPUT)
C                 IER = STATUS RETURN:
C                       0 = GOOD RETURN.
C                       6 = LOC NOT IN RANGE 1 TO ND5.
C                       7 = IPOS NOT IN RANGE 1 TO L3264B.
C                       8 = NBIT NOT IN RANGE 0 TO 32.
C                   * = ALTERNATE RETURN WHEN IER NE 0.
C        NON SYSTEM SUBROUTINES CALLED
C            NONE
C
      DIMENSION IPACK(ND5)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/util/src/grib2unpacker/RCS/unpkbg.f,v $
     . $',                                                             '
     .$Id: unpkbg.f,v 1.1 2004/09/16 16:51:50 dsa Exp $
     . $' /
C    ===================================================================
C
C
C        CHECK CORRECTNESS OF INPUT AND SET STATUS RETURN.
C
      IER=0
      NVALUE=0
C        IF IER NE 0 OR NBIT EQ 0, NVALUE IS RETURNED EQ 0.
      IF(NBIT.EQ.0)GO TO 150
      IF(LOC.LT.1.OR.LOC.GT.ND5)IER=6
      IF(IPOS.LE.0.OR.IPOS.GT.L3264B)IER=7
      IF(NBIT.LT.0.OR.NBIT.GT.32)IER=8
      IF(IER.NE.0)RETURN 1      
C 
C        IT APPEARS MVBITS WON'T TRANSFER A FULL 32-BIT WORD,
C        WITH THE FORTRAN COMPILER ON HP 755'S, CONTRARY
C        TO THE HP DOCUMENTATION.  MUST BE A BUG.  TEST FOR THAT
C        HERE.  NBIT WILL RARELY BE 32, AND WITH A 64-BIT WORD,
C        THIS PROBLEM SHOULD NOT EXIST.  THIS BUG IS FIXED IN
C        UNIX 10.20, AND THE TEST CAN BE REMOVED WHEN ALL MACHINES
C        ARE UPGRADED.
C
      IF(NBIT.EQ.L3264B.AND.IPOS.EQ.1)THEN
         NVALUE=IPACK(LOC)
         LOC=LOC+1
         GO TO 150
      ENDIF
C
C        NORMAL PROCESSING BELOW.
C
      NEWIPOS=IPOS+NBIT
C
C        WHEN NEWIPOS LE L3264B+1, THEN ONLY ONE WORD IS UNPACKED FROM.
C        ELSE TWO WORDS ARE INVOLVED.
C
      IF(NEWIPOS.LE.L3264B+1)THEN
         CALL MVBITS(IPACK(LOC),L3264B+1-NEWIPOS,NBIT,NVALUE,0)
C
         IF(NEWIPOS.LE.L3264B)THEN
            IPOS=NEWIPOS
         ELSE
            IPOS=1
            LOC=LOC+1
         ENDIF
C
      ELSE
         NBIT1=L3264B+1-IPOS
         NBIT2=NBIT-NBIT1
         CALL MVBITS(IPACK(LOC),0,NBIT1,NVALUE,NBIT2)
         LOC=LOC+1
C
         IF(LOC.LE.ND5)GO TO 130
         IER=6
         NVALUE=0
         RETURN 1
C
 130     CALL MVBITS(IPACK(LOC),L3264B-NBIT2,NBIT2,NVALUE,0)
         IPOS=NBIT2+1
      ENDIF
C
 150  CONTINUE
      RETURN
      END
