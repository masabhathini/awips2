      SUBROUTINE W3FB12_FREEZING_STATION_LIST(XI,XJ,ALAT1,ELON1,DX,ELONV,ALATAN,ALAT,ELON,
     &                               IERR)
C
      PARAMETER ( LAT_LL_P   =  16.2810       )
      PARAMETER ( LON_LL_P   = -126.1378      )
      PARAMETER ( LAT_TAN_P  =  25.0          )

C -- for 13km RUC.  Multiply by 1.5 for 20km RUC, by 3 for 40km RUC
      PARAMETER ( DX_P       =  13545.087     )

      PARAMETER ( LAT_TRUE_P =  35.0          )
      PARAMETER ( LON_XX_P   = -95.0          )

C - Example of call
C           call w3fb12 (oi(ista), oj(ista),LAT_LL_P,360.+LON_LL_P,DX_P,
C     +              360.+LON_XX_P,LAT_TAN_P,zlat,zlon,ierr)
C
C$$$   SUBPROGRAM  DOCUMENTATION  BLOCK
C
C SUBPROGRAM:  W3FB12        LAMBERT(I,J) TO LAT/LON FOR GRIB
C   PRGMMR: STACKPOLE        ORG: NMC42       DATE:88-11-28
C
C ABSTRACT: CONVERTS THE COORDINATES OF A LOCATION ON EARTH GIVEN IN A
C   GRID COORDINATE SYSTEM OVERLAID ON A LAMBERT CONFORMAL TANGENT
C   CONE PROJECTION TRUE AT A GIVEN N OR S LATITUDE TO THE
C   NATURAL COORDINATE SYSTEM OF LATITUDE/LONGITUDE
C   W3FB12 IS THE REVERSE OF W3FB11.
C   USES GRIB SPECIFICATION OF THE LOCATION OF THE GRID
C
C PROGRAM HISTORY LOG:
C   88-11-25  ORIGINAL AUTHOR:  STACKPOLE, W/NMC42
C
C USAGE:  CALL W3FB12(XI,XJ,ALAT1,ELON1,DX,ELONV,ALATAN,ALAT,ELON,IERR,
C                                   IERR)
C   INPUT ARGUMENT LIST:
C     XI       - I COORDINATE OF THE POINT  REAL*4
C     XJ       - J COORDINATE OF THE POINT  REAL*4
C     ALAT1    - LATITUDE  OF LOWER LEFT POINT OF GRID (POINT 1,1)
C                LATITUDE <0 FOR SOUTHERN HEMISPHERE; REAL*4
C     ELON1    - LONGITUDE OF LOWER LEFT POINT OF GRID (POINT 1,1)
C                  EAST LONGITUDE USED THROUGHOUT; REAL*4
C     DX       - MESH LENGTH OF GRID IN METERS AT TANGENT LATITUDE
C     ELONV    - THE ORIENTATION OF THE GRID.  I.E.,
C                THE EAST LONGITUDE VALUE OF THE VERTICAL MERIDIAN
C                WHICH IS PARALLEL TO THE Y-AXIS (OR COLUMNS OF
C                THE GRID) ALONG WHICH LATITUDE INCREASES AS
C                THE Y-COORDINATE INCREASES.  REAL*4
C                THIS IS ALSO THE MERIDIAN (ON THE OTHER SIDE OF THE
C                TANGENT CONE) ALONG WHICH THE CUT IS MADE TO LAY
C                THE CONE FLAT.
C     ALATAN   - THE LATITUDE AT WHICH THE LAMBERT CONE IS TANGENT TO
C                (TOUCHES OR OSCULATES) THE SPHERICAL EARTH.
C                 SET NEGATIVE TO INDICATE A
C                 SOUTHERN HEMISPHERE PROJECTION; REAL*4
C
C   OUTPUT ARGUMENT LIST:
C     ALAT     - LATITUDE IN DEGREES (NEGATIVE IN SOUTHERN HEMI.)
C     ELON     - EAST LONGITUDE IN DEGREES, REAL*4
C     IERR     - .EQ. 0   IF NO PROBLEM
C                .GE. 1   IF THE REQUESTED XI,XJ POINT IS IN THE
C                         FORBIDDEN ZONE, I.E. OFF THE LAMBERT MAP
C                         IN THE OPEN SPACE WHERE THE CONE IS CUT.
C                  IF IERR.GE.1 THEN ALAT=999. AND ELON=999.
C
C   REMARKS: FORMULAE AND NOTATION LOOSELY BASED ON HOKE, HAYES,
C     AND RENNINGER'S "MAP PROJECTIONS AND GRID SYSTEMS...", MARCH 1981
C     AFGWC/TN-79/003
C
C ATTRIBUTES:
C   LANGUAGE: IBM VS FORTRAN
C   MACHINE:  NAS
C
C$$$
C
         LOGICAL NEWMAP
         DATA  RERTH /6.3712E+6/, PI/3.14159/, OLDRML/99999./
C
C        PRELIMINARY VARIABLES AND REDIFINITIONS
C
C        H = 1 FOR NORTHERN HEMISPHERE; = -1 FOR SOUTHERN
C
         IF(ALATAN.GT.0) THEN
           H = 1.
         ELSE
           H = -1.
         ENDIF
C
         PIBY2 = PI/2.
         RADPD = PI/180.0
         DEGPRD = 1./RADPD
         REBYDX = RERTH/DX
         ALATN1 = ALATAN * RADPD
         AN = H * SIN(ALATN1)
         COSLTN = COS(ALATN1)
C
C        MAKE SURE THAT INPUT LONGITUDE DOES NOT PASS THROUGH
C        THE CUT ZONE (FORBIDDEN TERRITORY) OF THE FLAT MAP
C        AS MEASURED FROM THE VERTICAL (REFERENCE) LONGITUDE
C
         ELON1L = ELON1
         IF((ELON1-ELONV).GT.180.)
     &     ELON1L = ELON1 - 360.
         IF((ELON1-ELONV).LT.(-180.))
     &     ELON1L = ELON1 + 360.
C
         ELONVR = ELONV * RADPD
C
C        RADIUS TO LOWER LEFT HAND (LL) CORNER
C
         ALA1 =  ALAT1 * RADPD
         RMLL = REBYDX * ((COSLTN**(1.-AN))*(1.+AN)**AN) *
     &           (((COS(ALA1))/(1.+H*SIN(ALA1)))**AN)/AN
C
C        USE RMLL TO TEST IF MAP AND GRID UNCHANGED FROM PREVIOUS
C        CALL TO THIS CODE.  THUS AVOID UNNEEDED RECOMPUTATIONS.
C
         IF(RMLL.EQ.OLDRML) THEN
           NEWMAP = .FALSE.
         ELSE
           NEWMAP = .TRUE.
           OLDRML = RMLL
C
C          USE LL POINT INFO TO LOCATE POLE POINT
C
           ELO1 = ELON1L * RADPD
           ARG = AN * (ELO1-ELONVR)
           POLEI = 1. - H * RMLL * SIN(ARG)
           POLEJ = 1. + RMLL * COS(ARG)
         ENDIF
C
C        RADIUS TO THE I,J POINT (IN GRID UNITS)
C              YY REVERSED SO POSITIVE IS DOWN
C
         XX = XI - POLEI
         YY = POLEJ - XJ
         R2 = XX**2 + YY**2
C
C        CHECK THAT THE REQUESTED I,J IS NOT IN THE FORBIDDEN ZONE
C           YY MUST BE POSITIVE UP FOR THIS TEST
C
         THETA = PI*(1.-AN)
         BETA = ABS(ATAN2(XX,-YY))
         IERR = 0
         IF(BETA.LE.THETA) THEN
           IERR = 1
           ALAT = 999.
           ELON = 999.
           IF(.NOT.NEWMAP)  RETURN
         ENDIF
C
C        NOW THE MAGIC FORMULAE
C
         IF(R2.EQ.0) THEN
           ALAT = H * 90.
           ELON = ELONV
         ELSE
C
C          FIRST THE LONGITUDE
C
           ELON = ELONV + DEGPRD * ATAN2(H*XX,YY)/AN
           ELON = AMOD(ELON+360., 360.)
C
C          NOW THE LATITUDE
C          RECALCULATE THE THING ONLY IF MAP IS NEW SINCE LAST TIME
C
           IF(NEWMAP) THEN
             ANINV = 1./AN
             ANINV2 = ANINV/2.
             THING = ((AN/REBYDX) ** ANINV)/
     &         ((COSLTN**((1.-AN)*ANINV))*(1.+ AN))
           ENDIF
           ALAT = H*(PIBY2 - 2.*ATAN(THING*(R2**ANINV2)))*DEGPRD
         ENDIF
C
C        FOLLOWING TO ASSURE ERROR VALUES IF FIRST TIME THRU
C         IS OFF THE MAP
C
         IF(IERR.NE.0) THEN
           ALAT = 999.
           ELON = 999.
           IERR = 2
         ENDIF
         RETURN
         END

