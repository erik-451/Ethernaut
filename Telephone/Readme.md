```solidity
 function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
```
### Conceptos:
- msg.sender es la dirección del contrato que llama a la función.
- tx.origin es la dirección de la cuenta externa que inició la transacción original que desencadenó la llamada al contrato.

La función changeOwner() solo cambia el Owner del contrato si la dirección que llama a la función NO es la misma que la dirección de la cuenta externa que inició la transacción original.

Para cambiar el owner del contrato necesitamos que:
La wallet que esta haciendo la llamada (msg.sender),
NO sea la misma dirección de la cuenta que inició la transacción original que desencadenó la llamada al contrato.

#### En resumen
- tx.origin seremos nosotros que hemos creado el contrato para hacer la llamada
- msg.sender sera el contrato que esta interactuando con la funcion del contrato de Ethernaut 

*Con esto tx.origin no será el mismo que el msg.sender al usar un contrato como intermediario*
