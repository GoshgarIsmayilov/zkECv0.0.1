import zokrates_hash from './zokrates-hash';
import zokrates_evolution_proof_f2 from './zokrates-evolution-f2';

window.zokrates_hash = async function(population){
    return await zokrates_hash(population);
}

window.zokrates_evolution_proof_f2 = async function(population, candidates, cutoffs, flips, commitment, next_commitment, next_fitness){
    return await zokrates_evolution_proof_f2(population, candidates, cutoffs, flips, commitment, next_commitment, next_fitness);
}