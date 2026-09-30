\# Day 9 — NFT Marketplace



A simple non-custodial NFT marketplace built and tested on Base Mainnet.



\## Contracts



\### Papa721NFT.sol



ERC-721 NFT contract used to test the marketplace.



Features:

\- ERC-721 standard

\- Owner-only minting

\- Sequential token IDs

\- OpenZeppelin implementation



\### PapaMarketplace.sol



Non-custodial marketplace for ERC-721 NFTs.



Features:

\- List NFT for sale

\- Update listing price

\- Cancel listing

\- Buy NFT with ETH

\- 2.5% marketplace fee

\- Withdraw collected fees

\- Reentrancy protection

\- Ownership and approval validation

\- Marketplace events



\## Marketplace Flow



1\. Mint NFT

2\. Approve Marketplace

3\. List NFT

4\. Update price

5\. Cancel listing

6\. Re-list NFT

7\. Buy NFT from another wallet

8\. Transfer NFT to buyer

9\. Pay seller

10\. Keep marketplace fee

11\. Withdraw marketplace fees



\## Base Mainnet



Papa721NFT:



`0x28cFc025993d77fcfbc1cd92BF37F13148869BE5`



PapaMarketplace:



`0x81c56C758dE3a9F8df90a12A18f2a8A20153c021`



\## Test Result



Full marketplace lifecycle successfully tested on Base Mainnet.



\- NFT minted successfully

\- Marketplace approval confirmed

\- Listing created

\- Listing price updated

\- Listing cancelled

\- NFT re-listed

\- NFT purchased from a second wallet

\- NFT ownership transferred to buyer

\- Listing removed after purchase

\- 2.5% marketplace fee collected

\- Marketplace fees withdrawn successfully

