// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract ImplementationContractV1{

    address public implementationContract;
    address public admin;

    // NOTE: storage layout must be the same as Proxy Contract Layout
    uint256 public numVar;
    address public sender;
    uint256 public value;

    function setNumVars(uint256 _numVar) public payable {
        numVar = _numVar;
        sender = msg.sender;
        value = msg.value;
    }
}

contract SimpleDelegateUpgradableProxy {
        address public implementationContract;
        address public admin;

        uint256 public numVar;
        address public sender;
        uint256 public value;

        constructor(){
            admin = msg.sender;
        }

        modifier onlyAdmin(){
            require(msg.sender == admin, "Not Admin");
            _;
        }

        function upgrade(address _newImplementationContract) onlyAdmin public {
            implementationContract = _newImplementationContract;
        }

        function setNumVars(uint256 _newNumVar) public payable {
            (bool success, bytes memory data) = implementationContract.delegatecall(
                abi.encodeWithSignature("setNumVars(uint256)", _newNumVar));
            
            require(success, "Implement delegatecall fail");
   
        }

    }

