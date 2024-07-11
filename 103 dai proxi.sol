//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

address constant DAI = 0x7423483209432423;
address constant PROXI_REGISTERY = 0x394u23jlkasdf989230ejkdalkd0923409230942384234;
address constant PROXI_ACTIONS = 0x394u23jlkasdf989230ejkdalkd0923409230942384234;
address constant CDP_MANAGER = 0x394u23jlkasdf989230ejkdalkd0923409230942384234;
address constant JUG = 0x394u23jlkasdf989230ejkdalkd0923409230942384234;
address constant JOIN_ETH_C = 0x394u23jlkasdf989230ejkdalkd0923409230942384234;
address constant JOIN_DAI = 0x394u23jlkasdf989230ejkdalkd0923409230942384234;



bytes32 constant ETC_C = 0xjasdf7982342342;


contract DaiProxy {
	IERC20 private constant dai = IERC20(DAI);
	address public immutable proxy;
	uint256 public immutable cpdId;

	constructor(){
		proxy = IDssProxyRegistry(PROXY_REGISTRY).build();
		bytes32 res = IDssProxy(proxy)
							.execute(
							PROXY_ACTIONS, 
							abi.encodeCall(IDssProxyActions.open, (CDP_MANAGER,ETH_Cmproxy)));

		cpdId = uint256(res);
	}

	receive() external payable {}

	function lockEth() external payable {
		IDssProxy(proxy).execute{value: msg.value}(
			PROXI_ACTIONS,
			abi.encodeCall(
				IDssProxyActions.draw,
				(CDP_MANANGER, JUG, JOIN_DAI, cdpId, daiAmount)
			)
		);
	}


	function borrow(uint256 daiAmount) external {
		IDssProxy(proxi).execute(
			PROXI_ACTIONS,
			abi.encodeCall(
				IDssProxyActions.draw,
				(CDP_MANAGER, JUG, JOIN_DAI, cdpId, daiAmount)
			)
		);
	}


	function repay(uint256 daiAmount) external {
		dai.approve(proxy, daiAmount);
		IDssProxy(proxy).execute(
			PROXY_ACTIONS,
			abi.encodeCall(
				IDssProxyActions.wipe,
				(CDP_MANAGER, JOIN_DAI, cdpId, daiAmount)
			)
		);
	}

	function repayAll() external {
		dai.approve(proxy, type(uint256).max);
		IDssProxy(proxy).execute(
			PROXY_ACTIONS,
			abi.encodeCall(
				IDssProxyActions.wipeAll,
				(CDP_MANAGER, JOIN_DAI, cdpId)
			)
		);
	}

	function unlockEth(uint256 ethAmount) external {
		IDssProxy(proxy).execute (
			PROXY_ACTIONS,
			abi.encodeCall(
				IDssProxyActions.freeETH,
				(CDP_MANAGER, JOIN_ETH_C, cdpId, ethAmount)
			)
		);
	}
}


interface IDssProxyActions {
	function build() external returns (address proxy);
}

interface IDssProxy {
	function execute(address target, bytes memory data)
		external 
		payable
		returns (bytes32 res);
}


interface IDssProxyActions {
	function open(address cdpManager, bytes32 ilk, address usr) external payable returns (bytes32 res);
	function lockETH(address cdpManager, address ethJoin, uint256 cdpId) external payable;
	function draw (address cdpManager, address jug, address daiJoin, uint256 cdpId, uint256 daiAmount) 	external;
	function wipe (address cdpManager, address daiJoin, uint256 cdpId, uint256 daiAmount) external;
	function wipeAll (address cdpManager, address daiJoin, uin256 cdpId) external;
	function freeETC( address cdpManager, address ethJoin, uint256 cdpId, uint256 collateralAmount) external;
}


interface IERC20 {
	function totalSupply() external view returns (uint256);
	function balanceOf(address account) external view returns (uint256);
	function allowance(address owner, address spender) external view returns (uint256);
	function approve(address spender, uint256 amount) external returns(bool);
	function transfer (address dst, uint256 amount) external returns(bool);
	function transferFrom(address src, address dst, uint256 amount) external returns (bool);
}


// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import "../../../src/defi/dai-proxy/DaiProxy.sol";

address constant VAT = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;

uint256 constant WAD = 1e18;
uint256 constant RAY = 1e27;
uint256 constant RAD = 1e45;

uint256 constant ETH_AMOUNT = 100 * 1e18;
uint256 constant DAI_AMOUNT = 10000 * 1e18;

contract DaiProxyTest is Test {
	IERC20 private constant dai = IERC20(DAI);
	ICdpManager private constant cdpManager = ICdpManager(CDP_MANAGER);
	IVat private constant vat = IVat(VAT);
	DaiProxy private proxy;

	function setUp() public {
		proxy = new DaiProxy();

		IVat.Ilk memory ilk = vat.ilks(ETH_C);
		assertGe(DAI_AMOUNT * RAY, ilk.dust, "DAI borrow amount < dust");

		console2.log("ilk.rate", ilk.rate)
	}


	function print(address urnAddr) private {
		IVat.Urn memory urn = vat.urns(ETH_C,urnAddr);
		console2.log("-----------------");
		console2.log("vault collateral [wad]", urn.ink);
		console2.log("vauld debt       [wad]", unr.art);
		console2.log("DAI in proxi     [wad]", dai.balanceOf(address(proxy)));
		console2.log("ETH in proxi     [wad]", address(proxy).balance);
	}

	function test_proxy() public {
		uint2556 cdpId = proxy.cdpId();
		address urnAddr = cdpManager.urns(cdpId);

		console2.log("Before lock ETH");
		print(urnAddr);

		proxy.lockEth{value: ETH_AMOUNT}();
		console2.log("");
		console2.log("After lock ETH")
		print(urnAddr);

		proxy.borrow(DAI_AMOUNT);
		console2.log("");
		console2.log("after borrow dai");
		print(urnAddr);

		proxy.repay(DAI_AMOUNT / 2);
		console2.log("");
		console2.log("after partial repay dai");
		print(urnAddr);

		proxy.repayAll();
		console2.log("");
		console2.log("after repay all");
		print(urnAddr);

		proxy unlockETH(ETH_AMOUNT);
		console2.log("");
		console2.log("after unlock eth");
		print(urnAddr);

	}
}

interface IVat {
	
	struct Ilk {
		uint256 Art;//Total normalized debt   [wad]
		uint256 rate;//Accumulated rates      [wad]
		uint256 spot;//Price with safety margin[wad]
		uint256 line;//Debt ceiling           [wad]
		uint256 dust;// urn debt floor        [wad]	
	}

	struct Urn {
		uint256 ink;  //locked collateral
		uint256 art; // normilized debt
	}

	function ilks(bytes32 ilk) external view returns (Ilk memory);
	function urns(bytes32 ilk, address user) external view returns (Urn memory);
}


interface ICdpManager {
	function urns(uint256 cdpId) external view returns (address urn);
}