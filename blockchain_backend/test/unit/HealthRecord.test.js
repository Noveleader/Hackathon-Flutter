const { expect } = require("chai");

describe("HealthRecord", function () {
  let healthRecord;
  let owner;
  let healthcareProvider;

  beforeEach(async function () {
    const HealthRecord = await ethers.getContractFactory("HealthRecord");
    healthRecord = await HealthRecord.deploy();
    await healthRecord.deployed();

    [owner, healthcareProvider] = await ethers.getSigners();
  });

  it("should add a record", async function () {
    const name = "John Doe";
    const age = 30;
    const height = 180;
    const weight = 80;
    const allergies = ["Peanuts", "Shellfish"];
    const vaccinationsTaken = ["Flu", "COVID-19"];

    await healthRecord.connect(owner).addRecord(name, age, height, weight, allergies, vaccinationsTaken);
    await healthRecord.connect(owner).shareRecordAccess(healthcareProvider.address);
    const recordCount = await healthRecord.getRecordsCount();
    expect(recordCount).to.equal(1);

    const [timestamp, recordName, recordAge, recordHeight, recordWeight, recordAllergies, recordVaccinationsTaken] = await healthRecord.getRecord(0, healthcareProvider.address);
    expect(recordName).to.equal(name);
    expect(recordAge).to.equal(age);
    expect(recordHeight).to.equal(height);
    expect(recordWeight).to.equal(weight);
    expect(recordAllergies).to.deep.equal(allergies);
    expect(recordVaccinationsTaken).to.deep.equal(vaccinationsTaken);
  });

  it("should share record access", async function () {
    await healthRecord.connect(owner).shareRecordAccess(healthcareProvider.address);

    const hasAccess = await healthRecord.hasAccess(owner.address, healthcareProvider.address);
    expect(hasAccess).to.be.true;
  });

  it("should revoke record access", async function () {
    await healthRecord.connect(owner).shareRecordAccess(healthcareProvider.address);

    let hasAccess = await healthRecord.hasAccess(owner.address, healthcareProvider.address);
    expect(hasAccess).to.be.true;

    await healthRecord.connect(owner).revokeRecordAccess(healthcareProvider.address);

    hasAccess = await healthRecord.hasAccess(owner.address, healthcareProvider.address);
    expect(hasAccess).to.be.false;
  });

  it("should not allow access to record without sharing", async function () {
    await expect(healthRecord.getRecord(0, healthcareProvider.address)).to.be.revertedWith("No access to record");
  });
  
  it("should not allow revoking access without sharing", async function () {
    await expect(healthRecord.connect(owner).revokeRecordAccess(healthcareProvider.address)).to.be.revertedWith("No access to revoke");
  });
});