/* 
 source code generate by Bui Dinh Ngoc aka ngocbd<buidinhngoc.aiti@gmail.com> for smartcontract OrderString at 0x6e4d548c326504aa4afa37bae6496ff9bcb6efd9
*/
pragma solidity ^0.4.24;

contract OrderString {
 
    string internal _orderString = "????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????";
    function getOrderString () view external returns(string) {
        return _orderString;
    }
}