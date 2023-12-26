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

    function initialize(
        string memory name,
        string memory symbol
    ) public initializer {
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

    function transferFractNFT(
        address from,
        address to,
        uint256 tokenId
    ) internal {
        super.safeTransferFrom(from, to, tokenId);
    }

    function transferAsset(
        address from,
        address to,
        uint256 fNftTokenId
    ) public {
        _requireMinted(fNftTokenId);

        address tokenAddress = getTokenAddress(fNftTokenId);

        if (tokenAddress != address(0x0)) {
            // Transfer ERC-20 Tokens.
            transferSharesOfFracNft(
                tokenAddress,
                to,
                ERC20Upgradeable(tokenAddress).balanceOf(from)
            );
        }

        transferFractNFT(from, to, fNftTokenId);
    }

    function mintFracNFT(
        uint256 _tokenId,
        address _to,
        string memory _tokenURI,
        string memory shareName,
        string memory shareSymbol,
        uint256 numOfFractionalTokens
    ) external onlyOwner {
        _safeMint(_to, _tokenId);
        _setTokenURI(_tokenId, _tokenURI);

        if (numOfFractionalTokens > 0) {
            // Creating an ERC20 Token Contract for newly minted NFT.
            FNFToken _fnftoken = (new FNFToken)();

            _fnftoken.initialize(shareName, shareSymbol);

            // Minting fractional tokens and sending them to the NFT owner's account.
            _fnftoken.mint(_to, numOfFractionalTokens * (10 ** 18));

            fractionalERC20Tokens memory tokenAddress;
            tokenAddress.erc20TokenAddress = address(_fnftoken);

            // Bind the fractional token address to the newly minted NFT's tokenId.
            tokenIdToERC20TokenAddress[_tokenId] = tokenAddress;
        }
    }

    function transferSharesOfFracNft(
        address tokenAddress,
        address to,
        uint256 amount
    ) internal {
        require(amount > 0, "Transfer amount must be greater than zero");

        // Transfer ERC-20 Tokens.
        FNFToken _fnftoken = FNFToken(tokenAddress);
        _fnftoken.transfer(msg.sender, to, amount);
    }

    function getTokenAddress(uint256 _tokenId) public view returns (address) {
        return tokenIdToERC20TokenAddress[_tokenId].erc20TokenAddress;
    }

    function userShareBalance(
        uint256 _tokenId,
        address userAddress
    ) public view returns (uint256) {
        _requireMinted(_tokenId);

        FNFToken _fnftoken = FNFToken(getTokenAddress(_tokenId));
        return _fnftoken.balanceOf(userAddress);
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

    function _burn(
        uint256 tokenId
    ) internal override(ERC721Upgradeable, ERC721URIStorageUpgradeable) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    )
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
