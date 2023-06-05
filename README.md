# <h1 align="center"> Contadorasm </h1>
<p>Contador de 00 a 99 com indicação de números primos nos leds.
O contador utiliza dois displays de sete segmentos e 8 leds da placa auxiliar Tiva que está acoplada ao microcontrolador TM4C1294NCPDT.
Cada display e os leds estão multiplexados, portanto para controla-los foi necessário alternar o acionamento entre cada display e os leds em uma frequência em que o olho humano não detectasse a alternância. </p>
<p>  Além das saídas, foram necessários dois botões SW1 e SW2, SW1 para o incremento do passo de contagem e SW2 para o decremento, o passo possui limite superior 9 e inferior 1.</p>
 <p> A técnica utilizada para a leitura dos botões ao mesmo tempo em que as saídas eram atualizadas é o polling. </p>
  
<h2 align="center">Esquemático dos leds da placa</h2>
<div align="center">
<img src="https://user-images.githubusercontent.com/16793600/194778509-709f14dd-ab1a-4695-a364-436d7a145bf8.PNG" width="700px"/></div>
<h2 align="center">Esquemático dos displays da placa</h2>
<div align="center">
<img src="https://user-images.githubusercontent.com/16793600/194778503-e50ce5e1-3547-4190-be59-d58888f8bf76.PNG" width="700px"/>
<h2>Fluxograma</h2>
<img src="LAB1FLUXOGRAMA.png" />
 LAB1FLUXOGRAMA.png
</div>
