// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;



library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

library Counters {
    struct Counter {
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}



interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

interface IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}



abstract contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _setOwner(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}



contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    string private _name;

    string private _symbol;

    mapping(uint256 => address) private _owners;

    mapping(address => uint256) private _balances;

    mapping(uint256 => address) private _tokenApprovals;

    mapping(address => mapping(address => bool)) private _operatorApprovals;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != _msgSender(), "ERC721: approve to caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}

abstract contract ERC721URIStorage is ERC721 {
    using Strings for uint256;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(tokenId);
    }

    /**
     * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);

        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }
}

contract PlanetNFTs is ERC721URIStorage, Ownable {
    struct OfferStr {
        address fromOffer;
        uint256 offerPrice;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    string private _batchTokenURI = "";
    uint256 private MAX_TOKEN = 100000;

    address private _royaltyReceiver = address(0);
    uint8 private _royaltyFee = 5;
    uint8 private _refundPercentFee = 98;

    uint256[] private TIER_PRICE = [2000, 2100, 2200, 2300, 2500];
    uint256[] private TIER_BLOCK = [11294394, 11303034, 11311674, 11320314, 11328954]; // test
    // uint256[] private TIER_BLOCK = [11245574, 11254214, 11262854, 11271494, 11280134]; // main
    uint256[] private WHITELISTER_LEN = [3, 3, 3, 2];
    address[] private WHITELISTER0 = [
        0x0696f415af52D3fe71b34Fa7F43fB731e864c624,
        0x178B43093A73fbBe84caf996295dBfc215e1F8c1,
        0x015352c4c79FaBe59b9af6b88aC9d1448a593F26
    ];
    address[] private WHITELISTER1 = [
        0x28e201efe21b7ED695F9f3983Ba8B850eE23aD8C,
        0x9F2D432BB0975DE67C77ba66A7DE884072b4c660,
        0xbf5a47dd76C1522A8978ffc5943f4B2258A940dD
    ];
    address[] private WHITELISTER2 = [
        0xc87f673E834BC5e513Dce0694674637A73D8af9f,
        0x43f3aC34295CA1e29794D1d746E504f91761f79E,
        0xb13e5Eb29D26ec4b79121c4C69CEc9680af78Ca6
    ];
    address[] private WHITELISTER3 = [
        0x3F78987d3d3f63cc0B374898B4fA833212878873,
        0x14609a7f9fEd9D7f33353B8601AD2bf16CA78892
    ];
    mapping(address => uint256) private _WHITELISTER;

    // Mapping from token to operator price
    mapping(uint256 => OfferStr[]) private _buyOffer;
    mapping(uint256 => mapping(address => bool)) _offerState;
    mapping(uint256 => bool) private _isBuyable;
    mapping(uint256 => uint256) private _buyablePrice;

    constructor() ERC721("PLANET", "PLN") {
        _royaltyReceiver = msg.sender;
    }

    modifier ableBatch() {
        require(keccak256(abi.encodePacked(_batchTokenURI)) != keccak256(abi.encodePacked("")), "Batch Token URI not set");
        _;
    }

    function getPrice() public view returns(uint256) {
        uint256 curBlock = block.number;
        if (curBlock >= TIER_BLOCK[4]) {
            return TIER_PRICE[4];
        }
        if (curBlock >= TIER_BLOCK[3]) {
            return TIER_PRICE[3];
        }
        if (curBlock >= TIER_BLOCK[2]) {
            return TIER_PRICE[2];
        }
        if (curBlock >= TIER_BLOCK[1]) {
            return TIER_PRICE[1];
        }
        return TIER_PRICE[0];
    }

    function getMaxLimit() external view returns(uint256) {
        return MAX_TOKEN;
    }

    function setMaxLimit(uint256 limit) external onlyOwner {
        MAX_TOKEN = limit;
    }

    function withDraw() external onlyOwner {
        address payable tgt = payable(owner());
        (bool success1, ) = tgt.call{value:address(this).balance}("");
        require(success1, "Failed to Withdraw Ether");
    }

    function setTokenBatchURI(string memory tokenURI) public onlyOwner {
        _batchTokenURI = tokenURI;
    }

    function setTokenURI(uint256 number, string memory tokenURI) public onlyOwner {
        _setTokenURI(number, tokenURI);
    }

    function mintBatch(uint256 number) public payable ableBatch returns(uint256) {
        require(_checkWhitelist(msg.sender), "Not exsit in whitelist.");
        require(MAX_TOKEN > number + _tokenIds.current() + 1, "Not enough tokens left to buy.");
        require(msg.value >= getPrice() * number, "Amount of ether sent not correct.");

        uint256 newItemId = 0;
        for (uint256 i = 0; i < number; i++) {
            _tokenIds.increment();
            newItemId = _tokenIds.current();
            _mint(msg.sender, newItemId);
            _setTokenURI(newItemId, string(abi.encodePacked(_batchTokenURI, "/", uint2str(newItemId))));
        }
        return newItemId;
    }

    function createCollectible(string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function _checkWhitelist(address pm_address) private view returns(bool) {
        uint256 curBlock = block.number;
        if (curBlock >= TIER_BLOCK[4]) {
            return true;
        }
        if (curBlock >= TIER_BLOCK[3]) {
            for (uint256 i=0; i<WHITELISTER_LEN[3]; i++) {
                if (pm_address == WHITELISTER3[i]) {
                    return true;
                }
            }
            return false;
        }
        if (curBlock >= TIER_BLOCK[2]) {
            for (uint256 i=0; i<WHITELISTER_LEN[2]; i++) {
                if (pm_address == WHITELISTER2[i]) {
                    return true;
                }
            }
            return false;
        }
        if (curBlock >= TIER_BLOCK[1]) {
            for (uint256 i=0; i<WHITELISTER_LEN[1]; i++) {
                if (pm_address == WHITELISTER1[i]) {
                    return true;
                }
            }
            return false;
        }
        if (curBlock >= TIER_BLOCK[0]) {
            for (uint256 i=0; i<WHITELISTER_LEN[0]; i++) {
                if (pm_address == WHITELISTER0[i]) {
                    return true;
                }
            }
        }
        return false;
    }


    function getBlockLimit(uint8 index) external view returns(uint256) {
        return TIER_BLOCK[index];
    }

    function setBlockLimit(uint8 index, uint256 timestamp) public {
        TIER_BLOCK[index] = timestamp;
    }

    function getTierPrice(uint8 index) external view returns(uint256) {
        return TIER_PRICE[index];
    }

    function setTierPrice(uint8 index, uint256 timestamp) public {
        TIER_PRICE[index] = timestamp;
    }

    function getRoyaltyReceiver() external view returns(address) {
        return _royaltyReceiver;
    }

    function setRoyaltyReceiver(address pm_address) external onlyOwner {
        _royaltyReceiver = pm_address;
    }


    function totalSupply() external view returns(uint256) {
        return _tokenIds.current();
    }

    function getBuyable(uint256 tokenId) public view returns(bool) {
        if (_isBuyable[tokenId]) {
            return true;
        }
        return false;
    }

    function getBuyablePrice(uint256 tokenId) public view returns(uint256) {
        return _buyablePrice[tokenId];
    }

    function setBuyable(uint256 tokenId, bool state) external {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
        _isBuyable[tokenId] = state;
    }

    function makeTokenBuyable(uint256 tokenId, uint256 price) external {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
        _isBuyable[tokenId] = true;
        _buyablePrice[tokenId] = price;
    }

    function buy(uint256 tokenId) external payable {
        require(ownerOf(tokenId) != msg.sender, "You can't buy yours");
        require(getBuyable(tokenId), "Token is not public");
        require(_royaltyReceiver != address(0), "Royalty is not avaible");
        require(msg.value >= _buyablePrice[tokenId], "Fund is not enough");
        _transfer(ownerOf(tokenId), msg.sender, tokenId);
        _isBuyable[tokenId] = false;
        uint256 offerLen = _buyOffer[tokenId].length;
        for(uint256 i=0; i<offerLen; i++) {
            if (_buyOffer[tokenId][i].fromOffer == msg.sender) {
                delete _buyOffer[tokenId][i];
            }
        }
        _offerState[tokenId][msg.sender] = false;
        address payable royaltyReceiver = payable(_royaltyReceiver);
        (bool success1, ) = royaltyReceiver.call{ value: msg.value * _royaltyFee / 100 }("");
        require(success1, "Failed to Pay Royalty fee");
    }

    function offer(uint256 tokenId) external payable {
        require(ownerOf(tokenId) != msg.sender, "You can't buy yours");
        require(ownerOf(tokenId) != address(0), "You can't send offer no-owner token");
        require(_offerState[tokenId][msg.sender] != true, "You can't send mutli offer");
        _buyOffer[tokenId].push(OfferStr({fromOffer:msg.sender, offerPrice:msg.value}));
        _offerState[tokenId][msg.sender] = true;
    }

    function calcelOffer(uint256 tokenId) external {
        require(ownerOf(tokenId) != msg.sender, "You can't buy yours");
        require(ownerOf(tokenId) != address(0), "You can't send offer no-owner token");
        uint256 offerLen = _buyOffer[tokenId].length;
        for(uint256 i=0; i<offerLen; i++) {
            if (_buyOffer[tokenId][i].fromOffer == msg.sender) {
                (bool success1, ) = msg.sender.call{ value: _buyOffer[tokenId][i].offerPrice * _refundPercentFee / 100 }("");
                require(success1, "Failed to Pay Royalty fee");
                delete _buyOffer[tokenId][i];
                break;
            }
        }
        _offerState[tokenId][msg.sender] = false;
    }

    function getOffers(uint256 tokenId) external view returns(OfferStr[] memory) {
        require(ownerOf(tokenId) != address(0), "No-owner token can't have offer");
        return _buyOffer[tokenId];
    }

    function approveOffer(uint256 tokenId, address offerSender) external {
        require(ownerOf(tokenId) == msg.sender, "You can't approve others");
        require(_royaltyReceiver != address(0), "Royalty is not avaible");
        _transfer(ownerOf(tokenId), offerSender, tokenId);
        _isBuyable[tokenId] = false;
        uint256 offerLen = _buyOffer[tokenId].length;
        for(uint256 i=0; i<offerLen; i++) {
            if (_buyOffer[tokenId][i].fromOffer == offerSender) {
                address payable royaltyReceiver = payable(_royaltyReceiver);
                (bool success1, ) = royaltyReceiver.call{ value: _buyOffer[tokenId][i].offerPrice * _royaltyFee / 100 }("");
                require(success1, "Failed to Pay Royalty fee");
                delete _buyOffer[tokenId][i];
                break;
            }
        }
        _offerState[tokenId][offerSender] = false;
    }
}

