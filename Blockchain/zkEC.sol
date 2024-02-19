// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "../zokrates_f2/verifier.sol";

contract zkEC {
    address problemOwner;

    uint tokenPerWin;
    uint totalTokenBalance;
    uint maximumIteration;
    uint initialBlocktime;
    uint blocktimePerIteration;
    
    mapping(address => Solver) solvers;
    mapping(uint => uint) bestSolution;   // iteration => bestSolution
    mapping(uint => address) bestAddress; // iteration => bestAddress
    mapping(uint => bool) isProposed; // iteration => bool

    struct Solver {
        uint commitment;
        uint balance;
        uint nextBlocktimeToPropose;
        bool exist;
    }

    modifier isProblemOwner(address _address) {
        require(_address == problemOwner, "Not Problem Owner!");
        _;
    }

    modifier isProblemSolver(address _address) {
        require(solvers[_address].exist == true, "Not Problem Solver!");
        _;
    } 

    modifier isRegistrationOpen() {
        require(block.number < initialBlocktime, "Registration Closed!");
        _;
    } 

    modifier isClaimOpen() {
        require(block.number > initialBlocktime + blocktimePerIteration * 
maximumIteration, "Claim Closed!");
        _;
    } 

    modifier isEligibleToRegister(address _address) {
        require(solvers[_address].exist != true && problemOwner != 
_address, "Not Eligible To Register!");
        _;
    } 

    modifier isEligibleToPropose(address _address) {
        require(block.number > solvers[_address].nextBlocktimeToPropose, 
"Not Eligible To Propose!");
        _;
    } 

    constructor(uint _initialBlocktime, uint _blocktimePerIteration, uint 
_maximumIteration, uint _tokenPerWin) {
        problemOwner = msg.sender;
        maximumIteration = _maximumIteration;
        initialBlocktime = _initialBlocktime;
        blocktimePerIteration = _blocktimePerIteration;
        tokenPerWin = _tokenPerWin;
        totalTokenBalance = tokenPerWin * maximumIteration;
    }

    function register(uint _commitment) isRegistrationOpen 
isEligibleToRegister(msg.sender) public { // 
        Solver memory solver = Solver(_commitment, 0, initialBlocktime, 
true);
        solvers[msg.sender] = solver;
    }

    function proposeSolution(
        uint[2] memory a, 
        uint[2][2] memory b, 
        uint[2] memory c,
        uint _next_population_commitment,
        uint _fitness) public isProblemSolver(msg.sender) 
isEligibleToPropose(msg.sender) { // 

        Verifier verifier = new Verifier();
        bool isProofCorrect = verifier.verifyTX(a, b, c, 
[solvers[msg.sender].commitment,
                                                          
_next_population_commitment,
                                                          _fitness,
                                                          1]);

        if (isProofCorrect) {
            
            uint currentIteration = (block.number - initialBlocktime) / 
blocktimePerIteration;
            solvers[msg.sender].nextBlocktimeToPropose = initialBlocktime 
+ (currentIteration + 1) * blocktimePerIteration;
            solvers[msg.sender].commitment = _next_population_commitment;

            if (!isProposed[currentIteration]) {
                bestSolution[currentIteration] = _fitness;
                bestAddress[currentIteration] = msg.sender;   
            }
            else {
                if (_fitness < bestSolution[currentIteration]) {
                    bestSolution[currentIteration] = _fitness;
                    bestAddress[currentIteration] = msg.sender;
                }
            }
        }
    }

    function countWins() public isClaimOpen isProblemSolver(msg.sender) 
returns (uint) { // 
        uint winCounter = 0;
        for (uint iter = 0; iter < maximumIteration; iter++) {
            if (bestAddress[iter] == msg.sender) {
                bestAddress[iter] = address(0x0);
                winCounter += 1;
            }
        }

        totalTokenBalance -= winCounter * tokenPerWin;
        solvers[msg.sender].balance += winCounter * tokenPerWin;
        return winCounter;
    }

    function getTotalBalance() public view isProblemOwner(msg.sender) 
returns (uint) {
        return totalTokenBalance;
    }

    function getMyBalance() public view isProblemSolver(msg.sender) 
returns (uint) {
        return solvers[msg.sender].balance;
    }

    function getMyCommitment() public view isProblemSolver(msg.sender) 
returns (uint) {
        return solvers[msg.sender].commitment;
    }
}
