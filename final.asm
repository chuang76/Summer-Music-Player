.386 
.model flat, stdcall 
option casemap:none 

WinMain proto :dword, :dword, :dword, :dword
WndProc proto :dword, :dword, :dword, :dword 
Multimedia proto :dword, :dword, :dword, :dword 
PlayMp3File proto :dword, :dword 

include C:\masm32\include\windows.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\comctl32.inc
include C:\masm32\include\gdi32.inc
include C:\masm32\include\winmm.inc

includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\comctl32.lib
includelib C:\masm32\lib\gdi32.lib
includelib C:\masm32\lib\winmm.lib

RGB macro red,green,blue 
    xor eax, eax 
    mov ah, blue 
    shl eax, 8 
    mov ah, green 
    mov al, red 
endm

.const 		
	ButtonEarthID   equ  		1					; button for main window
	ButtonMarsID    equ  		2
	ButtonJupID     equ  		3

	ID_LIST1 	equ  		101					; button for dialog box 
	ID_BUTTON1 	equ  		201
   	ID_BUTTON2 	equ  		202
	ID_BUTTON3 	equ  		203
	ID_SHOWPATH 	equ  		1000

.data?
	hInstance 	HINSTANCE 		?
	CommandLine 	LPSTR 			?
	hEarthButton   	HWND        		?			; handle of button 
	hMarsButton     HWND        		?
	hJupButton      HWND        		? 
	icex 		INITCOMMONCONTROLSEX 	<>

.data 
	ClassName 		db 	"test", 0
	AppName 		db 	"Summer Music Player", 0
	ButtonClassName 	db 	"button", 0
	dlgname 		db 	"MAINSCREEN", 0

	BorderText     		db  	"==============================================", 0
	ProjectText     	db  	"< Summer Music Player >", 0
	WelcomeText     	db  	"Weclome !", 0
	WelcomeText2    	db  	"You get the Free Space tickets !", 0
	WelcomeText3    	db  	"Which planet will you visit ?", 0
   	VersionText     	db  	"Version: v1.2      Date: June 12, 2019", 0

	Earth_title     	db 	"Exit to Earth", 0
	Earth_text      	db  	"Are you sure to leave ? ", 0
	
	Mars_title 		db  	"Welcome to Mars :)", 0
	Mars_text    		db  	"We hope you enjoyed journey through sound...", 0
	Stop_text 		db 	"Want to stop ? ", 0
		
	Start_song      	db  	"start.wav", 0
	First_song      	db  	"nujabes.wav", 0
		
	msg1    		db  	"Exit to Earth", 0			; msg on button 
	msg2    		db  	"Fly to Mars", 0
   	msg3    		db  	"Fly to Jupiter", 0

	Mp3DeviceID 		dd 	0
	PlayFlag 		dd 	0 
	Mp3Files 		db 	"*.mp3", 125 dup (0)
	Mp3Device 		db 	"MPEGVideo", 0
	FileName 		db 	128 dup (0)
    
.code 
start: 
	invoke GetModuleHandle, NULL 
	mov hInstance, eax 

	invoke GetCommandLine 
	mov CommandLine, eax 

	invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
	invoke ExitProcess, eax 

; =============================================================================================================

WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:dword 

	local wc:WNDCLASSEX 
	local msg:MSG 
	local hwnd:HWND 						; handle 

	mov wc.cbSize, sizeof WNDCLASSEX 				
	mov wc.style, CS_HREDRAW or CS_VREDRAW 
	mov wc.lpfnWndProc, offset WndProc 				; main window 
	mov wc.cbClsExtra, NULL 
	mov wc.cbWndExtra, NULL 

	push hInst 
	pop wc.hInstance

	mov wc.hbrBackground, COLOR_GRAYTEXT + 1 or COLOR_BTNFACE + 1			
	mov wc.lpszMenuName, NULL 
	mov wc.lpszClassName, offset ClassName

	invoke LoadIcon, NULL, IDI_APPLICATION 				
	mov wc.hIcon, eax 
	mov wc.hIconSm, eax 

	invoke LoadCursor, NULL, IDC_ARROW 					
	mov wc.hCursor, eax 

	invoke RegisterClassEx, addr wc 				; register 

	invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr ClassName, \
		addr AppName, WS_VISIBLE or WS_OVERLAPPED or WS_SYSMENU, \
        100, 100, 610, 480, \
        NULL, NULL, hInst, NULL 

    mov hwnd, eax 
    invoke ShowWindow, hwnd, SW_SHOWNORMAL 
    invoke UpdateWindow, hwnd 

    .while TRUE 
    	invoke GetMessage, addr msg, NULL, 0, 0
    	.break .if (!eax)
    	invoke TranslateMessage, addr msg 
    	invoke DispatchMessage, addr msg 
    .endw 

    mov eax, msg.wParam 
    ret 
WinMain endp 

; =============================================================================================================

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 

 	local hdc:HDC 
 	local ps:PAINTSTRUCT 

 	.if uMsg == WM_DESTROY 
 		invoke PostQuitMessage, NULL 

 	.elseif uMsg == WM_PAINT 
 		invoke BeginPaint, hWnd, addr ps 
 		mov hdc, eax 

 		RGB    255, 255, 153
        invoke SetTextColor, hdc, eax 

        RGB    109, 109, 109
        invoke SetBkColor, hdc, eax 

 		invoke TextOut, hdc, 120, 50, addr BorderText, sizeof BorderText - 1
		invoke TextOut, hdc, 190, 100, addr ProjectText, sizeof ProjectText - 1
		invoke TextOut, hdc, 190, 130, addr WelcomeText, sizeof WelcomeText - 1
		invoke TextOut, hdc, 190, 160, addr WelcomeText2, sizeof WelcomeText2 - 1
		invoke TextOut, hdc, 190, 190, addr WelcomeText3, sizeof WelcomeText3 - 1
		invoke TextOut, hdc, 120, 240, addr BorderText, sizeof BorderText - 1  		
		invoke TextOut, hdc, 170, 290, addr VersionText, sizeof VersionText - 1 		
		invoke EndPaint, hWnd, addr ps 

 	.elseif uMsg == WM_CREATE
 		invoke CreateWindowEx, NULL, addr ButtonClassName, addr msg1, \
        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, 40, 350, 150, 30, hWnd, ButtonEarthID, hInstance, NULL
		mov hEarthButton, eax

		invoke CreateWindowEx, NULL, addr ButtonClassName, addr msg2, \
        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, 220, 350, 150, 30, hWnd, ButtonMarsID, hInstance, NULL
		mov hMarsButton, eax

		invoke CreateWindowEx, NULL, addr ButtonClassName, addr msg3, \
        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, 400, 350, 150, 30, hWnd, ButtonJupID, hInstance, NULL
		mov hJupButton, eax

 	.elseif uMsg == WM_COMMAND 
 		mov edx, wParam
 		.if lParam == 0
 			ret 
 		.else
			.if dx == ButtonEarthID 
				jmp earth 
			.elseif dx == ButtonMarsID 
				jmp mars 
			.else 
				jmp jupiter 
			.endif 
		.endif 
	.else 
 		invoke DefWindowProc, hWnd, uMsg, wParam, lParam
 		ret 
		
 	.endif 
	
	xor eax, eax 
 	ret

earth: 
	invoke MessageBox, NULL, offset Earth_text, offset Earth_title, MB_YESNO or MB_ICONQUESTION
	.if eax == IDYES 
		invoke DestroyWindow, hWnd 
	.endif 
	ret 

mars:
	invoke PlaySound, offset Start_song, NULL, SND_FILENAME or SND_ASYNC
	invoke MessageBox, NULL, offset Mars_text, offset Mars_title, MB_YESNO
	.if eax == IDYES 
		invoke PlaySound, offset First_song, NULL, SND_FILENAME or SND_ASYNC
		invoke MessageBox, NULL, offset Stop_text, offset Mars_title, MB_OK
		.if eax == IDOK 
			invoke PlaySound, NULL, NULL, SND_ASYNC
			ret
		.endif 
	.elseif eax == IDNO
		ret 
	.endif 
    ret 

jupiter: 
	mov icex.dwSize, sizeof INITCOMMONCONTROLSEX
	invoke InitCommonControlsEx, addr icex 
	invoke CreateDialogParam, hInstance, addr dlgname, hWnd, addr Multimedia, NULL
	ret 

WndProc endp 

; =============================================================================================================

Multimedia proc hWin:dword, uMsg:dword, aParam:dword, bParam:dword 

	.if uMsg == WM_INITDIALOG 

		; para: HWND  hDlg, LPSTR lpPathSpec (*.mp3) , int nIDListBox, int nIDStaticPath, UINT uFileType
		invoke DlgDirList, hWin, addr Mp3Files, ID_LIST1, ID_SHOWPATH, DDL_DIRECTORY or DDL_DRIVES 

		; when the new string is selected, the list box removes the highlight from the previously selected string.
		invoke SendDlgItemMessage, hWin, ID_LIST1, LB_SETCURSEL, 0, 0 	

		invoke SendDlgItemMessage, hWin, ID_LIST1, LB_GETTEXT, eax, addr FileName     ; get string from the list box 
		invoke SetFocus, hWin    	; set the keyboard focus on the specified window 

	.elseif uMsg == WM_COMMAND
		mov eax, aParam 

		.if eax == ID_BUTTON1 			; play button	
			.if PlayFlag == 0
				mov PlayFlag, 1 
				invoke SendDlgItemMessage, hWin, ID_LIST1, LB_GETCURSEL, 0, 0
				invoke SendDlgItemMessage, hWin, ID_LIST1, LB_GETTEXT, eax, addr FileName
				invoke PlayMp3File, hWin, addr FileName 
			.endif 

		.elseif eax == ID_BUTTON2 		; stop button 
			invoke mciSendCommand, Mp3DeviceID, MCI_CLOSE, 0, 0
			mov PlayFlag, 0 

		.elseif eax == ID_BUTTON3		; close button (close the dialog box)
			invoke SendMessage, hWin, WM_CLOSE, NULL, NULL 

		.endif 
		
		and eax, 0FFFFh 

		.if eax == ID_LIST1 
			mov eax, aParam 
			shr eax, 16 

			.if eax == LBN_DBLCLK 		; double click 
				invoke DlgDirSelectEx, hWin, addr Mp3Files, 128, ID_LIST1
				invoke DlgDirList, hWin, addr Mp3Files, ID_LIST1, ID_SHOWPATH, DDL_DIRECTORY or DDL_DRIVES
				invoke SendDlgItemMessage, hWin, ID_LIST1, LB_SETCURSEL, 0, 0
			.endif 
		.endif 

	.elseif uMsg == WM_CLOSE
		invoke EndDialog, hWin, NULL 	; close the dialog box 

	.elseif uMsg == MM_MCINOTIFY 
		invoke mciSendCommand, Mp3DeviceID, MCI_CLOSE, 0, 0				
		mov PlayFlag, 0

	.endif

	xor eax, eax 
	ret 

Multimedia endp 

; ====================================================================================================================

PlayMp3File proc hWin:dword, NameOfFile:dword 

	local mciOpenParms:MCI_OPEN_PARMS, mciPlayParms:MCI_PLAY_PARMS

	; para: LPHMIDIIN lphMidiIn, UINT uDeviceID, DWORD_PTR dwCallback, DWORD_PTR dwCallbackInstance, DWORD dwFlags

	mov eax, hWin
	mov mciPlayParms.dwCallback, eax 

	mov eax, offset Mp3Device 
	mov mciOpenParms.lpstrDeviceType, eax 

	mov eax, NameOfFile 
	mov mciOpenParms.lpstrElementName, eax 

	invoke mciSendCommand, 0, MCI_OPEN, MCI_OPEN_TYPE or MCI_OPEN_ELEMENT, addr mciOpenParms

	mov eax, mciOpenParms.wDeviceID 
	mov Mp3DeviceID, eax 
	invoke mciSendCommand, Mp3DeviceID, MCI_PLAY, MCI_NOTIFY, addr mciPlayParms
	ret 

PlayMp3File endp 

end start 
