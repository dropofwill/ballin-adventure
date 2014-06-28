require "forwardable"

# Wrapper around array that only exposes its FIFO functions
class Stack
	extend Forwardable

	def initialize array = []
		if array.is_a?(Array)
			@s = array 
		else
			@s = [array]
		end
	end
	
	def_delegator :@s, :push, :push
	def_delegator :@s, :pop, :pop

	def_delegators :@s, :size, :length, :count, :empty?, :clear
end
