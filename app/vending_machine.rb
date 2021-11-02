require 'pry'
require 'bigdecimal'
require 'test/unit'


class VendingMachine
    def initialize
        # Cash is money in the vending machine
        # coins are money the user put into the machine
        # change is the money that is returned to the user

        @items = {
           Coca_Cola: {Price: 2.00, Quantity: 2},
           Sprite: {Price: 2.50, Quantity: 2},
           Fanta: {Price: 2.70, Quantity: 3},
           Orange_Juice: {Price: 3.00, Quantity: 1},
           Water: {Price: 3.25, Quantity: 0}
        }
        @cash = {'$20.00' => 0, '$10.00' => 0, '$5.00' => 5, '$3.00'=> 5, '$2.00'=> 5, '$1.00'=> 5, '$0.50'=> 5, '$0.25'=> 5, '$0.10' => 0, '$0.05' => 0}
        # @cash_total = @cash.sum{|key, val| key.to_s.to_f * val} # 58.75

        @user_item = nil
        @user_coins = []
        @user_coins_total = 0

        @change_to_be_returned = []
    end

    ### All Items ###
    def items
        @items.keys
    end

    def price(item)
        @items[item][:Price]
    end
    
    def in_stock?(item)
        @items[item][:Quantity] > 0 ? true : false
    end

    ### Coins ###
    def get_coin_value(key)
        BigDecimal(key[1..-1])
    end

    ### User Item ###
    def update_user_item(item)
        @user_item = item
    end

    def get_user_item
        return @user_item
    end

    ### Transactions ###
    def add_coin(coin_str) # Returns Balance
        @user_coins_total += get_coin_value(coin_str)
        @user_coins << coin_str
        @cash[coin_str] +=1
        if @user_coins_total >= price(@user_item)
           return price(@user_item) - @user_coins_total
        else 
            return price(@user_item) - @user_coins_total
        end
    end

    # Enoungh_change? and check_curr_coin first path through took about 30 mins with initial puesdo-code. Refractor took about 10 mins
    def enough_change?
        amount_owed = @user_coins_total - price(@user_item)
        @cash.each do |coin, qty|
            amount_owed = check_curr_coin(coin, amount_owed)
        end
        if amount_owed == 0
            return true
        else # not enough change
            return false
        end
    end

    def check_curr_coin(current_coin, amount_owed) # current_coin is a string in the format of @cash key, amounted_owed is a float
        coin_value = get_coin_value(current_coin)
        if coin_value <= amount_owed && @cash[current_coin] > 0
            @cash[current_coin] -= 1
            @change_to_be_returned << current_coin
            amount_owed -= coin_value
            check_curr_coin(current_coin, amount_owed)
        else
            return amount_owed
        end
    end

    ### Transaction Success ###
    def dispense_change
        return @change_to_be_returned
    end

    def dispense_item
        @items[@user_item][:Quantity] -= 1
        return @user_item
    end

    ### Transaction Failure ### 
    def return_coins
        @change_to_be_returned.each do |coin|
            @cash[coin] += 1
        end

        return @user_coins
    end

    #### Reset Machine for next purchase ####
    def reset_machine # Does not alter cash or items in the machine
        @user_item = nil
        @user_coins = []
        @user_coins_total = 0
        @change_to_be_returned = []
    end

end