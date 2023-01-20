// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./fNFTtoken.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract FractionalNFT is
    ERC721EnumerableUpgradeable,
    ERC721URIStorageUpgradeable,
    ERC721BurnableUpgradeable,
    OwnableUpgradeable
{
    // fNFT's Token Address.
    struct fractionalERC20Tokens {
        address erc20TokenAddress;
    }

    // Grouping together the Jewellery Data.
    struct Jewellery {
        address nftTokenAddress;
        string jewelleryMetal;
        string purity;
        string netWeight;
        string grossWeight;
        string stones;
        string additional_data;
        string ownerName;
    }

    // Valuations Data.
    struct Valuations {
        address nftTokenAddress;
        string valuationFirm;
        string timestamp;
        string valuationData;
        bool updateJewellery;
    }

    // Mapping fractional token's addresses against NFT's tokenId.
    mapping(uint256 => fractionalERC20Tokens)
        private tokenIdToERC20TokenAddress;

    // Mapping Jewellery Data against NFT's tokenId.
    mapping(uint256 => Jewellery) public tokenIdToJewelleryData;

    // Mapping Valuations Data against NFT's tokenId.
    mapping(uint256 => Valuations) public tokenIdToValuationsData;

    function initialize(string memory name, string memory symbol)
        public
        initializer
    {
        __ERC721_init(name, symbol);
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __ERC721Burnable_init();
        __Ownable_init();
    }

    // Set Jewellery Data against provided tokenId.
    function setJewelleryData(
        uint256 _tokenId,
        string memory _jewelleryMetal,
        string memory _netWeight,
        string memory _grossWeight,
        string memory _purity,
        string memory _stones,
        string memory _additionalData,
        string memory _ownerName
    ) public onlyOwner {
        _requireMinted(_tokenId);

        Jewellery memory jewellery;
        jewellery.nftTokenAddress = getTokenAddress(_tokenId);
        jewellery.stones = _stones;
        jewellery.additional_data = _additionalData;
        jewellery.jewelleryMetal = _jewelleryMetal;
        jewellery.netWeight = _netWeight;
        jewellery.grossWeight = _grossWeight;
        jewellery.purity = _purity;
        jewellery.ownerName = _ownerName;

        tokenIdToJewelleryData[_tokenId] = jewellery;
    }

    // Set Valuation Data against provided tokenId.
    function setValuationData(
        uint256 _tokenId,
        string memory _valuationsData,
        string memory _valuationFirm,
        string memory _timestamp,
        bool _updateJewellery
    ) public onlyOwner {
        _requireMinted(_tokenId);

        Valuations memory valuations;
        valuations.valuationData = _valuationsData;
        valuations.valuationFirm = _valuationFirm;
        valuations.timestamp = _timestamp;
        valuations.updateJewellery = _updateJewellery;
        valuations.nftTokenAddress = getTokenAddress(_tokenId);

        tokenIdToValuationsData[_tokenId] = valuations;
    }

    function transferNFT(
        address from,
        address to,
        uint256 tokenId,
        string memory transferType,
        string memory price
    ) public {
        super.safeTransferFrom(from, to, tokenId);
    }

    function transferAsset(
        address from,
        address to,
        uint256 tokenId,
        string memory transferType,
        string memory price
    ) public {
        _requireMinted(tokenId);

        address tokenAddress = getTokenAddress(tokenId);
        if (tokenAddress != address(0x0)) {
            // Transfer ERC-20 Tokens.
            transferSharesOfFNFT(
                tokenId,
                to,
                ERC20Upgradeable(tokenAddress).balanceOf(from)
            );
            super.safeTransferFrom(from, to, tokenId);
        } else {
            super.safeTransferFrom(from, to, tokenId);
        }
    }

    function mintFNFT(
        uint256 _tokenId,
        address _to,
        string memory _tokenURI,
        string memory shareName,
        string memory shareSymbol,
        uint256 _totalFractionalTokens
    ) external onlyOwner {
        _safeMint(_to, _tokenId);
        _setTokenURI(_tokenId, _tokenURI);

        if (_totalFractionalTokens > 0) {
            // Creating an ERC20 Token Contract for newly minted NFT.
            FNFToken _fnftoken = (new FNFToken)();

            _fnftoken.initialize(shareName, shareSymbol);

            // Minting fractional tokens and sending them to the NFT owner's account.
            _fnftoken.mint(_to, _totalFractionalTokens * 1000000000000000000);

            fractionalERC20Tokens memory tokenAddress;
            tokenAddress.erc20TokenAddress = address(_fnftoken);

            // Bind the fractional token address to the newly minted NFT's tokenId.
            tokenIdToERC20TokenAddress[_tokenId] = tokenAddress;
        }
    }

    function transferSharesOfFNFT(
        uint256 tokenId,
        address to,
        uint256 amount
    ) public {
        _requireMinted(tokenId);

        address tokenAddress = getTokenAddress(tokenId);

        // Transfer ERC-20 Tokens.
        FNFToken _fnftoken = FNFToken(tokenAddress);
        _fnftoken.transfer(msg.sender, to, amount);
    }

    function getTokenAddress(uint256 _tokenId) public view returns (address) {
        return tokenIdToERC20TokenAddress[_tokenId].erc20TokenAddress;
    }

    function userShareBalance(uint256 _tokenId, address account)
        public
        view
        returns (uint256)
    {
        _requireMinted(_tokenId);

        address tokenAddress = getTokenAddress(_tokenId);

        FNFToken _fnftoken = FNFToken(tokenAddress);
        return _fnftoken.balanceOf(account);
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
