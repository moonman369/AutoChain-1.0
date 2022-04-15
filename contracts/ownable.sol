// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

 contract Ownable {
   address payable _owner;

   constructor () {
     _owner = payable(msg.sender);
   }

   modifier onlyOwner () {
     require (isOwner(), "This function can only be called by the owner.");
     _;
   }

   function isOwner () public view returns (bool) {
     return (msg.sender == _owner);
   }
 }