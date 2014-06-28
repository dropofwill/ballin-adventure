def generate_array(length = 100)
    n = 100
    random = rand(n-1)
    arr = (1..n).to_a
    missing = arr.delete_at(random)
    arr = arr.shuffle
    return arr, missing
end
    

def find_missing(arr, n)
    b = 0
    a = n - 1
    
    # Sums the elements in the array
    a.times do
        b += arr.pop
    end
    
    # Equal to the sum of n consecutive numbers
    a = (n * (n+1))/2
    
    # The difference is the missing number
    return a - b
end

50.times do |x|
    n = 100
    arr, answer = generate_array 100
    result = find_missing arr, n
    p result == answer
end
