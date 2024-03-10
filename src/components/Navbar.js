/** @format */

import logo from '../logo_3.png';
import fullLogo from '../full_logo.png';
import {
	BrowserRouter as Router,
	Switch,
	Route,
	Link,
	useRouteMatch,
	useParams,
} from 'react-router-dom';
import { useEffect, useState } from 'react';
import { useLocation } from 'react-router';

function Navbar() {
	const [connected, toggleConnect] = useState(false);
	const location = useLocation();
	const [currAddress, updateAddress] = useState('0x');

	return (
		<div className=''>
			<nav className='w-screen'>
				<ul className='flex items-end justify-between py-3 pr-5 text-white bg-transparent'>
					<li className='flex items-end pb-2 ml-5'>
						<Link to='/'>
							{/* <img src={fullLogo} alt="" width={120} height={120} className="inline-block -mt-2"/> */}
							<div className='inline-block ml-2 text-xl font-bold'>
								Varun NFT Marketplace
							</div>
						</Link>
					</li>
					<li className='w-2/6'>
						<ul className='justify-between mr-10 text-lg font-bold lg:flex'>
							{location.pathname === '/' ? (
								<li className='p-2 border-b-2 hover:pb-0'>
									<Link to='/'>Marketplace</Link>
								</li>
							) : (
								<li className='p-2 hover:border-b-2 hover:pb-0'>
									<Link to='/'>Marketplace</Link>
								</li>
							)}
							{location.pathname === '/sellNFT' ? (
								<li className='p-2 border-b-2 hover:pb-0'>
									<Link to='/sellNFT'>List My NFT</Link>
								</li>
							) : (
								<li className='p-2 hover:border-b-2 hover:pb-0'>
									<Link to='/sellNFT'>List My NFT</Link>
								</li>
							)}
							{location.pathname === '/profile' ? (
								<li className='p-2 border-b-2 hover:pb-0'>
									<Link to='/profile'>Profile</Link>
								</li>
							) : (
								<li className='p-2 hover:border-b-2 hover:pb-0'>
									<Link to='/profile'>Profile</Link>
								</li>
							)}
							<li>
								<button className='px-4 py-2 text-sm font-bold text-white bg-blue-500 rounded enableEthereumButton hover:bg-blue-700'>
									{connected ? 'Connected' : 'Connect Wallet'}
								</button>
							</li>
						</ul>
					</li>
				</ul>
			</nav>
			<div className='mr-10 text-sm text-right text-white text-bold'>
				{currAddress !== '0x'
					? 'Connected to'
					: 'Not Connected. Please login to view NFTs'}{' '}
				{currAddress !== '0x' ? currAddress.substring(0, 15) + '...' : ''}
			</div>
		</div>
	);
}

export default Navbar;
