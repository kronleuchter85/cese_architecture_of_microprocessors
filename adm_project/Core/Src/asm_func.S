.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_svc
.global asm_sum
.global asm_zeros
.global asm_copy_vector
.global asm_scalarProduct32

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_svc (void)
@
.thumb_func
    asm_svc:
        svc 0
        bx lr


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   uint32_t asmSum (uint32_t firstOperand, uint32_t secondOperand)
@
@ Parametros recibidos:
@   r0: firstOperand
@   r1: secondOperand
@
@ Valor de retorno:
@   r0: resultado de la suma de firstOperand y secondOperand
@
.thumb_func
    asm_sum:
        add r0, r1  @ r0 = r0 + r1
        bx lr       @ vuelve adonde fue llamada (especificamente, si "pc"
                    @ es la direccion, en el codigo del programa, de la
                    @ instruccion "bl asm_sum" usada para saltar a
                    @ esta funcion, entonces "lr" contiene ese "pc" + 4).
                    @ el valor de retorno debe quedar en el registro r0.
                    @ En este caso, r0 es el resultado de r0 + r1.

        @ Otras alternativas para el retorno
        @ mov pc,lr
        @ bx lr
        @ push {lr} ... pop {pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_zeros (uint32_t *vector, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: *vector
@   r1: longitud
@
.thumb_func
    asm_zeros:
        @ Registros usados
        @   r2: valor cero
        mov r2, 0           @ constante cero
    .asm_zeros_loop:
        str r2, [r0], 4     @ sizeof(uint32_t) == 4, *vector++ = r2
        subs r1, 1          @ --longitud
        bne .asm_zeros_loop
        bx lr



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_copy_vector (uint32_t *vector1, uint32_t *vector2, uint32_t length);
@
@ Parametros recibidos:
@   r0: *vector1
@   r1: *vector2
@   r2: length
@
.thumb_func
    asm_copy_vector:
    	@ Registros usados
    	@	r3: valor cero
    	mov		r3,0
    .asm_copy_loop:
    	ldr		r3,[r0],4
    	str		r3,[r1],4
    	subs	r2, 1
    	bne		.asm_copy_loop
    	bx		lr
    	


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_scalarProduct32(uint32_t *vectorIn, uint32_t *vectorOut, uint32_t length, uint32_t scalarNumber);
@
@ Parametros recibidos:
@   r0: *vectorIn
@   r1: *vectorOut
@   r2: length
@	r3:	scalarNumber
@
.thumb_func
    asm_scalarProduct32:
    	@ Registros usados
    	@	r4: inicializo en cero - estoy asumiendo que el R4 es un registro de proposito general
    	@		claramente pueda haber algo importante ahi y todo puede fallar..
    	mov		r4,0
    .asm_scalarProduct32_loop_1:
    	ldr		r4,[r0],4
    	mul		r4,r3
    	str		r4,[r1],4
    	subs	r2, 1
    	bne		.asm_scalarProduct32_loop_1
    	bx		lr
    	