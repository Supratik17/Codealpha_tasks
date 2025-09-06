// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PollingSystem {
    struct Poll {
        string title;
        string[] options;
        uint endTime;
        mapping(address => bool) hasVoted;
        mapping(uint => uint) votes; // optionId => vote count
        uint totalVotes;
    }

    uint public pollCount;
    mapping(uint => Poll) public polls;

    function createPoll(string memory _title, string[] memory _options, uint _duration) public {
        pollCount++;
        Poll storage poll = polls[pollCount];
        poll.title = _title;
        poll.endTime = block.timestamp + _duration;
        for (uint i = 0; i < _options.length; i++) {
            poll.options.push(_options[i]);
        }
    }

    function vote(uint pollId, uint optionId) public {
        Poll storage poll = polls[pollId];
        require(block.timestamp < poll.endTime, "Voting ended");
        require(!poll.hasVoted[msg.sender], "Already voted");

        poll.votes[optionId]++;
        poll.totalVotes++;
        poll.hasVoted[msg.sender] = true;
    }

    function getVotes(uint pollId, uint optionId) public view returns (uint) {
        return polls[pollId].votes[optionId];
    }

    function getWinner(uint pollId) public view returns (string memory winnerOption) {
        Poll storage poll = polls[pollId];
        uint winningVoteCount = 0;
        uint winningOptionIndex = 0;
        for (uint i = 0; i < poll.options.length; i++) {
            if (poll.votes[i] > winningVoteCount) {
                winningVoteCount = poll.votes[i];
                winningOptionIndex = i;
            }
        }
        winnerOption = poll.options[winningOptionIndex];
    }
}
