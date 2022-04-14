// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Item {
    uint public itemPriceInWei;
    uint public pricePaid;
    uint public itemIndex;

    ItemManager parentContract;

    constructor(ItemManager _parentContract, uint _itemPriceInWei, uint _itemIndex) public {
        parentContract = parentContract;
        itemPriceInWei = _itemPriceInWei;
        itemIndex = _itemIndex;
    }

    function pay (ItemManager _parentContract) external payable {
        require (pricePaid == 0, "Item is paid for already.");
        require (itemPriceInWei == msg.value, "Please pay exact amount.");
        pricePaid += msg.value;
        //address payable mainAddr = address(parentContract);
        _parentContract.triggerPayment{value : msg.value}(itemIndex);
        //(bool success, ) =  address(parentContract).call{value : msg.value, gas : 80000000 }(abi.encodeWithSignature("triggerPayment(uint256)", itemIndex));
        //require (success, "Transaction unsuccessful, cancelling payment");
    }

    //fallback () external payable {}
}

contract ItemManager {

    enum AutoChainState {Created, Paid, Delivered}

    struct item {
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.AutoChainState _state;
    }

    event AutoChainEvent (uint _itemIndex, AutoChainState _state, address _itemAddress);

    mapping (uint => item) public items;
    uint itemIndex;

    function createItem (string memory _identifier, uint _itemPrice) public {
        Item _item = new Item(this, _itemPrice, itemIndex);

        items[itemIndex]._item = _item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = AutoChainState.Created;
        emit AutoChainEvent(itemIndex, items[itemIndex]._state, address(_item));
        itemIndex++;
    }

    function triggerPayment (uint _itemIndex) external payable{
        require (items[_itemIndex]._itemPrice == msg.value, "Please pay exact amount.");
        require (items[_itemIndex]._state == AutoChainState.Created, "Item has been already paid for or delivered");
        
        items[_itemIndex]._state = AutoChainState.Paid;
        emit AutoChainEvent(_itemIndex, items[_itemIndex]._state, address(items[itemIndex]._item));
    }

    function triggerDelivery (uint _itemIndex) public {
        require (items[_itemIndex]._state == AutoChainState.Paid, "Item awaiting payment...");
        items[_itemIndex]._state = AutoChainState.Delivered;
        emit AutoChainEvent(_itemIndex, items[_itemIndex]._state, address(items[itemIndex]._item));
    }
}