require "tty-prompt"
require_relative './vending_machine'


class Interface
    def initialize
        @machine = VendingMachine.new
        @prompt = TTY::Prompt.new
    end 

    def start
        puts "Welcome to Colten's Vending Machine: \n"
        select_item
    end
    
    def select_item
        items = @machine.items
        item = @prompt.select("Select a product", items)
        print "You selected: #{item} \n \n"
        if !@machine.in_stock?(item)
            puts "This item is out of stock. \n"
            select_item # start prompt over again
        else 
            print "The item costs $#{"%.2f" % @machine.price(item)} \n" 
            if @prompt.yes?("Would you like to purchase this item", convert: :bool)
                @machine.update_user_item(item)
                enter_coins
            else
                select_item
            end
        end
    end
    
    def enter_coins
        puts "Please enter your coins. We do no accept coins smaller than $.05 or larger than $20.00"
        cash_accepted = ['$5.00','$3.00','$2.00','$1.00','$0.50','$0.25', '$0.50', '$0.25', '$0.10', '$0.05', '$10.00', '$20.00']
        current_coin = @prompt.select("", cash_accepted)
        balance = @machine.add_coin(current_coin)
        if balance == 0 # User paid with exact change
            complete_sucessful_transaction
        elsif balance < 0 # We owe the user money
            if @machine.enough_change? # Success - Machine has enough change
                return_change
            else  # Failed - Not enough change
                complete_failed_transaction
            end
        else
            print "Your balance is: $ #{"%.2f" % balance}. Please enter more coins. \n"
            enter_coins
        end
    end

    #### Return Change ####
    def complete_failed_transaction
        puts "There is not enough change in the machine. \nPlease take your returned coins"
        coins = @machine.return_coins
        print_coins(coins)
        puts
        finish
    end
    
    #### End Transaction ####
    def return_change
        coins_returned = @machine.dispense_change
        if coins_returned.length > 0
            total = coins_returned.sum{|coin| coin[1..-1].to_f}
            puts "Please take your coins in the return slot. \nThe total change is: $#{"%.2f" % total}. \nClink...Clink...Click \nCoins returned: \n"
            print_coins(coins_returned)
        end
        complete_sucessful_transaction
    end

    def print_coins(coin_list)
        coin_list.each_with_index do |coin, ind|
            print coin
            if ind < coin_list.length-1
                print ", "
                if ind == coin_list.length-2
                    print "& "
                end
            else
                print "."
            end
        end
    end
        
    def complete_sucessful_transaction
        item = @machine.dispense_item
        print "\nBang Bang! \n...... \ndispensing \n...... \n#{item}\n\nPlease take your item.\n"
        finish
    end 

    def finish
        @machine.reset_machine
        start_again
    end

    def start_again
        if @prompt.yes?("Would you like to purchase another item", convert: :bool)
            start
        else
            # Exit the program
            puts "...exiting...\n"
            exit 
        end
    end
end

transaction = Interface.new
transaction.start