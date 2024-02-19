# zkEC@0.0.1: Evolutionary Computation Meets Programmable Cryptography on Blockchain

There has been a notable increase in the intellectuality of humankind about their privacy in recent years. This naturally pushes the modern cryptography out of its boundaries to explore general-purpose programmable cryptography where a privacy-preserving arbitrary computation can be built on top of it. In this work, we address the evolutionary computation in programmable cryptography using the blockchain technologies for the first time in the literature. For this conceptualization, we propose a novel cryptographic, privacy-preserving and decentralized protocol (i.e. _zkEC@0.0.1_) where evolutionary computation model is public while the user inputs (i.e. the current population) and outputs (i.e. the next population) are fully private. The protocol relies on the transitions between the public-domain (i.e. contract-domain) and the private-domain (i.e. evolutionary-domain) to be secure. We analyze the protocol with respect to the security and computational complexity aspects. We perform an extensive experimental study using two popular benchmark problems (i.e. _Sphere_ and _Rosenbrock_ functions) to measure the blockchain gas consumption, zero-knowledge proof generation/verification times, zero-knowledge proof size and the best fitness changes over generations. Finally, we identify several promising research directions to be potentially explored in future.

# To Run

The _zkEC@0.0.1_ application needs the following steps to be completed to run:

1. Install and configure Metamask extension on browser for Ethereum Sepolia network.
2. Deploy _zkEC@0.0.1_ and verifier contracts to blockchain.
3. Run Web UI with ```node server.js``` on port 3300.
4. Open Web UI on browser with ```http://localhost:3300/```.
5. You can now register, propose evolutionary computation-based solution by generation zero-knowledge _evolution_ proof and claim rewards over Web UI.

<img src="https://github.com/GoshgarIsmayilov/zkECv0.0.1/blob/main/Auxilliary/Screenshots/design.png" width="80%"/>

# Experimental Study 

## Blockchain Gas Consumption 

| Function              | Gas Units        | Transaction Hash (https://sepolia.etherscan.io/)                    |
| --------------------- | ---------------- | ------------------------------------------------------------------- |
| (F1) Deploy Contract  | 3,332,635        | 0xe81532728b2bde0cf8767f7e06d1a1628ca5cafa07c7c2d3499f3d39217ad6e8  |
| (F1) Register         | 95,267           | 0x96809e7e43887c1e07bbcfc10ef1eff66bff47bcfc8d547e2a63f5303f50d299  |
| (F1) Propose Solution | 2,184,245        | 0xb2026147f1c797056db53d1ca6970a4c25981a4a216b8f3d6263cdd47b2a48e6  |
| (F1) Claim Reward     | 58,184           | 0x9d98c6a630309de045c97f182f02665bf59c8c2cf1fa379c3bc5c5be9bd6b234  |
| (F2) Deploy Contract  | 3,332,767        | 0xe81532728b2bde0cf8767f7e06d1a1628ca5cafa07c7c2d3499f3d39217ad6e8  |
| (F2) Register         | 95,267           | 0xcb41946eee56ee7b7eec9a20f72269218bf2abf1b75835cbe26fee66b0a7fd1e  |
| (F2) Propose Solution | 2,184,445        | 0x73b9ec8754f2ac046ecbf1da4a7d7ecb2715e2561cc3c6f0ae0d135a7c608a28  |
| (F2) Claim Reward     | 58,184           | 0x5df15e192bccd9db2bccb32645b7e5e41da6b985391d967fcc51f84fe1947cad  |

## Zero-Knowledge Proof Artifacts

| Proof Generation | Proof Verification | Constraint Size | Proving Key | Verification Key | Proof Size  |
| ---------------- | ------------------ | --------------- | ----------- | ---------------- | ----------- |
| 98,6 sec         | N/A                | 549,644         | 241.6MB     | 2KB              | 1KB         | 
| 102,2 sec        | N/A                | 553,204         | 242.8MB     | 2KB              | 1KB         | 

## Fitness Values over Generations

<img src="https://github.com/GoshgarIsmayilov/zkECv0.0.1/blob/main/Auxilliary/Screenshots/generations_f1.png" width="70%"/>

<img src="https://github.com/GoshgarIsmayilov/zkECv0.0.1/blob/main/Auxilliary/Screenshots/generations_f2.png" width="70%"/>


# Publications to Read

1. Shafi Goldwasser, Silvio Micali, and Chales Rackoff. The knowledge complexity of interactive proof-systems. SIAM Journal on Computing, 18(1):186–208, 1989.
2. Jacob Eberhardt and Stefan Tai. Zokrates-scalable privacy-preserving off-chain computations. In IEEE International Conference on Internet of Things (iThings) and Cyber, Physical and Social Computing (CPSCom), pages 1084–1091, 2018.
3. Eli Ben-Sasson, Alessandro Chiesa, Eran Tromer, and Madars Virza. Succinct {Non-Interactive} zero knowledge for a von neumann architecture. In 23rd USENIX Security Symposium (USENIX Security 14), pages 781–796, 2014.
4. Tianyi Liu, Xiang Xie, and Yupeng Zhang. Zkcnn: Zero knowledge proofs for convolutional neural network predictions and accuracy. In Proceedings of the 2021 ACM SIGSAC Conference on Computer and Communications Security, pages 2968–2985, 2021.
5. Jason G Digalakis and Konstantinos G Margaritis. On be

# Disclaimer

This software is made available for educational purposes only.
