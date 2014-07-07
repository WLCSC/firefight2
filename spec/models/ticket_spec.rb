require "spec_helper"

describe Ticket do
	describe :statusify do
		it "returns a string using predefined value of 1 (low priority)" do
			t = Ticket.new(status: 1)

			expect(t.statusify).to be_a(String)
		end

		it "returns a string using predefined value of 2 (routine priority)" do
			t = Ticket.new(status: 2)

			expect(t.statusify).to be_a(String)
		end

		it "returns a string using predefined value of 3 (urgent priority)" do
			t = Ticket.new(status: 3)

			expect(t.statusify).to be_a(String)
		end

		it "returns a string using predefined value of 99 (deferred status)" do
			t = Ticket.new(status: 99)

			expect(t.statusify).to be_a(String)
		end

		it "returns a string using predefined value of 100 (completed status)" do
			t = Ticket.new(status: 100)

			expect(t.statusify).to be_a(String)
		end

		it "returns the correct string using predefined value of 1 (low priority)" do
			t = Ticket.new(status: 1)

			expect(t.statusify).to eq("Low")
		end

		it "returns the correct string using predefined value of 2 (routine priority)" do
			t = Ticket.new(status: 2)

			expect(t.statusify).to eq("Routine")
		end

		it "returns the correct string using predefined value of 3 (urgent priority)" do
			t = Ticket.new(status: 3)

			expect(t.statusify).to eq("Urgent")
		end

		it "returns the correct string using predefined value of 99 (deferred status)" do
			t = Ticket.new(status: 99)

			expect(t.statusify).to eq("Deferred")
		end

		it "returns the correct string using predefined value of 100 (completed status)" do
			t = Ticket.new(status: 100)

			expect(t.statusify).to eq("Completed")
		end
	end
end
