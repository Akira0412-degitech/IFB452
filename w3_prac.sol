// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract multipleStakeholders{
    uint public qualityScore;
    mapping(address => bool) public stakeholders;

    constructor(address[] memory initialStakeholders){
        for (uint i = 0; i < initialStakeholders.length; i++)
            stakeholders[initialStakeholders[i]] = true;
    }

    modifier onlyStakeholders(){
        require(stakeholders[msg.sender] == true, "You are not the stakeholders");
        _;
    }

    event QualityScoreUpdated(uint oldScore, uint newScore);

    function updateQualityScore(uint _newScore) public onlyStakeholders{
        require(_newScore >= 0 && _newScore <= 100, "New score should be between 0 and 100 inclusive");

        emit QualityScoreUpdated(qualityScore, _newScore);

        qualityScore = _newScore;
    }

    function addStakeholders(address _addr) public onlyStakeholders {
        require(_addr != address(0), "Invalid address");

        stakeholders[_addr] = true;
    }

    function getQualityScore() public view returns (uint){
        return qualityScore;
    }

}