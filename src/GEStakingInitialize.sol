//SPDX-License-Identifier: MIT

pragma solidity ^0.8;

interface IBEP20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender,address recipient,uint amount ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value); 
}

contract GEStakingInitialize {

    IBEP20 public nativetoken;

    address public contractOwner;

    uint256 public lockingDays=300;
    uint256 public adminCharge=10;
    uint256 public minimumWithdrawal=5000000000000000000000;

    uint256 public totalNumberofStakers;
    uint256 public totalTierOneStakers;
    uint256 public totalTierTwoStakers;
    uint256 public totalTierThreeStakers;

	uint256 public totalStakesGE;
    uint256 public totalLevelIncome;
    uint256 public totalJackportIncome;
    uint256 public totalAwardAndReward;

    //Index For Every Thing Will Start From 0,1,2
    uint256[3] public tierYearSlab = [1,2,3];
    uint256[3] public tierAPY = [12 ether,24 ether,36 ether];
    uint256[3] public tierLocking = [20,50,80];
    uint256[3] public stakePenaltySlab = [10,20,30];

    struct UserStakingDetails {
        uint256 userId;
        bool[3] stakingStatus;
        uint256[3] totalStakedAvailable;
        uint256[3] totalUnLockedStaked;
        uint256[3] totalLockedStaked;
        uint256[3] totalStaked;
        uint256[3] totalUnStaked;
        uint256[3] totalReward;
        uint256[3] rewards;
		uint256[3] totalRewardWithdrawal;
		uint256[3] totalRewardStaked;
        uint256[3] penaltyCollected;
        uint[3] lastStakedUpdateTime;
        uint[3] lastUnStakedUpdateTime;
        uint[3] lastUpdateTime;
	}

    struct UserOverallDetails {
        uint256 totalStakedAvailable;
        uint256 totalUnLockedStaked;
        uint256 totalLockedStaked;
        uint256 totalStaked;
        uint256 totalUnStaked;
        uint256 totalReward;
		uint256 totalRewardWithdrawal;
		uint256 totalRewardStaked;
        uint256 penaltyCollected;
        uint lastStakedUpdateTime;
        uint lastUnStakedUpdateTime;
        uint lastUpdateTime;
    }

    struct UserAffiliateDetails {
        uint256 checkpoint;
        bool isIncomeBlocked;
        address referrer;
		uint256 totalReferrer;
        uint256 totalBusiness;
        uint256 availableAwardRewardBonus;
		uint256 awardRewardBonusWithdrawn;
        uint256 creditedLevelBonus;
		uint256 availableLevelBonus;
		uint256 levelBonusWithdrawn;
        uint256 availableJackpotBonus;
		uint256 jackpotBonusWithdrawn;
		uint256[41] levelWiseBusiness;
        uint256[41] levelWiseBonus;
		uint[41] refs;
        string[41] allIds;
        uint256[20] levelWiseJackpotBonus;
    }

    struct UserRewardDetails {
        bool tierfirstreceived;
        bool tiersecondreceived;
        bool tierthirdreceived;
        bool tierfourthreceived;
        bool tierfifthreceived;
    }

    // Index For Every Thing Will Start From 0,1,2

    uint[41] public ref_bonuses = [15,10,5,5,5,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]; 
    uint[41] public requiredDirect = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41];
    
    uint noofleveljackpot=3;
    uint[20]  public jackpot_bonuses = [30,30,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

    uint[5]  public requiredBusiness = [5000000000000000000000000,10000000000000000000000000,30000000000000000000000000,100000000000000000000000000,200000000000000000000000000];
    uint[5]  public requiredLevel = [3,5,10,30,41];
    uint[5]  public requiredNoofId = [100,300,1000,5000,10000];
    uint[5]  public reward= [50000000000000000000000,100000000000000000000000,300000000000000000000000,1000000000000000000000000,10000000000000000000000000];

    mapping (address => UserStakingDetails) public userstakingdetails;
    mapping (address => UserOverallDetails) public useraggregatedetails;
    mapping (address => UserAffiliateDetails) public useraffiliatedetails;
    mapping (address => UserRewardDetails) public userrewarddetails;

	event Staking(address indexed _user, uint256 _amount,uint256 _tierslab);
	event UnStakeUnlockedAmount(address indexed _user, uint256 _amount,uint256 _tierslab);
	event UnStakeLockedAmount(address indexed _user, uint256 _amount,uint256 _tierslab);
    event RewardWithdrawal(address indexed _user, uint256 _amount,uint256 _tierslab);
    event RewardStaking(address indexed _user, uint256 _amount,uint256 _tierslab);
	event Withdrawn(address indexed _user, uint256 _amount);

    constructor() {
        contractOwner = 0x2A39C10369726913360BA5c88CC8b02Cebe8a51A;
        nativetoken = IBEP20(0x0D9028F9F14A8ca47b5d4E1C6ccfc7Cb363ff4Fd);
        useraffiliatedetails[contractOwner].checkpoint = block.timestamp;
        userstakingdetails[contractOwner].userId = block.timestamp;
    }
}