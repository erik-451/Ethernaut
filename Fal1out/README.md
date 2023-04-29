# El desarrollador que cometió un error ortografico
## Caso Rubixi
Este fue un error real, donde el contrato se llama Rubixi y el "constructor" DynamicPyramid()

Investigando un poco este historico error me he encontrado con este contrato que parece ser el original.

Mirando por encima el codigo, está la funcion critica donde se puede reclamar el owner (mejor no tocarlo)
```solidity
contract Rubixi {
 ...
   function DynamicPyramid() {
           creator = msg.sender;
   }

   modifier onlyowner {
           if (msg.sender == creator) _
   }
  ...
```        
- https://etherscan.io/address/0xe82719202e5965Cf5D9B6673B7503a3b92DE20be#code#L1
---
### Codigo Fallout
```solidity
 /* constructor */
  function Fal1out() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
  }
```

- Contrato Original: [Fallout.sol](Fallout.sol)
---
## Conceptos: 
**constructor()**

- En cada contrato se indica un constructor, que es una funcion especial que solo se ejecuta una vez por instancia del contrato.
- Es utilizado para indicar las variables de cada contrato y realizar otras tareas necesarias antes de que el contrato se despliegue.

En versiones muy antiguas se tenia indicar el constructor con una funcion que tenga el nombre exacto del contrato.

Pero actualmente se puede usar simplemente constructor() en vez de usar una funcion con el nombre exacto

---

### Que esta pasando en este contrato?
El error en el contrato original fue que la función no se llamaba exactamente igual que el nombre del contrato, lo que resultaba en una función adicional y no en un constructor.

Lo que habría sido correcto:
```solidity
function Fallout() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
  }
```

*La función se llamaba Fal1out() en lugar de Fallout()*

Al no estar restringida cualquier persona puede aprovecharse de que el msg.sender(El que realiza la llamada) se le asignará el owner
```solidity
 owner = msg.sender;
 ```
 
 ### Payload:
 ```js
 await contract.Fal1out()
 ```
