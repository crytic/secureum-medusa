pragma solidity 0.8.19;

interface IVM {
    function addr(uint256) external returns (address);
    function ffi(string[] calldata) external returns (bytes memory);
    function parseBytes(string calldata) external returns (bytes memory);
    function parseBytes32(string calldata) external returns (bytes32);
    function parseAddress(string calldata) external returns (address);
    function parseUint(string calldata) external returns (uint256);
    function parseInt(string calldata) external returns (int256);
    function parseBool(string calldata) external returns (bool);
    function sign(uint256, bytes32) external returns (uint8, bytes32, bytes32);
    function toString(address) external returns (string memory);
    function toString(bool) external returns (string memory);
    function toString(uint256) external returns (string memory);
    function toString(int256) external returns (string memory);
    function toString(bytes32) external returns (string memory);
    function toString(bytes memory) external returns (string memory);
    function warp(uint64) external;
    function load(address, bytes32) external returns (bytes32);
    function store(address, bytes32, bytes32) external;
    function roll(uint256) external;
    function prank(address) external;
    function prankHere(address) external;
    function getNonce(address) external returns (uint64);
    function setNonce(address, uint64) external;
    function fee(uint256) external;
    function etch(address, bytes calldata) external;
    function difficulty(uint256) external;
    function deal(address, uint256) external;
    function coinbase(address) external;
    function chainId(uint256) external;
}
