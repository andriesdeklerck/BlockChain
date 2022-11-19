// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.9;

/**
 * @title Owner
 * @dev Set & change owner
 */
abstract contract Owner {
    address public owner;

    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    // modifier to check if caller is owner
    modifier isOwner() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    /**
     * @dev Set contract deployer as owner
     */
    constructor() {
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit OwnerSet(address(0), owner);
    }

    /**
     * @dev Change owner
     * @param newOwner address of new owner
     */
    function changeOwner(address newOwner) public isOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }
}

contract Voting is Owner {
    // Map van proposal id naar aantal stemmen
    mapping(uint256 => uint256) proposals;
    // Array van proposal ids
    uint[] proposalIds;


    // Map van user address naar boolean
    // True: gebruiker mag stemmen
    // False: gebruiker mag niet stemmen
    mapping(address => bool) voterRights;

    // Deadline in block numbers
    uint deadline;

    event ProposalVoted(uint proposalId, uint votes, address voter);

    modifier canVote(){
        require(voterRights[msg.sender], "You may not vote!");
        require(block.number < deadline, "Deadline is passed, no more voting");
        _;
    }

    constructor(){
        deadline = block.number + 1000;
    }

    function vote(uint proposalId) public canVote {
        proposals[proposalId]++;

        voterRights[msg.sender] = false;

        emit ProposalVoted(proposalId, proposals[proposalId], msg.sender);
    }

    function giveVoterRights(address[] memory voters) public isOwner{
        for(uint i = 0; i < voters.length; i++){
            voterRights[voters[i]] = true;
        }
    }

    function addProposals(uint[] memory _proposalIds) public {
        for(uint i = 0; i < _proposalIds.length; i++){
            proposalIds.push(_proposalIds[i]);
        }
    }

    function calculateWinner() public view returns(uint proposalId){
        uint winningProposal = proposalIds[0];
        uint winningProposalVotes;

        for(uint i = 0; i< proposalIds.length; i++){
            uint currentProposalVotes = proposals[proposalIds[i]];

            if(currentProposalVotes > winningProposalVotes){
                winningProposalVotes = proposals[proposalIds[i]];
                winningProposal = proposalIds[i];
            }
        }

        return winningProposal;
    }
}
