import "@stdlib/deploy";

contract CrowdFund with Deployable {
    owner_address: Address;
    goal_amount: Int;
    deadline: Int;
    total_raised: Int = 0;
    contributors: map<Address, Int>; // Removed = map() here
    is_active: Bool = true;

    init(owner: Address, goal: Int, deadline: Int, fundGoal: Int) {
        self.owner_address = owner;
        self.goal_amount = goal;
        self.total_raised = fundGoal;
        self.deadline = deadline;
        self.contributors = emptyMap(); // Correct map initialization inside init()
    }


/// contribute func
    receive() {
        require(self.is_active, "Campaign is not active");
        require(now() < self.deadline, "Campaign has ended");
        require(context().value > 0, "contribution must be greater than 0");

        
/// save the contribution
         self.contributors.set(sender(), context().value);
        self.total_raised += context().value;
        
    }


    // function for completing the campaign

    fun finish_campaign() {
        require(sender() == self.owner_address, "Only owner can finish");
        require(now() >= self.deadline, "Campaign still active");

        if (self.total_raised >= self.goal_amount) {

            send( SendParameters {
                to: self.owner_address,
                value: self.total_raised,
                mode: SendIgnoreErrors
            });
        }
        else{
            self.is_active = false;
        }
        
    }


///  calling the function to get the contract information about the   total amount of money raised
    

    get fun get_campaign_info():  Int {
        return (
       
        self.total_raised);
    }


//// calling the function to get the address of the contributors 
    get fun get_contribution(contributor: Address): Address{

        return self.owner_address;
    }
}
