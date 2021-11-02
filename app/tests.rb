require_relative './vending_machine'
require 'test/unit'

class TestMachine < Test::Unit::TestCase

    def test_big_decimal
        machine = VendingMachine.new
        # assert(false)
        x = machine.get_coin_value("$5.00")
        y = machine.get_coin_value("$0.10")

        assert_equal(4.9, x-y)
    end

    def test_enough_change
        machine = VendingMachine.new
        machine.update_user_item(:Sprite)
        assert_equal(2.40, machine.add_coin("$0.10"))
        assert_equal(2.30, machine.add_coin("$0.10"))
        machine.add_coin("$20.00")
        assert_equal(true, machine.enough_change?)
    end
end







