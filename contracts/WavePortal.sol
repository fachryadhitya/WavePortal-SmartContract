// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver; //The address of the user who waved
        string message; //the message that was sent
        uint256 timestamp; //the timestamp when user waved
    }

    Wave[] waves;

    mapping(address => uint256) public lastWaved;

    constructor() payable {
        console.log("Yo yo, im a contract and im smart!");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {

        require(
            lastWaved[msg.sender] + 30 seconds < block.timestamp,
            "You can only wave once every 30 seconds"
        );

        lastWaved[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved with message %s", msg.sender, _message);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        seed = (block.timestamp + block.difficulty + seed) % 100;

        console.log("Random # generated: %d", seed);

        if (seed <= 50) {
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "contract doesnt have enough balance!"
            );

            (bool success, ) = msg.sender.call{value: prizeAmount}("");
            require(success, "Failed to send ether to winner");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("we have %d waves", totalWaves);
        return totalWaves;
    }
}
