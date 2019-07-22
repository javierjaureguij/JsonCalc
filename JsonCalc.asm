.MODEL small, STDCALL
.STACK 100h

.DATA


    ; --> CONSTANTES

    ; -----> ESTADOS:

    ; Generales:

    ESTADO_FINAL                      EQU         0
    ESTADO_INICIAL                    EQU         1   

    ; Cadenas:

    ESTADO_CADENA_INICIO              EQU         2 
    ESTADO_CADENA_CONTENIDO           EQU         3 
    ESTADO_CADENA_FIN                 EQU         4 

    ; Números:

    ESTADO_SIGUIENTE_DIGITO           EQU         5
    
    ; Operaciones:

    ESTADO_EXP_PADRE                  EQU         6
    ESTADO_EXP_PADRE_INICIO           EQU         7
    ESTADO_EXP1                       EQU         8
    ESTADO_INICIO_EXP2                EQU         9
    ESTADO_EXP2                       EQU         10
    ESTADO_EVALUAR_EXPRESIONES        EQU         11


    ; Objeto Padre:

    ESTADO_INICIO_PADRE               EQU         12
    ESTADO_INICIO_OPERACION           EQU         13
    ESTADO_INICIO_OPERACION_2         EQU         14
    ESTADO_ANALIZAR_OPERACION         EQU         15
    
    ESTADO_FIN_OPERACION              EQU         16
    ESTADO_FIN_OPERACION_2            EQU         17
    ESTADO_SIGUIENTE_OPERACION        EQU         18    

    ; -----> TIPO OPERACIONES:

    OP_NUMERO                         EQU         0
    OP_SUMA                           EQU         1
    OP_RESTA                          EQU         2
    OP_MULTIPLICACION                 EQU         3
    OP_DIVISION                       EQU         4
    OP_IDENTIFICADOR                  EQU         5
    
     ; --> STRUCTS:

    Operacion STRUCT
        Nombre BYTE 31 dup(00h)
        Valor  WORD 0
    Operacion ENDS

    ; --> Menú Inicio

    strMenuInicio               BYTE        0ah, 0ah, 0ah, 0dh, "  ============================================================"
                                BYTE        0ah, 0dh, "  == UNIVERSIDAD DE SAN CARLOS DE GUATEMALA                 =="
                                BYTE        0ah, 0dh, "  == FACULTAD DE INGENIERIA                                 =="
                                BYTE        0ah, 0dh, "  == CIENCIAS Y SISTEMAS                                    =="
                                BYTE        0ah, 0dh, "  == CURSO: ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1  =="
                                BYTE        0ah, 0dh, "  == NOMBRE: JAVIER ORLANDO JAUREGUI JUAREZ                 =="
                                BYTE        0ah, 0dh, "  == CARNET: 201503748                                      =="
                                BYTE        0ah, 0dh, "  ============================================================"
                                BYTE        0ah, 0dh, "  == 1) CARGAR ARCHIVO                                      =="
                                BYTE        0ah, 0dh, "  == 2) CONSOLA                                             =="
                                BYTE        0ah, 0dh, "  == 3) SALIR                                               =="
                                BYTE        0ah, 0dh, "  ============================================================", 0ah, 0dh
                                BYTE        0ah, 0dh, "  Escoja Opcion: ", "$"

    strSoliciarNombre           BYTE        0ah, 0dh, "  ====================== CARGAR ARCHIVO ======================"
                                BYTE        0ah, 0dh, "  INGRESE NOMBRE DEL ARCHIVO: ", "$"

    ; --> Consola

    strConsola                  BYTE        0ah, 0dh, 0ah, 0dh, " ========================== CONSOLA =========================="
                                BYTE        0ah, 0dh, " >> ", "$"

    ; --> Mensajes:

    strMsgArchivoCargado        BYTE        0ah, 0dh, 0ah, 0dh, " Se ha cargado el archivo con exito!!", "$"

    strMsgMayor                 BYTE        0ah, 0dh, 0ah, 0dh, " NUMERO MAYOR: ", "$"
    strMsgMenor                 BYTE        0ah, 0dh, 0ah, 0dh, " NUMERO MENOR: ", "$"
    strMsgMedia                 BYTE        0ah, 0dh, 0ah, 0dh, " ESTADISTICO MEDIA: ", "$"
    strMsgMediana               BYTE        0ah, 0dh, 0ah, 0dh, " ESTADISTICO MEDIANA: ", "$"
    strMsgModa                  BYTE        0ah, 0dh, 0ah, 0dh, " ESTADISTICO MODA: ", "$"

    strMsgResultado             BYTE        0ah, 0dh, 0ah, 0dh, " RESULTADO ", "$"
    strDoblePunto               BYTE        ": ", "$"

    ; --> Variables

    strBufferEntrada            BYTE        31 dup(00h)
    handleArchivo               WORD        0

    ; --> Analizador:

    EstadoActual                BYTE        0
    strContenidoArchivo         BYTE        20481 dup(00h)
    
    strCadenaActual             BYTE        31 dup(00h)
    strCadenaActual2            BYTE        31 dup(00h)

    strNombrePadre              BYTE        31 dup(00h)
    arrayOperaciones            Operacion   50 dup(<>)

    cantidadOperaciones         WORD        0
    arrayValoresOrdenados       WORD        50 dup(0)

    ; --> Tiempo:

    strFecha                    BYTE        "00/00/0000", 0ah, 0dh, "$"
    strTiempo                   BYTE        "00:00:00", 0ah, 0dh, "$"

    
    ; --> Reporte:


    strTabulacion               BYTE        09h
    strSaltoLinea               BYTE        0ah, 0dh
    strComilla                  BYTE        22h

    strCorcheteAbre             BYTE        "["
    strCorcheteCierra           BYTE        "]"

    strLlaveAbre                BYTE        "{"
    strLlaveCierra              BYTE        "}"

    strComa                     BYTE        ","

    strReporte                  BYTE        09h, 22h, "reporte", 22h, ":"

    strAlumno                   BYTE        09h, 09h, 22h, "alumno", 22h, ":"
    strNombreAlumno             BYTE        09h, 09h, 09h, 22h, "Nombre", 22h, ":", 22h, "Javier Orlando Jauregui Juarez", 22h, ","
    strCarnetAlumno             BYTE        09h, 09h, 09h, 22h, "Carnet", 22h, ":", 22h, "201503748", 22h, ","
    strSeccionAlumno            BYTE        09h, 09h, 09h, 22h, "Seccion", 22h, ":", 22h, "A", 22h, ","
    strCurso                    BYTE        09h, 09h, 09h, 22h, "Curso", 22h, ":", 22h, "Arquitectura de Computadoras Y Ensambladores 1", 22h

    strFechaReporte             BYTE        09h, 09h, 22h, "fecha", 22h, ":"
    strDiaReporte               BYTE        09h, 09h, 09h, 22h, "Dia", 22h, ":"
    strMesReporte               BYTE        09h, 09h, 09h, 22h, "Mes", 22h, ":"
    strAnioReporte              BYTE        09h, 09h, 09h, 22h, "Anio", 22h, ":"
    
    strHoraReporte              BYTE        09h, 09h, 22h, "hora", 22h, ":"
    strHoraInReporte            BYTE        09h, 09h, 09h, 22h, "Hora", 22h, ":"
    strMinutosReporte           BYTE        09h, 09h, 09h, 22h, "Minutos", 22h, ":"
    strSegundosReporte          BYTE        09h, 09h, 09h, 22h, "Segundos", 22h, ":"
    
    strResultados               BYTE        09h, 09h, 22h, "resultados", 22h, ":"
    strMediaReporte             BYTE        09h, 09h, 09h, 22h, "media", 22h, ":"
    strMedianaReporte           BYTE        09h, 09h, 09h, 22h, "mediana", 22h, ":"
    strModaReporte              BYTE        09h, 09h, 09h, 22h, "moda", 22h, ":"
    strMenorReporte             BYTE        09h, 09h, 09h, 22h, "menor", 22h, ":"
    strMayorReporte             BYTE        09h, 09h, 09h, 22h, "mayor", 22h, ":"

    strNoHayModa                BYTE        22h, "No hay", 22h

    ; --> Errores

    strOpcionInvalida           BYTE        0ah, 0dh, "Error: La opcion ingresada es invalida", 0ah, 0dh, "$"

    strErrorCrearArchivo        BYTE        0ah, 0dh, "Error: No fue posible crear el archivo.", 0ah, 0dh, "$"
    strErrorEscribirArchivo     BYTE        0ah, 0dh, "Error: No fue posible escribir en el archivo.", 0ah, 0dh, "$"
    strErrorAbrirArchivo        BYTE        0ah, 0dh, "Error: No fue posible abrir el archivo.", 0ah, 0dh, "$"     
    strErrorLeerArchivo         BYTE        0ah, 0dh, "Error: No fue posible leer el archivo.", 0ah, 0dh, "$"
    strErrorFinArchivo          BYTE        0ah, 0dh, "Error: No fue posible posicinarse en el final del archivo", 0ah, 0dh, "$"
    strErrorCerrarArchivo       BYTE        0ah, 0dh, "Error: No fue posible cerrar el archivo.", 0ah, 0dh, "$"     
    
    strErrorIDNoEncontrado      BYTE        0ah, 0dh, 0ah, 0dh, "Error: No se encontro el identificador.", "$"

    strErrorNoDeclarado         BYTE        " No ha sido declarado.", 0ah, 0dh


.CODE

;------------------------------------------------
; ---------           MACROS            ---------                 
;------------------------------------------------

;------------------------------------------------
ImprimirEnConsola MACRO cadena
;
; Descripción : Imprime en consola una cadena.
; Recibe      : Cadena terminada en '$'
; Devuelve    : NADA
;------------------------------------------------

    push ax
    push cx
    push dx

    mov ah, 09h
    mov dx, OFFSET cadena
    int 21h

    pop dx
    pop cx
    pop ax
    
ENDM

;------------------------------------------------
LeerCaracterConsola MACRO
;
; Descripción : Lee una caracter ingresado por el usuario en consola.
; Recibe      : NADA
; Devuelve    : AL = Código ASCII en Hexadecimal del caracter ingresado
;------------------------------------------------

    mov ah, 01h
    int 21h

ENDM

;------------------------------------------------
EliminarCaracterConsola MACRO
;
; Descripción : Elimina un caracter de la consola cuando el usuario ingresa un 'backspace'
; Recibe      : NADA
; Devuelve    : NADA
;------------------------------------------------

    push ax
    push dx

    mov ah, 02h
    mov dl, 20h
    int 21h
    mov dl, 08h
    int 21h

    pop dx
    pop ax

ENDM

;------------------------------------------------
TerminarPrograma MACRO
;
; Descripción : Termina la ejecución de programa.
; Recibe      : NADA
; Devuelve    : NADA
;------------------------------------------------

    mov ah, 4CH
    mov al, 01
    int 21h

ENDM

;------------------------------------------------
UpperLetra MACRO
;
; Descripción : Convierte una letra de minúscula a mayúscula.
; Recibe      : AL = valor ascii en hexadecimal de la letra.
; Devuelve    : AL = valor ascii en hexadecimal de la letra en mayúsucla, si el registro AL no contenía
;               una letra minúscula, el valor de éste no cambia.
;------------------------------------------------
LOCAL PosibleMinuscula, Convertir, Salir

    cmp al, "a"
        jae PosibleMinuscula
    jmp Salir

    PosibleMinuscula:
        cmp al, "z"
            jbe Convertir
        jmp Salir

    Convertir:
        sub al, 20h
        jmp Salir
    
    Salir:

ENDM


;------------------------------------------------
EsDigitoAscii MACRO
;
; Descripción : Determina si un valor ascii en hexadecimal corresponde al de un digito.
; Recibe      : AL = valor ascii en hexadecimal a evaluar.
; Devuelve    : CF = 1 es dígito, CF = 0 No es dígito.
;------------------------------------------------
LOCAL PosibleDigito, EsDigito, NoEsDigito, Salir

    cmp al, "0"
        jae PosibleDigito

    jmp NoEsDigito
    
    PosibleDigito:
        cmp al, "9"
            jbe EsDigito
        
        jmp NoEsDigito

    EsDigito:
        STC                 ; CF = 1
        jmp Salir
    
    NoEsDigito:
        CLC                 ; CF = 0
        jmp Salir

    Salir:

ENDM

;------------------------------------------------
DigitoAsciiToNumero MACRO
;
; Descripción : Convierte un dígito de ascii a su valor numérico.
; Recibe      : Al = valor ascii en hexadecimal del dígito.
; Devuelve    : Al = valor numérico del dígito. Si Al no contenía un dígito, el valor de éste no cambia.
;------------------------------------------------
LOCAL PosibleDigito, Convertir, Salir

    EsDigitoAscii
    jc Convertir
    jmp Salir

    Convertir:
        sub al, "0"
        jmp Salir

    Salir:

ENDM


CrearArchivo MACRO strNombre, handle
;
; Descripción : Crea un archivo..
; Recibe      : strNombre = Cadena donde está almacenado el nombre del archivo.
;             : handle = Variable donde se almacenará el Handle del archivo
; Devuelve    : handle = Handle del archivo creado.
;------------------------------------------------
LOCAL ErrorArchivo, Salir

    push cx
    push dx

    mov ah, 3ch
    mov cx, 00h
    lea dx, strNombre

    int 21h
    jc ErrorArchivo

    mov handle, ax
    jmp Salir

    ErrorArchivo:
        ImprimirEnConsola strErrorCrearArchivo

    Salir:
        pop dx
        pop cx

ENDM

;------------------------------------------------
EscribirEnArchivo MACRO handle, strContenido, tamanioContenido
;
; Descripción : Abre un archivo y escribe dentro de él.
; Recibe      : strContenido = Cadena que se escribirá en el archivo.
;             : handle = Variable donde se almacena el Handle del archivo
;             : tamanioContenido = Tamaño del contenido a escribir.
; Devuelve    : Nada
;------------------------------------------------
LOCAL ErrorArchivo, Salir

    push ax
    push bx
    push cx
    push dx

    mov ah, 40h
    mov bx, handle
    mov cx, tamanioContenido
    lea dx, strContenido
    
    int 21h
    jc ErrorArchivo
    jmp Salir

    ErrorArchivo:
        ImprimirEnConsola strErrorEscribirArchivo

    Salir:
        pop dx
        pop cx
        pop bx
        pop ax

ENDM

;------------------------------------------------
PosicionarEnFinalDeArchivo macro handle
;
; Descripción : Posiciona cursor de lectura y escritura del archivo en el final.
; Recibe      : handle = Variable donde se almacena el Handle del archivo
; Devuelve    : Nada
;------------------------------------------------
LOCAL ErrorArchivo, Salir

    push ax
    push bx
    push cx
    push dx

    mov ah, 42h
    mov al, 02h 
    mov bx, handle

    xor cx, cx
    xor dx, dx
    int 21h

    jc ErrorArchivo
    jmp Salir

    ErrorArchivo:
        ImprimirEnConsola strErrorFinArchivo

    Salir:
        pop dx
        pop cx
        pop bx
        pop ax

ENDM

;------------------------------------------------
AbrirArchivo MACRO nombreArchivo, handle
;
; Descripción : Abre un archivo y devuelve su Handle.
; Recibe      : nombreArchivo = Cadena donde está almacenado el nombre del archivo.
;             : handle = Variable donde se almacenará el Handle devuelto
; Devuelve    : handle = Handle del archivo abierto.
;------------------------------------------------
LOCAL ErrorArchivo, Salir

    push ax
    push dx

    mov ah, 3Dh
    mov al, 02h
    lea dx, nombreArchivo
    int 21h
    jc ErrorArchivo
    mov handle, ax
    jmp Salir

    ErrorArchivo:
        ImprimirEnConsola strErrorAbrirArchivo
        mov handle, 0h
    
    Salir:
        pop dx
        pop ax

ENDM

;------------------------------------------------
LeerArchivo MACRO handle, bufferContenidoArchivo, tamanioContenido
;
; Descripción : Lee un archivo y guarda su contenido en una cadena.
; Recibe      : handle = handle del archivo
;             : bufferContenidoArchivo = Cadena donde se almacenará el contenido del archivo.
;             : tamanioContenido = tamaño del contenido a leer del archivo.
; Devuelve    : NADa.
;------------------------------------------------

LOCAL ErrorArchivo, Salir

    cmp handle, 0
        je ErrorArchivo

    push ax
    push bx
    push cx
    push dx

    mov ah, 3FH
    mov bx, handle
    mov cx, tamanioContenido
    lea dx, bufferContenidoArchivo
    int 21h
    jc ErrorArchivo
    jmp Salir

    ErrorArchivo:
        ImprimirEnConsola strErrorLeerArchivo

    Salir:
        pop dx
        pop cx
        pop bx
        pop ax

ENDM

;------------------------------------------------
CerrarArchivo MACRO handle
;
; Descripción : Cierra un archivo.
; Recibe      : handle = Handle del archivo a cerrar.
; Devuelve    : NADA.
;------------------------------------------------
LOCAL ErrorArchivo, Salir

    cmp handle, 0
        je ErrorArchivo

    push ax
    push bx

    mov ah, 3EH
    mov bx, handle
    int 21h
    jc ErrorArchivo
    jmp Salir

    ErrorArchivo:
        ImprimirEnConsola strErrorCerrarArchivo
    
    Salir:
        pop bx
        pop ax

ENDM


;------------------------------------------------
CargarArchivo MACRO nombreArchivo
;
; Descripción : Carga un archivo la variable global strContenidoArchivo
; Recibe      : nombreArchivo = Cadena con el nombre del archivo a cargar.
; Devuelve    : NADA.
;------------------------------------------------

    INVOKE LimpiarBuffer, ADDR strContenidoArchivo, SIZEOF strContenidoArchivo
    AbrirArchivo nombreArchivo, handleArchivo
    LeerArchivo handleArchivo, strContenidoArchivo, SIZEOF strContenidoArchivo
    CerrarArchivo handleArchivo

ENDM

;------------------------------------------------
; ---------       PROCEDIMIENTOS        ---------                 
;------------------------------------------------


Put_BCD2 PROC

    push    ax

    shr     ax, 1
    shr     ax, 1
    shr     ax, 1
    shr     ax, 1

    and     ax, 0fh
    add     ax, '0'
    mov     [bx], al
    inc     bx
    pop     ax

    and     ax, 0fh
    add     ax, '0'
    mov     [bx], al

    inc     bx
    ret

Put_BCD2 ENDP

;------------------------------------------------
GetTiempo PROC USES ax bx
;
; Descripción : Obtiene el tiempo del BIOS y lo convierte a una cadena.
; Recibe      : NADA
; Devuelve    : La variable global strTiempo guarda la cadena con el tiempo actual
; Fuente      : https://stackoverflow.com/questions/28609924/assembly-a86-get-and-display-time
;------------------------------------------------

    mov     ah, 02h              ; Obtener tiempo del BIOS.
    int     1ah

    mov     bx, OFFSET strTiempo ; Horas
    mov     al, ch
    call    Put_BCD2

    inc     bx                   ; Minutos
    mov     al, cl
    call    Put_BCD2 

    inc     bx                   ; Segundos
    mov     al, dh
    call    Put_BCD2 

    ret

GetTiempo ENDP

;------------------------------------------------
GetFecha PROC USES ax bx
;
; Descripción : Obtiene la fecha del BIOS y lo convierte a una cadena.
; Recibe      : NADA
; Devuelve    : La variable global strFecha guarda la cadena con la fecha actual
; Fuente      : https://stackoverflow.com/questions/28609924/assembly-a86-get-and-display-time
;------------------------------------------------

    mov     ah, 04h             ; Obtener fecha del BIOS.
    int     1ah

    mov     bx, OFFSET strFecha ; Día
    mov     al, dl
    call    Put_BCD2

    inc     bx                  ; Mes
    mov     al, dh
    call    Put_BCD2

    inc     bx                  ; Año
    mov     al, ch
    call    Put_BCD2
    mov     al, cl
    call    Put_BCD2

    ret

GetFecha ENDP


;------------------------------------------------
LimpiarBuffer PROC USES bx cx si, buffer: PTR BYTE, tamanioBuffer: WORD
;
; Descripción : Rellena con "00h" el contenido del buffer.
; Recibe      : Dirección de memoria del buffer a ser limpiado.
; Devuelve    : NADA
;------------------------------------------------

    xor bx, bx
    xor cx, cx
    xor si, si

    mov cx, tamanioBuffer
    mov bx, buffer

    EtqCiclo:
        mov BYTE PTR [bx + si], 00h
        inc si
        loop EtqCiclo

    ret

LimpiarBuffer ENDP

;------------------------------------------------
LeerCadenaConsola PROC USES ax bx cx si, pCadenaLeida: PTR BYTE, tamanioCadena: BYTE
;
; Descripción : Lee una cadena ingresada por el usuario en consola.
; Recibe      : pCadenaLeida = dirección de memoria donde se guardará la cadena ingresada por el usuario.
;             : tamanioCadena = Tamaño máximo de la cadena donde se guardará lo ingresado por el usuario.
; Devuelve    : Guarda en la dirección a donde apunta pCadenaLeida la cadena ingresada por el usuario.
;------------------------------------------------
    
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor si, si

    INVOKE LimpiarBuffer, pCadenaLeida, tamanioCadena

    mov si, 0
    mov cl, tamanioCadena
    mov bx, pCadenaLeida

    EtqCiclo:
        LeerCaracterConsola
        cmp al, 08h
            je EtqEliminarCaracter
        cmp al, 0dh
            jne EtqVerificarCaracter
        jmp EtqTerminarLectura
    
    EtqVerificarCaracter:
        cmp si, cx
            jb EtqGuardarCaracter
        jmp EtqCiclo
    EtqGuardarCaracter:
        mov BYTE PTR [bx + si], al
        inc si
        jmp EtqCiclo
    EtqEliminarCaracter:
        cmp si, 0
            je EtqCiclo
        EliminarCaracterConsola
        dec si
        mov BYTE PTR [bx + si], 00h
        jmp EtqCiclo
        
    EtqTerminarLectura:
        mov BYTE PTR [bx + si], 00h
        ret

LeerCadenaConsola ENDP

;------------------------------------------------
CopiarCadena PROC USES ax bx si, pCadenaOrigen: PTR BYTE, pCadenaDestino: PTR BYTE, tamanioDestino : WORD
;
; Descripción : Copia el contenido de una cadena a otra.
; Recibe      : pCadenaOrigen = dirección de memoria donde se almacena la cadena original.
;             : pCadenaDestino = dirección de memoria donde se guardará la copia de la cadena.
;             : tamanioDestino = cantidad de caracteres a copiar.
; Devuelve    : Guarda en la dirección a donde apunta pCadenaDestino la cadena copiada.
;------------------------------------------------

    Inicializacion:

        xor ax, ax
        xor bx, bx
        xor si, si

        INVOKE LimpiarBuffer, pCadenaDestino, tamanioDestino

    Ciclo:
        mov bx, pCadenaOrigen
        mov al, BYTE PTR[bx + si]
        cmp al, 00h
            je Salir 
        mov bx, pCadenaDestino
        mov BYTE PTR[bx + si], al
        inc si
        dec tamanioDestino
        cmp tamanioDestino, 0
            jne Ciclo
        
    Salir:
        ret

CopiarCadena ENDP

;------------------------------------------------
ConvertirNumeroToCadena PROC USES ax cx dx bx si di Numero: WORD, pCadenaDestino: PTR BYTE, tamanioDestino : WORD
;
; Descripción : Convierte un número a cadena.
; Recibe      : Numero = Valor numérico que se desa convertir
;             : pCadenaDestino = dirección de memoria donde se guardará el número convertido.
;             : tamanioDestino = cantidad de caracteres a copiar.
; Devuelve    : Guarda en la dirección a donde apunta pCadenaDestino el número convertido.
;------------------------------------------------


    Inicializacion:
    
        INVOKE LimpiarBuffer, pCadenaDestino, tamanioDestino
    
        mov ax, Numero
        mov cx, 10
        mov bx, pCadenaDestino         
        mov si, 0
        mov di, 0

        test ax, ax
        jns Convertir
        
        mov BYTE PTR[bx + 0], "-"
        inc di
        mov cx, -1 
        mul cx
        mov cx, 10

    Convertir:

        mov dx, 0            
        div cx              
        add dx, "0"         
        
        inc si
        push dx

        cmp ax,0            
            je CrearCadena            
        jmp Convertir 

    CrearCadena:

        pop dx
        mov BYTE PTR[bx + di], dl
        
        inc di
        dec si

        cmp si, 0
            je Salir
        jmp CrearCadena
       
    Salir:
        ret

ConvertirNumeroToCadena ENDP


;------------------------------------------------
GetTamanioCadena PROC USES bx cx si pCadena : PTR BYTE
;
; Descripción : Obtiene el tamaño de una cadena.
; Recibe      : pCadena = cadena a obtener su tamaño.
; Devuelve    : Registro AL = tamaño de la cadena.
;------------------------------------------------

    Inicializacion:

        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor si, si

        mov bx, pCadena

    Ciclo:
        
        mov cl, BYTE PTR[bx + si]
        cmp cl, 00h
            je Salir
        inc al
        inc si
        jmp Ciclo

    Salir:
        ret 

GetTamanioCadena ENDP

;------------------------------------------------
CompararCadenas PROC USES ax bx cx si, pCadena1 : PTR BYTE, pCadena2 : PTR BYTE
;
; Descripción : Determina si 2 cadenas son iguales.
; Recibe      : pCadena1 = posición de memoria de la primera cadena.
;               pCadena2 = posición de memoria del a segunda cadena.
; Devuelve    : Bandera CF = 1 si son iguales, CF = 0 si no lo son.
;------------------------------------------------

    Inicializacion:

        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor si, si

    CompararTamanios:

        INVOKE GetTamanioCadena, pCadena1
        mov cl, al
        INVOKE GetTamanioCadena, pCadena2

        cmp al, cl
            jne NoIguales
        
        xor ax, ax
        xor cx, cx
    
    CompararCaracteres:

        mov bx, pCadena1
        mov al, BYTE PTR[bx + si]
        
        UpperLetra
        mov cl, al

        mov bx, pCadena2
        mov al, BYTE PTR[bx + si]
        UpperLetra

        cmp al, cl
            jne NoIguales
        inc si
        cmp al, 00h
            jne CompararCaracteres

    Iguales:
        STC
        jmp Salir

    NoIguales:
        CLC
        jmp Salir
        
    Salir:
        ret

CompararCadenas ENDP

;------------------------------------------------
GetValorDeIdentificador PROC USES cx di si, pCadenaIdentificador : PTR BYTE
;
; Descripción : Busca el identificador en el arrayOperaciones y obtiene su valor.
; Recibe      : pCadenaIdentificador = dirección de memoria donde se encuentra la cadena del identificador.
; Devuelve    : Registro AX = Valor del identificador.
;             : Bandera CF = 1; Identificador Encontrado, CF = 0; No se encontró el identificador.
;------------------------------------------------

    Inicializacion:
        
        xor cx, cx
        xor si, si 
        xor di, di
        
    Ciclo:

        INVOKE CompararCadenas, pCadenaIdentificador, ADDR arrayOperaciones[di].Nombre
        jc IDEncontrado

        add di, TYPE Operacion
        inc si
    
        cmp si, 50
            jne Ciclo

        jmp IDNoExiste

    IDEncontrado:
        mov ax, arrayOperaciones[di].Valor
        STC
        jmp Salir
    
    IDNoExiste:
        mov ax, 0
        CLC
        jmp Salir

    Salir:
        ret

GetValorDeIdentificador ENDP

;------------------------------------------------
EjecutarOperacion PROC USES bx dx, tipoOperacion : BYTE, Valor1 : WORD, Valor2 : WORD
;
; Descripción : Realiza una operación dependiendo del tipo de operación indicado.
; Recibe      : tipoOperacion = Tipo de la operación.
;               Valor1 = Valor izquierdo de la operación.
;               Valor2 = Valor Derecho de la operación.
; Devuelve    : AX = Resultado de la operación.
;------------------------------------------------

    xor ax, ax
    xor bx, bx
    xor dx, dx

    cmp tipoOperacion, OP_SUMA
        je Sumar
    cmp tipoOperacion, OP_RESTA
        je Restar
    cmp tipoOperacion, OP_MULTIPLICACION
        je Multiplicar
    cmp tipoOperacion, OP_DIVISION
        je Dividir

    Sumar:

        mov ax, Valor1
        add ax, Valor2
        jmp Salir

    Restar:

        mov ax, Valor1
        sub ax, Valor2
        jmp Salir

    Multiplicar:

        mov ax, Valor1
        imul Valor2
        jmp Salir

    Dividir:

        mov ax, Valor1
        cwd
        idiv Valor2
        jmp Salir

    Salir:
        ret

EjecutarOperacion ENDP

;------------------------------------------------
OrdenarValores PROC USES ax bx cx dx si di
;
; Descripción : Guarda los valores del arrayOperaciones en el arreglo arrayValoresOrdenados
;             : ordenados de mayor a menor. Utiliza el método burbuja para la realización del ordenamiento.
; Recibe      : NADA
; Devuelve    : arrayValoresOrdenados = valores ordenados de mayor a menor.
;------------------------------------------------

    Inicializacion:
        
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        xor si, si
        xor di, di

    CicloRellenarValoresOrdenados:

        mov ax, arrayOperaciones[si].Valor
        mov arrayValoresOrdenados[di], ax

        add si, TYPE Operacion
        add di, TYPE WORD
        inc cx

        cmp cx, cantidadOperaciones
            jne CicloRellenarValoresOrdenados
        
        xor cx, bx
        xor ax, ax
        xor si, si

    CicloExterior:
        
        xor cx, cx
        xor dx, dx
        xor di, di

        CicloInterior:

            mov ax, arrayValoresOrdenados[di]
            mov bx, arrayValoresOrdenados[di+TYPE WORD]

            cmp ax, bx
                jl Swap

            jmp EvaluarCicloInterior

            Swap:
                mov arrayValoresOrdenados[di], bx
                mov arrayValoresOrdenados[di+TYPE WORD], ax

            EvaluarCicloInterior:
                add di, TYPE WORD
                inc dx
                mov cx, cantidadOperaciones
                sub cx, si
                sub cx, 1
                cmp dx, cx
                    jb CicloInterior
                
        inc si
        cmp si, cantidadOperaciones
            jb CicloExterior

    Salir:
        ret


OrdenarValores ENDP


;------------------------------------------------
AnalizarCadena PROC USES ax bx di, pCadenaDestino: PTR BYTE
;
; Descripción : Analiza una cadena encerra dentro de "" en base a la posición que se encuentra actualmente
;               índice de strContenidoArchivo y almacena su contenido la cadena a donde apunta pCadenaDestino.
; Recibe      : pCadenaDestino = dirección de memoria donde se guardará la cadena analizada.
;             : Registro SI = Índice actual de strContenidoArchivo de donde empezará a leer en busca de la cadena.
; Devuelve    : Guarda en la dirección a donde apunta pCadenaDestino la cadena analizada.
;             : SI = Posición después del fin de la cadena en strContenidoArchivo.
;------------------------------------------------

LOCAL Estado: BYTE

    Inicializacion:

        INVOKE LimpiarBuffer, pCadenaDestino, 31

        xor ax, ax
        xor bx, bx
        xor di, di
        mov bx, pCadenaDestino
        mov Estado, ESTADO_INICIAL

    EvaluarEstado:

        cmp Estado, ESTADO_INICIAL
            je EstadoInicial
        cmp Estado, ESTADO_CADENA_CONTENIDO
            je EstadoCadenaContenido
        cmp Estado, ESTADO_CADENA_FIN
            je Salir
    
    EstadoInicial:

        cmp strContenidoArchivo[si], 22h    ; 22h = comilla doble "
            jne IncrementarIndice

        mov Estado, ESTADO_CADENA_CONTENIDO
        jmp IncrementarIndice

    EstadoCadenaContenido:

        cmp strContenidoArchivo[si], 22h    ; 22h = comilla doble "
            je FinDeCadena

        mov al, strContenidoArchivo[si]
        UpperLetra

        mov BYTE PTR [bx + di], al
        inc di
        jmp IncrementarIndice

    FinDeCadena:
        
        mov Estado, ESTADO_CADENA_FIN
        jmp IncrementarIndice

    IncrementarIndice:
        inc si
        jmp EvaluarEstado

    Salir:
        ret


AnalizarCadena ENDP

;------------------------------------------------
AnalizarTipoOperacion PROC USES bx, pCadenaOperacion : PTR BYTE
;
; Descripción : Recibe una cadena y determina si es un tipo de operación válido.
; Recibe      : pCadenaOperacion = dirección de memoria de la cadena a anlizar.
; Devuelve    : Guarda en el registro AL el tipo de operación.
;------------------------------------------------

    Inicializacion:
        
        xor bx, bx
        mov bx, pCadenaOperacion

    EvaluarTipo:

        cmp BYTE PTR[bx + 0], "#"
            je Numero
        cmp BYTE PTR[bx + 0], "+"
            je Suma
        cmp BYTE PTR[bx + 0], "-"
            je Resta
        cmp BYTE PTR[bx + 0], "*"
            je Multiplicacion
        cmp BYTE PTR[bx + 0], "/"
            je Division

        CadenaAdd:
            
            cmp BYTE PTR[bx + 0], "A"
                jne CadenaResta
            cmp BYTE PTR[bx + 1], "D"
                jne CadenaResta
            cmp BYTE PTR[bx + 2], "D"
                jne CadenaResta
            cmp BYTE PTR[bx + 3], 00h
                jne Salir
            
            jmp Suma

        CadenaResta:

            cmp BYTE PTR[bx + 0], "S"
                jne CadenaMultiplicacion
            cmp BYTE PTR[bx + 1], "U"
                jne CadenaMultiplicacion
            cmp BYTE PTR[bx + 2], "B"
                jne CadenaMultiplicacion
            cmp BYTE PTR[bx + 3], 00h
                jne Salir
            
            jmp Resta

        CadenaMultiplicacion:

            cmp BYTE PTR[bx + 0], "M"
                jne CadenaDivision
            cmp BYTE PTR[bx + 1], "U"
                jne CadenaDivision
            cmp BYTE PTR[bx + 2], "L"
                jne CadenaDivision
            cmp BYTE PTR[bx + 3], 00h
                jne Salir
            
            jmp Multiplicacion

        CadenaDivision:

            cmp BYTE PTR[bx + 0], "D"
                jne CadenaID
            cmp BYTE PTR[bx + 1], "I"
                jne CadenaID
            cmp BYTE PTR[bx + 2], "V"
                jne Salir
            cmp BYTE PTR[bx + 3], 00h
                jne Salir
            
            jmp Division

        CadenaID:

            cmp BYTE PTR[bx + 0], "I"
                jne Salir
            cmp BYTE PTR[bx + 1], "D"
                jne Salir
            cmp BYTE PTR[bx + 2], 00h
                jne Salir

            jmp ID

        Numero:
            mov al, OP_NUMERO
            jmp Salir
        Suma:
            mov al, OP_SUMA
            jmp Salir
        Resta:
            mov al, OP_RESTA
            jmp Salir
        Multiplicacion:
            mov al, OP_MULTIPLICACION
            jmp Salir
        Division:
            mov al, OP_DIVISION
            jmp Salir
        ID:
            mov al, OP_IDENTIFICADOR
            jmp Salir

    Salir:
        ret

AnalizarTipoOperacion ENDP

;------------------------------------------------
AnalizarNumero PROC USES bx cx dx
LOCAL Estado : BYTE, Negativo : BYTE
;
; Descripción : Extrae un número de strContenidoArchivo en base al índice actual en SI y lo
;               guarda en el registro AX
; Recibe      : SI = posición de strContenidoArchivo donde comienza a buscar el número a extraer.
; Devuelve    : Guarda en el registro AX el número extraído.
;------------------------------------------------

    Inicializacion:

        xor ax, ax
        xor cx, cx
        xor bx, bx
        xor dx, dx
        mov Negativo, 0
        mov Estado, ESTADO_INICIAL
        

    EvaluarEstado:

        cmp Estado, ESTADO_INICIAL
            je EstadoInicial
        cmp Estado, ESTADO_SIGUIENTE_DIGITO
            je EvaluarSiguienteDigito
        cmp Estado, ESTADO_FINAL
            je VerificarNegativo
    
    EstadoInicial:

        mov al, strContenidoArchivo[si]
        EsDigitoAscii
            jc PrimerDigito
    
        cmp ax, "-" 
            jne IncrementarIndice

        mov Negativo, 1
        jmp IncrementarIndice

    PrimerDigito:
        
        DigitoAsciiToNumero
        mov Estado, ESTADO_SIGUIENTE_DIGITO
        jmp IncrementarIndice

    EvaluarSiguienteDigito:
        
        
        xor bx, bx
        mov bx, ax

        xor ax, ax
        mov al, strContenidoArchivo[si]

        EsDigitoAscii
            jc EstadoSiguienteDigito

        xor ax, ax
        mov ax, bx

        mov Estado, ESTADO_FINAL
        jmp EvaluarEstado

    EstadoSiguienteDigito:

        DigitoAsciiToNumero                 ; Ax = valor del dígito

        xchg ax, bx
        mov cx, 10
        mul cx
        add ax, bx

        mov Estado, ESTADO_SIGUIENTE_DIGITO
        jmp IncrementarIndice

    IncrementarIndice:
        inc si
        jmp EvaluarEstado

    VerificarNegativo:

        cmp Negativo, 0
            je Salir

        mov cx, -1
        mul cx

    Salir:
        ret

AnalizarNumero ENDP


;------------------------------------------------
AnalizarOperacion PROC USES ax
;
; Descripción : Analiza una operación y obtiene sus resultados de manera recursiva.
; Recibe      : SI = Índice de strContenidoArchivo donde comenzará a analizar.
; Devuelve    : CX = Resultado de la operación.
;------------------------------------------------

LOCAL tipoOperacionPadre : BYTE, tipoOperacionExp : BYTE,
      Estado : BYTE, ValorExp1 : WORD, ValorExp2 : WORD

    Inicializacion:

        mov Estado, ESTADO_INICIAL

    EvaluarEstado:

        cmp Estado, ESTADO_INICIAL
            je EstadoInicial
        cmp Estado, ESTADO_EXP_PADRE
            je EstadoExpPadre
        cmp Estado, ESTADO_EXP_PADRE_INICIO
            je EstadoExpPadreInicio
        cmp Estado, ESTADO_EXP1
            je EstadoExp1
        cmp Estado, ESTADO_INICIO_EXP2
            je EstadoInicioExp2
        cmp Estado, ESTADO_EXP2
            je EstadoExp2
        cmp Estado, ESTADO_EVALUAR_EXPRESIONES
            je EvaluarExpresiones
        cmp Estado, ESTADO_FINAL
            je EstadoFinal

    EstadoInicial:

        INVOKE AnalizarCadena, ADDR strCadenaActual
        INVOKE AnalizarTipoOperacion, ADDR strCadenaActual

        mov tipoOperacionPadre, al
        mov Estado, ESTADO_EXP_PADRE
        jmp EvaluarEstado

    EstadoExpPadre:

        cmp strContenidoArchivo[si], ":"
            jne IncrementarIndice
        
        mov Estado, ESTADO_EXP_PADRE_INICIO
        jmp EvaluarEstado
    
    EstadoExpPadreInicio:

        cmp strContenidoArchivo[si], "{"
            jne IncrementarIndice

        INVOKE AnalizarCadena, ADDR strCadenaActual
        INVOKE AnalizarTipoOperacion, ADDR strCadenaActual

        mov tipoOperacionExp, al
        mov Estado, ESTADO_EXP1
        jmp EvaluarEstado
    
    EstadoExp1:
    
        cmp strContenidoArchivo[si], ":"
            jne IncrementarIndice

        cmp tipoOperacionExp, OP_NUMERO
            je GuardarNumero1
        cmp tipoOperacionExp, OP_IDENTIFICADOR
            je GuardarIdentificador1

        CicloRegresoExp1:
            dec si
            cmp strContenidoArchivo[si], "{"
                jne CicloRegresoExp1

        INVOKE AnalizarOperacion
        mov ValorExp1, cx
        mov Estado, ESTADO_INICIO_EXP2
        jmp EvaluarEstado

    GuardarNumero1:
        
        INVOKE AnalizarNumero   ; AX = Número leído
        mov ValorExp1, ax

        mov Estado, ESTADO_INICIO_EXP2
        jmp EvaluarEstado

    GuardarIdentificador1:

        INVOKE AnalizarCadena, ADDR strCadenaActual
        INVOKE GetValorDeIdentificador, ADDR strCadenaActual
        mov ValorExp1, ax
        jc FinID1

        ID1NOExiste:
            mov strCadenaActual[15], "$"
            ImprimirEnConsola strCadenaActual
            ImprimirEnConsola strErrorNoDeclarado
        
        FinID1:
            mov Estado, ESTADO_INICIO_EXP2
            jmp EvaluarEstado

    EstadoInicioExp2:

        cmp strContenidoArchivo[si], ","
            jne IncrementarIndice   

        INVOKE AnalizarCadena, ADDR strCadenaActual
        INVOKE AnalizarTipoOperacion, ADDR strCadenaActual    

        mov tipoOperacionExp, al
        mov Estado, ESTADO_EXP2
        jmp EvaluarEstado

    EstadoExp2:

        cmp strContenidoArchivo[si], ":"
            jne IncrementarIndice

        cmp tipoOperacionExp, OP_NUMERO
            je GuardarNumero2
        cmp tipoOperacionExp, OP_IDENTIFICADOR
            je GuardarIdentificador2

        CicloRegresoExp2:
            dec si
            cmp strContenidoArchivo[si], ","
                jne CicloRegresoExp2

        INVOKE AnalizarOperacion
        mov ValorExp2, cx
        mov Estado, ESTADO_EVALUAR_EXPRESIONES
        jmp EvaluarEstado

    GuardarNumero2:

        INVOKE AnalizarNumero   ; AX = Número leído
        mov ValorExp2, ax

        mov Estado, ESTADO_EVALUAR_EXPRESIONES
        jmp EvaluarEstado

   GuardarIdentificador2:

        INVOKE AnalizarCadena, ADDR strCadenaActual
        INVOKE GetValorDeIdentificador, ADDR strCadenaActual
        mov ValorExp2, ax
        jc FinID2

        ID2NOExiste:
            mov strCadenaActual[15], "$"
            ImprimirEnConsola strCadenaActual
            ImprimirEnConsola strErrorNoDeclarado
        
        FinID2:
            mov Estado, ESTADO_EVALUAR_EXPRESIONES
            jmp EvaluarEstado

    EvaluarExpresiones:

        INVOKE EjecutarOperacion, tipoOperacionPadre, ValorExp1, ValorExp2
    
        mov cx, ax
        mov Estado, ESTADO_FINAL
        jmp EvaluarEstado

    EstadoFinal:

        cmp strContenidoArchivo[si], "}"
            jne IncrementarIndice
        
        inc si
        jmp Salir

    IncrementarIndice:

        inc si
        jmp EvaluarEstado


    Salir:
        ret

AnalizarOperacion ENDP

;------------------------------------------------
AnalizarContenidoArchivo PROC USES ax si di cx
;
; Descripción : Analiza el contenido de la variable global strContenidoArchivo.
; Recibe      : NADA
; Devuelve    : NADA
;------------------------------------------------
LOCAL Estado : BYTE, indiceOperaciones : WORD
    
    Inicializacion:

        xor ax, ax
        xor cx, cx
        xor di, di
        xor si, si

        mov cantidadOperaciones, 0
        mov indiceOperaciones, 0

        mov Estado, ESTADO_INICIAL

    EvaluarEstado:

        cmp Estado, ESTADO_INICIAL
            je EstadoInicial
        cmp Estado, ESTADO_INICIO_PADRE
            je EstadoInicioPadre
        cmp Estado, ESTADO_INICIO_OPERACION
            je EstadoInicioOperacion
        cmp Estado, ESTADO_INICIO_OPERACION_2
            je EstadoInicioOperacion2
        cmp Estado, ESTADO_ANALIZAR_OPERACION
            je EstadoAnalizarOperacion
        cmp Estado, ESTADO_FIN_OPERACION
            je EstadoFinOperacion
        cmp Estado, ESTADO_FIN_OPERACION_2
            je EstadoFinOperacion2
        cmp Estado, ESTADO_SIGUIENTE_OPERACION
            je EstadoSiguienteOperacion
        cmp Estado, ESTADO_FINAL
            je EstadoFinal

    EstadoInicial:

        cmp strContenidoArchivo[si], "{"
            jne IncrementarIndice
        
        INVOKE AnalizarCadena, ADDR strCadenaActual
        INVOKE CopiarCadena, ADDR strCadenaActual, ADDR strNombrePadre, SIZEOF strCadenaActual
    
        mov Estado, ESTADO_INICIO_PADRE
        jmp EvaluarEstado

    EstadoInicioPadre:

        cmp strContenidoArchivo[si], "["
            jne IncrementarIndice
        
        mov Estado, ESTADO_INICIO_OPERACION
        jmp IncrementarIndice
    
    EstadoInicioOperacion:

        cmp strContenidoArchivo[si], "{"
            jne IncrementarIndice

        mov di, indiceOperaciones
        INVOKE AnalizarCadena, ADDR arrayOperaciones[di].Nombre        

        mov Estado, ESTADO_INICIO_OPERACION_2
        jmp EvaluarEstado

    EstadoInicioOperacion2:
        
        cmp strContenidoArchivo[si], ":"
            jne IncrementarIndice

        mov Estado, ESTADO_ANALIZAR_OPERACION
        jmp IncrementarIndice

    EstadoAnalizarOperacion:

        cmp strContenidoArchivo[si], "{"
            jne IncrementarIndice

        INVOKE AnalizarOperacion
        
        mov di, indiceOperaciones
        mov arrayOperaciones[di].Valor, cx
        add indiceOperaciones, TYPE Operacion
        add cantidadOperaciones, 1

        mov Estado, ESTADO_FIN_OPERACION
        jmp EvaluarEstado
    
    EstadoFinOperacion:

        cmp strContenidoArchivo[si], "}"
            jne IncrementarIndice

        mov Estado, ESTADO_FIN_OPERACION_2
        jmp IncrementarIndice
    
    EstadoFinOperacion2:

        cmp strContenidoArchivo[si], "}"
            jne IncrementarIndice

        mov Estado, ESTADO_SIGUIENTE_OPERACION
        jmp IncrementarIndice

    EstadoSiguienteOperacion:

        cmp strContenidoArchivo[si], ","
            jne EstadoFinOperaciones
        
        mov Estado, ESTADO_INICIO_OPERACION
        jmp IncrementarIndice

    EstadoFinOperaciones:

        cmp strContenidoArchivo[si], "]"
            jne IncrementarIndice

        mov Estado, ESTADO_FINAL
        jmp IncrementarIndice
    
    EstadoFinal:

        cmp strContenidoArchivo[si], "}"
            jne IncrementarIndice
        
        jmp Salir

    IncrementarIndice:

        inc si
        jmp EvaluarEstado


    Salir:
        ret

AnalizarContenidoArchivo ENDP

;------------------------------------------------
GetMayor PROC USES cx si 
;
; Descripción : Obtiene el valor mayor de los resultados de las operaciones.
; Recibe      : NADA
; Devuelve    : AX = resultado de la operación
;------------------------------------------------

   Inicializacion:
        
        xor ax, ax
        xor cx, cx
        xor si, si

        INVOKE OrdenarValores
    
    ObtenerValor:
        mov ax, arrayValoresOrdenados[0]

    Salir:
        ret

GetMayor ENDP

;------------------------------------------------
GetMenor PROC USES cx si 
;
; Descripción : Obtiene el valor menor de los resultados de las operaciones.
; Recibe      : NADA
; Devuelve    : AX = resultado de la operación
;------------------------------------------------

   Inicializacion:
        
        xor ax, ax
        xor cx, cx
        xor si, si

        INVOKE OrdenarValores

    ObtenerValor:
        
        mov ax, cantidadOperaciones
        sub ax, 1
        mov si, TYPE WORD
        mul si
        mov si, ax

        mov ax, arrayValoresOrdenados[si]

    Salir:
        ret

GetMenor ENDP

;------------------------------------------------
GetMedia PROC USES cx si di
;
; Descripción : Obtiene el valor medio de los resultados de las operaciones.
; Recibe      : NADA
; Devuelve    : AX = resultado de la operación
;------------------------------------------------

   Inicializacion:
        
        xor ax, ax
        xor cx, cx
        xor si, si
        xor di, di
        
        INVOKE OrdenarValores

    Ciclo:

        add ax, arrayValoresOrdenados[si]        
        add si, TYPE WORD
        add di, 1
        cmp di, cantidadOperaciones
            jb Ciclo


    ObtenerValor:
        
        mov cx, cantidadOperaciones
        cwd
        idiv cx

    Salir:
        ret

GetMedia ENDP

;------------------------------------------------
GetMediana PROC USES cx si di
;
; Descripción : Obtiene el valor de la mediana de los resultados de las operaciones.
; Recibe      : NADA
; Devuelve    : AX = resultado de la operación
;------------------------------------------------

    Inicializacion:
        
        xor ax, ax
        xor cx, cx
        xor si, si
        xor di, di

        INVOKE OrdenarValores

    VerificarCantidadOps:

        mov ax, cantidadOperaciones
        mov cl, 2
        div cl
        cmp ah, 0
            jne EsCantidadImpar
    
    EsCantidadPar:

        sub ax, 1
        mov si, TYPE WORD
        mul si
        mov si, ax

        mov ax, arrayValoresOrdenados[si]
        add ax, arrayValoresOrdenados[si+TYPE WORD]

        Promediar:
            mov cx, 2
            cwd
            idiv cx

        jmp Salir

    EsCantidadImpar:

        mov ah, 0
        mov si, TYPE WORD
        mul si
        mov si, ax

        mov ax, arrayValoresOrdenados[si]
 
        jmp Salir

    Salir:
        ret

GetMediana ENDP


;------------------------------------------------
GetModa PROC USES bx cx dx si di
;
; Descripción : Obtiene el valor de la moda de los resultados de las operaciones.
; Recibe      : NADA
; Devuelve    : AX = resultado de la operación
;------------------------------------------------
LOCAL moda : WORD, frecuencia : WORD, frecuenciaMayor : WORD

    Inicializacion:

        xor ax, ax
        xor bx, bx 
        xor cx, cx
        xor dx, dx
        xor si, si
        xor di, di

        INVOKE OrdenarValores

        mov ax, arrayValoresOrdenados[si]
        mov moda, ax
        mov frecuencia, 0
        mov frecuenciaMayor, 1

    Ciclo:

        cmp ax, arrayValoresOrdenados[si]
            je AumentarFrecuencia

        CambioValor:
            
            mov bx, ax
            mov ax, arrayValoresOrdenados[si]
            
            mov dx, frecuencia
            mov frecuencia, 0

            cmp frecuenciaMayor, dx
                ja IncrementarIndice

            mov frecuenciaMayor, dx
            mov moda, bx
            jmp AumentarFrecuencia

        AumentarFrecuencia:
            inc frecuencia
            jmp IncrementarIndice

        IncrementarIndice:
            add si, TYPE WORD
            inc cx
            cmp cx, cantidadOperaciones
                jne Ciclo

        mov dx, frecuencia
        cmp frecuenciaMayor, dx
            ja GuardarModa
        
        mov moda, ax
        mov frecuenciaMayor, dx

    GuardarModa:

        mov ax, moda
        cmp frecuenciaMayor, 1
            je NoHayModa
        jmp HayModa
    
    NoHayModa:
        CLC
        jmp Salir
    HayModa:
        STC
        jmp Salir

    Salir:
        ret

GetModa ENDP

;------------------------------------------------
ShowMayor PROC USES ax cx si
;
; Descripción : Imprime el valor mayor de los resultados de las operaciones.
; Recibe      : NADA
; Devuelve    : Nada
;------------------------------------------------

    Inicializacion:

        xor ax, ax
        xor cx, cx 
        xor si, si

    Comando:
        
        INVOKE GetMayor
        mov cx, ax

        INVOKE ConvertirNumeroToCadena, cx, ADDR strCadenaActual, SIZEOF strCadenaActual
        INVOKE GetTamanioCadena, ADDR strCadenaActual

        mov si, ax
        mov strCadenaActual[si], "$"

        ImprimirEnConsola strMsgMayor
        ImprimirEnConsola strCadenaActual
    
    Salir:
        ret

ShowMayor ENDP

;------------------------------------------------
ShowMenor PROC USES ax cx si
;
; Descripción : Imprime el valor menor de los resultados de las operaciones.
; Recibe      : NADA
; Devuelve    : Nada
;------------------------------------------------

    Inicializacion:

        xor ax, ax
        xor cx, cx
        xor si, si        

    Comando:
        
        INVOKE GetMenor
        mov cx, ax

        INVOKE ConvertirNumeroToCadena, cx, ADDR strCadenaActual, SIZEOF strCadenaActual
        INVOKE GetTamanioCadena, ADDR strCadenaActual

        mov si, ax
        mov strCadenaActual[si], "$"

        ImprimirEnConsola strMsgMenor
        ImprimirEnConsola strCadenaActual

    Salir:
        ret

ShowMenor ENDP

;------------------------------------------------
ShowMedia PROC USES ax cx si
;
; Descripción : Imprime el valor medio de los resultados de las operaciones.
; Recibe      : NADA
; Devuelve    : Nada
;------------------------------------------------

    Inicializacion:
    
        xor ax, ax
        xor cx, cx
        xor si, si        

    Comando:

        INVOKE GetMedia
        mov cx, ax

        INVOKE ConvertirNumeroToCadena, cx, ADDR strCadenaActual, SIZEOF strCadenaActual
        INVOKE GetTamanioCadena, ADDR strCadenaActual

        mov si, ax
        mov strCadenaActual[si], "$"

        ImprimirEnConsola strMsgMedia
        ImprimirEnConsola strCadenaActual

    Salir:
        ret

ShowMedia ENDP

;------------------------------------------------
ShowMediana PROC USES ax cx si
;
; Descripción : Imprime el valor de la mediana de los resultados de las operaciones.
; Recibe      : NADA
; Devuelve    : Nada
;------------------------------------------------

    Inicializacion:

        xor ax, ax
        xor cx, cx
        xor si, si

    Comando:

        INVOKE GetMediana
        mov cx, ax

        INVOKE ConvertirNumeroToCadena, cx, ADDR strCadenaActual, SIZEOF strCadenaActual
        INVOKE GetTamanioCadena, ADDR strCadenaActual

        mov si, ax
        mov strCadenaActual[si], "$"

        ImprimirEnConsola strMsgMediana
        ImprimirEnConsola strCadenaActual
    
    Salir:
        ret

ShowMediana ENDP

;------------------------------------------------
ShowModa PROC USES ax cx si
;
; Descripción : Imprime el valor de la moda de los resultados de las operaciones.
; Recibe      : NADA
; Devuelve    : Nada
;------------------------------------------------

    Inicializacion:

        xor ax, ax
        xor cx, cx 
        xor si, si

    Comando:

        ImprimirEnConsola strMsgModa
        
        INVOKE GetModa
        jnc NoHayModa

        HayModa:

            mov cx, ax

            INVOKE ConvertirNumeroToCadena, cx, ADDR strCadenaActual, SIZEOF strCadenaActual
            INVOKE GetTamanioCadena, ADDR strCadenaActual

            mov si, ax
            mov strCadenaActual[si], "$"

            ImprimirEnConsola strCadenaActual
            jmp Salir

        NoHayModa:

            mov strNoHayModa[0], " "
            mov strNoHayModa[7], "$"

            ImprimirEnConsola strNoHayModa

            mov strNoHayModa[0], 22h
            mov strNoHayModa[7], 22h

            jmp Salir
    
    Salir:
        ret

ShowModa ENDP


;------------------------------------------------
EscribirEnReporte PROC handle : WORD, pCadena : PTR BYTE, tamanioCadena : WORD, saltoLinea : BYTE
;
; Descripción : Escribe una cadena en el reporte y posiciona el cursor al final del archivo.
; Recibe      : handle = handle del reporte.
;             : pCadena = dirección de memoria de la cadena a escribir.
;             : tamanioCadena = Tamaño de la cadena a escribir.
;             : saltoLinea = 1; Inserta salto de línea, saltoLinea = 0; No inserta salto de linea.
; Devuelve    : NADA.
;------------------------------------------------

    INVOKE CopiarCadena, pCadena, ADDR strCadenaActual, tamanioCadena
    EscribirEnArchivo handle, strCadenaActual, tamanioCadena

    cmp saltoLinea, 1
        jne Salir

    InsertarSalto:
        PosicionarEnFinalDeArchivo handle
        INVOKE CopiarCadena, ADDR strSaltoLinea, ADDR strCadenaActual, SIZEOF strSaltoLinea
        EscribirEnArchivo handle, strCadenaActual, SIZEOF strSaltoLinea

    Salir:
        PosicionarEnFinalDeArchivo handle
        ret

EscribirEnReporte ENDP

;------------------------------------------------
CrearReporte PROC USES ax bx cx dx di si, pNombreReporte : PTR BYTE
;
; Descripción : Crea el reporte de operaciones en formato JSON.
; Recibe      : pNombreReporte = dirección de memoria del nombre con el que se guardará el reporte.
; Devuelve    : NADA.
;------------------------------------------------

LOCAL handleReporte : WORD

    Inicializacion:

        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor si, si
        xor di, di
    
        INVOKE GetTiempo
        INVOKE GetFecha

    Creacion:

        INVOKE CopiarCadena, pNombreReporte, ADDR strCadenaActual, SIZEOF strCadenaActual
        
        INVOKE GetTamanioCadena, ADDR strCadenaActual
        mov si, ax

        mov strCadenaActual[si], "."
        mov strCadenaActual[si + 1], "j"
        mov strCadenaActual[si + 2], "s"
        mov strCadenaActual[si + 3], "o"
        mov strCadenaActual[si + 4], "n"

        CrearArchivo strCadenaActual, handleReporte

    Escritura:

        INVOKE EscribirEnReporte, handleReporte, ADDR strLlaveAbre, SIZEOF strLlaveAbre, 1
        
            INVOKE EscribirEnReporte, handleReporte, ADDR strReporte, SIZEOF strReporte, 1 ; REPORTE
            INVOKE EscribirEnReporte, handleReporte, ADDR strLlaveAbre, SIZEOF strLlaveAbre, 1

                INVOKE EscribirEnReporte, handleReporte, ADDR strAlumno, SIZEOF strAlumno, 1    ; ALUMNO
                
                INVOKE EscribirEnReporte, handleReporte, ADDR strLlaveAbre, SIZEOF strLlaveAbre, 1
                    INVOKE EscribirEnReporte, handleReporte, ADDR strNombreAlumno, SIZEOF strNombreAlumno, 1
                    INVOKE EscribirEnReporte, handleReporte, ADDR strCarnetAlumno, SIZEOF strCarnetAlumno, 1
                    INVOKE EscribirEnReporte, handleReporte, ADDR strSeccionAlumno, SIZEOF strSeccionAlumno, 1
                    INVOKE EscribirEnReporte, handleReporte, ADDR strCurso, SIZEOF strCurso, 1
                INVOKE EscribirEnReporte, handleReporte, ADDR strLlaveCierra, SIZEOF strLlaveCierra, 0

                INVOKE EscribirEnReporte, handleReporte, ADDR strComa, SIZEOF strComa, 1  

                INVOKE EscribirEnReporte, handleReporte, ADDR strFechaReporte, SIZEOF strFechaReporte, 1   ; FECHA
                INVOKE EscribirEnReporte, handleReporte, ADDR strLlaveAbre, SIZEOF strLlaveAbre, 1
                    
                    INVOKE EscribirEnReporte, handleReporte, ADDR strDiaReporte, SIZEOF strDiaReporte, 0   ; DIA
                    INVOKE EscribirEnReporte, handleReporte, ADDR strFecha[0], 2, 0                           
                    INVOKE EscribirEnReporte, handleReporte, ADDR strComa, SIZEOF strComa, 1

                    INVOKE EscribirEnReporte, handleReporte, ADDR strMesReporte, SIZEOF strMesReporte, 0   ; MES
                    INVOKE EscribirEnReporte, handleReporte, ADDR strFecha[3], 2, 0
                    INVOKE EscribirEnReporte, handleReporte, ADDR strComa, SIZEOF strComa, 1

                    INVOKE EscribirEnReporte, handleReporte, ADDR strAnioReporte, SIZEOF strAnioReporte, 0 ; AÑO
                    INVOKE EscribirEnReporte, handleReporte, ADDR strFecha[6], 4, 1
                    
                INVOKE EscribirEnReporte, handleReporte, ADDR strLlaveCierra, SIZEOF strLlaveCierra, 0 

                INVOKE EscribirEnReporte, handleReporte, ADDR strComa, SIZEOF strComa, 1

                INVOKE EscribirEnReporte, handleReporte, ADDR strHoraReporte, SIZEOF strHoraReporte, 1   ; hora
                INVOKE EscribirEnReporte, handleReporte, ADDR strLlaveAbre, SIZEOF strLlaveAbre, 1
                    
                    INVOKE EscribirEnReporte, handleReporte, ADDR strHoraInReporte, SIZEOF strHoraInReporte, 0   ; Hora
                    INVOKE EscribirEnReporte, handleReporte, ADDR strTiempo[0], 2, 0                           
                    INVOKE EscribirEnReporte, handleReporte, ADDR strComa, SIZEOF strComa, 1

                    INVOKE EscribirEnReporte, handleReporte, ADDR strMinutosReporte, SIZEOF strMinutosReporte, 0   ; Minutos
                    INVOKE EscribirEnReporte, handleReporte, ADDR strTiempo[3], 2, 0
                    INVOKE EscribirEnReporte, handleReporte, ADDR strComa, SIZEOF strComa, 1

                    INVOKE EscribirEnReporte, handleReporte, ADDR strSegundosReporte, SIZEOF strSegundosReporte, 0 ; Segundos
                    INVOKE EscribirEnReporte, handleReporte, ADDR strTiempo[6], 2, 1
                    
                INVOKE EscribirEnReporte, handleReporte, ADDR strLlaveCierra, SIZEOF strLlaveCierra, 0 

                INVOKE EscribirEnReporte, handleReporte, ADDR strComa, SIZEOF strComa, 1

                Resultados:

                    INVOKE EscribirEnReporte, handleReporte, ADDR strResultados, SIZEOF strResultados, 1 ; Resultados

                    INVOKE EscribirEnReporte, handleReporte, ADDR strLlaveAbre, SIZEOF strLlaveAbre, 1

                        INVOKE EscribirEnReporte, handleReporte, ADDR strMediaReporte, SIZEOF strMediaReporte, 0  ; Media
                        INVOKE GetMedia
                        mov cx, ax
                        INVOKE ConvertirNumeroToCadena, cx, ADDR strCadenaActual2, SIZEOF strCadenaActual
                        INVOKE GetTamanioCadena, ADDR strCadenaActual2
                        mov cx, ax
                        INVOKE EscribirEnReporte, handleReporte, ADDR strCadenaActual2, cx, 0
                        INVOKE EscribirEnReporte, handleReporte, ADDR strComa, SIZEOF strComa, 1


                        INVOKE EscribirEnReporte, handleReporte, ADDR strMedianaReporte, SIZEOF strMedianaReporte, 0  ; Mediana
                        INVOKE GetMediana
                        mov cx, ax
                        INVOKE ConvertirNumeroToCadena, cx, ADDR strCadenaActual2, SIZEOF strCadenaActual
                        INVOKE GetTamanioCadena, ADDR strCadenaActual2
                        mov cx, ax
                        INVOKE EscribirEnReporte, handleReporte, ADDR strCadenaActual2, cx, 0
                        INVOKE EscribirEnReporte, handleReporte, ADDR strComa, SIZEOF strComa, 1

                        INVOKE EscribirEnReporte, handleReporte, ADDR strModaReporte, SIZEOF strModaReporte, 0  ; Moda
                        
                        INVOKE GetModa
                        jnc NoHayModa

                        HayModa:

                            mov cx, ax
                            INVOKE ConvertirNumeroToCadena, cx, ADDR strCadenaActual2, SIZEOF strCadenaActual
                            INVOKE GetTamanioCadena, ADDR strCadenaActual2
                            mov cx, ax
                            INVOKE EscribirEnReporte, handleReporte, ADDR strCadenaActual2, cx, 0

                            jmp FinModa

                        NoHayModa:
                            INVOKE EscribirEnReporte, handleReporte, ADDR strNoHayModa, SIZEOF strNoHayModa, 0
                            jmp FinModa

                        FinModa:
                            INVOKE EscribirEnReporte, handleReporte, ADDR strComa, SIZEOF strComa, 1

                        INVOKE EscribirEnReporte, handleReporte, ADDR strMenorReporte, SIZEOF strMenorReporte, 0  ; Menor
                        INVOKE GetMenor
                        mov cx, ax
                        INVOKE ConvertirNumeroToCadena, cx, ADDR strCadenaActual2, SIZEOF strCadenaActual
                        INVOKE GetTamanioCadena, ADDR strCadenaActual2
                        mov cx, ax
                        INVOKE EscribirEnReporte, handleReporte, ADDR strCadenaActual2, cx, 0
                        INVOKE EscribirEnReporte, handleReporte, ADDR strComa, SIZEOF strComa, 1

                        
                        INVOKE EscribirEnReporte, handleReporte, ADDR strMayorReporte, SIZEOF strMayorReporte, 0  ; Mayor
                        INVOKE GetMayor
                        mov cx, ax
                        INVOKE ConvertirNumeroToCadena, cx, ADDR strCadenaActual2, SIZEOF strCadenaActual
                        INVOKE GetTamanioCadena, ADDR strCadenaActual2
                        mov cx, ax
                        INVOKE EscribirEnReporte, handleReporte, ADDR strCadenaActual2, cx, 1
                        

                    INVOKE EscribirEnReporte, handleReporte, ADDR strLlaveCierra, SIZEOF strLlaveCierra, 0
                    INVOKE EscribirEnReporte, handleReporte, ADDR strComa, SIZEOF strComa, 1

                

                IDPadre:

                INVOKE EscribirEnReporte, handleReporte, ADDR strTabulacion, 1, 0
                INVOKE EscribirEnReporte, handleReporte, ADDR strTabulacion, 1, 0

                INVOKE EscribirEnReporte, handleReporte, ADDR strComilla, 1, 0
                INVOKE EscribirEnReporte, handleReporte, pNombreReporte, si, 0   ; ID PADRE
                INVOKE EscribirEnReporte, handleReporte, ADDR strComilla, 1, 0
                INVOKE EscribirEnReporte, handleReporte, ADDR strDoblePunto, 1, 1
                INVOKE EscribirEnReporte, handleReporte, ADDR strCorcheteAbre, SIZEOF strCorcheteAbre, 1

                Operaciones:

                    
                    mov cx, cantidadOperaciones
                    xor dx, dx
                    xor di, di

                    Ciclo:

                        INVOKE EscribirEnReporte, handleReporte, ADDR strLlaveAbre, SIZEOF strLlaveAbre, 1

                            INVOKE EscribirEnReporte, handleReporte, ADDR strTabulacion, 1, 0
                            INVOKE EscribirEnReporte, handleReporte, ADDR strTabulacion, 1, 0
                            INVOKE EscribirEnReporte, handleReporte, ADDR strTabulacion, 1, 0

                            INVOKE EscribirEnReporte, handleReporte, ADDR strComilla, 1, 0

                            INVOKE GetTamanioCadena, ADDR arrayOperaciones[di].Nombre
                            mov dx, ax

                            INVOKE EscribirEnReporte, handleReporte, ADDR arrayOperaciones[di].Nombre, dx, 0
                            INVOKE EscribirEnReporte, handleReporte, ADDR strComilla, 1, 0
                            
                            INVOKE EscribirEnReporte, handleReporte, ADDR strDoblePunto, 1, 0

                            INVOKE ConvertirNumeroToCadena, arrayOperaciones[di].Valor, ADDR strCadenaActual2, SIZEOF strCadenaActual
                            INVOKE GetTamanioCadena, ADDR strCadenaActual2
                            mov dx, ax
                            INVOKE EscribirEnReporte, handleReporte, ADDR strCadenaActual2, dx, 1

                        INVOKE EscribirEnReporte, handleReporte, ADDR strLlaveCierra, SIZEOF strLlaveCierra, 0

                        cmp cx, 1
                            je AumentarIndice

                        INVOKE EscribirEnReporte, handleReporte, ADDR strComa, SIZEOF strComa, 1
                        
                        AumentarIndice:

                            add di, TYPE Operacion
                            dec cx
                            cmp cx, 0
                                jne Ciclo


                INVOKE EscribirEnReporte, handleReporte, ADDR strCorcheteCierra, SIZEOF strCorcheteCierra, 1

            INVOKE EscribirEnReporte, handleReporte, ADDR strLlaveCierra, SIZEOF strLlaveCierra, 1

        INVOKE EscribirEnReporte, handleReporte, ADDR strLlaveCierra, SIZEOF strLlaveCierra, 1

    Cierre:

        CerrarArchivo handleReporte

    Salir:
        ret

CrearReporte ENDP

;------------------------------------------------
ShowID PROC USES ax bx cx di si, pEntrada : PTR BYTE
;
; Descripción : Imprime el valor de un identificador o, en caso de que se pase el nombre del objeto padre,
;             : se creará el reporte con extensión .json de operaciones.
; Recibe      : pEntrada = dirección de memoria donde se encuentra la cadena con el identificador a mostrar.
; Devuelve    : NADA
;------------------------------------------------

    Inicializacion:
        
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor si, si 
        xor di, di
    
    VerificarSiEsPadre:

        INVOKE CompararCadenas, ADDR strNombrePadre, pEntrada
        jnc ObtenerValor

        INVOKE CrearReporte, pEntrada
        jmp Salir
        
    ObtenerValor:

        INVOKE GetValorDeIdentificador, pEntrada
        mov cx, ax

        jc IDEncontrado
        jmp IDNOExiste

    IDEncontrado:

        INVOKE CopiarCadena, pEntrada, ADDR strCadenaActual, SIZEOF strCadenaActual
        INVOKE GetTamanioCadena, pEntrada

        mov si, ax
        mov strCadenaActual[si], "$"

        ImprimirEnConsola strMsgResultado
        ImprimirEnConsola strCadenaActual
        ImprimirEnConsola strDoblePunto

        INVOKE ConvertirNumeroToCadena, cx, ADDR strCadenaActual, SIZEOF strCadenaActual

        INVOKE GetTamanioCadena, ADDR strCadenaActual
        mov si, ax
        mov strCadenaActual[si], "$"

        ImprimirEnConsola strCadenaActual
        jmp Salir

    IDNOExiste:

        ImprimirEnConsola strErrorIDNoEncontrado
        jmp Salir

    Salir:
        ret

ShowID ENDP



;------------------------------------------------
EjecutarMenu PROC
;
; Descripción : Muestra el menú y y lee la opción ingresada por el usuario.
; Recibe      : NADA.
; Devuelve    : NADA.
;------------------------------------------------

    Mostrar:
        ImprimirEnConsola strMenuInicio
        INVOKE LeerCadenaConsola, ADDR strBufferEntrada, SIZEOF strBufferEntrada

        cmp strBufferEntrada[0], "1"
            je OpCargarArchivo
        cmp strBufferEntrada[0], "2"
            je OpConsola
        cmp strBufferEntrada[0], "3"
            je Salir

        jmp OpInvalida
    
    OpCargarArchivo:
        
        ImprimirEnConsola strSoliciarNombre
        INVOKE LeerCadenaConsola, ADDR strBufferEntrada, SIZEOF strBufferEntrada
        CargarArchivo strBufferEntrada
        INVOKE AnalizarContenidoArchivo
        ImprimirEnConsola strMsgArchivoCargado
        jmp Mostrar

    OpConsola:
        ImprimirEnConsola strConsola
        INVOKE LeerCadenaConsola, ADDR strBufferEntrada, SIZEOF strBufferEntrada

        cmp strBufferEntrada[0], "e"
            je OpExit
        cmp strBufferEntrada[0], "s"
            jne OpInvalida
        cmp strBufferEntrada[1], "h"
            jne OpInvalida
        cmp strBufferEntrada[2], "o"
            jne OpInvalida
        cmp strBufferEntrada[3], "w"
            jne OpInvalida


        OpMedia:

            cmp strBufferEntrada[5], "m"
                jne OpID
            cmp strBufferEntrada[6], "e"
                jne OpMediana
            cmp strBufferEntrada[7], "d"
                jne OpMediana
            cmp strBufferEntrada[8], "i"
                jne OpMediana
            cmp strBufferEntrada[9], "a"
                jne OpMediana
            cmp strBufferEntrada[10], 00h
                jne OpMediana

            INVOKE ShowMedia
            jmp OpConsola            

        OpMediana:

            cmp strBufferEntrada[5], "m"
                jne OpID
            cmp strBufferEntrada[6], "e"
                jne OpModa
            cmp strBufferEntrada[7], "d"
                jne OpModa
            cmp strBufferEntrada[8], "i"
                jne OpModa
            cmp strBufferEntrada[9], "a"
                jne OpModa
            cmp strBufferEntrada[10], "n"
                jne OpModa
            cmp strBufferEntrada[11], "a"
                jne OpModa
            cmp strBufferEntrada[12], 00h
                jne OpModa

            INVOKE ShowMediana
            jmp OpConsola            


        OpModa:

            cmp strBufferEntrada[5], "m"
                jne OpID
            cmp strBufferEntrada[6], "o"
                jne OpMayor
            cmp strBufferEntrada[7], "d"
                jne OpMayor
            cmp strBufferEntrada[8], "a"
                jne OpMayor
            cmp strBufferEntrada[9], 00h
                jne OpMayor
            
            INVOKE ShowModa
            jmp OpConsola


        OpMayor:

            cmp strBufferEntrada[5], "m"
                jne OpID
            cmp strBufferEntrada[6], "a"
                jne OpMenor
            cmp strBufferEntrada[7], "y"
                jne OpMenor
            cmp strBufferEntrada[8], "o"
                jne OpMenor
            cmp strBufferEntrada[9], "r"
                jne OpMenor
            cmp strBufferEntrada[10], 00h
                jne OpMenor

            INVOKE ShowMayor
            jmp OpConsola


        OpMenor:

            cmp strBufferEntrada[5], "m"
                jne OpID
            cmp strBufferEntrada[6], "e"
                jne OpID
            cmp strBufferEntrada[7], "n"
                jne OpID
            cmp strBufferEntrada[8], "o"
                jne OpID
            cmp strBufferEntrada[9], "r"
                jne OpID
            cmp strBufferEntrada[10], 00h
                jne OpID

            INVOKE ShowMenor
            jmp OpConsola


        OpID:

            INVOKE ShowID, ADDR strBufferEntrada[5]
            jmp OpConsola

        OpExit:

            cmp strBufferEntrada[0], "e"
                jne OpInvalida
            cmp strBufferEntrada[1], "x"
                jne OpInvalida
            cmp strBufferEntrada[2], "i"
                jne OpInvalida
            cmp strBufferEntrada[3], "t"
                jne OpInvalida

            jmp Mostrar

    OpInvalida:
        ImprimirEnConsola strOpcionInvalida
        jmp OpConsola

    Salir:
        ret

EjecutarMenu ENDP


Main PROC

    Inicio:
        mov ax, @data
        mov ds, ax

    Menu:
        INVOKE EjecutarMenu

    Salir:
        TerminarPrograma
    
Main ENDP



END Main