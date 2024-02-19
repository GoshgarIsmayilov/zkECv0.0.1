const fs = require('fs');

async function generate_sender_proof(population){
    let { initialize } = await import("zokrates-js");

    initialize().then((zokratesProvider) => {
        const source = 'import "hashes/sha256/512bit" as sha256;\n\
                        import "utils/casts/u32_to_field" as toField;\n\
                        const u32 VECTOR_SIZE = 16;\n\
                        const u32 POPULATION_SIZE = 8;\n\
                        const u32 TOURNAMENT_SIZE = 2;\n\
                        def main(u32[POPULATION_SIZE][VECTOR_SIZE] population) -> field {\n\
                            u32[8] comm0 = sha256(population[0][0..8], population[0][8..16]);\n\
                            u32[8] comm1 = sha256(population[1][0..8], population[1][8..16]);\n\
                            u32[8] comm2 = sha256(population[2][0..8], population[2][8..16]);\n\
                            u32[8] comm3 = sha256(population[3][0..8], population[3][8..16]);\n\
                            u32[8] comm4 = sha256(population[4][0..8], population[4][8..16]);\n\
                            u32[8] comm5 = sha256(population[5][0..8], population[5][8..16]);\n\
                            u32[8] comm6 = sha256(population[6][0..8], population[6][8..16]);\n\
                            u32[8] comm7 = sha256(population[7][0..8], population[7][8..16]);\n\
                            return toField(comm0[0] + comm1[0] + comm2[0] + comm3[0] + comm4[0] + comm5[0] + comm6[0] + comm7[0]);\n\
                        }'

        const artifacts = zokratesProvider.compile(source);
    
        const { witness, output } = zokratesProvider.computeWitness(artifacts, [population]);

        console.log(output);
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


generate_sender_proof(population)  



