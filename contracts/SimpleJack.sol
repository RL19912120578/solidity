// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleJack {
    address public owner;
    uint256 private dealerNumber;
    uint256 private gamblerNumber;

    event Received(address indexed from, uint256 amount);
    event Transferred(address indexed to, uint256 amount);
    event NumbersGenerated(uint256 dealer, uint256 gambler);

    constructor() {
        owner = msg.sender;
    }

    // 接收以太币
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    // 将合约中的以太币转到所有者帐户
    function transferToOwner(uint256 amount) public {
        require(msg.sender == owner, "Only owner can transfer funds");
        require(address(this).balance >= amount, "Insufficient balance");

        payable(owner).transfer(amount);
        emit Transferred(owner, amount);
    }

        // 将合约中的以太币转到任意帐户（仅当 gamblerNumber 大于 dealerNumber 时）
    function transferTo(address to, uint256 amount) public {
        require(gamblerNumber > dealerNumber, "Gambler number must be greater than dealer number");
        require(address(this).balance >= amount, "Insufficient balance");

        payable(to).transfer(amount);
        emit Transferred(to, amount);
    }

    // 获取合约的余额
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 生成随机数
    function generateNumbers() public {

        dealerNumber = (uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao))) % 13) + 1;
        gamblerNumber = (uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, dealerNumber))) % 13) + 1;

        emit NumbersGenerated(dealerNumber, gamblerNumber);
    }
    // 获取 dealer 的随机数
    function getDealerNumber() public view returns (uint256) {
        return dealerNumber;
    }

    // 获取 gambler 的随机数
    function getGamblerNumber() public view returns (uint256) {
        return gamblerNumber;
    }

}