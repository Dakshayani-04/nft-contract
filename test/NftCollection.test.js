const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NftCollection", function () {
    let nftCollection;
    let owner, addr1, addr2, addr3;
    const TOKEN_NAME = "NFT Collection";
    const TOKEN_SYMBOL = "NFT";
    const MAX_SUPPLY = 1000;
    const BASE_URI = "https://metadata.example.com/";

    beforeEach(async function () {
        [owner, addr1, addr2, addr3] = await ethers.getSigners();
        const NftCollection = await ethers.getContractFactory("NftCollection");
        nftCollection = await NftCollection.deploy(
            TOKEN_NAME,
            TOKEN_SYMBOL,
            MAX_SUPPLY,
            BASE_URI
        );
        await nftCollection.deployed();
    });

    describe("Deployment", function () {
        it("Should have correct initial configuration", async function () {
            expect(await nftCollection.name()).to.equal(TOKEN_NAME);
            expect(await nftCollection.symbol()).to.equal(TOKEN_SYMBOL);
            expect(await nftCollection.maxSupply()).to.equal(MAX_SUPPLY);
            expect(await nftCollection.totalSupply()).to.equal(0);
        });
    });

    describe("Minting", function () {
        it("Should mint token successfully", async function () {
            await nftCollection.safeMint(addr1.address, 1);
            expect(await nftCollection.balanceOf(addr1.address)).to.equal(1);
            expect(await nftCollection.ownerOf(1)).to.equal(addr1.address);
            expect(await nftCollection.totalSupply()).to.equal(1);
        });

        it("Should emit Transfer event", async function () {
            await expect(nftCollection.safeMint(addr1.address, 1))
                .to.emit(nftCollection, "Transfer")
                .withArgs(ethers.constants.AddressZero, addr1.address, 1);
        });

        it("Should prevent double minting", async function () {
            await nftCollection.safeMint(addr1.address, 1);
            await expect(nftCollection.safeMint(addr2.address, 1)).to.be.revertedWith(
                "Token already minted"
            );
        });

        it("Should prevent minting beyond max supply", async function () {
            for (let i = 1; i <= MAX_SUPPLY; i++) {
                await nftCollection.safeMint(addr1.address, i);
            }
            await expect(nftCollection.safeMint(addr1.address, MAX_SUPPLY + 1)).to.be.revertedWith(
                "Max supply reached"
            );
        });
    });

    describe("Transfers", function () {
        beforeEach(async function () {
            await nftCollection.safeMint(addr1.address, 1);
            await nftCollection.safeMint(addr1.address, 2);
        });

        it("Should transfer token", async function () {
            await nftCollection.connect(addr1).transferFrom(addr1.address, addr2.address, 1);
            expect(await nftCollection.ownerOf(1)).to.equal(addr2.address);
            expect(await nftCollection.balanceOf(addr1.address)).to.equal(1);
            expect(await nftCollection.balanceOf(addr2.address)).to.equal(1);
        });

        it("Should revert on unauthorized transfer", async function () {
            await expect(
                nftCollection.connect(addr2).transferFrom(addr1.address, addr2.address, 1)
            ).to.be.revertedWith("Not authorized to transfer");
        });
    });

    describe("Approvals", function () {
        beforeEach(async function () {
            await nftCollection.safeMint(addr1.address, 1);
        });

        it("Should approve transfer", async function () {
            await nftCollection.connect(addr1).approve(addr2.address, 1);
            expect(await nftCollection.getApproved(1)).to.equal(addr2.address);
        });

        it("Should allow approved address to transfer", async function () {
            await nftCollection.connect(addr1).approve(addr2.address, 1);
            await nftCollection.connect(addr2).transferFrom(addr1.address, addr3.address, 1);
            expect(await nftCollection.ownerOf(1)).to.equal(addr3.address);
        });
    });

    describe("Metadata", function () {
        beforeEach(async function () {
            await nftCollection.safeMint(addr1.address, 1);
        });

        it("Should return correct tokenURI", async function () {
            const uri = await nftCollection.tokenURI(1);
            expect(uri).to.equal(BASE_URI + "1");
        });
    });
});
