//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
// console.log("Hello, Hardhat!"); equialvalent in solidity
import "@openzeppelin/contracts/utils/Counters.sol";
// mostly used in every code to track the number of tokens
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// set of function and storing the token uri 
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// 

contract NFTMarketplace is ERC721URIStorage{
  
  address payable owner;
  using Counters for Counters.Counter;
  // this is the data type 

  Counters.Counter private _tokenIds;
  // this is the current token id 

  Counters.Counter private _itemSold;

  uint256 listPrice = 0.01 ether;
  // price of the listing of nft
  
  
  // ṆAME OF CLASS AND ACRONYM

  constructor() ERC721("NFTMarketplace", "NFTM") {
    // owner address person who deployed the particular contract
    owner = payable(msg.sender);  // when ever address is able eleigeble to recieve some ether
  }



  struct ListedToken{
    uint256 tokenId; //token id of nft
    address payable owner; // owner of the nft
    address payable seller; // seller of the nft
    uint256 price; // price of the nft
    bool currentlyListed; // if the nft is listed or not
  }


  mapping(uint256 => ListedToken) private idToListedToken;
  // mapping a token id to the listed token


  // helper function that will help us to test and retrieve 
  function updateListPrice(uint256 _listPrice) public payable {
    // if else in one line we can use always 
    require(owner == msg.sender, "Only owner can update the list price");
    listPrice = _listPrice;
  }

// normal to see that why its view
  function getListPrice() public view returns (uint256){
    return listPrice;
  }

  function getLatestIdToListedToken() public view returns (ListedToken memory){
    uint256 currentTokenId = _tokenIds.current();
    return idToListedToken[currentTokenId];
  }

  function getListedForTokenId(uint256 tokenId) public view returns(ListedToken memory){
    return idToListedToken[tokenId];
  }

  function getCurrentToeknId() public view returns(uint256){
    return _tokenIds.current();
  }


  // main function which actuals runs the front end

  // create token
  // create listed token
  // getallnfts
  // getmynfts
  // executesale 

  function createToken(string memory tokenURI, uint256 price) public payable returns (uint){
    require(msg.value == listPrice, "Price must be equal to list price");
    require(price > 0, "make sure price wont be negative");

    _tokenIds.increment();
    uint256 currentTokenId = _tokenIds.current();
    _safeMint(msg.sender, currentTokenId);  

    _setTokenURI(currentTokenId, tokenURI);

    createListedToken(currentTokenId, price);
    
    return currentTokenId;
  } 

  function createListedToken(uint256 tokenId, uint256 price) private {
      idToListedToken[tokenId] = ListedToken(
        tokenId,
        payable(address(this)),
        payable(msg.sender),
        price,
        true
      );
      _transfer(msg.sender, address(this), tokenId);
  }

  function getAllNFTs() public view returns(ListedToken[] memory){
    uint256 nftCount = _tokenIds.current();
    ListedToken[] memory tokens = new ListedToken[](nftCount);  
    
    uint currentIndex = 0;
    
    for(uint i=0;i<nftCount;i++)
    {
      uint currentId = i+1;
      ListedToken storage currentToken = idToListedToken[currentId];
      tokens[currentIndex] = currentToken;
      currentIndex += 1;
    } 
    
    return tokens;
  }




  function getMyNfts() public view returns(ListedToken[] memory){
    uint totalItemCount = _tokenIds.current();
    uint itemCount = 0;
    uint currentIndex = 0;

    for(uint i=0;i<totalItemCount;i++)
    {
      if(idToListedToken[i+1].owner == msg.sender || idToListedToken[i+1].seller == msg.sender ){
        itemCount += 1;
      }
      
    }

    ListedToken[] memory items = new ListedToken[](itemCount);
    for(uint i=0;i<totalItemCount;i++)
    {
      if(idToListedToken[i+1].owner == msg.sender || idToListedToken[i+1].seller == msg.sender){
        uint currentId = i+1; 
        ListedToken storage currentItem = idToListedToken[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    } 
    
    return items;
  }

// use payable jaha par paise dene paad rhe haii
  function executeSale(uint256 tokenId) public payable{
    uint price = idToListedToken[tokenId].price;
    require(msg.value == price, "please submit the asking price for the nft in order to buy");

    address seller = idToListedToken[tokenId].seller;

    idToListedToken[tokenId].currentlyListed = true;
    idToListedToken[tokenId].seller = payable(msg.sender);

    _itemSold.increment();
    // address(this) is the address of the contract

    _transfer(address(this), msg.sender, tokenId);
    approve(address(this), tokenId);

    payable(owner).transfer(listPrice);
    payable(seller).transfer(msg.value);
  }

}