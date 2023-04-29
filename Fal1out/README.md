```solidity
 /* constructor */
  function Fal1out() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
  }
```
***El desarrollador se cometió un error ortografico***

## Conceptos: 
**constructor()**

- En cada contrato se indica un constructor, que es una funcion especial que solo se ejecuta una vez por instancia del contrato.
- Es utilizado para indicar las variables de cada contrato y realizar otras tareas necesarias antes de que el contrato se despliegue.

### Que esta pasando en este contrato?
Para hacer el constructor se usa una funcion que tenga el nombre del contrato que hacia lo mismo que el constructor.

En versiones muy antiguas se tenia que usar esta funcion como constructor. 

Actualmente se puede usar simplemente constructor() para realizar lo mismo.




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
 
 ## Payload:
 ```js
 await contract.Fal1out()
 ```
