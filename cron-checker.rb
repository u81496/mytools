#!/usr/bin/env ruby
require 'date'

def error(i = -1)
	type = ['min', 'hour', 'day', 'month', 'dow']
	puts("format wrong: #{type[i]}")
	exit
end

if ARGV.size == 0
	print("min hour day month dow [limit=5]: ")
	input = gets.chomp.split
else
	input = ARGV
end

if input.size < 5
	puts("USAGE: #{$0} min hour day month dow [limit=5]")
	puts("example:")
	puts("	#{$0} '0' '0' '*' '*' '*'")
	puts("	#{$0} '0' '12-16' '*' '*' '*'")
	puts("	#{$0} '0' '12-16/2' '*' '*' '*'")
	puts("	#{$0} '0' '*/2' '*' '*' '*'")
	puts("	#{$0} '0' '2,3,5,7,11' '*' '*' '*'")
	exit
end

limit = 5
if input.size >= 6
	limit = input[5].to_i
end

flag = [
	[0] * 60,
	[0] * 24,
	[0] * 32,
	[0] * 13,
	[0] * 8,
]

reg = [
	/^(\*(\/0*[1-9][0-9]*)?|0*[1-5]?[0-9](-0*[1-5]?[0-9](\/0*[1-9][0-9]*)?)?)$/,
	/^(\*(\/0*[1-9][0-9]*)?|0*(1?[0-9]|2[0-3])(-0*(1?[0-9]|2[0-3])(\/0*[1-9][0-9]*)?)?)$/,
	/^(\*(\/0*[1-9][0-9]*)?|0*([1-9]|[12][0-9]|3[01])(-0*([1-9]|[12][0-9]|3[01])(\/0*[1-9][0-9]*)?)?)$/,
	/^(\*(\/0*[1-9][0-9]*)?|0*([1-9]|1[0-2])(-0*([1-9]|1[0-2])(\/0*[1-9][0-9]*)?)?)$/,
	/^(\*(\/0*[1-9][0-9]*)?|0*[0-7](-0*[0-7](\/0*[1-9][0-9]*)?)?)$/,
]

default = [60, 24, 32, 13, 8]

(0..4).each do |i|
	input[i].split(',').each do |cond|
		error(i) if !cond.match(reg[i])
		st = 1
		if cond.include?('/')
			cond, st = cond.split('/')
			st = st.to_i
		end

		if cond.include?('-')
			s, e = cond.split('-').map(&:to_i)
		elsif cond == '*'
			flag[i] = ['*'] * default[i]
			next
		else
			s, e = cond.to_i, -1
		end

		if e == -1
			flag[i][s] = 1 if flag[i][s] == 0
		else
			s.step(e, st).each do |j|
				flag[i][j] = 1 if flag[i][j] == 0
			end
		end
	end
end
flag[4][0] = 1 if flag[4][7] == 1

now = Time.now
start_min = now.min
start_hour = now.hour
start_day = now.day
start_month = now.month
start_year = now.year

count = 0
(start_year..2100).each do |y|
	(start_month..12).each do |m|
		next if flag[3][m] == 0
		eom = Date.new(y, m, -1).day
		(start_day..eom).each do |d|
			dow = Date.new(y, m, d).wday
			next if flag[2][d] == 0 && flag[4][dow] == 0
			next if flag[2][d] == 0 && flag[4][dow] == '*'
			next if flag[2][d] == '*' && flag[4][dow] == 0
			(start_hour..23).each do |h|
				next if flag[1][h] == 0
				(start_min..59).each do |min|
					next if flag[0][min] == 0
					puts(Time.new(y, m, d, h, min).strftime('%Y/%m/%d(%a) %H:%M:%S'))
					count += 1
					exit if count >= limit
				end
				start_min = 0
			end
			start_hour = 0
			start_min = 0
		end
		start_day = 1
		start_hour = 0
		start_min = 0
	end
	start_month = 1
	start_day = 1
	start_hour = 0
	start_min = 0
end
