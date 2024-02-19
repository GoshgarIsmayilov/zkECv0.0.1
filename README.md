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



# Publications to Read

1. Shafi Goldwasser, Silvio Micali, and Chales Rackoff. The knowledge complexity of interactive proof-systems. SIAM Journal on Computing, 18(1):186–208, 1989.
2. Jacob Eberhardt and Stefan Tai. Zokrates-scalable privacy-preserving off-chain computations. In IEEE International Conference on Internet of Things (iThings) and Cyber, Physical and Social Computing (CPSCom), pages 1084–1091, 2018.
3. Eli Ben-Sasson, Alessandro Chiesa, Eran Tromer, and Madars Virza. Succinct {Non-Interactive} zero knowledge for a von neumann architecture. In 23rd USENIX Security Symposium (USENIX Security 14), pages 781–796, 2014.
4. Tianyi Liu, Xiang Xie, and Yupeng Zhang. Zkcnn: Zero knowledge proofs for convolutional neural network predictions and accuracy. In Proceedings of the 2021 ACM SIGSAC Conference on Computer and Communications Security, pages 2968–2985, 2021.
5. Jason G Digalakis and Konstantinos G Margaritis. On be

# Disclaimer

This software is made available for educational purposes only.
