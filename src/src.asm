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
name_program_error_text db 'Far Cry 1 Cyrillic Fix by x0r1x v1.0.exe не найден. Убедитесь что у исполняемого файла фиксера вот такое название: Far Cry 1 Cyrillic Fix by x0r1x v1.0.exe. ', 0
name_program_error_name_message_box db 'Файл не найден', 0
error_handle_file_text db 'parameters.ini не найден. Чтобы исправить эту ошибку, создайте файл: parameters.ini', 0
error_handle_file_name_message_box db 'Файл не найден', 0
name_file db 'parameters.ini', 0
handle_file dd 0
buffer rb 256
buffer_size equ 256
bytes_read dd 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section '.text' code readable executable
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start:
        ; создаём файл
        push 0
        push FILE_ATTRIBUTE_NORMAL
        push OPEN_EXISTING
        push 0
        push FILE_SHARE_READ
        push GENERIC_READ
        push name_program
        call [CreateFileA]

        ; сохраняем дескриптор файла из eax в handle_file_program
        mov [handle_file_program], eax

        ; сравнение двух операндов на INVALID_HANDLE_VALUE
        cmp eax, INVALID_HANDLE_VALUE

        ; если операнды были равны, совершить короткий прыжок
        je name_program_error

        ; перенести дескриптор файла из eax в edx
        mov edx, eax

        ; закрываем хэндл файла программы
        mov edx, [handle_file_program]
        push edx
        call [CloseHandle]

        ; создаём файл
        push 0
        push FILE_ATTRIBUTE_NORMAL
        push OPEN_EXISTING
        push 0
        push FILE_SHARE_READ
        push GENERIC_READ
        push name_file
        call [CreateFileA]

        ; сохраняем дескриптор файла из eax в handle_file
        mov [handle_file], eax

        ; сравнение двух операндов на INVALID_HANDLE_VALUE
        cmp eax, INVALID_HANDLE_VALUE

        ; если операнды были равны, совершить короткий прыжок
        je error_handle_file

        ; перенести дескриптор файла из eax в edx
        mov edx, eax

        ; читаем файл
        push 0
        push bytes_read
        push buffer_size
        push buffer ; в "buffer" будет записан результат чтения
        push edx
        call [ReadFile]

        ; получаем индетификатор текущей раскладки клавиатуры в регистр eax
        push 0
        call [GetKeyboardLayout]

        ; сравниваем два операнда на значение английской раскладки клавиатуры
        cmp eax, 0x04090409

        ; если два операнда не равны совершить прыжок на функцию eax_eng
        jne eax_eng

        ; запускаем игру
        push 0
        push buffer
        call [WinExec]

        ; закрываем хэндл файла
        mov edx, [handle_file]
        push edx
        call [CloseHandle]

        ; обнуляем регистр eax
        xor eax, eax

        ; выходим из программы с возвратом eax
        push eax
        call [ExitProcess]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
name_program_error:
        ; вывод ошибки(Message Box)
        push MB_ICONERROR
        push name_program_error_name_message_box
        push name_program_error_text
        push 0
        call [MessageBoxA]

        ; обнуляем регистр eax
        xor eax, eax

        ; переносим число 1 в eax
        mov eax, 1

        ; выходим из программы с возвратом eax
        push eax
        call [ExitProcess]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
eax_eng:
        ; получаем дескриптор окна переднего плана в eax
        call [GetForegroundWindow]

        ; записываем дескриптор окна переднего плана в ebx
        mov ebx, eax

        ; меняем раскладку клавиатуры на английскую
        push 0x0409
        push 0x0002
        push 0x0050
        push ebx
        call [PostMessageA]

        ; запускаем игру
        push 0
        push buffer
        call [WinExec]

        ; обнуляем регистр eax
        xor eax, eax

        ; выходим из программы с возвратом eax
        push eax
        call [ExitProcess]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
error_handle_file:
        ; вывод ошибки(Message Box)
        push MB_ICONERROR
        push error_handle_file_name_message_box
        push error_handle_file_text
        push 0
        call [MessageBoxA]

        ; обнуляем регистр eax
        xor eax, eax

        ; переносим число 1 в eax
        mov eax, 1

        ; выходим из программы с возвратом eax
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