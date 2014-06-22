require "forwardable"

# Wrapper around array that only exposes its FIFO functions
class Queue
	extend Forwardable

	def initialize array = []
		if array.is_a?(Array)
			@q = array 
		else
			@q = [array]
		end
	end
	
	def_delegator :@q, :push, :enq
	def_delegator :@q, :shift, :deq

	def_delegators :@q, :size, :length, :count, :empty?, :clear
end
