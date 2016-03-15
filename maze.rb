# create a simple class using Struct in order to save the path to the goal point
class NodePoint < Struct.new(:pntx,:pnty,:parent)
end

class Maze
   
   def initialize(x,y)
      @xs = x
      @ys = y
      @ar = []
      @q = []
      # add input to 2 dimensional array 
      File.open("input.txt", "r") do |file|
         file.each_line do |line|
            @ar << line.split.map(&:to_i)
         end
      end
   end

   def solve()
      if @ar[@xs][@ys] == 1
         abort("This is a wall point. Please select another start point")
      elsif @ar[@xs][@ys] == 2
         abort("This is the end point. Please select another start point")
      end
      found = false
      shiftpoint = NodePoint.new(@xs,@ys,nil)
      @q.push(shiftpoint)
      # assign a number to this coordinate to show that it has been examined
      @ar[@xs][@ys] = 5
      # while queue is empty and we have not found the Goal point
      while !@q.empty? && found == false
         # point to be used as a parent for the adjacent points
         shiftpoint = @q.shift
         pointx = shiftpoint.pntx
         pointy = shiftpoint.pnty

         if @ar[pointx][pointy] == 2
            @ar[pointx][pointy] = 'G'
            found = true
         else
            # check top neighbor. if it is inside the matrix and is not wall and has not been visited then add it to queue
            if isInside(pointx,pointy+1) 
               if !isWall(pointx,pointy+1) && !isVisited(pointx,pointy+1)
                  @q.push(NodePoint.new(pointx,pointy+1,shiftpoint))
                  @ar[pointx][pointy+1] = 5 if @ar[pointx][pointy+1]!=2
               end
            end
            # check right neighbor. if it is inside the matrix and is not wall and has not been visited then add it to queue
            if isInside(pointx+1,pointy) == true
               if !isWall(pointx+1,pointy) && !isVisited(pointx+1,pointy)
                  @q.push(NodePoint.new(pointx+1,pointy,shiftpoint))
                  @ar[pointx+1][pointy] = 5 if @ar[pointx+1][pointy]!=2
               end
            end
            # check bottom neighbor. if it is inside the matrix and is not wall and has not been visited then add it to queue
            if isInside(pointx,pointy-1) 
               if !isWall(pointx,pointy-1) && !isVisited(pointx,pointy-1)
                  @q.push(NodePoint.new(pointx,pointy-1,shiftpoint))
                  @ar[pointx][pointy-1] = 5 if @ar[pointx][pointy-1]!=2
               end
            end
            # check left neighbor. if it is inside the matrix and is not wall and has not been visited then add it to queue
            if isInside(pointx-1,pointy) 
               if !isWall(pointx-1,pointy) && !isVisited(pointx-1,pointy)
                  @q.push(NodePoint.new(pointx-1,pointy,shiftpoint))
                  @ar[pointx-1][pointy] = 5 if @ar[pointx-1][pointy]!=2
               end
            end
         end
      end
      # create shortest path by assigning . to every point of the path
      if found == true
         while shiftpoint.parent 
            shiftpoint = shiftpoint.parent 
            if shiftpoint.parent == nil
               # start point
               @ar[shiftpoint.pntx][shiftpoint.pnty] = 'S'
            else
               # path point
               @ar[shiftpoint.pntx][shiftpoint.pnty] = '.'
            end
         end
      end
      return found
   end

   def draw_solution(s)
      coordinates = []
      if s == true
         # print path 
         puts "Solution:"
         @ar.each_with_index do |row,rowi|
            row.each_with_index do |item,indexi|
               if item == 5
                  print 'P'
               elsif item == '.' || item == 'S' || item == 'G'
                  print item
                  coordinates.push([rowi,indexi])
               else
                  print item 
               end
            end
            print "\n"
         end
         # print coordinates of the path
         print "Coordinates:\n #{coordinates}"
         print "\n"
      else
         puts "no solution found"
      end

   end

   #check if point is inside the matrix
   def isInside(x,y)
      if x < 0 || y < 0 || y > (@ar[0].length-1) || x > @ar.length-1
         return false
      else
         return true
      end
   end

   #check for wall
   def isWall(x,y)
      if @ar[x][y] == 1
         return true
      else
         return false
      end
   end

   #check if point has been visited
   def isVisited(x,y)
      if @ar[x][y] == 5
         return true
      else
         return false
      end
   end

end

# create an object
x1 = ARGV[0].to_i
y1 = ARGV[1].to_i
box = Maze.new(x1,y1)
solution = box.solve()
box.draw_solution(solution)