// This file is MIT Licensed.
//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a 
copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the 
Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included 
in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN 
NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE 
USE OR OTHER DEALINGS IN THE SOFTWARE.
// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;
library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() pure internal returns (G1Point memory) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() pure internal returns (G2Point memory) {
        return G2Point(
            
[10857046999023057135944570762232829481370756359578518086990519993285655852781,
             
11559732032986387107991004021392285783925812861821192530917403151452391805634],
            
[8495653923123431417604973247489272438418190587263600148770280649306958101930,
             
4082367875863433681332203403145435568316851327593401208105741076214120093531]
        );
    }
    /// @return the negation of p, i.e. p.addition(p.negate()) should be 
zero.
    function negate(G1Point memory p) pure internal returns (G1Point 
memory) {
        // The prime q in the base field F_q for G1
        uint q = 
21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    /// @return r the sum of two points of G1
    function addition(G1Point memory p1, G1Point memory p2) internal view 
returns (G1Point memory r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 6, input, 0xc0, r, 
0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
    }


    /// @return r the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all 
points p.
    function scalar_mul(G1Point memory p, uint s) internal view returns 
(G1Point memory r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 
0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require (success);
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] memory p1, G2Point[] memory p2) internal 
view returns (bool) {
        require(p1.length == p2.length);
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[1];
            input[i * 6 + 3] = p2[i].X[0];
            input[i * 6 + 4] = p2[i].Y[1];
            input[i * 6 + 5] = p2[i].Y[0];
        }
        uint[1] memory out;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), 
mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point memory a1, G2Point memory a2, G1Point 
memory b1, G2Point memory b2) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2,
            G1Point memory d1, G2Point memory d2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}

contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G1Point alpha;
        Pairing.G2Point beta;
        Pairing.G2Point gamma;
        Pairing.G2Point delta;
        Pairing.G1Point[] gamma_abc;
    }
    struct Proof {
        Pairing.G1Point a;
        Pairing.G2Point b;
        Pairing.G1Point c;
    }
    function verifyingKey() pure internal returns (VerifyingKey memory vk) 
{
        vk.alpha = 
Pairing.G1Point(uint256(0x1f3e9687e56aa81bb5694e76ffe25015ad5ce2e8cd64566c952e91e32c0ada77), 
uint256(0x20567029b1e31f1e0763dc189b329d2f387d5a16d73417f15698fcecffe60507));
        vk.beta = 
Pairing.G2Point([uint256(0x1ef78b74f6aa56bd948e4f2fed4054734b68bc327ca1d1d095f54448d8864f7f), 
uint256(0x0f81786e2b47d0437d383f795269cb373db34aa96c6854de59fcd3316ce3d882)], 
[uint256(0x27dacd3058eb1468a40c1da765680087e57b9f90d1c704205a449e0b937a888e), 
uint256(0x116acd34616234743dbc962aa80be26a3707564081f96eafac3ee5caab3e4ed3)]);
        vk.gamma = 
Pairing.G2Point([uint256(0x17bf61dc10d2f4c341924b6fa7cd7fc7b06becebcb5267b8725280009c194f9e), 
uint256(0x1197a7f18b0dff2f48ae7e3a57db9db8809ce791eceb0b13229ad8809ba8a752)], 
[uint256(0x1791928cab4dedf126ff74e696d6f6e7dd19bf423bfd0fdae9c4ab2cb503f873), 
uint256(0x2b444bd3c1b586aedb098b5f80f3cedd0e9421fd6654558a2523f59b8bbf1851)]);
        vk.delta = 
Pairing.G2Point([uint256(0x0bea98453f18544747e3474ef5049b798bd040a8211673b0e47ddb99962a0666), 
uint256(0x091550db92554885ea76f2c2fb644264d2035167d2d5b07e7b73cc1cf9c4729b)], 
[uint256(0x1eee642436403cd336558209dfc6aa16fab886951299affa3d8608657289ef93), 
uint256(0x29fc1213a751aaf2769b25e8cd98b750b6d4e17d95bda6fa04b54e70f868f80f)]);
        vk.gamma_abc = new Pairing.G1Point[](5);
        vk.gamma_abc[0] = 
Pairing.G1Point(uint256(0x2b88b2e30ab5cda9b31579bb040098d3e8841cf7b4e3a94f62000e6967c13226), 
uint256(0x188bf4d842fd85b02fa2eb0c0a2418cbaac2dde5e18e1579ff2b5626ee47e397));
        vk.gamma_abc[1] = 
Pairing.G1Point(uint256(0x013143c4000dd7c3517f05c75c99e2ba676f2c18c2c0b989c1e3f096caa93cd8), 
uint256(0x0b86852ed6402d46f2349b2a962b576fc5a90026d3e23dba1c632217b4e5cbcf));
        vk.gamma_abc[2] = 
Pairing.G1Point(uint256(0x17e0fdb54059a7a98a2987b30054362d46b3807e5f4e74904f93e28e301049b4), 
uint256(0x1cdc6cd762f20139fca70fbaf2e5220eadd4e13452d0d9fd7b673b7bc8355e24));
        vk.gamma_abc[3] = 
Pairing.G1Point(uint256(0x26b5f55f9471653663309c7a9160b935e58a4b8f329d186bcf3ee42bf4dc5673), 
uint256(0x1ca4d5d47f596e4f7b31f1606ea55013d6db7676c94914aec4016eaffc7194d0));
        vk.gamma_abc[4] = 
Pairing.G1Point(uint256(0x08c6f4bdf1beda84e9c8a87a5abacdf0530347734e3e39bd859fa7818b3f9678), 
uint256(0x2aede5d74b7185d152052e2bd738c00d0b6bf511d36bbce803f1b35fb55be3fd));
    }
    function verify(uint[] memory input, Proof memory proof) internal view 
returns (uint) {
        uint256 snark_scalar_field = 
21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.gamma_abc.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++) {
            require(input[i] < snark_scalar_field);
            vk_x = Pairing.addition(vk_x, 
Pairing.scalar_mul(vk.gamma_abc[i + 1], input[i]));
        }
        vk_x = Pairing.addition(vk_x, vk.gamma_abc[0]);
        if(!Pairing.pairingProd4(
             proof.a, proof.b,
             Pairing.negate(vk_x), vk.gamma,
             Pairing.negate(proof.c), vk.delta,
             Pairing.negate(vk.alpha), vk.beta)) return 1;
        return 0;
    }
    function verifyTx(
            Proof memory proof, uint[4] memory input
        ) public view returns (bool r) {
        uint[] memory inputValues = new uint[](4);
        
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            return true;
        } else {
            return false;
        }
    }

    function verifyTX(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c, uint[4] memory input
        ) public view returns (bool r) {
        Proof memory proof;
        proof.a = Pairing.G1Point(a[0], a[1]);
        proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.c = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](4);
        
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            return true;
        } else {
            return false;
        }
    }
}


