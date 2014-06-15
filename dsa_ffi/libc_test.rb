require 'ffi'

module LibcWrapper
	extend FFI::Library
	ffi_lib FFI::Library::LIBC
	attach_function :getpid, [], :int
end

puts LibcWrapper.getpid
puts $$
