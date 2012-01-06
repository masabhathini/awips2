/*
** Generated by X-Designer
*/
/*
**LIBS: -lXm -lXt -lX11
*/

#include <X11/Xatom.h>
#include <X11/Intrinsic.h>
#include <X11/Shell.h>

#include <Xm/Xm.h>
#include <Xm/DialogS.h>
#include <Xm/Form.h>
#include <Xm/Frame.h>
#include <Xm/Label.h>
#include <Xm/List.h>
#include <Xm/PushB.h>
#include <Xm/RowColumn.h>
#include <Xm/ScrollBar.h>
#include <Xm/Separator.h>
#include <Xm/Text.h>
#include <Xm/CascadeBG.h>
#include <Xm/LabelG.h>


Widget geoareaDS = (Widget) NULL;
Widget geoareaFO = (Widget) NULL;
Widget geoareaOM = (Widget) NULL;
Widget geoareaLB1 = (Widget) NULL;
Widget geoarea_typesCB = (Widget) NULL;
Widget geoarea_typesPDM = (Widget) NULL;
Widget types_zonesPB = (Widget) NULL;
Widget types_countiesPB = (Widget) NULL;
Widget types_basinsPB = (Widget) NULL;
Widget types_reservoirsPB = (Widget) NULL;
Widget geoarea_intLB = (Widget) NULL;
Widget geoareaLB2 = (Widget) NULL;
Widget geoareaLB3 = (Widget) NULL;
Widget geoareaLB4 = (Widget) NULL;
Widget geoareaSL = (Widget) NULL;
Widget geoareaHSB = (Widget) NULL;
Widget geoareaVSB = (Widget) NULL;
Widget geoareaLS = (Widget) NULL;
Widget geoarea_inoutFR = (Widget) NULL;
Widget geoarea_inoutFO = (Widget) NULL;
Widget area_fileLB = (Widget) NULL;
Widget area_fileTX = (Widget) NULL;
Widget area_importPB = (Widget) NULL;
Widget area_editPB = (Widget) NULL;
Widget area_readlog_importPB = (Widget) NULL;
Widget geoarea_inoutLB = (Widget) NULL;
Widget geoarea_okPB = (Widget) NULL;
Widget geolineDS = (Widget) NULL;
Widget geolineFO = (Widget) NULL;
Widget geolineOM = (Widget) NULL;
Widget geolineLB1 = (Widget) NULL;
Widget geolineCB = (Widget) NULL;
Widget geolinePDM = (Widget) NULL;
Widget types_riversPB = (Widget) NULL;
Widget types_streamsPB = (Widget) NULL;
Widget types_SP1 = (Widget) NULL;
Widget types_hiwaysPB = (Widget) NULL;
Widget types_roadsPB = (Widget) NULL;
Widget geoline_inoutFO = (Widget) NULL;
Widget line_fileTX = (Widget) NULL;
Widget line_importPB = (Widget) NULL;
Widget line_fileLB = (Widget) NULL;
Widget line_editPB = (Widget) NULL;
Widget geoline_okPB = (Widget) NULL;
Widget line_readlog_importPB = (Widget) NULL;
Widget geo_logviewDS = (Widget) NULL;
Widget geo_logviewFO = (Widget) NULL;
Widget geo_logviewST = (Widget) NULL;
Widget geo_viewlogHSB = (Widget) NULL;
Widget geo_logviewVSB = (Widget) NULL;
Widget geo_logviewTX = (Widget) NULL;
Widget geo_logview_okPB = (Widget) NULL;
Widget geo_logviewLB = (Widget) NULL;



void create_geoareaDS (parent)
Widget parent;
{
	Widget children[8];      /* Children to manage */
	Arg al[64];                    /* Arg List */
	register int ac = 0;           /* Arg Count */
	XmString xmstrings[16];    /* temporary storage for XmStrings */

	XtSetArg(al[ac], XmNheight, 490); ac++;
	XtSetArg(al[ac], XmNallowShellResize, TRUE); ac++;
	XtSetArg(al[ac], XmNtitle, "Areal Definitions"); ac++;
	XtSetArg(al[ac], XmNminWidth, 680); ac++;
	XtSetArg(al[ac], XmNminHeight, 490); ac++;
	XtSetArg(al[ac], XmNmaxWidth, 680); ac++;
	XtSetArg(al[ac], XmNmaxHeight, 490); ac++;
	geoareaDS = XmCreateDialogShell ( parent, "geoareaDS", al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNheight, 490); ac++;
	XtSetArg(al[ac], XmNautoUnmanage, FALSE); ac++;
	geoareaFO = XmCreateForm ( geoareaDS, "geoareaFO", al, ac );
	ac = 0;
	xmstrings[0] = XmStringCreateLtoR("List:", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG);
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	geoareaOM = XmCreateOptionMenu ( geoareaFO, "geoareaOM", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	geoareaLB1 = XmOptionLabelGadget ( geoareaOM );
	geoarea_typesCB = XmOptionButtonGadget ( geoareaOM );
	geoarea_typesPDM = XmCreatePulldownMenu ( geoareaOM, "geoarea_typesPDM", al, ac );
	xmstrings[0] = XmStringCreateLtoR ( "Zones", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	types_zonesPB = XmCreatePushButton ( geoarea_typesPDM, "types_zonesPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "Counties", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	types_countiesPB = XmCreatePushButton ( geoarea_typesPDM, "types_countiesPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "Basins", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	types_basinsPB = XmCreatePushButton ( geoarea_typesPDM, "types_basinsPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "Reservoirs", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	types_reservoirsPB = XmCreatePushButton ( geoarea_typesPDM, "types_reservoirsPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "Interior", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	geoarea_intLB = XmCreateLabel ( geoareaFO, "geoarea_intLB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "Area Id  Name", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	geoareaLB2 = XmCreateLabel ( geoareaFO, "geoareaLB2", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "Lat", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	geoareaLB3 = XmCreateLabel ( geoareaFO, "geoareaLB3", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "Lon", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	geoareaLB4 = XmCreateLabel ( geoareaFO, "geoareaLB4", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNlistSizePolicy, XmRESIZE_IF_POSSIBLE); ac++;
	geoareaLS = XmCreateScrolledList ( geoareaFO, "geoareaLS", al, ac );
	ac = 0;
	geoareaSL = XtParent ( geoareaLS );

	XtSetArg(al[ac], XmNhorizontalScrollBar, &geoareaHSB); ac++;
	XtSetArg(al[ac], XmNverticalScrollBar, &geoareaVSB); ac++;
	XtGetValues(geoareaSL, al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNlistSizePolicy, XmRESIZE_IF_POSSIBLE); ac++;
	XtSetValues ( geoareaLS,al, ac );
	ac = 0;
	geoarea_inoutFR = XmCreateFrame ( geoareaFO, "geoarea_inoutFR", al, ac );
	geoarea_inoutFO = XmCreateForm ( geoarea_inoutFR, "geoarea_inoutFO", al, ac );
	xmstrings[0] = XmStringCreateLtoR ( "Source Data File:", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	area_fileLB = XmCreateLabel ( geoarea_inoutFO, "area_fileLB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	area_fileTX = XmCreateText ( geoarea_inoutFO, "area_fileTX", al, ac );
	xmstrings[0] = XmStringCreateLtoR ( "Create Binary Files\nImport to Database", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_CENTER); ac++;
	area_importPB = XmCreatePushButton ( geoarea_inoutFO, "area_importPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "Edit File", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	area_editPB = XmCreatePushButton ( geoarea_inoutFO, "area_editPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "Review Log", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	area_readlog_importPB = XmCreatePushButton ( geoarea_inoutFO, "area_readlog_importPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNchildType, XmFRAME_TITLE_CHILD); ac++;
	xmstrings[0] = XmStringCreateLtoR ( "Import Operations ", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	geoarea_inoutLB = XmCreateLabel ( geoarea_inoutFR, "geoarea_inoutLB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "OK", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	geoarea_okPB = XmCreatePushButton ( geoareaFO, "geoarea_okPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );


	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -41); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -286); ac++;
	XtSetValues ( geoareaOM,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 25); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 460); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_NONE); ac++;
	XtSetValues ( geoarea_intLB,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 50); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 9); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_NONE); ac++;
	XtSetValues ( geoareaLB2,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 51); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 429); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_NONE); ac++;
	XtSetValues ( geoareaLB3,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 50); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 512); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_NONE); ac++;
	XtSetValues ( geoareaLB4,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 75); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -270); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, 10); ac++;
	XtSetValues ( geoareaSL,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 280); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -435); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -670); ac++;
	XtSetValues ( geoarea_inoutFR,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 445); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -475); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -95); ac++;
	XtSetValues ( geoarea_okPB,al, ac );
	ac = 0;
	children[ac++] = types_zonesPB;
	children[ac++] = types_countiesPB;
	children[ac++] = types_basinsPB;
	children[ac++] = types_reservoirsPB;
	XtManageChildren(children, ac);
	ac = 0;
	XtSetArg(al[ac], XmNsubMenuId, geoarea_typesPDM); ac++;
	XtSetValues(geoarea_typesCB, al, ac );
	ac = 0;
	XtManageChild(geoareaLS);

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 10); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -35); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -160); ac++;
	XtSetValues ( area_fileLB,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 37); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -200); ac++;
	XtSetValues ( area_fileTX,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 35); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -90); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 225); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -410); ac++;
	XtSetValues ( area_importPB,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 80); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -115); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -130); ac++;
	XtSetValues ( area_editPB,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 35); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -90); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 440); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -630); ac++;
	XtSetValues ( area_readlog_importPB,al, ac );
	ac = 0;
	children[ac++] = area_fileLB;
	children[ac++] = area_fileTX;
	children[ac++] = area_importPB;
	children[ac++] = area_editPB;
	children[ac++] = area_readlog_importPB;
	XtManageChildren(children, ac);
	ac = 0;
	children[ac++] = geoarea_inoutFO;
	children[ac++] = geoarea_inoutLB;
	XtManageChildren(children, ac);
	ac = 0;
	children[ac++] = geoareaOM;
	children[ac++] = geoarea_intLB;
	children[ac++] = geoareaLB2;
	children[ac++] = geoareaLB3;
	children[ac++] = geoareaLB4;
	children[ac++] = geoarea_inoutFR;
	children[ac++] = geoarea_okPB;
	XtManageChildren(children, ac);
	ac = 0;
}


void create_geolineDS (parent)
Widget parent;
{
	Widget children[6];      /* Children to manage */
	Arg al[64];                    /* Arg List */
	register int ac = 0;           /* Arg Count */
	XmString xmstrings[16];    /* temporary storage for XmStrings */

	XtSetArg(al[ac], XmNwidth, 520); ac++;
	XtSetArg(al[ac], XmNheight, 250); ac++;
	XtSetArg(al[ac], XmNallowShellResize, TRUE); ac++;
	XtSetArg(al[ac], XmNtitle, "Vector Definitions"); ac++;
	XtSetArg(al[ac], XmNminWidth, 520); ac++;
	XtSetArg(al[ac], XmNminHeight, 250); ac++;
	XtSetArg(al[ac], XmNmaxWidth, 520); ac++;
	XtSetArg(al[ac], XmNmaxHeight, 250); ac++;
	geolineDS = XmCreateDialogShell ( parent, "geolineDS", al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNwidth, 570); ac++;
	XtSetArg(al[ac], XmNheight, 350); ac++;
	XtSetArg(al[ac], XmNautoUnmanage, FALSE); ac++;
	geolineFO = XmCreateForm ( geolineDS, "geolineFO", al, ac );
	ac = 0;
	xmstrings[0] = XmStringCreateLtoR("Manage:", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG);
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	geolineOM = XmCreateOptionMenu ( geolineFO, "geolineOM", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	geolineLB1 = XmOptionLabelGadget ( geolineOM );
	geolineCB = XmOptionButtonGadget ( geolineOM );
	geolinePDM = XmCreatePulldownMenu ( geolineOM, "geolinePDM", al, ac );
	xmstrings[0] = XmStringCreateLtoR ( "Rivers", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	types_riversPB = XmCreatePushButton ( geolinePDM, "types_riversPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "Streams", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	types_streamsPB = XmCreatePushButton ( geolinePDM, "types_streamsPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	types_SP1 = XmCreateSeparator ( geolinePDM, "types_SP1", al, ac );
	xmstrings[0] = XmStringCreateLtoR ( "Highways", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	types_hiwaysPB = XmCreatePushButton ( geolinePDM, "types_hiwaysPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "Roads", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	types_roadsPB = XmCreatePushButton ( geolinePDM, "types_roadsPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNwidth, 520); ac++;
	XtSetArg(al[ac], XmNheight, 180); ac++;
	geoline_inoutFO = XmCreateForm ( geolineFO, "geoline_inoutFO", al, ac );
	ac = 0;
	line_fileTX = XmCreateText ( geoline_inoutFO, "line_fileTX", al, ac );
	xmstrings[0] = XmStringCreateLtoR ( "Create Binary Files", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_CENTER); ac++;
	line_importPB = XmCreatePushButton ( geoline_inoutFO, "line_importPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "Source Data File:", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	line_fileLB = XmCreateLabel ( geoline_inoutFO, "line_fileLB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "Edit File", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	line_editPB = XmCreatePushButton ( geoline_inoutFO, "line_editPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "OK", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	geoline_okPB = XmCreatePushButton ( geoline_inoutFO, "geoline_okPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "Review Log", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	line_readlog_importPB = XmCreatePushButton ( geoline_inoutFO, "line_readlog_importPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );


	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -45); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -245); ac++;
	XtSetValues ( geolineOM,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 65); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -230); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 15); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -505); ac++;
	XtSetValues ( geoline_inoutFO,al, ac );
	ac = 0;
	children[ac++] = types_riversPB;
	children[ac++] = types_streamsPB;
	children[ac++] = types_SP1;
	children[ac++] = types_hiwaysPB;
	children[ac++] = types_roadsPB;
	XtManageChildren(children, ac);
	ac = 0;
	XtSetArg(al[ac], XmNsubMenuId, geolinePDM); ac++;
	XtSetValues(geolineCB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 15); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -50); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 165); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -330); ac++;
	XtSetValues ( line_fileTX,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 70); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -105); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 15); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -230); ac++;
	XtSetValues ( line_importPB,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 20); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -45); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 15); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -145); ac++;
	XtSetValues ( line_fileLB,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 15); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -50); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 350); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -475); ac++;
	XtSetValues ( line_editPB,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 125); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -155); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 15); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -100); ac++;
	XtSetValues ( geoline_okPB,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 70); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -105); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 275); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -475); ac++;
	XtSetValues ( line_readlog_importPB,al, ac );
	ac = 0;
	children[ac++] = line_fileTX;
	children[ac++] = line_importPB;
	children[ac++] = line_fileLB;
	children[ac++] = line_editPB;
	children[ac++] = geoline_okPB;
	children[ac++] = line_readlog_importPB;
	XtManageChildren(children, ac);
	ac = 0;
	children[ac++] = geolineOM;
	children[ac++] = geoline_inoutFO;
	XtManageChildren(children, ac);
	ac = 0;
}


void create_geo_logviewDS (parent)
Widget parent;
{
	Widget children[3];      /* Children to manage */
	Arg al[64];                    /* Arg List */
	register int ac = 0;           /* Arg Count */
	XmString xmstrings[16];    /* temporary storage for XmStrings */

	XtSetArg(al[ac], XmNallowShellResize, TRUE); ac++;
	XtSetArg(al[ac], XmNtitle, "Geo Data Import Log"); ac++;
	XtSetArg(al[ac], XmNminWidth, 900); ac++;
	XtSetArg(al[ac], XmNminHeight, 460); ac++;
	XtSetArg(al[ac], XmNmaxWidth, 900); ac++;
	XtSetArg(al[ac], XmNmaxHeight, 460); ac++;
	geo_logviewDS = XmCreateDialogShell ( parent, "geo_logviewDS", al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNautoUnmanage, FALSE); ac++;
	geo_logviewFO = XmCreateForm ( geo_logviewDS, "geo_logviewFO", al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNeditable, FALSE); ac++;
	XtSetArg(al[ac], XmNeditMode, XmMULTI_LINE_EDIT); ac++;
	geo_logviewTX = XmCreateScrolledText ( geo_logviewFO, "geo_logviewTX", al, ac );
	ac = 0;
	geo_logviewST = XtParent ( geo_logviewTX );

	XtSetArg(al[ac], XmNhorizontalScrollBar, &geo_viewlogHSB); ac++;
	XtSetArg(al[ac], XmNverticalScrollBar, &geo_logviewVSB); ac++;
	XtGetValues(geo_logviewST, al, ac );
	ac = 0;
	xmstrings[0] = XmStringCreateLtoR ( "OK", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	geo_logview_okPB = XmCreatePushButton ( geo_logviewFO, "geo_logview_okPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "Log of import for dataset", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_BEGINNING); ac++;
	geo_logviewLB = XmCreateLabel ( geo_logviewFO, "geo_logviewLB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );


	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 30); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -425); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -890); ac++;
	XtSetValues ( geo_logviewST,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 425); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -110); ac++;
	XtSetValues ( geo_logview_okPB,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -30); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -885); ac++;
	XtSetValues ( geo_logviewLB,al, ac );
	ac = 0;
	XtManageChild(geo_logviewTX);
	children[ac++] = geo_logview_okPB;
	children[ac++] = geo_logviewLB;
	XtManageChildren(children, ac);
	ac = 0;
}

