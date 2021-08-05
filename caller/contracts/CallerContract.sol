// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EthPriceOracleInterface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CallerContract is Ownable {
    uint256 private ethPrice;
    address private oracleAddress;
    EthPriceOracleInterface private ethPriceOracleInstance;
    mapping(uint256 => bool) myRequests;

    event newOracleAddressEvent(address oracleAddress);
    event ReceivedNewRequestIdEvent(uint256 id);
    event PriceUpdatedEvent(uint256 ethPrice, uint256 id);

    modifier onlyOracle() {
        require(msg.sender == oracleAddress, "You are not authorized to call this function.");
        _;
    }

    function setOracleInstanceAddress(address _oracleInstanceAddress) external onlyOwner {
        oracleAddress = _oracleInstanceAddress;
        ethPriceOracleInstance = EthPriceOracleInterface(_oracleInstanceAddress);
        emit newOracleAddressEvent(_oracleInstanceAddress);
    }

    function updateEthPrice() public {
        uint256 id = ethPriceOracleInstance.getLatestEthPrice();
        myRequests[id] = true;
        emit ReceivedNewRequestIdEvent(id);
    }

    function callback(uint256 _ethPrice, uint256 _id) external onlyOracle {
        require(myRequests[_id] == true, "This request is not in my pending list.");
        ethPrice = _ethPrice;
        delete myRequests[_id];
        emit PriceUpdatedEvent(_ethPrice, _id);
    }

}