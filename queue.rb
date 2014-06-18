require "forwardable"

# Wrapper around array that only exposes its FIFO functions
class Queue
	extend Forwardable

	def initialize array = []
		@q = array
	end
	
	def_delegator :@q, :push, :enq
	def_delegator :@q, :shift, :deq

	def_delegators :@q, :size, :length, :count, :empty?, :clear
end
