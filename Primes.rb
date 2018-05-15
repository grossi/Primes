# Calculates primes in a range and returns it in an array
#  for a range [n, m] the complexity is around O(sqrt(m)*(m-n))

class Primes
	attr_accessor :ps
	def initialize
		@ps = Array.new
	end

	# Returns an array with all primes contained in the [b, e] interval
	def calculate(b=2, e)
		return calculateRange(b, e)
	end

	# Returns an array with all primes contained in the [b, e] interval
	def calculateRange(b=2, e)
		# The number of elements we need to test to see if it's prime
		range = e - b + 1
		# We only need to find all primes up to sqrt(end) to vefiry the range since
		#  any prime over sqrt(end) would need to be multiplied by a lower value, that
		#  has already been verified, to be a multiple of a number inside the range (b, e)
		maxDiv = (Math.sqrt e).to_i
		calculateToNumber maxDiv
		primesArray = Array.new
		# First populate the result array with all numbers from b to e
		range.times{|x| primesArray << b+x}
		# For each prime up to maxDiv we take all multiples of it that fall inside [b, e]
		@ps.each do |prime|
			break if prime > maxDiv
			takeRange(prime, primesArray, b)
		end
		primesArray = primesArray.compact
		# For intervals where b is less than sqrt e
		if b < ps.last then
			primesArray = ps.collect{|x| x if x >= b}.compact.concat primesArray.collect{|x| x if x > ps.last}.compact
		end
		return primesArray
	end

	# Calculates all primes up to n
	private def calculateToNumber(n)
		# If this is the first time we are populating the primes
		if @ps.size == 0 then
			(n+1).times{ |a| @ps << a}
			@ps[0] = nil
			@ps[1] = nil
			maxDiv = Math.sqrt n
			i = 2
			loop do 
				break if i > maxDiv
				i = take(i)
			end
			@ps = @ps.compact
			return
		end
		# Nothing to do if it's already calculated up to n
		return if @ps.last > n

		# Here we can use a recursive call until we find a range where n is already calculated
		@ps.concat calculateRange(@ps.last+1, n)
	end

	# Take all the multiples of prime that are inside pr
	private def takeRange(prime, pr, start)
		# Nullify every number that's multiple of prime
		if start%prime == 0 then
			dif = 0
		else
			dif = prime-(start%prime)
		end
		loop.with_index do |_, x|
			break if (x*prime)+dif > pr.size
			pr[(x*prime)+dif] = nil
		end
	end

	private def take(n)
		(@ps.size/n).times do |x|
			@ps[(1+x)*n] = nil
		end
		@ps[n] = n
		return @ps[(n+1)..@ps.size].find{|x|x}
	end
end

# Only executes when we call the file directly, not when imported

# The input begins with the number t of test cases in a single line
#  In each of the next t lines there are two numbers m and n, separated by a space.
# Example
# Input:
# 2
# 1 10
# 3 5
# Output:
# 2
# 3
# 5
# 7

# 3
# 5
if __FILE__ == $0
	t = gets.to_i
	m, n = Array.new, Array.new
	t.times {
		line = gets.split
		m << line[0].to_i
		n << line[1].to_i
	}

	p = Primes.new

	t.times { |x|
		puts p.calculateRange m[x], n[x]
		puts
	}
end