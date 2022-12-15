// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.9;

contract VotePropose {

    function vote(uint proposalId) public canVote {
        proposals[proposalId]++;

        voterRights[msg.sender] = false;

        emit ProposalVoted(proposalId, proposals[proposalId], msg.sender);
    }

}