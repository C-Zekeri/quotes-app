const main = async () => {
    const [owner, waver] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1")
    });
    await waveContract.deployed();

    console.log('Contract deployed to:' + waveContract.address);
    console.log('Contract deployed by:' + owner.address);

    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log("Contract Balance:", hre.ethers.utils.formatEther(contractBalance));

    let waveCount;
    const waveTxn = await waveContract.wave("This is wave #1");
    await waveTxn.wait();

    //const waveTxn2 = await waveContract.wave("This is wave #2");
    //await waveTxn2.wait();

    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log("Contract Balance:", hre.ethers.utils.formatEther(contractBalance));

    let allWaves = await waveContract.grabTheWaves();
    console.log(allWaves);
};

const  runMain = async () => {
    try{
        await main();
        process.exit(0);
    }
    catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();