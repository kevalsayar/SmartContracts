// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./fNFTtoken.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract FractionalNFT is
    Initializable,
    ERC721Upgradeable,
    ERC721EnumerableUpgradeable,
    ERC721URIStorageUpgradeable,
    ERC721BurnableUpgradeable,
    OwnableUpgradeable
{
    // fNFT's Token Address.
    struct fractionalERC20Tokens {
        address erc20TokenAddress;
    }

    // Jewellery Data.
    struct Jewellery {
        string jewelleryData;
    }

    // Valuations Data.
    struct Valuations {
        string valuationsData;
    }

    // Mapping fractional token's addresses against NFT's tokenId.
    mapping(uint256 => fractionalERC20Tokens) private ERC20TokenAddress;

    // Mapping Jewellery Data against NFT's tokenId.
    mapping(uint256 => Jewellery) private JewelleryData;

    // Mapping Valuations Data against NFT's tokenId.
    mapping(uint256 => Valuations) private ValuationsData;

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
    function setJewelleryData(uint256 _tokenId, string memory _jewelleryData)
        public
        onlyOwner
    {
        Jewellery memory jewellery;
        jewellery.jewelleryData = _jewelleryData;

        JewelleryData[_tokenId] = jewellery;
    }

    // Set Valuation Data against provided tokenId.
    function setValuationData(uint256 _tokenId, string memory _valuationsData)
        public
        onlyOwner
    {
        Valuations memory valuations;
        valuations.valuationsData = _valuationsData;

        ValuationsData[_tokenId] = valuations;
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override(ERC721Upgradeable) {
        address tokenAddress = getTokenAddress(tokenId);
        require(
            ERC20(tokenAddress).totalSupply() == 0,
            "Existing Tokens for this NFT!"
        );
        super.transferFrom(from, to, tokenId);
    }

    function mintFNFT(
        uint256 _tokenId,
        address _to,
        string memory _tokenURI,
        uint256 _totalFractionalTokens
    ) external onlyOwner {
        _safeMint(_to, _tokenId);
        _setTokenURI(_tokenId, _tokenURI);

        if (_totalFractionalTokens > 0) {
            // Creating an ERC20 Token Contract for newly minted NFT.
            FNFToken _fnftoken = (new FNFToken)();

            // Minting fractional tokens and sending them to the NFT owner's account.
            _fnftoken.mint(
                msg.sender,
                _totalFractionalTokens * 1000000000000000000
            );
            fractionalERC20Tokens memory tokenAddress;
            tokenAddress.erc20TokenAddress = address(_fnftoken);

            // Bind the fractional token address to the newly minted NFT's tokenId.
            ERC20TokenAddress[_tokenId] = tokenAddress;
        }
    }

    function getTokenAddress(uint256 _tokenId) public view returns (address) {
        return ERC20TokenAddress[_tokenId].erc20TokenAddress;
    }

    function getJewelleryData(uint256 _tokenId)
        public
        view
        returns (string memory)
    {
        return JewelleryData[_tokenId].jewelleryData;
    }

    function getValuationsData(uint256 _tokenId)
        public
        view
        returns (string memory)
    {
        return ValuationsData[_tokenId].valuationsData;
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
