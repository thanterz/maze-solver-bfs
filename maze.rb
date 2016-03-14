class NodePoint < Struct.new(:pntx,:pnty,:parent)
end

class Maze
   # constructor method
   
   def initialize(x,y)
      @xs = x
      @ys = y
      @parentx = nil
      @parenty = nil
      @ar = []
      @q = []
      @tpath = []

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
      @ar[@xs][@ys] = 5
      while !@q.empty? && found == false
         shiftpoint = @q.shift
         pointx = shiftpoint.pntx
         pointy = shiftpoint.pnty

         if @ar[pointx][pointy] == 2
            @ar[pointx][pointy] = 'E'
            found = true
         else
            if isInside(pointx,pointy+1) 
               if !isWall(pointx,pointy+1) && !isVisited(pointx,pointy+1)
                  @q.push(NodePoint.new(pointx,pointy+1,shiftpoint))
                  #@tpath.push(NodePoint.new(pointx,pointy+1,shiftpoint))
                  @ar[pointx][pointy+1] = 5 if @ar[pointx][pointy+1]!=2
               end
            end
            if isInside(pointx+1,pointy) == true
               if !isWall(pointx+1,pointy) && !isVisited(pointx+1,pointy)
                  @q.push(NodePoint.new(pointx+1,pointy,shiftpoint))
                  #@tpath.push(NodePoint.new(pointx+1,pointy,shiftpoint))
                  @ar[pointx+1][pointy] = 5 if @ar[pointx+1][pointy]!=2
               end
            end
            if isInside(pointx,pointy-1) 
               if !isWall(pointx,pointy-1) && !isVisited(pointx,pointy-1)
                  @q.push(NodePoint.new(pointx,pointy-1,shiftpoint))
                  #@tpath.push(NodePoint.new(pointx,pointy-1,shiftpoint))
                  @ar[pointx][pointy-1] = 5 if @ar[pointx][pointy-1]!=2
               end
            end
            if isInside(pointx-1,pointy) 
               if !isWall(pointx-1,pointy) && !isVisited(pointx-1,pointy)
                  @q.push(NodePoint.new(pointx-1,pointy,shiftpoint))
                  #@tpath.push(NodePoint.new(pointx-1,pointy,shiftpoint))
                  @ar[pointx-1][pointy] = 5 if @ar[pointx-1][pointy]!=2
               end
            end
         end
      end
      #find shortest path
      
      if found == true
         while shiftpoint.parent 
            shiftpoint = shiftpoint.parent 
            if shiftpoint.parent == nil
               @ar[shiftpoint.pntx][shiftpoint.pnty] = 'S'
            else
               @ar[shiftpoint.pntx][shiftpoint.pnty] = '.'
            end
         end
      end
      return found
   end

   def draw_solution(s)
      if s == true
         puts "Solution:"
         @ar.each do |row|
            row.each do |item|
               if item == 5
                  print 'P'
               else
                  print item
               end
            end
            print "\n"
         end
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