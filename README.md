# zkEC@0.0.1: Evolutionary Computation Meets Programmable Cryptography on Blockchain

There has been a notable increase in the intellectuality of humankind about their privacy in recent years. This naturally pushes the modern cryptography out of its boundaries to explore general-purpose programmable cryptography where a privacy-preserving arbitrary computation can be built on top of it. In this work, we address the evolutionary computation in programmable cryptography using the blockchain technologies for the first time in the literature. For this conceptualization, we propose a novel cryptographic, privacy-preserving and decentralized protocol (i.e. _zkEC@0.0.1_) where evolutionary computation model is public while the user inputs (i.e. the current population) and outputs (i.e. the next population) are fully private. The protocol relies on the transitions between the public-domain (i.e. contract-domain) and the private-domain (i.e. evolutionary-domain) to be secure. We analyze the protocol with respect to the security and computational complexity aspects. We perform an extensive experimental study using two popular benchmark problems (i.e. _Sphere_ and _Rosenbrock_ functions) to measure the blockchain gas consumption, zero-knowledge proof generation/verification times, zero-knowledge proof size and the best fitness changes over generations. Finally, we identify several promising research directions to be potentially explored in future.

<img src="https://github.com/GoshgarIsmayilov/zkECv0.0.1/blob/main/Auxilliary/Screenshots/types.png" width="40%"/>

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

<img src="https://github.com/GoshgarIsmayilov/zkECv0.0.1/blob/main/Auxilliary/Screenshots/generations_f1.png" width="60%"/>

<img src="https://github.com/GoshgarIsmayilov/zkECv0.0.1/blob/main/Auxilliary/Screenshots/generations_f2.png" width="60%"/>

# Some Maths

The evolutionary computation in programmable cryptography is based on the transformation of computational power of a group of solvers $\{ u_0, u_1, ..., u_i, ..., u_{N-1} \} \in U$ into the population evolution where $N$ is the arbitrary number of total solvers. Each solver $u_i$ needs to maintain an independent population $P_i$ consisting of a set of vectors $\{ v_{i0}, v_{i1}, ..., v_{ij}, ..., u_{iM-1} \} \in P_i$ where $M$ is the arbitrary number of total vectors in that population. Lastly, each vector (i.e. solution) is a string of binary decision variables $v_{ij} = b_{ij0} b_{ij1} ... b_{ijk} ... b_{ijL-1}$ where $L$ is the arbitrary length of that vector and $b_{ijk} \in \{ 0, 1 \}$.

The Evolutionary Computation Model (i.e. _ECM_) is a privacy-preserving nonlinear function that transforms the given private input population into the private output population through applying an ordered set of evolutionary operators over the vectors available, $ECM: P^t_i \to P_i^{t+1}$ where $t$ denotes the generation (i.e. notion of time in evolutionary computation). The iterative composition property of the _ECM_ function can be also shown as $ECM^y_x = ECM^y_{y-1}(ECM^{y-1}_{y-2}(...(ECM^{x+1}_x))) : P^x_i \to P^{y}_i$ where $x$ is the starting generation while $y$ is the final generation. The evaluation function of the optimization problem maps the given population to the best fitness value of the vectors available in that population, $F: P^t_i \to f^t_i$. The goal of our work is to define such an _ECM_ that the evaluation function $F$ can select the best fitness value (e.g. for a minimization problem) at each generation by considering the populations from all the solvers with the following way:

$$
\begin{align}
& f^t_{best} = min(F(ECM^t_0(P_0)), F(ECM^t_0(P_1)), ..., F(ECM^t_0(P_{N-1})))
\end{align}
$$

where $f^t_{best}$ denotes the best fitness value of the generation $t \in [ 0, |G| )$ where the $|G|$ is the maximum number of generations. Note that the common notations and symbols used throughout our work are given in Table 1. 

Each solver represents the population as the commitment of the commitments with the following way:

$$
\begin{align}
c_i^j & \leftarrow Comm([v_{i0} \odot v_{i1} \odot \dots \odot v_{i{M-1}}]) \\
c_t^{P_i} & \leftarrow Comm([c_i^{0} \odot c^{1}_i \odot \dots \odot c_i^{M-1}]) 
\end{align}
$$

where $c^{j}_i$ is the commitment value of the vector $j$ of the solver $i$ based on the decision variables $v$ while $c^{P_i}_t$ is the commitment value of the population $P^{t}_i$ of the solver $i$ at the time $t$ based on the commitments of the vectors $c^{j}_i$. Note that $\odot$ is the binary concatenation operation while $Comm$ is the commitment function.

<img src="https://github.com/GoshgarIsmayilov/zkECv0.0.1/blob/main/Auxilliary/Screenshots/hashes.png" width="60%"/>

Each solver iterates the private population through the public evolutionary computation model by generating the zero-knowledge proof to validate that off-chain computation as follows:

$$
\begin{align}
\pi[A, B, C] \leftarrow ZkGen( & P_i^{t+1} \leftarrow P_i^{t}, \\
& [c_{t+1}^{P_i}, c_t^{P_i},  F(P_i^{t+1}), pk]) 
\end{align}
$$

where the population $P_i^{t+1}$ is evolved from the population $P_i^{t}$. The proof generation needs the private values including these populations and the public values including their commitments $c_{t+1}^{P_i}$ and $c_{t+1}^{P_i}$ the evaluation function $F$ and the proving key $pk$. The $\pi[A, B, C]$ represents the generated proof $\pi$ with its three elliptic curve point components as $A, B, C$ while $ZkGen$ is the zero-knowledge proof generation function. Afterward, the smart contract verifies the proofs on-chain by fetching only the public values as follows:

$$
\begin{align}
b \leftarrow ZkVfy(& \pi[A, B, C], \nonumber \\ 
& [c^{P_i}_{t+1}, c^{P_i}_t,  F(P^{t+1}_i), vk])
\end{align}
$$

where $vk$ is the verification key, $ZkVfy$ is the zero-knowledge proof verification function while $b$ is the binary resulting output where zero represents failure while one represents success. 

__Theorem__. The _zkEC@0.0.1_ protocol is secure, provided that the underlying zk-SNARK protocol is secure.

__Proof__. Let $\mathcal{A}$ and $\mathcal{B}$ be adversaries (i.e. provers) that can break _zkEC@0.0.1_ and zk-SNARK, respectively. According to the scenario between the adversary $\mathcal{A}$ and the challenger (i.e. verifier) $\mathcal{C}$:

- The challenger $\mathcal{C}$ runs the trusted setup to generate the proving $pk$ and verification $vk$ keys.

- The adversary $\mathcal{A}$ samples a random population $P_t^A$ and later forwards its commitment $c_{t}^{P_{A}} \leftarrow Comm (P_t^{A})$ to the challenger $\mathcal{C}$. 

- The adversary $\mathcal{A}$ performs _ECM_ over the population $P_t^{A}$ for one generation $P_{t+1}^{A} \leftarrow ECM_t^{t+1} (P_t^A)$ and forwards its commitment $c_{t+1}^{P_A} \leftarrow Comm(P_{t+1}^{A})$ to the challenger $\mathcal{C}$. 

- The adversary $\mathcal{A}$ invokes the adversary $\mathcal{B}$ to forward the forged proof with the incorrect commitment $c_{t+1}^{P_A^{'}} \neq c_{t+1}^{P_A}$ as $\pi'[A, B, C] \leftarrow ZkGen(P_i^{t+1} \leftarrow P_i^{t}, [c_{t+1}^{P_A^{'}}, c_t^{P_A},  F(P_A^{t+1}), pk])$ to the challenger $\mathcal{C}$. 

- The challenger $\mathcal{C}$ returns $1$ if the forged proof is correctly verified $b \leftarrow ZkVfy(\pi'[A, B, C], [c^{P_i}_{t+1}, c^{P_i}_t,  F(P^{t+1}_i), vk])$ and $0$ otherwise.

The challenger $\mathcal{C}$ would return $1$ in case there was the adversary $\mathcal{B}$ to be able to the forge that proof. However, this fundamentally contradicts the security assumption of zk-SNARK. More concisely: 

$$
\begin{align}
F_1(x_0, x_1, ..., x_{V-1}) = \sum_{i=0}^{V-1} x^2_i = x^2_0 + x^2_1 + ... + x^2_{V-1}
\end{align}
$$

where $\lambda$ is the security parameter and $\pi'$ is the forged proof. According to the given equation, the challenger (i.e. verifier) $\mathcal{C}$ should not correctly verify the forged proof with the given incorrect population commitments as long as there is no adversary to be able to break zk-SNARK.

The _Sphere_ function is unimodal with single global minimum, convex and symmetric as follows:

$$
\begin{align}
F_1(x_0, x_1, ..., x_{V-1}) = \sum_{i=0}^{V-1} x^2_i = x^2_0 + x^2_1 + ... + x^2_{V-1}
\end{align}
$$

\noindent
where $V$ is the vector size and $x_i \in \{0, 1\}$ is the decision variable. The global minimum of the function is located at $(x_0, x_1, ..., x_{V-1}) = (0, 0, ..., 0)$.

The _Rosenbrock_ function is defined as follows:

$$
\begin{align}
F_2(x_0, x_1, ..., x_{V-1}) = \sum_{i=0}^{V-2} \left[ 100 \cdot (x_{i+1} - x_{i})^2 + (1 - x_{i})^2 \right]
\end{align}
$$

\noindent
where $x_i \in \{0, 1\}$ is again the decision variable. The global minimum of the function lies in $(x_0, x_1, ..., x_{V-1}) = (1, 1, ..., 1)$. 

# Web UI Visualization


# Publications to Read

1. Shafi Goldwasser, Silvio Micali, and Chales Rackoff. The knowledge complexity of interactive proof-systems. SIAM Journal on Computing, 18(1):186–208, 1989.
2. Jacob Eberhardt and Stefan Tai. Zokrates-scalable privacy-preserving off-chain computations. In IEEE International Conference on Internet of Things (iThings) and Cyber, Physical and Social Computing (CPSCom), pages 1084–1091, 2018.
3. Eli Ben-Sasson, Alessandro Chiesa, Eran Tromer, and Madars Virza. Succinct {Non-Interactive} zero knowledge for a von neumann architecture. In 23rd USENIX Security Symposium (USENIX Security 14), pages 781–796, 2014.
4. Tianyi Liu, Xiang Xie, and Yupeng Zhang. Zkcnn: Zero knowledge proofs for convolutional neural network predictions and accuracy. In Proceedings of the 2021 ACM SIGSAC Conference on Computer and Communications Security, pages 2968–2985, 2021.
5. Jason G Digalakis and Konstantinos G Margaritis. On be

# Disclaimer

This software is made available for educational purposes only.
