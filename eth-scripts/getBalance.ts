// get LTK token balance on both chains
import { ethers } from "ethers";
import * as fs from "fs";

const ltkTokenAddress = "0xA9456C391C1930Fc50af92C7C44b45CF6066C1B4";
// see ~/.hyperlane/deployments/warp_routes/LTK/anvil8545-anvil8546-config.yaml
const addressOrDenom = "0xdB611018BB4aeC6Cc513f9962c8977fe4E235160";

async function getBalance(port: number, tokenAddress) {
  const ltkAbi = JSON.parse(
    fs.readFileSync("./warp-token/ltkAbi.json", "utf-8")
  );
  const provider = new ethers.JsonRpcProvider(`http://127.0.0.1:${port}`); // Anvil's default RPC URL
  const contract = new ethers.Contract(
    tokenAddress, // Use the address from the artifact
    ltkAbi,
    await provider.getSigner() // Get a signer from Anvil
  );

  // Querying the Contract
  return await contract.balanceOf("0xd0A8b649C848917C035d7aF0267c1bBE964B9f88");
}

async function main() {
  const balanceData1 = await getBalance(8545, ltkTokenAddress);
  console.log(`Balance on 8545: ${balanceData1}`);

  const balanceData2 = await getBalance(8546, addressOrDenom);
  console.log(`Balance on 8546: ${balanceData2}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
