# NFT Contract

ERC-721 Compatible NFT Smart Contract with Comprehensive Automated Test Suite and Docker Containerization

## Overview

This project implements a fully functional ERC-721-compatible NFT smart contract with:

- **Smart Contract**: Solidity-based ERC-721 implementation with extended features
- **Test Suite**: Comprehensive test coverage using Hardhat and Chai
- **Docker Support**: Containerized environment for reproducible testing
- **Documentation**: Complete setup and usage instructions

## Features

### Contract Features

- ✅ ERC-721 Standard Compliance
- ✅ Token Ownership Management
- ✅ Safe Minting with Authorization
- ✅ Transfer Mechanisms (including safe transfers)
- ✅ Approval & Operator Support
- ✅ Token Metadata (tokenURI)
- ✅ Maximum Supply Enforcement
- ✅ Pause/Unpause Functionality
- ✅ Token Burning
- ✅ Comprehensive Event Logging

### Test Coverage

- Deployment and initialization tests
- Minting functionality and edge cases
- Transfer operations and authorization
- Approval and operator mechanisms
- Metadata handling
- Error conditions and reverts

## Project Structure

```
project-root/
├── contracts/
│   └── NftCollection.sol        # Main ERC-721 contract
├── test/
│   └── NftCollection.test.js    # Comprehensive test suite
├── Dockerfile                   # Container configuration
├── .dockerignore                # Docker build optimization
├── hardhat.config.js            # Hardhat configuration
├── package.json                 # Project dependencies
└── README.md                    # This file
```

## Requirements

- Docker (for containerized testing)
- Node.js 18+ (for local development)
- npm or yarn

## Installation

### Local Development Setup

```bash
# Clone the repository
git clone https://github.com/Dakshayani-04/nft-contract.git
cd nft-contract

# Install dependencies
npm install

# Compile contracts
npx hardhat compile
```

## Running Tests

### Using Docker (Recommended)

```bash
# Build the Docker image
docker build -t nft-contract .

# Run tests in Docker
docker run nft-contract
```

### Local Testing

```bash
# Run all tests
npm test

# Run specific test file
npx hardhat test test/NftCollection.test.js

# Run tests with coverage
npx hardhat coverage
```

## Contract Functions

### Core ERC-721 Functions

- `balanceOf(address)` - Get token balance
- `ownerOf(uint256)` - Get token owner
- `transferFrom(from, to, tokenId)` - Transfer token
- `safeTransferFrom(from, to, tokenId)` - Safe transfer
- `approve(to, tokenId)` - Approve transfer
- `setApprovalForAll(operator, approved)` - Operator approval
- `getApproved(tokenId)` - Get approved address
- `isApprovedForAll(owner, operator)` - Check operator status

### Additional Functions

- `safeMint(to, tokenId)` - Admin-only minting
- `burn(tokenId)` - Token burning
- `tokenURI(tokenId)` - Metadata URI
- `pauseMinting()` / `unpauseMinting()` - Minting control

## Configuration

### Contract Initialization

```solidity
new NftCollection(
    "NFT Collection",           // Token name
    "NFT",                      // Token symbol
    1000,                       // Maximum supply
    "https://metadata.example.com/"  // Base URI
)
```

## Docker Usage

### Build

```bash
docker build -t nft-contract .
```

### Run Tests

```bash
docker run nft-contract
```

### Interactive Shell

```bash
docker run -it nft-contract /bin/sh
```

## Testing Details

The test suite covers:

1. **Deployment Tests** - Initial configuration validation
2. **Minting Tests** - Token creation and constraints
3. **Transfer Tests** - Ownership changes
4. **Approval Tests** - Permission management
5. **Metadata Tests** - URI handling
6. **Edge Cases** - Error conditions and boundary testing

## Security Considerations

- ✅ Input validation on all functions
- ✅ Unauthorized access prevention
- ✅ Proper state management
- ✅ Event emission for all state changes
- ✅ Safe math operations
- ✅ Atomic transactions

## Gas Optimization

- Efficient mapping structures
- Minimal storage operations
- Optimized loops and logic
- Reasonable gas bounds for normal operations

## Development

### Compiling Contracts

```bash
npx hardhat compile
```

### Cleaning Build Artifacts

```bash
npx hardhat clean
```

## Troubleshooting

### Docker Build Issues

- Ensure Docker is properly installed
- Check that sufficient disk space is available
- Verify internet connectivity for npm package downloads

### Test Failures

- Ensure all dependencies are installed: `npm install`
- Recompile contracts: `npx hardhat compile`
- Clear artifacts: `npx hardhat clean && npm install`

## License

MIT License - See LICENSE file for details

## Author

Dakshayani-04

## Support

For issues or questions, please create an issue in the repository.
