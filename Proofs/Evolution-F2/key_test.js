const fs = require('fs');

async function generate_sender_proof(population, candidates, cutoffs, flips, commitment, next_commitment, best_fitness){
    let { initialize } = await import("zokrates-js");

    initialize().then((zokratesProvider) => {
        const source = 'import "hashes/sha256/512bit" as sha256;\n\
                        import "utils/casts/u32_to_field" as toField;\n\
                        const u32 VECTOR_SIZE = 16;\n\
                        const u32 POPULATION_SIZE = 8;\n\
                        const u32 TOURNAMENT_SIZE = 2;\n\
                        def calculate_commitments(u32[POPULATION_SIZE][VECTOR_SIZE] population) -> field {\n\
                            u32[8] comm0 = sha256(population[0][0..8], population[0][8..16]);\n\
                            u32[8] comm1 = sha256(population[1][0..8], population[1][8..16]);\n\
                            u32[8] comm2 = sha256(population[2][0..8], population[2][8..16]);\n\
                            u32[8] comm3 = sha256(population[3][0..8], population[3][8..16]);\n\
                            u32[8] comm4 = sha256(population[4][0..8], population[4][8..16]);\n\
                            u32[8] comm5 = sha256(population[5][0..8], population[5][8..16]);\n\
                            u32[8] comm6 = sha256(population[6][0..8], population[6][8..16]);\n\
                            u32[8] comm7 = sha256(population[7][0..8], population[7][8..16]);\n\
                            return toField(comm0[0] + comm1[0] + comm2[0] + comm3[0] + comm4[0] + comm5[0] + comm6[0] + comm7[0]);\n\
                        }\n\
                        def evaluate_F2(u32[POPULATION_SIZE][VECTOR_SIZE] population) -> u32[POPULATION_SIZE] {\n\
                            u32[POPULATION_SIZE] mut fitness_values = [0; POPULATION_SIZE];\n\
                            for u32 i in 0..POPULATION_SIZE {\n\
                                u32 mut fitness_value = 0;\n\
                                for u32 j in 0..VECTOR_SIZE-1 {\n\
                                    fitness_value = fitness_value + 100 * (population[i][j+1] - population[i][j] * population[i][j]) * (population[i][j+1] - population[i][j] * population[i][j]);\n\
                                    fitness_value = fitness_value + (1 - population[i][j]) * (1 - population[i][j]);\n\
                                }\n\
                                fitness_values[i] = fitness_value;\n\
                            }\n\
                            return fitness_values;\n\
                        }\n\
                        def select_parents(u32[POPULATION_SIZE][VECTOR_SIZE] population, u32[POPULATION_SIZE] fitnesses, u32[POPULATION_SIZE][TOURNAMENT_SIZE] candidates) -> u32[POPULATION_SIZE][VECTOR_SIZE] {\n\
                            u32[POPULATION_SIZE][VECTOR_SIZE] mut parents = [[0; VECTOR_SIZE]; POPULATION_SIZE];\n\
                            for u32 i in 0..POPULATION_SIZE {\n\
                                u32 mut best_fitness = 4294967295;\n\
                                u32 mut best_fitness_index = 0;\n\
                                for u32 j in 0..TOURNAMENT_SIZE {\n\
                                    best_fitness_index = if fitnesses[candidates[i][j]] < best_fitness { j } else { best_fitness_index };\n\
                                    best_fitness = if fitnesses[candidates[i][j]] < best_fitness { fitnesses[candidates[i][j]] } else { best_fitness };\n\
                                }\n\
                                for u32 j in 0..VECTOR_SIZE {\n\
                                    parents[i][j] = population[candidates[i][best_fitness_index]][j];\n\
                                }\n\
                            }\n\
                            return parents;\n\
                        }\n\
                        def apply_crossover(u32[POPULATION_SIZE][VECTOR_SIZE] parents, u32[POPULATION_SIZE] cutoffs) -> u32[POPULATION_SIZE][VECTOR_SIZE] {\n\
                            u32[POPULATION_SIZE][VECTOR_SIZE] mut children = [[0; VECTOR_SIZE]; POPULATION_SIZE];\n\
                            for u32 i in 0..POPULATION_SIZE/2 {\n\
                                for u32 j in 0..VECTOR_SIZE {\n\
                                    children[2*i][j] = if j <= cutoffs[i] { parents[2*i][j] } else { parents[2*i+1][j] };\n\
                                    children[2*i+1][j] = if j <= cutoffs[i] { parents[2*i+1][j] } else { parents[2*i][j] };\n\
                                }\n\
                            }\n\
                            return children;\n\
                        }\n\
                        def apply_mutation(u32[POPULATION_SIZE][VECTOR_SIZE] children, u32[POPULATION_SIZE] flips) -> u32[POPULATION_SIZE][VECTOR_SIZE] {\n\
                            u32[POPULATION_SIZE][VECTOR_SIZE] mut next_population = [[0; VECTOR_SIZE]; POPULATION_SIZE];\n\
                            for u32 i in 0..POPULATION_SIZE {\n\
                                for u32 j in 0..VECTOR_SIZE {\n\
                                    next_population[i][j] = if (j == flips[i]) { 1 - children[i][j] } else { children[i][j] };\n\
                                }\n\
                            }\n\
                            return next_population;\n\
                        }\n\
                        def measure(u32[POPULATION_SIZE] next_fitness_values) -> field {\n\
                            u32 mut best_fitness = 4294967295;\n\
                            for u32 i in 0..POPULATION_SIZE {\n\
                                best_fitness = if next_fitness_values[i] < best_fitness { next_fitness_values[i] } else { best_fitness };\n\
                            }\n\
                            return toField(best_fitness);\n\
                        }\n\
                        def main(private u32[POPULATION_SIZE][VECTOR_SIZE] population, private u32[POPULATION_SIZE][TOURNAMENT_SIZE] candidates, private u32[POPULATION_SIZE] cutoffs, private u32[POPULATION_SIZE] flips, public field commitment, public field next_commitment, public field next_fitness) -> field {\n\
                            u32[POPULATION_SIZE] fitness_values = evaluate_F2(population);\n\
                            u32[POPULATION_SIZE][VECTOR_SIZE] parents = select_parents(population, fitness_values, candidates);\n\
                            u32[POPULATION_SIZE][VECTOR_SIZE] children = apply_crossover(parents, cutoffs);\n\
                            u32[POPULATION_SIZE][VECTOR_SIZE] next_population = apply_mutation(children, flips);\n\
                            u32[POPULATION_SIZE] next_fitness_values = evaluate_F2(next_population);\n\
                            field best_fitness_value = measure(next_fitness_values);\n\
                            field population_commitment = calculate_commitments(population);\n\
                            field next_population_commitment = calculate_commitments(next_population);\n\
                            field is_correct = if (best_fitness_value == next_fitness && population_commitment == commitment && next_population_commitment == next_commitment) { 1 } else { 0 };\n\
                            return is_correct;\n\
                        }'
                        
        const artifacts = zokratesProvider.compile(source);
    
        const { witness, output } = zokratesProvider.computeWitness(artifacts, [population, candidates, cutoffs, flips, commitment, next_commitment, best_fitness]);

        console.log(output);

        //var pkStr = "";

        // const pkRestored = new Uint8Array(Buffer.from(pkStr, 'base64')); 
        
        const keypair = zokratesProvider.setup(artifacts.program);
    
        const proof = zokratesProvider.generateProof(artifacts.program, witness, keypair.pk);

        console.log(proof.proof.a);
        console.log(proof.proof.b);
        console.log(proof.proof.c); 
        console.log(proof.inputs);
    
        const verifier = zokratesProvider.exportSolidityVerifier(keypair.vk);
        const isVerified = zokratesProvider.verify(keypair.vk, proof);

        var pkStr = Buffer.from(keypair.pk).toString('base64');
        console.log(pkStr);
        console.log(keypair.vk);
        console.log(verifier); 
    });
} 

population = [["1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"], 
              ["1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"], 
              ["1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"], 
              ["1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"], 
              ["1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"], 
              ["1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"], 
              ["1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"], 
              ["1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]]

candidates = [["1", "4"],
              ["7", "0"],
              ["1", "0"],
              ["4", "7"],
              ["5", "6"],
              ["5", "3"],
              ["1", "2"],
              ["5", "7"]] 

cutoffs = ["12", "3", "12", "3", "9", "13", "6", "3"]

flips = ["0", "0", "0", "0", "0", "0", "0", "0"]

commitment = "4074900648"
next_commitment = "3535062512"

best_fitness = "15";

generate_sender_proof(population, candidates, cutoffs, flips, commitment, next_commitment, best_fitness);  
