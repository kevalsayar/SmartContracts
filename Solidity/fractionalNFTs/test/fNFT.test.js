const { assert } = require("chai");
const FractionalNFT = artifacts.require("FractionalNFT");

contract("fNFT", (accounts) => {
  let contractOwner = accounts[0];
  const NFTname = "Ruptok";
  const NFTsymbol = "RPK";

  // Positive Test Cases
  it("should have Token name set correctly", async () => {
    const contract = await FractionalNFT.deployed();

    const tokenName = await contract.name.call();
    assert.equal(tokenName, NFTname);
  });

  it("should have Token Symbol set correctly", async () => {
    const contract = await FractionalNFT.deployed();

    const tokenSymbol = await contract.symbol.call();
    assert.equal(tokenSymbol, NFTsymbol);
  });

  it("should have Contract Owner value set correctly", async () => {
    const contract = await FractionalNFT.deployed();

    const owner = await contract.owner.call();
    assert.equal(owner, contractOwner);
  });

  it("should mint an fNFT and set the TokenURI and Token Owner", async () => {
    const contract = await FractionalNFT.deployed();

    await contract.mintFNFT(
      0,
      accounts[1],
      "google.com",
      "ShareName",
      "ShareSymbol",
      1,
      { from: contractOwner }
    );

    const tokenURI = await contract.tokenURI.call(0);
    const tokenOwner = await contract.ownerOf(0);
    const tokenAddress = await contract.getTokenAddress(0);

    assert.isNotEmpty(tokenAddress);
    assert.equal(tokenURI, "google.com");
    assert.equal(tokenOwner, accounts[1]);
  });

  it("should mint an NFT and set the TokenURI and Token Owner", async () => {
    const contract = await FractionalNFT.deployed();

    await contract.mintFNFT(
      2,
      accounts[1],
      "google.com",
      "ShareName",
      "ShareSymbol",
      0,
      { from: contractOwner }
    );

    const tokenURI = await contract.tokenURI.call(0);
    const tokenOwner = await contract.ownerOf(0);
    const tokenAddress = await contract.getTokenAddress(2);

    assert.equal(tokenAddress, "0x0000000000000000000000000000000000000000");
    assert.equal(tokenURI, "google.com");
    assert.equal(tokenOwner, accounts[1]);
  });

  it("should set Jewellery Data", async () => {
    const contract = await FractionalNFT.deployed();

    await contract.setJewelleryData(
      0,
      "Metal",
      "Netweight",
      "grossWeight",
      "purity",
      "stones",
      "additionaldata",
      "ownername"
    );

    const data = await contract.tokenIdToJewelleryData(0);
    assert.isNotEmpty(data.purity);
  });

  it("should set Valuation Data", async () => {
    const contract = await FractionalNFT.deployed();

    await contract.setValuationData(
      0,
      "Metal",
      "Netweight",
      "grossWeight",
      true
    );

    const data = await contract.tokenIdToValuationsData(0);
    assert.isNotEmpty(data.valuationFirm);
  });

  it("should transfer NFT", async () => {
    const contract = await FractionalNFT.deployed();

    await contract.transferNFT(
      accounts[1],
      accounts[2],
      0,
      "transferType",
      "price",
      {
        from: accounts[1],
      }
    );

    const tokenOwner = await contract.ownerOf(0);
    assert.equal(tokenOwner, accounts[2]);
  });

  it("should transfer NFT's Shares", async () => {
    const contract = await FractionalNFT.deployed();

    await contract.transferSharesOfFNFT(0, accounts[2], 10000000000, {
      from: accounts[1],
    });

    const balance = await contract.userShareBalance(0, accounts[2]);

    assert.equal(balance, 10000000000);
  });

  it("should transfer all NFT assets", async () => {
    const contract = await FractionalNFT.deployed();

    await contract.mintFNFT(
      1,
      accounts[1],
      "google.com",
      "ShareName",
      "ShareSymbol",
      1,
      { from: contractOwner }
    );

    await contract.transferAsset(
      accounts[1],
      accounts[2],
      1,
      "transferType",
      "price",
      {
        from: accounts[1],
      }
    );

    const tokenOwner = await contract.ownerOf(0);
    const balance = await contract.userShareBalance(1, accounts[1]);

    assert.equal(tokenOwner, accounts[2]);
    assert.equal(balance.toString(), 0);
  });

  it("should transfer ownership of contract", async () => {
    const contract = await FractionalNFT.deployed();

    await contract.transferOwnership(accounts[3], { from: contractOwner });

    const newOwner = await contract.owner.call();

    assert.equal(newOwner, accounts[3]);
  });

  it("should return total number of NFT's in contract", async () => {
    const contract = await FractionalNFT.deployed();

    const totalSupply = await contract.totalSupply.call();

    assert.equal(totalSupply, 3);
  });

  it("should return tokenURI", async () => {
    const contract = await FractionalNFT.deployed();

    const tokenURI = await contract.tokenURI.call(0);

    assert.equal(tokenURI, "google.com");
  });

  // Negative Test Cases
  it("should fail if contract's already initialized", async () => {
    const contract = await FractionalNFT.deployed();

    try {
      await contract.initialize("RUPTOK", "RUP");
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(
        err.message,
        "revert",
        "The error message should contain 'revert'"
      );
    }
  });

  it("should fail if any other address other than contract owner tries to mint NFT", async () => {
    const contract = await FractionalNFT.deployed();

    try {
      await contract.mintFNFT(
        0,
        accounts[1],
        "google.com",
        "ShareName",
        "ShareSymbol",
        1,
        { from: accounts[4] }
      );
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(
        err.message,
        "revert",
        "The error message should contain 'revert'"
      );
    }
  });

  it("should fail if caller tries to transfer NFT but isn't token owner", async () => {
    const contract = await FractionalNFT.deployed();

    try {
      await contract.transferNFT(
        accounts[1],
        accounts[2],
        0,
        "transferType",
        "price",
        {
          from: accounts[1],
        }
      );
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(
        err.message,
        "revert",
        "The error message should contain 'revert'"
      );
    }
  });

  it("should fail if caller tries to tranfer NFT shares but doesn't have enough", async () => {
    const contract = await FractionalNFT.deployed();

    try {
      await contract.transferSharesOfFNFT(1, accounts[2], 10000000000, {
        from: accounts[1],
      });
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(
        err.message,
        "revert",
        "The error message should contain 'revert'"
      );
    }
  });

  it("should fail if any other address other than contract owner tries to set Jewellery Data", async () => {
    const contract = await FractionalNFT.deployed();

    try {
      await contract.setJewelleryData(
        0,
        "Metal",
        "Netweight",
        "grossWeight",
        "purity",
        "stones",
        "additionaldata",
        "ownername",
        { from: accounts[4] }
      );
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(
        err.message,
        "revert",
        "The error message should contain 'revert'"
      );
    }
  });

  it("should fail if any other address other than contract owner tries to set Valuation Data", async () => {
    const contract = await FractionalNFT.deployed();

    try {
      await contract.setValuationData(
        0,
        "Metal",
        "Netweight",
        "grossWeight",
        true,
        { from: accounts[4] }
      );
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(
        err.message,
        "revert",
        "The error message should contain 'revert'"
      );
    }
  });

  it("should fail if caller tries to set Jewellery Data for a token that hasn't yet been minted", async () => {
    const contract = await FractionalNFT.deployed();

    try {
      await contract.setJewelleryData(
        2,
        "Metal",
        "Netweight",
        "grossWeight",
        "purity",
        "stones",
        "additionaldata",
        "ownername"
      );
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(
        err.message,
        "revert",
        "The error message should contain 'revert'"
      );
    }
  });

  it("should fail if caller tries to set Valuation Data for a token that hasn't yet been minted", async () => {
    const contract = await FractionalNFT.deployed();

    try {
      await contract.setValuationData(
        2,
        "Metal",
        "Netweight",
        "grossWeight",
        true
      );
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(
        err.message,
        "revert",
        "The error message should contain 'revert'"
      );
    }
  });

  it("should fail if caller sends wrong argument type whilst setting Jewellery Data", async () => {
    const contract = await FractionalNFT.deployed();

    try {
      await contract.setJewelleryData(
        2,
        "Metal",
        "Netweight",
        "grossWeight",
        "purity",
        "stones",
        "additionaldata",
        true
      );
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(
        err.message,
        "revert",
        "The error message should contain 'revert'"
      );
    }
  });

  it("should fail if caller sends wrong argument type whilst setting Valuation Data", async () => {
    const contract = await FractionalNFT.deployed();

    try {
      await contract.setValuationData(
        2,
        "Metal",
        "Netweight",
        "grossWeight",
        "true"
      );
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(
        err.message,
        "revert",
        "The error message should contain 'revert'"
      );
    }
  });

  it("should fail if caller tries to transfer contract ownership but isn't contract owner", async () => {
    const contract = await FractionalNFT.deployed();

    try {
      await contract.transferOwnership(accounts[3], { from: accounts[2] });

      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(
        err.message,
        "revert",
        "The error message should contain 'revert'"
      );
    }
  });

  it("should fail if caller tries to fetch tokenURI of a tokenID that's not yet been minted", async () => {
    const contract = await FractionalNFT.deployed();

    try {
      await contract.tokenURI.call(5);
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(
        err.message,
        "revert",
        "The error message should contain 'revert'"
      );
    }
  });

  it("should fail if caller tries to fetch user share balance of a tokenID that's not yet been minted", async () => {
    const contract = await FractionalNFT.deployed();

    try {
      await contract.userShareBalance.call(5, accounts[2]);
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(
        err.message,
        "revert",
        "The error message should contain 'revert'"
      );
    }
  });
});
