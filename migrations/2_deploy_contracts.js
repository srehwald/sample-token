var SampleToken = artifacts.require("./SampleToken.sol");

module.exports = function(deployer, network, accounts) {    
    if( network == "mainnet" ) {            
        // throw "Halt. Sanity check. Not ready for deployment to mainnet. Manually remove this throw and try again.";
    }
    
    deployer.deploy(SampleToken);
};