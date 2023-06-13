// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthRecord {
    struct Record {
        uint256 timestamp;
        string name;
        uint256 age;
        uint256 height;
        uint256 weight;
        string[] allergies; // Key is the name of the allergy, value is the severity
        string[] vaccinationsTaken; 
    }

    mapping(address => Record[]) private patientRecords;
    mapping(address => mapping(address => bool)) private sharedAccess;

    event RecordAdded(address indexed patient,  string name, uint256 age, uint256 height, uint256 weight, string[] allergies, string[] vaccinations);
    event RecordShared(address indexed patient, address indexed healthcareProvider);
    event RecordAccessRevoked(address indexed patient, address indexed healthcareProvider);

    function addRecord(string memory _name, uint256 _age, uint256 _height, uint256 _weight, string[] memory _allergies, string[] memory _vaccinationsTaken) public {
        Record memory newRecord = Record(block.timestamp, _name, _age, _height, _weight, _allergies, _vaccinationsTaken);
        patientRecords[msg.sender]
        .push(newRecord);
        emit RecordAdded(msg.sender,  _name, _age, _height, _weight, _allergies, _vaccinationsTaken);
    }

    function getRecordsCount() public view returns (uint256) {
        return patientRecords[msg.sender].length;
    }

    function getRecord(uint256 index, address healthcareProvider) public view returns (uint256, string memory, uint256, uint256, uint256, string[] memory, string[] memory) {
        require(sharedAccess[msg.sender][healthcareProvider], "No access to record");
        require(index < patientRecords[msg.sender].length && index>=0, "Invalid index");
        Record storage record = patientRecords[msg.sender][index];
        return (record.timestamp, record.name, record.age, record.height, record.weight, record.allergies, record.vaccinationsTaken);
    }


    function shareRecordAccess(address healthcareProvider) public {
        sharedAccess[msg.sender][healthcareProvider] = true;
        emit RecordShared(msg.sender, healthcareProvider);
    }

    function revokeRecordAccess(address healthcareProvider) public {
        require(sharedAccess[msg.sender][healthcareProvider], "No access to revoke");
        sharedAccess[msg.sender][healthcareProvider] = false;
        emit RecordAccessRevoked(msg.sender, healthcareProvider);
    }

    function hasAccess(address patient, address healthcareProvider) public view returns (bool) {
        return sharedAccess[patient][healthcareProvider];
    }
}
