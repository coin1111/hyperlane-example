import { ethers } from 'ethers';
//import { chainMetadata } from '@hyperlane-xyz/registry'; // Get metadata for Hyperlane chains
//import { MultiProvider } from '@hyperlane-xyz/sdk'; // Utilities to interact with multiple chains
import {validatorAnnounceAbi} from './validatorAnnounceAbi.ts'; 

const validatoAnnounceAddress = "0xE613Fa04ddadB791fD5320aB8D20B4f1635f85cA" ;


async function main() {
  const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545"); // Anvil's default RPC URL
  const contract = new ethers.Contract(
    validatoAnnounceAddress, // Use the address from the artifact
    validatorAnnounceAbi,
    await provider.getSigner() // Get a signer from Anvil
  );

  console.log(contract);


  // Querying the Contract
  const announceData = await contract.getAnnouncedValidators(); 
  console.log(announceData[0]);  

  const announceStorageData = await contract.getAnnouncedStorageLocations([announceData[0]]); 
  console.log(announceStorageData);

  //  const [
  //       validatorPublicKey, 
  //       signature, 
  //       owner,
  //       messageNonce
  //   ] = announceData;

  //   console.log("Validator Announcement Data for", validatorAddress);
  //   console.log("-------------------------------------------");
  //   console.log("Validator Public Key:", validatorPublicKey);
  //   console.log("Signature:", signature);
  //   console.log("Owner:", owner);
  //   console.log("Message Nonce:", messageNonce.toNumber()); // Assuming messageNonce is a BigNumber
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

