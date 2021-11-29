pragma solidity ^0.8.10;




//                 Coded by
//
//                                            __                        
//                         | |__ |_  __ _    |_  o __  _ __  _  o  _  | 
//                         |_|||||_) | (_| o |   | | |(_|| |(_  | (_| | 
//
//  
//
//                                      On Behalf Of
//
//    _______       _ _ _       _     _                          __ _                            
//   |__   __|     (_) (_)     | |   | |                        / _(_)                           
//      | |_      ___| |_  __ _| |__ | |_ _______  _ __   ___  | |_ _ _ __   __ _ _ __   ___ ___ 
//      | \ \ /\ / / | | |/ _` | '_ \| __|_  / _ \| '_ \ / _ \ |  _| | '_ \ / _` | '_ \ / __/ _ \
//      | |\ V  V /| | | | (_| | | | | |_ / / (_) | | | |  __/_| | | | | | | (_| | | | | (_|  __/
//      |_| \_/\_/ |_|_|_|\__, |_| |_|\__/___\___/|_| |_|\___(_)_| |_|_| |_|\__,_|_| |_|\___\___|
//                         __/ |                                                                 
//                        |___/                                                                  



contract ZONE_Token{
    
    //Public Variables
    string public name;
    string public symbol;
    uint256 public burned;
    uint8 public decimals;
    address public owner;
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    //End of Public Variables
    
    
    //Private Variables
    bool private airDrop;
    uint256 private _totalSupply;
    //End of Private Variables
    
    
    
    
    
    
    //Pass Inital Arguments for Deployment
    constructor(string memory _name, string memory _symbol, uint8 _decimal) {
       
        name = _name; 
        symbol = _symbol;
        decimals = _decimal;
        
        owner = msg.sender;
        
        
        //Default Settings
        airDrop = false;
        burned = 0;
        
    }
    
    
    
    
    
    //Events
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Mint(address indexed _owner, uint256 _value);
    event Burn(address indexed _owner, uint256 _value);
    event OwnerChange(address indexed _previousOwner, address indexed _newOwner);
    event AirDropEvent(uint256 _amountWhitelisted);
    event TimeWarp(uint256 _value, uint256 _newSupply);
    //End of Events
    
    
    
    //Internal Functions
    function _transfer(address _from, address _to, uint256 _value) private returns (bool success){
        require(balanceOf[_from] >= _value);
        require(_from != address(0));
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        return true;
    }
    
    function _deductAllowance(address _from, address _3rdParty, uint256 _value) private returns (bool success){
        require(allowance[_from][_3rdParty] >= _value);
        allowance[_from][_3rdParty] -= _value;
        return true;
    }
    
    function _airDrop(address[] memory _addressList, uint256[] memory _amountList) private returns (bool success){
        require(airDrop == false);
        require(_addressList.length == _amountList.length);
        for (uint i = 0; i < _addressList.length; i++) {
            require(_addressList[i] != address(0));
            require(_amountList[i] > 0);
            require(_transfer(owner, _addressList[i], _amountList[i]));
        }
        emit AirDropEvent(_addressList.length);
        return true;
    }

    function _timeWarp(uint256 _value) private returns (bool success){
        require(burned >= _value);
        burned -= _value;
        balanceOf[owner] += _value;
        return true;
    }
    //End of Internal Functions
    
    
    
    //Credential Modifiers
    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }
    //End Credential Modifiers
    
    

    //External TotalSupply Function
    function totalSupply() public view returns (uint256) {
        return (_totalSupply - burned);
    }

    //External Transfer Function
    function transfer(address _to, uint256 _value) public returns (bool success){
        require(_transfer(msg.sender, _to, _value));
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    //External TransferFrom Function
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(balanceOf[_from] >= _value);
        require(_deductAllowance(_from, msg.sender, _value));
        require(_transfer(_from, _to, _value));
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    //External Approve Function
    function approve(address _spender, uint256 _value) public returns (bool success){
        allowance[msg.sender][_spender] = _value;
        return true;
    }
    
    //External Burn Function
    function burn(uint256 _value) public isOwner returns (bool succes){
        require(balanceOf[owner] >= _value);
        balanceOf[owner] -= _value;
        emit Burn(owner, _value);
        return true;
    }

    //External TimeWarp Function
    function timeWarp(uint256 _value) public isOwner returns (bool success){
        require(_timeWarp(_value));
        emit TimeWarp(_value, totalSupply());
        return true;
    }
    
    
    
    
    
    //External OwnerChange Function
    function changeOwner(address _newOwner) public isOwner returns (bool success){
        owner = _newOwner;
        emit OwnerChange(msg.sender, _newOwner);
        return true;
    }
    
    
    
}
