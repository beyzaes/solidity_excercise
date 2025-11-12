// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HelloWorld {
    // Store the greeting message
    string public greeting = "Hello, World!";

    // Function to update the greeting
    function setGreeting(string memory _newGreeting) public {
        greeting = _newGreeting;
    }

    // Function to get the greeting (redundant since `greeting` is public,
    // but included for demonstration)
    function getGreeting() public view returns (string memory) {
        return greeting;
    }
}