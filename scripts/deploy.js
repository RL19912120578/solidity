async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const SimpleJack = await ethers.getContractFactory("SimpleJack");
  console.log(SimpleJack.deploy());

  const simpleJack = await SimpleJack.deploy();
  console.log("SimpleJack deployed to:", simpleJack.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });