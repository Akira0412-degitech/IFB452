// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract qualityContract{
    address public owner;

    struct contractData{
        string contractName;
        address[] stakeholders;
        string qualityCriteria;
        bool checkedByStakeholders;
        bool verifiedByOwner;
    }

    mapping(uint  => contractData) public qualityContracts;
    uint public contractId;


    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner(){
        require(msg.sender == owner, "You have no permission");
        _;
    }

    event DataAdded(uint contractId, string contractName, address[] stakeholders, string foodcriteria);

    function createQualityContract(string memory ContractName, address[] memory Stakeholders, string  memory foodQUalityCriteria) public onlyOwner returns(uint){
        contractId ++;

        qualityContracts[contractId] = contractData(ContractName, Stakeholders, foodQUalityCriteria, false, false);

        emit DataAdded(contractId, ContractName, Stakeholders, foodQUalityCriteria);

        return (contractId);
    }

    modifier onlyStakeholders(uint _contractId){
        bool inList = false;
        for (uint i = 0; i < qualityContracts[_contractId].stakeholders.length; i ++){
            if (msg.sender == qualityContracts[_contractId].stakeholders[i]){
                inList = true;
                break;
            }
        }
        require(inList == true, "You are not stakeholders");
        _;
    }

    modifier validId(uint _contractId){
        require(_contractId > 0 && _contractId <= contractId);
        _;
    }

    function getDetail(uint _contractId) public view onlyStakeholders(_contractId) returns(string memory, string memory){
        return (qualityContracts[_contractId].contractName, qualityContracts[_contractId].qualityCriteria);
    }

    event CheckedByStakeholders(uint ContractId, string QualityContract, bool Checked);

    function performQualityCheck(uint _contractId) public onlyStakeholders(_contractId) validId(_contractId){
        
        require(qualityContracts[_contractId].checkedByStakeholders == false, "Already checked by the stakeholders:");

        qualityContracts[_contractId].checkedByStakeholders = true;

        emit CheckedByStakeholders(_contractId, qualityContracts[_contractId].qualityCriteria, true);

    }

    event VerifiedByOwner(uint _contractId, string _contractName, string quality, bool _checked, bool _verified);

    function CompleteQualityContract(uint _contractId) public  onlyOwner validId(_contractId){
        require(qualityContracts[_contractId].checkedByStakeholders == true, "Not checked by stakeholders yet:");
        require(qualityContracts[_contractId].verifiedByOwner == false, "Verified by owner already");

        qualityContracts[_contractId].verifiedByOwner = true;
        
        contractData memory info = qualityContracts[_contractId];

        emit  VerifiedByOwner(_contractId, info.contractName, info.qualityCriteria, info.checkedByStakeholders, info.verifiedByOwner);
    }


}