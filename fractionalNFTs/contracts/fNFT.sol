// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./fNFTtoken.sol";
import "./erc20Beacon.sol";
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
    ERC20Beacon beacon;

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

    function initialize(
        string memory name,
        string memory symbol,
        address _vLogic
    ) public initializer {
        beacon = new ERC20Beacon();
        beacon.initializer(_vLogic);
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

    function transferNftAfterSale(
        address from,
        address to,
        uint256 tokenId
    ) public {
        address tokenAddress = getTokenAddress(tokenId);
        require(
            ERC20Upgradeable(tokenAddress).balanceOf(to) ==
                ERC20Upgradeable(tokenAddress).totalSupply(),
            "To address doesn't hold all the tokens yet!"
        );
        super.safeTransferFrom(from, to, tokenId);
    }

    function giftNFT(
        address from,
        address to,
        uint256 tokenId
    ) public {
        address tokenAddress = getTokenAddress(tokenId);
        require(
            ERC20Upgradeable(tokenAddress).balanceOf(from) ==
                ERC20Upgradeable(tokenAddress).totalSupply(),
            "You don't hold all the tokens!"
        );
        super.safeTransferFrom(from, to, tokenId);
    }

    function mintFNFT(
        uint256 _tokenId,
        address _to,
        string memory _tokenURI,
        uint256 _totalFractionalTokens,
        string memory shareName,
        string memory shareSymbol
    ) external onlyOwner {
        _safeMint(_to, _tokenId);
        _setTokenURI(_tokenId, _tokenURI);

        // if (_totalFractionalTokens > 0) {
        //     // Creating an ERC20 Token Contract for newly minted NFT.
        //     FNFToken _fnftoken = (new FNFToken)();

        //     _fnftoken.initialize("RuptokShare", "RKS");

        //     // Minting fractional tokens and sending them to the NFT owner's account.
        //     _fnftoken.mint(_to, _totalFractionalTokens * 1000000000000000000);

        // fractionalERC20Tokens memory tokenAddress;
        // tokenAddress.erc20TokenAddress = address(_fnftoken);

        // // Bind the fractional token address to the newly minted NFT's tokenId.
        // ERC20TokenAddress[_tokenId] = tokenAddress;
        // }
        if (_totalFractionalTokens > 0) {
            BeaconProxy proxy = new BeaconProxy(
                address(beacon),
                abi.encodeWithSelector(
                    FNFToken(address(0)).initialize.selector,
                    shareName,
                    shareSymbol
                )
            );

            FNFToken(address(proxy)).mint(
                _to,
                _totalFractionalTokens * 1000000000000000000
            );

            fractionalERC20Tokens memory tokenAddress;
            tokenAddress.erc20TokenAddress = address(proxy);

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

    /**
     * @dev Returns implementation address for a particular beacon.
     */
    function ERC20ImplAddress() public view returns (address) {
        return beacon.implementation();
    }

    /**
     * @dev Returns beacon address to which proxy address's point to.
     */
    function ERC20BeaconAddress() public view returns (address) {
        return address(beacon);
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
