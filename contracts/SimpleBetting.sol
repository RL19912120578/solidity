// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBetting {
    struct Player {
        uint256 bet;
        uint8 playerNumber;
        uint8 dealerNumber;
    }

    mapping(address => Player) public players;
    address public dealer;

    // Event definitions
    event BetPlaced(address indexed player, uint256 amount);
    event NumbersGenerated(address indexed player, uint8 playerNumber, uint8 dealerNumber);
    event WinnerDetermined(address indexed player, string result, uint256 payout);

    constructor() {
        dealer = msg.sender;
    }

    function placeBet() public payable {
        require(msg.value > 0, "Bet amount must be greater than 0");

        // Record the player's bet
        players[msg.sender].bet = msg.value;

        // Generate random numbers for player and dealer
        uint8 playerNumber = _generateRandomNumber();
        uint8 dealerNumber = _generateRandomNumber();

        // Store the numbers
        players[msg.sender].playerNumber = playerNumber;
        players[msg.sender].dealerNumber = dealerNumber;

        emit BetPlaced(msg.sender, msg.value);
        emit NumbersGenerated(msg.sender, playerNumber, dealerNumber);

        // Determine the winner and payout
        _determineWinner(msg.sender, playerNumber, dealerNumber);
    }

    function _determineWinner(address player, uint8 playerNumber, uint8 dealerNumber) internal {
        if (playerNumber > dealerNumber) {
            uint256 payout = players[player].bet * 2;
            payable(player).transfer(payout);
            emit WinnerDetermined(player, "Player wins", payout);
        } else {
            emit WinnerDetermined(player, "Dealer wins", 0);
        }

        // Reset player's bet
        players[player].bet = 0;
    }

    function _generateRandomNumber() internal view returns (uint8) {
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % 10 + 1);
    }

    // Fallback function to accept Ether
    receive() external payable {}

    // Function to withdraw funds from the contract
    function withdraw(uint256 amount) public {
        require(msg.sender == dealer, "Only the dealer can withdraw funds");
        payable(dealer).transfer(amount);
    }
}