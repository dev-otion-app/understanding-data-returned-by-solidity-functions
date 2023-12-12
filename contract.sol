// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract InternalExamples{

    function value_type() internal pure returns(address add){
        add = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    }

    function value_type_caller() external pure{
        value_type();
    }

    function memory_type() internal pure returns(bytes memory){
        bytes memory foo = new bytes(2);
        foo[0] = 0xff;
        foo[1] = 0xff;
        return foo;
    }

    function memory_type_caller() external pure{
        memory_type();
    }

}

contract ExternalExamples{

    function value_type() external pure returns(address add){
        add = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    }

    function calldata_array(uint[] calldata arr) external pure returns(uint[] calldata){
        return arr;
    }

    function memory_array_1(uint[] calldata arr) external pure returns(uint[] memory){
        return arr;
    }

    function memory_array_2(uint[] calldata arr) external pure returns(uint[] memory){
        uint[] memory out = arr;
        assembly{
            mstore(sub(out, 0x20), 0x20)
            return(sub(out,0x20), mul(add(mload(out),2), 0x20)) // Out contains the array length, we have to add 2 as we also have the offset and the length word
        }
    }

    function memory_array_3(uint[] calldata arr) public pure returns(uint[] memory){
        uint[] memory out = arr;
        assembly{
            let used_selector := shr(224,calldataload(0x00))
            let public_selector := 0xd5625e0f
            if eq(used_selector, public_selector){
                mstore(sub(out, 0x20), 0x20)
                return(sub(out,0x20), mul(add(mload(out),2), 0x20))
            }
        }
        return out;
    }

    function caller(uint[] calldata arr) external pure returns(uint[] memory){
        return memory_array_3(arr);
    }

    function bytes_array_1(bytes calldata arr) external pure returns(bytes memory){
        return arr;
    }

    function bytes_array_2(bytes calldata arr) external pure returns(bytes memory){
        bytes memory out = arr;
        assembly{
            mstore(sub(out, 0x20), 0x20)
            let words := add(div(mload(out),0x20),1)
            return(sub(out,0x20), mul(add(words,2), 0x20))
        }
    }
}