// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { ERC20 } from "solmate/src/tokens/ERC20.sol";
import { SafeTransferLib } from "solmate/src/utils/SafeTransferLib.sol";
import "./MerkleTreeWithHistory.sol";

interface IVerifier {
    function verify(bytes calldata _proof, bytes32[] calldata _publicInputs) external view returns (bool);
}

contract ShieldAMM {
    using SafeTransferLib for ERC20;
    using MerkleTreeWithHistoryLib for MerkleTreeWithHistory;

    uint32 public constant merkleTreeHeight = 20;

    ERC20 public immutable baseToken;

    ERC20 public immutable quoteToken;

    IVerifier public immutable depositVerifier;

    IVerifier public immutable swapVerifier;

    IVerifier public immutable addLiquidityVerifier;

    IVerifier public immutable removeLiquidityVerifier;

    MerkleTreeWithHistory public tokenMerkleTree;

    MerkleTreeWithHistory public liquidityMerkleTree;

    // checked nullifiers is used
    mapping(bytes32 => bool) public tokenDepositNullifierHashes;

    // checked commitments is existed
    mapping(bytes32 => bool) public tokenDepositCommitments;

    // checked nullifiers is used
    mapping(bytes32 => bool) public liquidityNullifierHashes;

    // checked commitments is existed
    mapping(bytes32 => bool) public liquidityCommitments;

    uint256 public liquidity;
    uint256 public price;
    uint256 public constant denominator = 10000;

    event Deposit(bytes32 indexed commitment, uint32 leafIndex, uint256 timestamp);

    event Withdrawal(address recipient, bytes32 nullifierHash);

    event Swap(bytes32 indexed commitment, uint32 leafIndex, uint256 timestamp);

    event AddLiquidity(bytes32 indexed commitment, uint32 leafIndex, uint256 timestamp);

    event RemoveLiquidity(bytes32 indexed commitment, uint32 leafIndex, uint256 timestamp);

    constructor(
        ERC20 _baseToken,
        ERC20 _quoteToken,
        IVerifier _depositVerifier,
        IVerifier _swapVerifier,
        IVerifier _addLiquidityVerifier,
        IVerifier _removeLiquidityVerifier,
        IHasher _hasher
    ) {
        baseToken = _baseToken;
        quoteToken = _quoteToken;
        depositVerifier = _depositVerifier;
        swapVerifier = _swapVerifier;
        addLiquidityVerifier = _addLiquidityVerifier;
        removeLiquidityVerifier = _removeLiquidityVerifier;

        tokenMerkleTree.initialize(_hasher, merkleTreeHeight);
        liquidityMerkleTree.initialize(_hasher, merkleTreeHeight);
    }

    function deposit(bytes32 _commitment, ERC20 _token, uint256 _amount) external {
        require(!tokenDepositCommitments[_commitment], "The commitment has been submitted");
        require(isPairTokens(_token), "token is invalid"); 

        // Set token commitment to true
        uint32 insertedIndex = tokenMerkleTree.insert(_commitment);
        tokenMerkleTree.insert(_commitment);
        tokenDepositCommitments[_commitment] = true;
        
        // Transfer token to this contract
        _token.safeTransferFrom(msg.sender, address(this), _amount);

        emit Deposit(_commitment, insertedIndex, block.timestamp);
    }

    function withdraw(
        bytes calldata _proof,
        bytes32[] calldata _publicInputs,
        address _recipient
    ) external {
        ERC20 token = ERC20(address(bytes20(_publicInputs[0])));
        uint256 amount = uint256(_publicInputs[1]);
        bytes32 nullifierHash = _publicInputs[2];
        bytes32 root = _publicInputs[3];

        require(!tokenDepositNullifierHashes[nullifierHash], "The note has been already spent");
        require(tokenMerkleTree.isKnownRoot(root), "Cannot find your merkle root");
        require(isPairTokens(token), "token is invalid"); 
        
        // Verify proof
        bool proofResult = depositVerifier.verify(_proof, _publicInputs);
        require(proofResult, "Invalid withdraw proof");

        // Set nullifier hash to true
        tokenDepositNullifierHashes[nullifierHash] = true;

        // Transfer tokens to recipient
        token.safeTransfer(_recipient, amount);

        emit Withdrawal(_recipient, nullifierHash);
    }

    function addLiquidity(
        bytes calldata _proof,
        bytes32[] calldata _publicInputs
    ) external {
        bytes32 commitment = _publicInputs[0];
        ERC20 token = ERC20(address(bytes20(_publicInputs[1])));
        bytes32 nullifierHash = _publicInputs[3];
        bytes32 root = _publicInputs[4];
        uint256 inputLiquidity = uint256(_publicInputs[5]);
        uint256 inputLiquidityAdded = uint256(_publicInputs[9]);

        require(!tokenDepositNullifierHashes[nullifierHash], "The note has been already spent");
        require(tokenMerkleTree.isKnownRoot(root), "Cannot find your merkle root");
        require(isPairTokens(token), "token is invalid");
        require(inputLiquidity > liquidity, "liquidity is not enough");

        // Verify proof
        bool proofResult = addLiquidityVerifier.verify(_proof, _publicInputs);
        require(proofResult, "Invalid add liquidity proof");

        // Set token nullifier hash to true
        tokenDepositNullifierHashes[nullifierHash] = true;

        // Set liquidity commitment to true
        uint32 insertedIndex = liquidityMerkleTree.insert(commitment);
        liquidityMerkleTree.insert(commitment);
        liquidityCommitments[commitment] = true;
        
        // Update liquidity
        liquidity += inputLiquidityAdded;

        emit AddLiquidity(commitment, insertedIndex, block.timestamp);
    }

    function removeLiquidity(
        bytes calldata _proof,
        bytes32[] calldata _publicInputs
    ) external {
        bytes32 commitment = _publicInputs[0];
        bytes32 nullifierHash = _publicInputs[2];
        bytes32 root = _publicInputs[3];
        uint256 inputLiquidity = uint256(_publicInputs[4]);
        bool isQuoteToken = _publicInputs[6] != bytes32(0);
        uint256 inputLiquidityRemoved = uint256(_publicInputs[7]);

        ERC20 token = baseToken;
        if (isQuoteToken) {
            token = quoteToken;
        }

        require(!liquidityNullifierHashes[nullifierHash], "The note has been already spent");
        require(liquidityMerkleTree.isKnownRoot(root), "Cannot find your merkle root");
        require(inputLiquidity < liquidity, "liquidity is too much");

        // Verify proof
        bool proofResult = removeLiquidityVerifier.verify(_proof, _publicInputs);
        require(proofResult, "Invalid remove liquidity proof");

        // Set liquidity nullifier hash to true
        liquidityNullifierHashes[nullifierHash] = true;

        // Set token commitment to true
        uint32 insertedIndex = tokenMerkleTree.insert(commitment);
        tokenMerkleTree.insert(commitment);
        tokenDepositCommitments[commitment] = true;
        
        // Update liquidity
        liquidity -= inputLiquidityRemoved;

        emit RemoveLiquidity(commitment, insertedIndex, block.timestamp);
    }

    function swap(
        bytes calldata _proof,
        bytes32[] calldata _publicInputs
    ) external {
        bytes32 commitment = _publicInputs[2];
        ERC20 token = ERC20(address(bytes20(_publicInputs[3])));
        bytes32 nullifierHash = _publicInputs[5];
        bytes32 root = _publicInputs[6];
        uint256 priceFrom = uint256(_publicInputs[5]);
        uint256 priceTo = uint256(_publicInputs[6]);
        bool isBuy = _publicInputs[7] != bytes32(0);

        require(!tokenDepositNullifierHashes[nullifierHash], "The note has been already spent");
        require(tokenMerkleTree.isKnownRoot(root), "Cannot find your merkle root");
        require(isPairTokens(token), "token is invalid");
        if (isBuy) {
            require(priceFrom > price, "price is too low");
        } else {
            require(priceFrom < price, "liquidity is too high");
        }

        // Verify proof
        bool proofResult = swapVerifier.verify(_proof, _publicInputs);
        require(proofResult, "Invalid swap proof");

        // Set token nullifier hash to true
        tokenDepositNullifierHashes[nullifierHash] = true;

        // Set token commitment to true
        uint32 insertedIndex = tokenMerkleTree.insert(commitment);
        tokenMerkleTree.insert(commitment);
        tokenDepositCommitments[commitment] = true;
        
        // Update price
        price += (priceFrom - priceTo);

        emit Swap(commitment, insertedIndex, block.timestamp);
    }

    function isPairTokens(ERC20 _token) public view returns (bool) {
        if (_token == baseToken || _token == quoteToken) {
            return true;
        }
        return false;
    }
}
