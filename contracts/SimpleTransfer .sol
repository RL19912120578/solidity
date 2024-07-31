// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleTransfer {
    address public owner;

    event Received(address indexed from, uint256 amount);
    event Transferred(address indexed to, uint256 amount);

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

    // 获取合约的余额
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}