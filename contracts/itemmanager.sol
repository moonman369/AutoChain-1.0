// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./item.sol";

contract ItemManager {

    enum AutoChainState {Null, Created, Paid, Delivered}

    

    struct item {
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.AutoChainState _state;
    }

    event AutoChainEvent (uint _itemIndex, AutoChainState _state, address _itemAddress);

    mapping (uint => item) public items;
    uint itemIndex;

    // function getEnum (uint _itemIndex) public view returns (ItemManager.AutoChainState) {
    //     return items[_itemIndex]._state;
    // }

    function createItem (string memory _identifier, uint _itemPrice) public {

        items[itemIndex]._item = new Item(_itemPrice, itemIndex, address(this));
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = AutoChainState.Created;
        emit AutoChainEvent(itemIndex, items[itemIndex]._state, address(items[itemIndex]._item));
        itemIndex++;
    }

    function triggerPayment (uint _itemIndex) external payable{
        require (items[_itemIndex]._itemPrice == msg.value, "Please pay exact amount.");
        require (items[_itemIndex]._state == AutoChainState.Created, "Item has been already paid for or delivered");
        
        items[_itemIndex]._state = AutoChainState.Paid;
        emit AutoChainEvent(_itemIndex, items[_itemIndex]._state, address(items[_itemIndex]._item));
    }

    function triggerDelivery (uint _itemIndex) public {
        require (items[_itemIndex]._state == AutoChainState.Paid, "Item awaiting payment...");
        items[_itemIndex]._state = AutoChainState.Delivered;
        emit AutoChainEvent(_itemIndex, items[_itemIndex]._state, address(items[_itemIndex]._item));
    }
}