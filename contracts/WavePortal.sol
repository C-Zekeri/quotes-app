// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed;

    //events are like 'methods' you can access from your front-end code
    //basically an envelope we use to package information
    event NewWave(address indexed from, uint256 timestamp, string message);

    //equivalent of a class in JS, I think
    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    //we're initiating an array of Wave objects named 'waves'
    Wave[] waves;
    
    //we're mapping the waver's address to their timestamp
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Ojochenemi's contract");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        //cool-down function
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "I appreciate your enthusiasm, but please allow for a duration of 15 minutes between messages."
        );

        //reset lastWavedAt
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved w/ message %s", msg.sender, _message);

        //we're initiating a new Wave and adding it to the struct array
        waves.push(Wave(msg.sender, _message, block.timestamp));
        
        seed = (block.timestamp + block.difficulty + seed) % 100;
        if (seed < 50) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require (
                prizeAmount <= address(this).balance, "Be like say we no get funds ooo"
            );
            (bool success, ) = (msg.sender).call{value : prizeAmount}("");
            require (success, "Could not withdraw money from contract");
        }

        //we're enveloping this wave and
        //sending it out to the universe with all our love!
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function grabTheWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("whoa! %d total waves!", totalWaves);
        return totalWaves;
    }
}
