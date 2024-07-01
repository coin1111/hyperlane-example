

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ltk.sol"; // Replace with your ERC20 contract path

contract LtkTest is Test {
    Ltk public token;
    address public user1;
    address public user2;

    function setUp() public {
        token = new Ltk(); // Deploy the token
        user1 = address(1); 
        user2 = address(2);
    }

    function testName() public view {
        assertEq(token.name(), "LibraToken"); // Test the token name
    }

    function testSymbol() public view {
        assertEq(token.symbol(), "LTK");  // Test the token symbol
    }

    function testDecimals() public view {
        assertEq(token.decimals(), 18);   // Test the token decimals
    }

    function testTotalSupply() public view {
        uint256 expectedSupply = 1_000_000 * 10 ** 18; // 1 million tokens
        assertEq(token.totalSupply(), expectedSupply);  // Test the total supply
    }

}
