; Este programa deve esperar o usuário pressionar uma chave.
; Caso o usuário pressione uma chave, um LED deve piscar a cada 1 segundo.

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Definições de Valores
;0x10 ativa o Digito 1, 0x20 ativo o Digito 2
Display1 			EQU				0x10	;Seleciona o Display1
Display2			EQU				0x20	;Seleciona o Display2
Ativar				EQU				0x01	;Modo Ativar
Desativar			EQU				0x00	;Modo Desativar
PASSO				EQU				0x01	;PASSO de contagem, PASSO pode ser igual a 1,2,3,4,5,6,7,8,9
USR_SW1				EQU				0x01	;BOTAO PJ0 = BOTAO ESQUERDO DA PLACA
USR_SW2				EQU				0x02    ;BOTAO PJ1 = BOTAO DIREITO DA PLACA
Ativar_leds			EQU 			0x20	;Ativa os leds
Desativar_leds		EQU				0x00	;Desativa os leds
Leds_seq1			EQU				2_10101010 
Leds_seq2			EQU				2_01010101
; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms			
		IMPORT  GPIO_Init
        IMPORT  PortN_Output
        IMPORT  PortJ_Input	
		IMPORT 	AtivarDesativar_Display
		IMPORT  AtivarDesativar_Leds
		IMPORT  Leds_out
; -------------------------------------------------------------------------------
; Função main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	
MainLoop
	MOV R9,#PASSO				; R9 será o passo de contagem
Resetar	
	MOV R10,#0					; Contador auxiliar
	MOV R2,#0					; Contador DIGITO 1     
	MOV R3,#0					; Contador DIGITO 2
	MOV R8,#500				    ; Variavel para controle do tempo do passo da contagem
	MOV R4,#2_01010101          ; Padrao dos leds
testa_entrada
	;Utilizar dois contadores, um para cada display
	;Ativa um dos displays por um tempo T
	
	;***************************************************
	;Lê os botoes USR_SW1 = PJ0 e USR_SW2 = PJ1
	;Se SW1 = 0 e SW2 = 1 R9++ 
	;	SW1 = 1 e SW2 = 0 r9--
	;Para outros casos não alterar o passo
	;Caso Ocarra leitura de botao sendo pressionado, em R12 é salvo 1
	;Na próxima leitura se o botao foi solto, nao pressionado, o valor 2 é salvo em R12=SW2 e  R11=S1

TESTE_AMBOSSOLTOS
	BL PortJ_Input				;Retorna a leitura do portJ no registrador R0
	AND R0,#2_00000011			;Retorna para R0 apenas a informação de J0 e J1 com os outros bits resetados	
	CMP R0,#2_00000011		    ;Testa se apenas SW1 e SW2 estão soltos,ou seja, em nível alto
	BNE TESTE_AMBOSPRESSIONADOS
	CMP R11,#1					;Se o botao foi pressionado anteriormente
	BNE	t2
	MOV R11,#2					;R11=2
t2
	CMP R12,#1
	BNE t3
	MOV R12,#2					;R12=2
t3
	B ATUALIZA_PASSO
TESTE_AMBOSPRESSIONADOS
	CMP R0,#2_00000000
	BNE TESTE_SW1
	MOV R11,#1
	MOV R12,#1
	B ATUALIZA_PASSO
TESTE_SW1
	CMP R0,#2_00000010
	BNE TESTE_SW2
	CMP R12,#1					;Se o botao foi pressionado anteriormente
	BNE	t4
	MOV R12,#2					;R12=2
t4
	MOV R11,#1					;R11=1
	B ATUALIZA_PASSO
TESTE_SW2
	CMP R11,#1					;Se o botao foi pressionado anteriormente
	BNE	t5
	MOV R11,#2					;R11=2
t5
	MOV R12,#1					;R12=1

	
ATUALIZA_PASSO
	CMP R11,#2
	BNE teste_r12
	MOV R11,#0					;Reseta R11
	CMP R9,#9					;Se o PASSO já estiver no máximo, então vai ao LOOP sem incrementar
	BEQ teste_r12
	ADD R9,#1
	
teste_r12
	CMP R12,#2
	BNE Incrementa_digito2
	MOV R12,#0					;Reseta R12
	CMP R9,#1					;Testa se o passo é 1, pois é o passo minimo, se sim vai ao LOOP sem decrementar
	BEQ Incrementa_digito2
	SUB	R9,#1
	
Incrementa_digito2
	
								;Display 2 sendo atribuido por R7
	MOV R7,R3
	BL PortN_Output
	
	MOV R0,#Display2
	MOV R5,#Ativar
	BL AtivarDesativar_Display
	
	;Desativa um dos displays
	MOV R0,#Display1
	MOV R5,#Desativar
	BL AtivarDesativar_Display
	;Desativa os leds
	MOV R0,#Desativar_leds
	BL AtivarDesativar_Leds
	
	MOV R0,#1
	BL SysTick_Wait1ms
	
	;Display 1 sendo atribuido por R7
	MOV R7,R2
	BL PortN_Output
	
	MOV R0,#Display1
	MOV R5,#Ativar
	BL AtivarDesativar_Display
	
	MOV R0,#Display2
	MOV R5,#Desativar
	BL AtivarDesativar_Display
	;Desativa os leds
	MOV R0,#Desativar_leds
	BL AtivarDesativar_Leds
	;Espera ligado por 5ms f = 200Hz
	MOV R0,#1
	BL SysTick_Wait1ms
	
	CMP R8,#500 ;Verifica se está no loop inicial
	BNE CHECAR_TESTE	
;Teste de numeros primos
	LDR R0,=PRIMOS
TESTE_PRIMOS
	LDRB R1,[R0],#1
	CMP R1,#0
	ITE EQ ;Se o loop de primos chegou no dado 0, entao nao o dado nao é primo
	MOVEQ R6,#0;Se R1 =0, Então não é primo R6 = 0
	MOVNE R6,#1;Senão, então é primo R6 = 1
	BEQ CHECAR_TESTE
	CMP R1,R10
	ITE EQ
	MOVEQ R6,#1
	MOVNE R6,#0
	BEQ CHECAR_TESTE
	B TESTE_PRIMOS
CHECAR_TESTE	
	CMP R6,#0 ;1 PRIMO 
	BNE LEDS_ACESOS
LEDS_APAGADOS
	MOV R0,#Desativar_leds
	BL AtivarDesativar_Leds
	B FIM_LEDS
LEDS_ACESOS
	;Desativa um dos displays
	MOV R0,#Display2
	MOV R5,#Desativar
	BL AtivarDesativar_Display
	MOV R0,#Display1
	BL AtivarDesativar_Display
	MOV R0,#Ativar_leds
	BL AtivarDesativar_Leds 
	;Rotaciona a sequencia dos leds acesos
	
	
	CMP R8,#500
	IT EQ
	EOREQ R4,R4,#2_11111111
    MOV R0,R4
	BL Leds_out
	
FIM_LEDS
	
	MOV R0,#1
	BL SysTick_Wait1ms
	;Subtrai 1 de R8 e testa se já é nulo, se sim pula para o próximo número
	;R8 serve para deixar o display 1 e 2 ligados por um tempo determinado pelos delays colocados no código acima
	;T = (Tdisplay1*n1+Tdisplay2*n2)*R8
	SUB R8,#1
	CMP R8,#450
	BEQ testa_entrada
	CMP R8,#400
	BEQ testa_entrada
	CMP R8,#350
	BEQ testa_entrada
	CMP R8,#300
	BEQ testa_entrada
	CMP R8,#150
	BEQ testa_entrada
	CMP R8,#50
	BEQ testa_entrada
	CMP R8,#0
	BNE Incrementa_digito2;testa_entrada
	MOV R6,#0
	ADD R10,R9				;Incrementa o contador auxiliar para teste de números primos
							;Testa se R3 estourou, passou de 9
	ADD R3,R9				;Incrementa o contador do display2
	CMP R3,#10
	BHS Incrementa_digito1
	;
	MOV R8,#500
	B Incrementa_digito2

Incrementa_digito1
	MOV R8,#500
	SUB R3,#10
	ADD R2,#1				;Incrementa o contador do display1
	CMP R2,#10
	BHS Resetar
	B Incrementa_digito2
	
	B MainLoop					 ;Se o teste viu que nenhuma chave está pressionada, volta para o laço principal






;Eh necessario configurar os Ports Q,A,B e P
; Saidas   =  Q0 Q1 Q2 Q3 A4 A5 A6 A7 P6 B4 B5
; Entradas =  J0 J1

LEDS_SEQ DCB 2_01010101
PRIMOS DCB	2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97,0
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
