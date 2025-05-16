forward
global type w_main from window
end type
type cb_pdf_to_blob_to_text from commandbutton within w_main
end type
type st_msg from statictext within w_main
end type
type cb_pdf_to_text from commandbutton within w_main
end type
type wb_1 from webbrowser within w_main
end type
type p_1 from picture within w_main
end type
type st_infocopyright from statictext within w_main
end type
type st_myversion from statictext within w_main
end type
type st_platform from statictext within w_main
end type
type sle_file from singlelineedit within w_main
end type
type st_file from statictext within w_main
end type
type cb_openfile from commandbutton within w_main
end type
type r_2 from rectangle within w_main
end type
end forward

global type w_main from window
integer width = 4631
integer height = 3368
boolean titlebar = true
string title = "PowerBuilder PDF Extractor"
boolean controlmenu = true
boolean minbox = true
string icon = "AppIcon!"
boolean center = true
cb_pdf_to_blob_to_text cb_pdf_to_blob_to_text
st_msg st_msg
cb_pdf_to_text cb_pdf_to_text
wb_1 wb_1
p_1 p_1
st_infocopyright st_infocopyright
st_myversion st_myversion
st_platform st_platform
sle_file sle_file
st_file st_file
cb_openfile cb_openfile
r_2 r_2
end type
global w_main w_main

type prototypes
Function boolean QueryPerformanceFrequency ( &
	Ref Double lpFrequency &
	) Library "kernel32.dll"

Function boolean QueryPerformanceCounter ( &
	Ref Double lpPerformanceCount &
	) Library "kernel32.dll"

end prototypes

type variables
Double idbl_frequency = 0



end variables

forward prototypes
public function double wf_perfstart ()
public function double wf_perfstop (double adbl_start)
public subroutine wf_version (statictext ast_version, statictext ast_patform)
public function boolean wf_writefile (string as_filename, blob ab_data)
end prototypes

public function double wf_perfstart ();Double ldbl_start

If idbl_frequency = 0 Then
	QueryPerformanceFrequency(idbl_frequency)
End If

QueryPerformanceCounter(ldbl_start)

Return ldbl_start

end function

public function double wf_perfstop (double adbl_start);Double ldbl_stop, ldbl_elapsed

QueryPerformanceCounter(ldbl_stop)

If idbl_frequency > 0 Then
	ldbl_elapsed = (ldbl_stop - adbl_start) / idbl_frequency
End If

Return ldbl_elapsed

end function

public subroutine wf_version (statictext ast_version, statictext ast_patform);String ls_version, ls_platform
environment env
integer rtn

rtn = GetEnvironment(env)

IF rtn <> 1 THEN 
	ls_version = string(year(today()))
	ls_platform="32"
ELSE
	ls_version = "20"+ string(env.pbmajorrevision)+ "." + string(env.pbbuildnumber)
	ls_platform=string(env.ProcessBitness)
END IF

ls_platform += " Bits"

ast_version.text=ls_version
ast_patform.text=ls_platform

end subroutine

public function boolean wf_writefile (string as_filename, blob ab_data);// --------------------------------------------------------------------------------------
// SCRIPT:     wf_WriteFile
//
// PURPOSE:    This function writes a blob to a file on disk.
//
// ARGUMENTS:  as_filename		- The name of the file
//					   ab_ata				- The blob data of the file
//
// RETURN:     True = Success, False = Failure
//
// DATE			PROG/ID			DESCRIPTION OF CHANGE / REASON
// --------		-------------	-----------------------------------------------------------
// 24/01/2022	Ramón San Félix	Initial Creation
// --------------------------------------------------------------------------------------
Integer li_file

li_file = FileOpen(as_filename, StreamMode!, Write!)

IF li_file = - 1 THEN
	RETURN FALSE
END IF

FileWriteEx(li_file, ab_data)
FileClose(li_file)

RETURN TRUE
end function

on w_main.create
this.cb_pdf_to_blob_to_text=create cb_pdf_to_blob_to_text
this.st_msg=create st_msg
this.cb_pdf_to_text=create cb_pdf_to_text
this.wb_1=create wb_1
this.p_1=create p_1
this.st_infocopyright=create st_infocopyright
this.st_myversion=create st_myversion
this.st_platform=create st_platform
this.sle_file=create sle_file
this.st_file=create st_file
this.cb_openfile=create cb_openfile
this.r_2=create r_2
this.Control[]={this.cb_pdf_to_blob_to_text,&
this.st_msg,&
this.cb_pdf_to_text,&
this.wb_1,&
this.p_1,&
this.st_infocopyright,&
this.st_myversion,&
this.st_platform,&
this.sle_file,&
this.st_file,&
this.cb_openfile,&
this.r_2}
end on

on w_main.destroy
destroy(this.cb_pdf_to_blob_to_text)
destroy(this.st_msg)
destroy(this.cb_pdf_to_text)
destroy(this.wb_1)
destroy(this.p_1)
destroy(this.st_infocopyright)
destroy(this.st_myversion)
destroy(this.st_platform)
destroy(this.sle_file)
destroy(this.st_file)
destroy(this.cb_openfile)
destroy(this.r_2)
end on

event open;wf_version(st_myversion, st_platform)

sle_file.text = gs_dir+"Test.pdf"
wb_1.Navigate(sle_file.text)
end event

type cb_pdf_to_blob_to_text from commandbutton within w_main
integer x = 2542
integer y = 336
integer width = 411
integer height = 92
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Pdf to Blob"
end type

event clicked;Double ldbl_start, ldbl_elapsed
String ls_filename, ls_txt, ls_error, ls_pdf
blob lblb_text
boolean lb_write
nvo_pdfextractor ln_pdf

ln_pdf = CREATE nvo_pdfextractor

ldbl_start = wf_PerfStart()

ls_filename = trim(sle_file.text)

If right(upper(ls_filename), 3)<> "PDF" Then Return

lblb_text = ln_pdf.of_pdftoblob( ls_filename, 1, 1)

//Checks the result
If ln_pdf.il_ErrorType < 0 Then
	ls_error = ln_pdf.is_ErrorText + " Exception: "+ln_pdf.of_GetError()
	MessageBox("Failed", ls_error )
	Return
End If

ls_txt = gf_cambiar_extension(ls_filename, ".txt")
	
IF FileExists(ls_txt) THEN FileDelete(ls_txt)

lb_write =  wf_WriteFile(ls_txt, lblb_text)

IF lb_write = FALSE THEN
	MessageBox("Failed", "Error Escribiendo Archivo Txt." )
	Return
END IF	
	
ldbl_elapsed = wf_PerfStop(ldbl_start)	

sle_file.text = ls_txt 
wb_1.Navigate(ls_txt)

Destroy ln_pdf

st_msg.text = "TXT elapsed time: " + String(ldbl_elapsed, "#,##0.0000") + " seconds"

end event

type st_msg from statictext within w_main
integer x = 101
integer y = 3216
integer width = 2917
integer height = 56
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 553648127
boolean focusrectangle = false
end type

type cb_pdf_to_text from commandbutton within w_main
integer x = 2121
integer y = 336
integer width = 411
integer height = 92
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Pdf to Txt"
end type

event clicked;Double ldbl_start, ldbl_elapsed
integer li_pages
String ls_filename, ls_txt, ls_error, ls_pdf
nvo_pdfextractor ln_pdf

ln_pdf = CREATE nvo_pdfextractor

ldbl_start = wf_PerfStart()

ls_filename = trim(sle_file.text)

If right(upper(ls_filename), 3)<> "PDF" Then Return

ls_txt = gf_cambiar_extension(ls_filename, ".txt")
	
IF FileExists(ls_txt) THEN FileDelete(ls_txt)

li_pages = ln_pdf.of_pdftotxt( ls_filename, ls_txt, 1, 1)
	
ldbl_elapsed = wf_PerfStop(ldbl_start)	


//Checks the result
If ln_pdf.il_ErrorType < 0 Then
	ls_error = ln_pdf.is_ErrorText + " Exception: "+ln_pdf.of_GetError()
	MessageBox("Failed", ls_error )
	Return
End If

sle_file.text = ls_txt 
wb_1.Navigate(ls_txt)

Destroy ln_pdf

st_msg.text = "Pages "+string(li_pages)+" TXT elapsed time: " + String(ldbl_elapsed, "#,##0.0000") + " seconds"

end event

type wb_1 from webbrowser within w_main
integer x = 64
integer y = 472
integer width = 4489
integer height = 2712
end type

type p_1 from picture within w_main
integer x = 5
integer y = 4
integer width = 1253
integer height = 248
boolean originalsize = true
string picturename = "logo.jpg"
boolean focusrectangle = false
end type

type st_infocopyright from statictext within w_main
integer x = 3072
integer y = 3216
integer width = 1289
integer height = 56
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 553648127
string text = "Copyright © Ramón San Félix Ramón  rsrsystem.soft@gmail.com"
boolean focusrectangle = false
end type

type st_myversion from statictext within w_main
integer x = 4059
integer y = 60
integer width = 489
integer height = 84
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 33521664
string text = "Versión"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_platform from statictext within w_main
integer x = 4059
integer y = 148
integer width = 489
integer height = 84
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 33521664
string text = "Bits"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_file from singlelineedit within w_main
integer x = 251
integer y = 332
integer width = 1673
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_file from statictext within w_main
integer x = 73
integer y = 344
integer width = 169
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "File:"
boolean focusrectangle = false
end type

type cb_openfile from commandbutton within w_main
integer x = 1934
integer y = 332
integer width = 174
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "..."
end type

event clicked;integer li_rtn
string ls_path, ls_ruta
string  ls_current

ls_ruta= gs_dir
ls_current=GetCurrentDirectory ( )
li_rtn = GetFileOpenName ("Abrir",  sle_file.text, ls_path, "", "All Files (*.*),*.*") 
ChangeDirectory ( ls_current )

if li_rtn < 1 then 	sle_file.text = ""

wb_1.Navigate(sle_file.text)

end event

type r_2 from rectangle within w_main
long linecolor = 33554432
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 33521664
integer width = 4599
integer height = 260
end type

