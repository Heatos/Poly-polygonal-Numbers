=begin
= Zachary Stray
= 9/12/2023
= Poly-Poly Solution
=
= takes in a text file that is formated like
=
= how many polygons to be analized
= the number of sides the polygon(s) has
= the poly-polygonal number to start at
= repeat or 0
=
= finds the first 5 poly-poly numbers that are the same between all the poly-polygonal shapes given
=
ruby C:/Users/heato/OneDrive/Desktop/College/JuinorFall/Lang_Machines/Project1/Project1.rb < C:/Users/heato/OneDrive/Desktop/College/JuinorFall/Lang_Machines/Project1/testing.txt > C:/Users/heato/OneDrive/Desktop/College/JuinorFall/Lang_Machines/Project1//test_out.txt
=end

#the arrays that will be used to store all the numbers for later math
poly_num = Array.new    #the amount of polygons
poly_step = Array.new   #the number of iterations we are on
poly_sides = Array.new  #the number of sides the polygons have
poly_count = Array.new  #the number of dots in each poly-polyagon
poly_start = Array.new  #where the min number poly-poly starts at

#@param {int} sides
# @param {int} step
# return {int}
# finds the next addtion to the polypolygon with that number of sides and the iteration it is on
def (sides, step)
  if step == 1
    return 1
  else
    return (sides - 2) * (step - 1) + 1
  end
end

#gets the file in the string
file_data = Array.new
while text = gets
  file_data.push(text.to_s.chomp + " ")
end

#get all the data into the right array

until file_data.length < 2
  poly_num.push(file_data.shift)
  poly_sides.push(file_data.shift)
  poly_start.push(file_data.shift)
end

#makes poly_num and poly_step an array of ints
temp1 = poly_num.map(&:to_i)
poly_num = temp1
temp1 = poly_start.map(&:to_i)
poly_start = temp1

#makes poly_sides from an array of strings into an array of array of numbers
for i in 0..poly_sides.length-1
  word = poly_sides.shift
  Array output = Array.new
  end_index = 1
  start_index = 0
  num = 0
  while end_index < word.to_s.length-1
    if word[end_index] != " "
      end_index += 1
    else
      new_int = word[start_index,end_index].to_i
      start_index = end_index + 1
      end_index = start_index + 1
      output.push(new_int)
    end
  end
  new_int = word[start_index,end_index].to_i
  output.push(new_int)
  poly_sides.push(output)
end

#get poly_count and poly_step with the corrent numbers
for i in 0..poly_num.length-1
  poly_step.push(Array.new)
  poly_count.push(Array.new)
  for j in 0..poly_sides[i].length-1
      poly_step[i][j] = 1
      poly_count[i][j] = 1
      while poly_count[i][j] < poly_start[i]
        poly_step[i][j] += 1
        poly_count[i][j] += get_next( poly_sides[i][j], poly_step[i][j])
      end
  end
end

#makes poly_step an array of arrays to keep track of what step each poly-polygon is on
for i in 0..poly_num.length-1
  Array temp = Array.new
  for j in 0..poly_num[i]-1
    temp.push(poly_step[i])
  end
end

#the output
out = "";

for i in 0..poly_num.length-1
  same_poly = Array.new() # output array

  while same_poly.length-1 < 5  #goes until the output array is 5 arrays long
    #print poly_count[i]
    #puts
    small_int = poly_count[i][0]
    small_index = 0
    for j in 1..poly_count[i].length-1    #finds the smallest poly count
      if poly_count[i][j] < small_int
        small_index = j
        small_int = poly_count[i][j]
      end
    end

    repeat = false                  #sees if the smallest index repeats
    for j in 0..poly_count[i].length
      if small_index != j and poly_count[i][small_index] == poly_count[i][j]
        repeat = true
      end
    end

  if(repeat)          #if the smallest poly_count repeats put it in the output array
    same_poly.push(Array.new([poly_count[i][small_index]]))
    for j in 0..poly_count[i].length
      if poly_count[i][j] == poly_count[i][small_index]
        same_poly[same_poly.length-1].push(poly_sides[i][j])
      end
    end
  end

  for j in 0..poly_count[i].length #increases the set of the smallest poly_count
    if poly_count[i][j] == small_int
      poly_step[i][j] += 1
      poly_count[i][j] += get_next(poly_sides[i][j], poly_step[i][j])
    end
  end
end

  for j in 0..4
    out += same_poly[j].shift.to_s
    out += ":"
    same_poly[j] = same_poly[j].sort
    for l in 0..same_poly[j].length-1
      out+= same_poly[j][l].to_s
      out += " "
    end
    out += "\n"
  end
  out += "\n"
end
out = out.chomp
puts out
