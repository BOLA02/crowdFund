import "@stdlib/deploy";

contract CrowdFund with Deployable {
    owner_address: Address;
    goal_amount: Int;
    deadline: Int;
    total_raised: Int = 0;
    contributors: Map<Address, Int>; // Removed = map() here
    is_active: Bool = true;

    init(owner: Address, goal: Int, deadline: Int) {
        self.owner_address = owner;
        self.goal_amount = goal;
        self.deadline = deadline;
        self.contributors = map(); // Correct map initialization inside init()
    }

    receive() {
        require(self.is_active, "Campaign is not active");
        require(now() < self.deadline, "Campaign has ended");

        let sender = msg.sender;
        let amount = msg.value;
        
        let contribution = self.contributors[sender] ?? 0;
        self.contributors[sender] = contribution + amount;
        self.total_raised += amount;
    }

    public fun finish_campaign() {
        require(msg.sender == self.owner_address, "Only owner can finish");
        require(now() >= self.deadline, "Campaign still active");

        if (self.total_raised >= self.goal_amount) {
            send(self.owner_address, self.total_raised);
        }
        self.is_active = false;
    }

    public fun claim_refund() {
        require(now() >= self.deadline, "Campaign still active");
        require(self.total_raised < self.goal_amount, "Campaign was successful");

        let sender = msg.sender;
        let contribution = self.contributors[sender] ?? 0;
        require(contribution > 0, "No contribution found");

        send(sender, contribution);
        self.total_raised -= contribution;
        self.contributors.delete(sender);
    }

    public fun get_campaign_info(): (Int, Int, Int) {
        return (self.goal_amount, self.deadline, self.total_raised);
    }

    public fun get_contribution(contributor: Address): Int {
        return self.contributors[contributor] ?? 0;
    }
}
