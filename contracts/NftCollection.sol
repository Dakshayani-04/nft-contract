// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NftCollection {
    string public name;
    string public symbol;
    uint256 public maxSupply;
    uint256 public totalSupply;
    bool public paused;

    address private admin;
    string private baseURI;

    mapping(uint256 => address) private tokenOwner;
    mapping(address => uint256) private balances;
    mapping(uint256 => address) private approved;
    mapping(address => mapping(address => bool)) private operatorApprovals;
    mapping(uint256 => bool) private tokenExists;
    mapping(uint256 => string) private tokenURIs;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event Paused(bool indexed pausedState);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _maxSupply,
        string memory _baseURI
    ) {
        require(_maxSupply > 0, "Max supply must be greater than 0");
        name = _name;
        symbol = _symbol;
        maxSupply = _maxSupply;
        baseURI = _baseURI;
        admin = msg.sender;
        totalSupply = 0;
        paused = false;
    }

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "Query for zero address");
        return balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = tokenOwner[tokenId];
        require(owner != address(0), "Token does not exist");
        return owner;
    }

    function safeMint(address to, uint256 tokenId) public onlyAdmin whenNotPaused {
        require(to != address(0), "Cannot mint to zero address");
        require(!tokenExists[tokenId], "Token already minted");
        require(totalSupply < maxSupply, "Max supply reached");
        require(tokenId <= maxSupply, "Token ID exceeds max supply");

        tokenOwner[tokenId] = to;
        balances[to]++;
        tokenExists[tokenId] = true;
        totalSupply++;

        emit Transfer(address(0), to, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(from != address(0), "Transfer from zero address");
        require(to != address(0), "Transfer to zero address");
        require(tokenExists[tokenId], "Token does not exist");
        require(tokenOwner[tokenId] == from, "From address is not the owner");
        require(
            msg.sender == from || msg.sender == approved[tokenId] || operatorApprovals[from][msg.sender],
            "Not authorized to transfer"
        );

        approved[tokenId] = address(0);
        balances[from]--;
        balances[to]++;
        tokenOwner[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public {
        transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(
            msg.sender == owner || operatorApprovals[owner][msg.sender],
            "Not authorized to approve"
        );
        require(to != owner, "Approval to owner is not allowed");

        approved[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved_) public {
        require(operator != msg.sender, "Cannot approve yourself");
        operatorApprovals[msg.sender][operator] = approved_;
        emit ApprovalForAll(msg.sender, operator, approved_);
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        require(tokenExists[tokenId], "Token does not exist");
        return approved[tokenId];
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return operatorApprovals[owner][operator];
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(tokenExists[tokenId], "Token does not exist");

        if (bytes(tokenURIs[tokenId]).length > 0) {
            return tokenURIs[tokenId];
        }

        return string(abi.encodePacked(baseURI, _uint2str(tokenId)));
    }

    function setTokenURI(uint256 tokenId, string memory uri) public onlyAdmin {
        require(tokenExists[tokenId], "Token does not exist");
        tokenURIs[tokenId] = uri;
    }

    function pauseMinting() public onlyAdmin {
        paused = true;
        emit Paused(true);
    }

    function unpauseMinting() public onlyAdmin {
        paused = false;
        emit Paused(false);
    }

    function burn(uint256 tokenId) public {
        require(tokenExists[tokenId], "Token does not exist");
        address owner = tokenOwner[tokenId];
        require(msg.sender == owner, "Only owner can burn token");

        balances[owner]--;
        delete tokenOwner[tokenId];
        delete approved[tokenId];
        tokenExists[tokenId] = false;
        totalSupply--;

        emit Transfer(owner, address(0), tokenId);
    }

    function _uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len = 0;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
