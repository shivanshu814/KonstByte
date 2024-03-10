/** @format */

require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-ethers');
const fs = require('fs');
// const infuraId = fs.readFileSync(".infuraid").toString().trim() || "";

task('accounts', 'Prints the list of accounts', async (taskArgs, hre) => {
	const accounts = await hre.ethers.getSigners();

	for (const account of accounts) {
		console.log(account.address);
	}
});

module.exports = {
	defaultNetwork: 'hardhat',
	networks: {
		hardhat: {
			chainId: 1337,
		},
		goerli: {
			url: 'https://eth-mainnet.g.alchemy.com/v2/moZdFZ0Mx28-zynoNtz2NY0uAezAVlmJ',
			accounts: [
				'74a9667408d44a07893a93e39eb4039c7698211630628c33e949f440364545da',
			],
		},
	},
	solidity: {
		version: '0.8.4',
		settings: {
			optimizer: {
				enabled: true,
				runs: 200,
			},
		},
	},
};
