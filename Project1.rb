=begin
= Zachary Stray
= 9/12/2023
= Poly-Poly Solution
=
= takes in a text file that is formated like
=
=
= how many polygons to be analized
= the number of sides the polygon(s) has
= the poly-polygonal number to start at
= repeat or 0
=
= finds the first 5 poly-poly numbers that are the same between all the poly-polygonal shapes given
=
=end

# @param {int} sides
# @param {int} step
# @return{int}
# find the poly-polygonal number for the given sides and
def get_poly_poly(sides, step)
  return (sides-2) * ((step *(step-1))/2) + step
end

# @param {int} sides
# @param {int} step
# @return{int}
# it gives back the poly poly step after the number start
def get_start(start, sides)
  step = 1
  testing = get_poly_poly(sides, step)
  while testing < start
    step+= 1
    testing = get_poly_poly(sides, step)
  end
  return step
end

# @para {string} word
# @return{int[]}
# takes a string of numbers to put them into an array
def string_to_array(word)
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
  return output
end

# @para {int[]} count
# @return {int}
# takes an array of ints and find the index of the smallest number
def find_smallest(count)
  small_int = count[0]
  small_index = 0
  index = 1
  while index < count.length
    if count[index] < small_int
      small_index = index
      small_int = count[index]
    end
    index += 1
  end
  return small_index
end

# @para {int[]}container
# @return {boolean}
# takes an array of ints and sees if there is the same number is two slots
def same_count(container)
  for i in 0..container.length-2
    for j in i+1..container.length-1
      if container[i] == container[j]
        return true
      end
    end
  end
  return false
end

# @para {int[]} container
# @para {int[]} container1
# @return {boolean}
# takes two int arrays and sees if they share a number in common
def share_count(container, container1)
  for i in 0..container.length-1
    for j in 0..container1.length-1
      if container[i] == container1[j][0]
        return true
      end
    end
  end
  return false
end

# @para {int} num
# @para {int[]} container
# @para {int} index1
# @return {int}
# tried to find where num is in container that is not at index1
def find_index(num, container, index1)
  index = 0
  while container[index] != num or index1 == index
    index += 1
  end
  return index
end

# @para {int[]} poly
# @para {int{}} sides
# @para {int} index
# @return {int}
# finds the index where poly[index] is equal to something else in the array
def get_output(poly, sides, index)
  index1 = 0
  while index1 < poly.length-1
    if index1 != index and poly[index1] == poly[index]
      return index1
    end
    index1 += 1
  end
  return index1
end

#gets the file in the string
file = File.open("testing.txt")
file_data = file.readlines.map(&:chomp)

#the arrays that will be used to store all the numbers for later math
poly_num = Array.new    #the amount of polygons
poly_step = Array.new   #the number of iterations we are on
poly_sides = Array.new  #the number of sides the polygons have
poly_count = Array.new  #the number of dots in each poly-polyagon
poly_start = Array.new  #where the min number poly-poly starts at

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
  current = string_to_array(poly_sides.shift)
  poly_sides.push(current)
end


#fills up poly_count with the begining of the array
for i in 0..poly_num.length-1
  Array temp = Array.new
  for j in 0..poly_sides[i].length-1
    temp.push(get_start(poly_start[i], poly_sides[i][j]))
  end
  poly_step.push(temp)
end

#fills up poly_count with the corrent number
for i in 0..poly_num.length-1
  Array temp = Array.new
  for j in 0..poly_sides[i].length-1
    temp.push(get_poly_poly(poly_sides[i][j], poly_step[i][j]))
  end
  poly_count.push(temp)
end
#makes poly_step an array of arrays to keep track of what step each poly-polygon is on
for i in 0..poly_num.length-1
  Array temp = Array.new
  for j in 0..poly_num[i]-1
    temp.push(poly_step[i])
  end
end

#the output
for i in 0..poly_num.length-1
  same_poly = Array.new()
  smallest = 0
  while same_poly.length < 6

    #see if poly_count has the same number in it as same_poly
    if share_count(poly_count[i], same_poly)

      index = poly_count[i].index(same_poly[same_poly.length-1][0]).to_i

      same_poly[same_poly.length-1].push(poly_sides[i][index])
      poly_step[i][index] += 1
      poly_count[i][index] = get_poly_poly(poly_sides[i][index],poly_step[i][index])

    elsif same_count(poly_count[i]) #if not see if same_poly has repeat numbers

      add = get_output(poly_count[i],poly_sides[i],smallest)
      same_poly[same_poly.length] = Array.new([poly_count[i][smallest], poly_sides[i][smallest],poly_sides[i][add]])

      poly_step[i][add] += 1
      poly_count[i][add] = get_poly_poly(poly_sides[i][add],poly_step[i][add])
      poly_step[i][smallest] += 1
      poly_count[i][smallest] = get_poly_poly(poly_sides[i][smallest],poly_step[i][smallest])
    elsif     #if neither increase the smallest number by one step
      smallest = find_smallest(poly_count[i])
      poly_step[i][smallest] += 1
      poly_count[i][smallest] = get_poly_poly(poly_sides[i][smallest], poly_step[i][smallest])
    end
  end
  for j in 0..4
    print same_poly[j].shift
    print ":"
    same_poly[j] = same_poly[j].sort
    for l in 0..same_poly[j].length-1
      print same_poly[j][l]
      print " "
    end
    puts
  end
  puts
end
