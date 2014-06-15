require 'ffi'

module LibFactorial
	extend FFI:Library
	ffi_lib './libfactorial.so'
	attach_function :factorial, [:int], :uint
end

puts LibFactorial.factorial(25)
