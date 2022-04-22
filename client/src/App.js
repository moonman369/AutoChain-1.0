import React, { Component } from "react";
import ItemManager from "./contracts/ItemManager.json";
import Item from "./contracts/Item.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { loaded: false, cost: 0, itemName: "" };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      this.web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      this.accounts = await this.web3.eth.getAccounts();

      // Get the contract instance.
      this.networkId = await this.web3.eth.net.getId();
      this.itemManager = new this.web3.eth.Contract(
        ItemManager.abi,
        ItemManager.networks[this.networkId] &&
          ItemManager.networks[this.networkId].address
      );

      this.item = new this.web3.eth.Contract(
        Item.abi,
        Item.networks[this.networkId] && Item.networks[this.networkId].address
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ loaded: true });
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`
      );
      console.error(error);
    }
  };

  handleInputChange = (event) => {
    const target = event.target;
    const value = target.type === "checkbox" ? target.checkrd : target.value;
    const name = target.name;
    this.setState({ [name]: value });
  };

  handleSubmit = async () => {
    const { cost, itemName } = this.state;
    // cost == 0 ||
    //   itemName == "" ||
    let result = await this.itemManager.methods
      .createItem(itemName, cost)
      .send({ from: this.accounts[0] });

    console.log(result);
  };

  // runExample = async () => {
  //   const { accounts, contract } = this.state;

  //   // Stores a given value, 5 by default.
  //   await contract.methods.set(69).send({ from: accounts[0] });

  //   // Get the value from the contract to prove it worked.
  //   const response = await contract.methods.get().call();

  //   // Update state with the result.
  //   this.setState({ storageValue: response });
  // };

  render() {
    if (!this.state.loaded) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      console.log(this),
      (
        <div className="App">
          <h1>AutoChain 1.0 test</h1>
          <h2>Items</h2>
          <h2>Add Items</h2>
          <p>
            Cost in wei:{" "}
            <input
              type="text"
              name="cost"
              placeholder="Cost"
              onChange={this.handleInputChange}
            />
            Item Identifier:{" "}
            <input
              type="text"
              name="itemName"
              placeholder="Item Name"
              onChange={this.handleInputChange}
            />
            <button type="button" onClick={this.handleSubmit}>
              Create New Item
            </button>
          </p>
        </div>
      )
    );
  }
}

export default App;
