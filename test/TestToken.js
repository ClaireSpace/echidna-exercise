const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe("Exe4 test case",function(){
    async function loadFixture(){
    const [owner, account1,account2] = await ethers.getSigners();

    const myToken = await ethers.getContractFactory("MyToken");
    const mt = await myToken.deploy();
    return [mt, owner, account1,account2];

    }

    it("transfer 1 token",async function(){
        const [mt, owner, account1,account2] = await loadFixture();
        mt.connect(account1).transfer(account2,1);
        await expect (mt.connect(account1).transfer(account2,1)).to.be.rejected;
        console.log( await mt.balanceOf(account2.address));
        console.log( await mt.balanceOf(account1.address));
        // assert.equal(await mt.balanceOf(account2.address),1);
        // assert.equal(await mt.balanceOf(account1.address),-1);
    });

})