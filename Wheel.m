classdef Wheel
   properties
      Center
      Radius
      Width
      NumOfSegments
      Colors
      Segments
      AngularPosition
      SwitchColor
      PPP
   end
   methods

      function obj = Wheel(n, center, radius, width, colors, pos)
        obj.AngularPosition = pos; 
        obj.NumOfSegments = n;    
        obj.Center = center;
        obj.Width = width;
        obj.Colors = colors;
        obj.Radius = radius;
        obj.SwitchColor = 0;
        
        p = 2*obj.Radius*cos([0, (2*pi/obj.NumOfSegments)*(0:(obj.NumOfSegments/2-1)) + obj.AngularPosition, pi]);
        obj.Segments = cell(obj.NumOfSegments/2,1); % only upper half is visible
        for i = 1 : obj.NumOfSegments/2+1
            obj.Segments{i} = Rectangle([(p(i)+p(i+1))/2 0]+obj.Center, p(i)-p(i+1), obj.Width, obj.Colors(1+(mod(i,2) == obj.SwitchColor), :)); 
        end
      end

      function Orientation = getOrientation(obj)
        Orientation = rad2deg(atan2(obj.Segments{1}.Center(1) - obj.Center(1), obj.Segments{1}.Center(2) - obj.Center(2)));
      end

      function obj = setAngularPostion(obj, angle)

        % Color switching - emulation of wheel rotation  
        angle = mod(angle, (2*pi/obj.NumOfSegments));
        if abs(obj.AngularPosition - angle) > (pi/obj.NumOfSegments)
            obj.SwitchColor = double(not(obj.SwitchColor));
        end
        obj.AngularPosition = angle;
        
        p = 2*obj.Radius*cos([0, (2*pi/obj.NumOfSegments)*(0:(obj.NumOfSegments/2-1)) + obj.AngularPosition, pi]);

        for i = 1 : obj.NumOfSegments/2+1
            obj.Segments{i} = obj.Segments{i}.update([(p(i)+p(i+1))/2 0]+obj.Center, p(i)-p(i+1), obj.Width, obj.Colors(1+(mod(i,2) == obj.SwitchColor), :));
        end

      end

      function obj = moveBy(obj, dx, dy)
        obj.Center = obj.Center + [dx, dy];
        for i = 1 : obj.NumOfSegments/2+1
            obj.Segments{i} = obj.Segments{i}.moveBy(dx, dy);
        end
      end

      function obj = rotateBy(obj, angle)
        for i = 1 : obj.NumOfSegments/2+1
            obj.Segments{i} = obj.Segments{i}.rotateByOrigin(angle, [obj.Center 0]);
        end
      end

      function obj = rotateByOrigin(obj, angle, origin)
        for i = 1 : obj.NumOfSegments/2+1
            obj.Segments{i} = obj.Segments{i}.rotateByOrigin(angle, origin);
        end
        obj.Center = (obj.Center - origin(1:2))*[cosd(angle) -sind(angle); sind(angle) cosd(angle)].' + origin(1:2);
      end

   end
end