// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract FabricaContract {
    uint idDigits = 16;

    struct Producto {
        string nombre;
        uint identificacion;
    }

    // Array público de structs Producto
    Producto[] public productos;

    // Declarar el evento NuevoProducto
    event NuevoProducto(uint ArrayProductoId, string nombre, uint id);

    // Mapping para realizar un seguimiento de la dirección que posee un producto
    mapping(uint => address) public productoAPropietario;

    // Mapping para realizar un seguimiento de cuántos productos tiene un propietario
    mapping(address => uint) propietarioProductos;

    function _crearProducto(string memory _nombre, uint _id) private {
        Producto memory nuevoProducto = Producto(_nombre, _id);
        productos.push(nuevoProducto);
        uint productoId = productos.length - 1;
        // Emitir el evento NuevoProducto
        emit NuevoProducto(productoId, _nombre, _id);
    }

    function _generarIdAleatorio(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        uint idModulus = 10 ** idDigits;
        return rand % idModulus;
    }

    function crearProductoAleatorio(string memory _nombre) public {
        uint randId = _generarIdAleatorio(_nombre);
        _crearProducto(_nombre, randId);
    }

    function Propiedad(uint _productoId) public {
        productoAPropietario[_productoId] = msg.sender;
        propietarioProductos[msg.sender]++;
    }

    function getProductosPorPropietario(address _propietario) external view returns (uint[] memory) {
        uint contador = 0;
        uint[] memory resultado = new uint[](propietarioProductos[_propietario]);
        for (uint i = 0; i < productos.length; i++) {
            if (productoAPropietario[i] == _propietario) {
                resultado[contador] = i;
                contador++;
            }
        }
        return resultado;
    }

}