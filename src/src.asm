;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Project: Far Cry 1 Cyrillic Fix(https://github.com/THE-X0R1X/far_cry_1_cyrillic_fix).            ;
; Version: 1.0.                                                                                    ;
; File: fc1cf.asm                                                                                  ;
;                                                                                                  ;
; Author: x0r1x(https://github.com/THE-X0R1X).                                                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

format PE GUI 4.0

entry start

include 'win32a.inc'

section '.data' data readable writeable
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
name_program db 'Far Cry 1 Cyrillic Fix by x0r1x v1.0.exe', 0
handle_file_program dd 0
name_program_error_text db 'Far Cry 1 Cyrillic Fix by x0r1x v1.0.exe �� ������. ��������� ��� � ������������ ����� ������� ��� ����� ��������: Far Cry 1 Cyrillic Fix by x0r1x v1.0.exe. ', 0
name_program_error_name_message_box db '���� �� ������', 0
error_handle_file_text db 'parameters.ini �� ������. ����� ��������� ��� ������, �������� ����: parameters.ini', 0
error_handle_file_name_message_box db '���� �� ������', 0
name_file db 'parameters.ini', 0
handle_file dd 0
buffer rb 256
buffer_size equ 256
bytes_read dd 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section '.text' code readable executable
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start:
        ; ������ ����
        push 0
        push FILE_ATTRIBUTE_NORMAL
        push OPEN_EXISTING
        push 0
        push FILE_SHARE_READ
        push GENERIC_READ
        push name_program
        call [CreateFileA]

        ; ��������� ���������� ����� �� eax � handle_file_program
        mov [handle_file_program], eax

        ; ��������� ���� ��������� �� INVALID_HANDLE_VALUE
        cmp eax, INVALID_HANDLE_VALUE

        ; ���� �������� ���� �����, ��������� �������� ������
        je name_program_error

        ; ��������� ���������� ����� �� eax � edx
        mov edx, eax

        ; ��������� ����� ����� ���������
        mov edx, [handle_file_program]
        push edx
        call [CloseHandle]

        ; ������ ����
        push 0
        push FILE_ATTRIBUTE_NORMAL
        push OPEN_EXISTING
        push 0
        push FILE_SHARE_READ
        push GENERIC_READ
        push name_file
        call [CreateFileA]

        ; ��������� ���������� ����� �� eax � handle_file
        mov [handle_file], eax

        ; ��������� ���� ��������� �� INVALID_HANDLE_VALUE
        cmp eax, INVALID_HANDLE_VALUE

        ; ���� �������� ���� �����, ��������� �������� ������
        je error_handle_file

        ; ��������� ���������� ����� �� eax � edx
        mov edx, eax

        ; ������ ����
        push 0
        push bytes_read
        push buffer_size
        push buffer ; � "buffer" ����� ������� ��������� ������
        push edx
        call [ReadFile]

        ; �������� ������������� ������� ��������� ���������� � ������� eax
        push 0
        call [GetKeyboardLayout]

        ; ���������� ��� �������� �� �������� ���������� ��������� ����������
        cmp eax, 0x04090409

        ; ���� ��� �������� �� ����� ��������� ������ �� ������� eax_eng
        jne eax_eng

        ; ��������� ����
        push 0
        push buffer
        call [WinExec]

        ; ��������� ����� �����
        mov edx, [handle_file]
        push edx
        call [CloseHandle]

        ; �������� ������� eax
        xor eax, eax

        ; ������� �� ��������� � ��������� eax
        push eax
        call [ExitProcess]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
name_program_error:
        ; ����� ������(Message Box)
        push MB_ICONERROR
        push name_program_error_name_message_box
        push name_program_error_text
        push 0
        call [MessageBoxA]

        ; �������� ������� eax
        xor eax, eax

        ; ��������� ����� 1 � eax
        mov eax, 1

        ; ������� �� ��������� � ��������� eax
        push eax
        call [ExitProcess]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
eax_eng:
        ; �������� ���������� ���� ��������� ����� � eax
        call [GetForegroundWindow]

        ; ���������� ���������� ���� ��������� ����� � ebx
        mov ebx, eax

        ; ������ ��������� ���������� �� ����������
        push 0x0409
        push 0x0002
        push 0x0050
        push ebx
        call [PostMessageA]

        ; ��������� ����
        push 0
        push buffer
        call [WinExec]

        ; �������� ������� eax
        xor eax, eax

        ; ������� �� ��������� � ��������� eax
        push eax
        call [ExitProcess]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
error_handle_file:
        ; ����� ������(Message Box)
        push MB_ICONERROR
        push error_handle_file_name_message_box
        push error_handle_file_text
        push 0
        call [MessageBoxA]

        ; �������� ������� eax
        xor eax, eax

        ; ��������� ����� 1 � eax
        mov eax, 1

        ; ������� �� ��������� � ��������� eax
        push eax
        call [ExitProcess]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section '.idata' import data readable
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
library kernel32, 'kernel32.dll', \
        user32, 'user32.dll'

import kernel32, \
       CreateFileA, 'CreateFileA', \
       ReadFile, 'ReadFile', \
       WinExec, 'WinExec', \
       CloseHandle, 'CloseHandle', \
       ExitProcess, 'ExitProcess'

import user32, \
       MessageBoxA, 'MessageBoxA', \
       GetKeyboardLayout, 'GetKeyboardLayout', \
       GetForegroundWindow, 'GetForegroundWindow', \
       PostMessageA, 'PostMessageA'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;