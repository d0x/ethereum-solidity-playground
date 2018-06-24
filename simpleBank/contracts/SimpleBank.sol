pragma solidity ^0.4.13;
contract SimpleBank {

    mapping (address => uint) private balances;

    address public owner;

    // Events - publicize actions to external listeners
    event LogDepositMade(address accountAddress, uint amount);

    constructor () public{
        owner = msg.sender;
    }

    /// @notice Enroll a customer with the bank, giving them 1000 tokens for free
    /// @return The balance of the user after enrolling
    function enroll() public returns (uint){
        // TODO: Throw error when already in list
        return balances[msg.sender] = 1000;
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
        uint balance = balances[msg.sender]+=msg.value;
        emit LogDepositMade(msg.sender, balance);
        return balance;
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint remainingBal) {
        require(balance() >= withdrawAmount);

        if(msg.sender.send(withdrawAmount)){
            remainingBal = balances[msg.sender]-=withdrawAmount;
        }
        else {
            remainingBal = balances[msg.sender];
        }
    }

    /// @notice Get balance
    /// @return The balance of the user
    function balance() public view returns (uint) {
        return balances[msg.sender];

    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function () public {
        revert();
    }
}
