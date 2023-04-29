# Variable almacenada en memoria
```solidity
contract Vault {
  bool public locked;
  bytes32 private password;
  ...
  
  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
}
```
- Contrato Original: [Vault.sol](Vault.sol)
---

## Conceptos:
Los contratos pueden almacenar variables internamente en la memoria, que aunque son públicas, su acceso está restringido por las reglas del contrato.
Si se tiene acceso al bytecode del contrato, es posible hacer reversing y encontrar la ubicación de estas variables en la memoria del contrato.

- En este caso la variable "password" está declarada como privada, pero aún puede leer si se tiene acceso al bytecode del contrato.
- Esta información se puede encontrar en el explorador de bloques, junto con otros detalles del contrato como su dirección, balance, transacciones, etc...

![bytecode](https://user-images.githubusercontent.com/47476901/235318728-52bd235e-09f3-4be3-90bc-b7ba5810ec0c.png)

---
## Como sacar el valor de la variable?
Bueno hay 2 metodos, el rapido y el complejo:

- Rapido: Usando una funcion de la libreria web3js
- Complejo: Reverseando el bytecode del contrato

---

### Metodo rapido:
Este es el metodo que he empleado, ya que es el mas rapido, trata de usar una funcion de la libreria web3js.

La variable *stor1* que equivale a password se guarda en la ubicacion 1 de la memoria.
```py
def storage:
  locked is uint8 at storage 0
  stor1 is uint256 at storage 1
```
Podemos ver el contenido de la memoria usando la funcion `getStorageAt()` de [web3js](https://web3js.readthedocs.io/)
- Candado bloqueado:
```js
-> await contract.locked()
<- true
```
- Password en memoria
```js
-> await web3.eth.getStorageAt("direccion_contrato",1);
<- '0x412076657279207374726f6e67207365637265742070617373776f7264203a29'
```
![image](https://user-images.githubusercontent.com/47476901/235319251-307f0c3c-a023-4e42-bca5-d8c737192efe.png)

- Enviamos la password:
```js
-> await contract.unlock('0x412076657279207374726f6e67207365637265742070617373776f7264203a29')
<- {tx: '0xtx..', receipt:...}
```
- Candado desbloqueado:
```js
-> await contract.locked()
<- false
```
---
### Metodo complejo:
El complejo seria reversear el propio codigo para sacar el valor de la contraseña.

Recomiendo encarecidamente leer este articulo, lo explica muy bien y con detalle.
- https://www.shielder.com/blog/2022/04/a-sneak-peek-into-smart-contracts-reversing-and-emulation/

Herramientas online para la decompilación del bytecode:
- https://library.dedaub.com/decompile
- https://etherscan.io/opcode-tool
- https://ethervm.io/decompile
- https://mumbai.polygonscan.com/bytecode-decompiler?a=0x000000
