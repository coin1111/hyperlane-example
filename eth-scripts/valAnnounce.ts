//query Validatorannounce contract to get the announced validators and their storage locations
import { ethers } from 'ethers';
import {validatorAnnounceAbi} from './validatorAnnounceAbi.ts'; 

const validatoAnnounceAddress = "0xE613Fa04ddadB791fD5320aB8D20B4f1635f85cA" ;


async function main() {
  const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545"); // Anvil's default RPC URL
  const contract = new ethers.Contract(
    validatoAnnounceAddress, // Use the address from the artifact
    validatorAnnounceAbi,
    await provider.getSigner() // Get a signer from Anvil
  );


  // Querying the Contract
  const announceData = await contract.getAnnouncedValidators(); 
  console.log(announceData[0]);  

  const announceStorageData = await contract.getAnnouncedStorageLocations([announceData[0]]); 
  console.log(announceStorageData);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

