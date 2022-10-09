; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definições dos Ports
; PORT Q 						   
GPIO_PORTQ_AHB_LOCK_R    	EQU    0x40066520
GPIO_PORTQ_AHB_CR_R      	EQU    0x40066524
GPIO_PORTQ_AHB_AMSEL_R   	EQU    0x40066528
GPIO_PORTQ_AHB_PCTL_R    	EQU    0x4006652C
GPIO_PORTQ_AHB_DIR_R     	EQU    0x40066400
GPIO_PORTQ_AHB_AFSEL_R   	EQU    0x40066420
GPIO_PORTQ_AHB_DEN_R     	EQU    0x4006651C
GPIO_PORTQ_AHB_PUR_R     	EQU    0x40066510	
GPIO_PORTQ_AHB_DATA_R    	EQU    0x400663FC
GPIO_PORTQ               	EQU    2_100000000000000
; PORT A
GPIO_PORTA_AHB_LOCK_R    	EQU    0x40058520
GPIO_PORTA_AHB_CR_R      	EQU    0x40058524
GPIO_PORTA_AHB_AMSEL_R   	EQU    0x40058528
GPIO_PORTA_AHB_PCTL_R    	EQU    0x4005852C
GPIO_PORTA_AHB_DIR_R     	EQU    0x40058400
GPIO_PORTA_AHB_AFSEL_R   	EQU    0x40058420
GPIO_PORTA_AHB_DEN_R     	EQU    0x4005851C
GPIO_PORTA_AHB_PUR_R     	EQU    0x40058510	
GPIO_PORTA_AHB_DATA_R    	EQU    0x400583FC
GPIO_PORTA               	EQU    2_000000000000001	
; PORT B
GPIO_PORTB_AHB_LOCK_R    	EQU    0x40059520
GPIO_PORTB_AHB_CR_R      	EQU    0x40059524
GPIO_PORTB_AHB_AMSEL_R   	EQU    0x40059528
GPIO_PORTB_AHB_PCTL_R    	EQU    0x4005952C
GPIO_PORTB_AHB_DIR_R     	EQU    0x40059400
GPIO_PORTB_AHB_AFSEL_R   	EQU    0x40059420
GPIO_PORTB_AHB_DEN_R     	EQU    0x4005951C
GPIO_PORTB_AHB_PUR_R     	EQU    0x40059510	
GPIO_PORTB_AHB_DATA_R    	EQU    0x400593FC
GPIO_PORTB               	EQU    2_000000000000010	
; PORT P
GPIO_PORTP_AHB_LOCK_R    	EQU    0x40065520
GPIO_PORTP_AHB_CR_R      	EQU    0x40065524
GPIO_PORTP_AHB_AMSEL_R   	EQU    0x40065528
GPIO_PORTP_AHB_PCTL_R    	EQU    0x4006552C
GPIO_PORTP_AHB_DIR_R     	EQU    0x40065400
GPIO_PORTP_AHB_AFSEL_R   	EQU    0x40065420
GPIO_PORTP_AHB_DEN_R     	EQU    0x4006551C
GPIO_PORTP_AHB_PUR_R     	EQU    0x40065510	
GPIO_PORTP_AHB_DATA_R    	EQU    0x400653FC
GPIO_PORTP               	EQU    2_010000000000000
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ               	EQU    2_000000100000000
	
; Tabela binario para display de 7 segmentos
;		O display eh conectado por dois ports, o primeiro eh o Port Q
;		O segundo eh o Port A, portanto precisamos de 2 NIBBLES para cada digito
;		Portando os 8 bits sao separados em 2 nibbles, um para cada Registrador Data do respectivo Port
;		NIBBLE1 refere-se ao Port Q
;		NIBBLE2 refere-se ao Port A
;**********************************************************
;	Para modificar apenas 4 bits precisamos fazer uma mascara com 0000 nos bits do registrador que queremos modificar
;	e 0 no nosso NIBBLE , assim fazemos uma operacao OR entre o NIBBLE e o registrador, nao afetando outros bits.
; ****************************************
; Decodificacao binario para display de 7 segmentos
; 
; ****************************************
;				GPIO do mcu				Pino do display			LEDS DA PLACA DE TESTES
;				PQ0  			---  		a							LED 8
;				PQ1	 			---  		b							LED 7
;				PQ2  			---  		c 							LED 6
;				PQ3 		    ---  		d							LED 5	
;				PA4  			---  		e							LED 4
;				PA5  			---  		f							LED 3
;				PA6 		    ---  		g							LED 2
;				PA7  			---  		PONTO						LED 1
;	PB4 Ativa o display 1	
;	PB5 Ativa o display 2
;	PM6 Ativa os LEDS da placa
;*****************************************
;	2_00111111 0
;	2_00000110 1
;	2_01011011 2
;	2_01001111 3
;	2_01100110 4
;	2_01101101 5
;	2_01111101 6
;	2_00000111 7
;	2_01111111 8
;	2_01101111 9
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            		; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortN_Output					; Permite chamar PortN_Output de outro arquivo
		EXPORT PortJ_Input          		; Permite chamar PortJ_Input de outro arquivo
		EXPORT AtivarDesativar_Display		; Aciona os displays ou os desativa com base em R0					
		EXPORT AtivarDesativar_Leds			; Aciona os LEDs ou os desativa com base em R0
		EXPORT Leds_out
;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; ****************************************
; Escrever função de inicialização dos GPIO
; Eh necessario configurar os Ports Q,A,B e P
; Saidas   =  Q0 Q1 Q2 Q3 A4 A5 A6 A7 B4 B5 P6
; Entradas =  J0 J1
; OBS.: -> PINO K3 com o pad danificado da PAT
; ****************************************

	LDR		R0,=SYSCTL_RCGCGPIO_R ;;Pegando o endereço do registrador do clock
	LDR 	R1,[R0]				
	MOV		R1, #GPIO_PORTQ                 ;Seta o bit da porta Q
	ORR     R1, #GPIO_PORTA					;Seta o bit da porta A, fazendo com OR
	ORR     R1, #GPIO_PORTB					;Seta o bit da porta B, fazendo com OR
	ORR     R1, #GPIO_PORTP					;Seta o bit da porta P, fazendo com OR
	ORR     R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
    STR     R1, [R0]						;Move para a memória os bits das portas no endereço do RCGCGPIO
	 
	LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  
	LDR     R1, [R0]						;Lê da memória o conteúdo do endereço do registrador
	MOV		R2, #GPIO_PORTQ                 ;Seta o bit da porta Q
	ORR     R2, #GPIO_PORTA					;Seta o bit da porta A, fazendo com OR
	ORR     R2, #GPIO_PORTB					;Seta o bit da porta B, fazendo com OR
	ORR     R2, #GPIO_PORTP					;Seta o bit da porta P, fazendo com OR
	ORR     R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
    TST     R1, R2							;ANDS de R1 com R2
    BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o laço. Senão continua executando
 
	;; AMSEL de todos deve ser resetado
	LDR 	R0,=GPIO_PORTJ_AHB_AMSEL_R
	LDR 	R1,[R0]
	BIC		R1,R1,#0x03;J0 J1 resetados
	STR		R1,[R0]
	
	LDR 	R0,=GPIO_PORTQ_AHB_AMSEL_R
	LDR 	R1,[R0]
	BIC		R1,R1,#0x0F;Q0 Q1 Q2 Q3 resetados
	STR		R1,[R0]
	
	LDR 	R0,=GPIO_PORTA_AHB_AMSEL_R
	LDR 	R1,[R0]
	BIC		R1,R1,#0xF0;A4 A5 A6 A7 resetados
	STR		R1,[R0]
	
	LDR 	R0,=GPIO_PORTB_AHB_AMSEL_R
	LDR 	R1,[R0]
	BIC		R1,R1,#0x30;B4 B5 resetados
	STR		R1,[R0]
	
	LDR 	R0,=GPIO_PORTP_AHB_AMSEL_R
	LDR 	R1,[R0]
	BIC		R1,R1,#0x20;P5 resetado
	STR		R1,[R0]
	
	;;Desativar a funcao alternativa para todos no registrador PCTL
	LDR		R0,=GPIO_PORTJ_AHB_PCTL_R
	LDR 	R1,[R0]
	BIC		R1,R1,#0xFF						;;J0 e J1 
	STR 	R1,[R0]
	
	LDR		R0,=GPIO_PORTQ_AHB_PCTL_R
	LDR 	R1,[R0]
	MOV		R2,#0xFFFF
	BIC		R1,R1,R2					;;Q0 Q1 Q2 Q3 
	STR 	R1,[R0]
	
	LDR		R0,=GPIO_PORTA_AHB_PCTL_R
	LDR 	R1,[R0]
	MOV 	R2,#0x0000
	MOVT	R2,#0xFFFF
	BIC		R1,R1,R2				;;A4 A5 A6 A7 
	STR 	R1,[R0]
	
	LDR		R0,=GPIO_PORTB_AHB_PCTL_R
	LDR 	R1,[R0]
	BIC		R1,R1,#0xFF0000					;;B4 B5
	STR 	R1,[R0]
	
	LDR		R0,=GPIO_PORTP_AHB_PCTL_R
	LDR 	R1,[R0]
	BIC		R1,R1,#0x0F00000			    ;;P5 
	STR 	R1,[R0]
	
	;;Setando a direcao dos pinos, J ENTRADA=0 e Q A B M SAÍDA=1
	LDR 	R0,=GPIO_PORTJ_AHB_DIR_R
	LDR 	R1,[R0]
	BIC		R1,R1,#0x03						;;J0 J1	 ENTRADAS			
	STR 	R1,[R0]
	
	LDR 	R0,=GPIO_PORTQ_AHB_DIR_R
	LDR 	R1,[R0]
	ORR		R1,#0x0F						;;Q0 Q1 Q2 Q3 SAIDAS
	STR 	R1,[R0]
	
	LDR 	R0,=GPIO_PORTA_AHB_DIR_R
	LDR 	R1,[R0]
	ORR		R1,#0xF0						;;A4 A5 A6 A7  SAIDAS
	STR 	R1,[R0]
	
	LDR 	R0,=GPIO_PORTB_AHB_DIR_R
	LDR 	R1,[R0]
	ORR		R1,#0x30						;;B4 B5  SAIDAS
	STR 	R1,[R0]
	
	LDR 	R0,=GPIO_PORTP_AHB_DIR_R
	LDR 	R1,[R0]
	ORR		R1,#0x20						;;P5  SAIDA
	STR 	R1,[R0]
	
	;;Retirando a opcao de funcao alternativa de todos os ports
	LDR 	R0,=GPIO_PORTJ_AHB_AFSEL_R
	LDR 	R1,[R0]
	BIC		R1,R1,#0x03;J0 J1 resetados
	STR		R1,[R0]
	
	LDR 	R0,=GPIO_PORTQ_AHB_AFSEL_R
	LDR 	R1,[R0]
	BIC		R1,R1,#0x0F;Q0 Q1 Q2 Q3 resetados
	STR		R1,[R0]
	
	LDR 	R0,=GPIO_PORTA_AHB_AFSEL_R
	LDR 	R1,[R0]
	BIC		R1,R1,#0xF0;A4 A5 A6 A7 resetados
	STR		R1,[R0]
	
	LDR 	R0,=GPIO_PORTB_AHB_AFSEL_R
	LDR 	R1,[R0]
	BIC		R1,R1,#0x30;B4 B5 resetados
	STR		R1,[R0]
	
	LDR 	R0,=GPIO_PORTP_AHB_AFSEL_R
	LDR 	R1,[R0]
	BIC		R1,R1,#0x20;P5 resetado
	STR		R1,[R0]
	
	;;Todos os ports como entradas e saidas digitais
	LDR 	R0,=GPIO_PORTJ_AHB_DEN_R
	LDR 	R1,[R0]
	ORR		R1,#0x03;J0 J1 setados
	STR		R1,[R0]
	
	LDR 	R0,=GPIO_PORTQ_AHB_DEN_R
	LDR 	R1,[R0]
	ORR		R1,#0x0F;Q0 Q1 Q2 Q3 setados
	STR		R1,[R0]
	
	LDR 	R0,=GPIO_PORTA_AHB_DEN_R
	LDR 	R1,[R0]
	ORR		R1,#0xF0;A4 A5 A6 A7 setados
	STR		R1,[R0]
	
	LDR 	R0,=GPIO_PORTB_AHB_DEN_R
	LDR 	R1,[R0]
	ORR		R1,#0x30;B4 B5 setados
	STR		R1,[R0]
	
	LDR 	R0,=GPIO_PORTP_AHB_DEN_R
	LDR 	R1,[R0]
	ORR		R1,#0x20;P5 setado
	STR		R1,[R0]
	
	;;Setando pull up em J0 e J1
	LDR 	R0,=GPIO_PORTJ_AHB_PUR_R
	LDR 	R1,[R0]
	ORR		R1,#0x03
	STR 	R1,[R0]
	
	BX LR

; -------------------------------------------------------------------------------
; Função PortN_Output
; Parâmetro de entrada:R7 = Digito = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
; Parâmetro de saída: Não tem
PortN_Output
; ****************************************
; Escrever função que acende ou apaga o LED
; ****************************************
	PUSH 	{R0,R1,R2,R3,R7}						;Salva os valores dos registradores que estao sendo modificados localmente
													;Pega o valor decimal decodificado para display 7 segmentos do VETOR
	LDR 	R1, =VETOR								;Pega o endereco do inicial do vetor
	LDRB 	R0,[R1,R7]								;armazena em R0 o valor de indice R2 do vetor 
	
	
Saida_A ;A4 A5 A6 A7 e f g PONTO
	LDR		R1, =GPIO_PORTA_AHB_DATA_R
	LDR		R7, [R1]
	BIC 	R7, R7,#0xF0                            ;MASCARA 0XF0 = NIBBLE 2
	ORR 	R3, R0, R7                              ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR 	R3, [R1]                                

Saida_Q ;Q0 Q1 Q2 Q3 a b c d
	LDR		R1, =GPIO_PORTQ_AHB_DATA_R
	LDR 	R7, [R1]
	BIC 	R7, R7,#0x0F                            ;MASCARA = 0X0F =NIBBLE1 
	ORR 	R3, R0, R7                              ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR 	R3, [R1]                                ;Escreve na porta Q o barramento de dados dos pinos Q0 Q1 Q2 Q3

	POP 	{R0,R1,R2,R3,R7}						;Restaura os valores dos registradores
	BX 		LR

Leds_out
	PUSH 	{R0,R1,R2,R3,R7}						;Salva os valores dos registradores que estao sendo modificados localmente
	LDR 	R1,=GPIO_PORTA_AHB_DATA_R
	LDR 	R7,[R1]
	BIC 	R7, R7,#0xF0                            ;MASCARA 0XF0 = NIBBLE 2
	ORR 	R3, R0, R7                              ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR 	R3, [R1]   
	LDR		R1, =GPIO_PORTQ_AHB_DATA_R
	LDR 	R7, [R1]
	BIC 	R7, R7,#0x0F                            ;MASCARA = 0X0F =NIBBLE1 
	ORR 	R3, R0, R7                              ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR 	R3, [R1]                                ;Escreve na porta Q o barramento de dados dos pinos Q0 Q1 Q2 Q3
	POP 	{R0,R1,R2,R3,R7}						;Restaura os valores dos registradores
	BX LR
	
;Ativa o display 1 ou o 2 ou os desativa
;Parâmetro de entrada : R0 = 0x10 ativa/desativa o Digito 1, 0x20 ativa/desativa o Digito 2
;Parâmetro de entrada : R5 modo(0 = desativar e 1 = ativar)
;Parâmetro de saída: Não tem

AtivarDesativar_Display	
	PUSH 	{R0,R1,R2,R5}
	LDR 	R1, = GPIO_PORTB_AHB_DATA_R
	LDR 	R2,[R1]
	CMP 	R5,#0 									;Modo desativar selecionado
	
	BEQ		Desativar
	BIC 	R2, R2, R0                              ;MASCARA = 0X10 = M4 ou MASCARA = 0X20 = M5
	ORR 	R0, R0, R2                              ;Fazer o OR do lido pela porta com o parâmetro de entrada
	B FINAL
Desativar
	BIC 	R0, R2, R0                              ;Desativa o bit selecionado
FINAL
	STR 	R0, [R1]                                ;Atualiza a saida
	POP 	{R0,R1,R2,R5}	
	BX		LR
	
;Ativa ou desativa os LEDs
;Parâmetro de entrada : R0 se R0 =0x20 ativa os LEDs, se R0 = 0x00 desativa os LEDs
;Parâmetro de saída: Não tem
AtivarDesativar_Leds	
	PUSH 	{R0,R1,R2}
	LDR 	R1, = GPIO_PORTP_AHB_DATA_R
	LDR 	R2,[R1]
	BIC 	R2, R2,#0x20                            ;MASCARA = 0X20 para P5
	ORR 	R0, R0, R2                              ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR 	R0, [R1]      
	POP 	{R0,R1,R2}		
	BX 		LR
	

; -------------------------------------------------------------------------------
; Função PortJ_Input
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
PortJ_Input
; ****************************************
; Escrever função que lê a chave e retorna 
; um registrador se está ativada ou não
; ****************************************
	PUSH 	{R1}
	LDR		R1,=GPIO_PORTJ_AHB_DATA_R
	LDR 	R0,[R1]
	POP 	{R1}		
	BX 		LR

;   2_00111111 0
;	2_00000110 1
;	2_01011011 2
;	2_01001111 3
;	2_01100110 4
;	2_01101101 5
;	2_01111101 6
;	2_00000111 7
;	2_01111111 8
;	2_01101111 9
VETOR DCB 2_00111111,2_00000110,2_01011011,2_01001111,2_01100110,2_01101101,2_01111101,2_00000111,2_01111111,2_01101111,0;; O 0 indicca o fim da lista
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo