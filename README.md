# vending-machine-cli

## Notes

The Interface class is how the user interacts with the machine. It is the front end. The VendingMachine Class does all of the calculations. It is the backend.

## How to use

1. Git Clone this repo on your machine
2. Run bundle install
3. confirm you are tin the /app directory
4. run ruby interface.rb


## Time

15 minutes - Puesdo-Code and mapping
1 hour - First pass through Vending Machine with core functions - add_coin, enough_change?, check_curr_coin. Spent most of the time with enough_change?. Orginally function was used to calculate the change to be returned to the user. 
1.5 hour - refractor core functions and add smaller DRY functions
30 minutes - Dealing with @cash conversion. Eventually went with BigDecimal to remove issues with floats. 
45 minutes - Interface. 
30 minutes - Cleaning up interface for readability.  
