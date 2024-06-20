classdef Rectangle
   properties
      Center
      Size
      Handle
      PointsXY
      Color
   end
   methods

      function obj = Rectangle(center, width, len, color)
        obj.Size = [width, len];
        obj.Center = center;
        obj.Color = color;
        
        obj.PointsXY = [
            [-width/2,-len/2]
            [ width/2,-len/2]
            [ width/2, len/2]
            [-width/2, len/2]
        ];

        obj.PointsXY = obj.PointsXY + obj.Center;

        obj.Handle = fill(obj.PointsXY(:,1), obj.PointsXY(:,2), obj.Color);
      end

      function Orientation = getOrientation(obj)
         Orientation = rad2deg(atan2(obj.Center(1) - (obj.Handle.XData(1)+obj.Handle.XData(2))/2, obj.Center(2) - (obj.Handle.YData(1)+obj.Handle.YData(2))/2));
      end

      function obj = moveBy(obj, dx, dy)
         obj.PointsXY = obj.PointsXY + [dx, dy];
         obj.Center = obj.Center + [dx, dy];
         obj.Handle.XData = obj.PointsXY(:,1);
         obj.Handle.YData = obj.PointsXY(:,2);

      end

      function obj = rotateBy(obj, angle)
         obj.PointsXY = obj.PointsXY * [cosd(angle) -sind(angle); sind(angle) cosd(angle)].';
         obj.Center = obj.Center * [cosd(angle) -sind(angle); sind(angle) cosd(angle)].';
         obj.Handle.XData = obj.PointsXY(:,1);
         obj.Handle.YData = obj.PointsXY(:,2);
      end

      function obj = rotateByOrigin(obj, angle, origin)
         obj = obj.moveBy(-origin(1), -origin(2));
         obj = obj.rotateBy(angle);
         obj = obj.moveBy(origin(1), origin(2));
      end

      function obj = update(obj, center, width, len, color)
        obj.Size = [width, len];
        obj.Center = center;
        obj.Color = color;
        
        obj.PointsXY = [
            [-width/2,-len/2]
            [ width/2,-len/2]
            [ width/2, len/2]
            [-width/2, len/2]
        ];

        obj.PointsXY = obj.PointsXY + obj.Center;

        obj.Handle.XData = obj.PointsXY(:,1);
        obj.Handle.YData = obj.PointsXY(:,2);
        obj.Handle.FaceColor = obj.Color;
      end

   end
end