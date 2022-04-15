// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Item{
    uint public itemPriceInWei;
    uint public pricePaid;
    uint public itemIndex;
    address public addr;

    constructor(uint _itemPriceInWei, uint _itemIndex, address _addr) {
        itemPriceInWei = _itemPriceInWei;
        itemIndex = _itemIndex;
        addr = _addr;
    }

    fallback () external payable {
        require (pricePaid == 0, "Item is paid for already.");
        require (itemPriceInWei == msg.value, "Please pay exact amount.");
        pricePaid += msg.value;
        //address payable mainAddr = address(parentContract);
        //parentContract.triggerPayment{value : msg.value}(itemIndex);
        (bool success, ) =  addr.call{value : msg.value, gas : 80000000 }(abi.encodeWithSignature("triggerPayment(uint256)", itemIndex));
        require (success, "Transaction unsuccessful, cancelling payment");
    }

    //fallback () external payable {}
}