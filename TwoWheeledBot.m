classdef TwoWheeledBot
   properties
      Center
      ChassisWidth
      ChassisLength
      WheelRadius
      WheelWidth
      WheelPos
      Handles
   end
   methods

      function obj = TwoWheeledBot(initPos, initOrietn, chassisWidth, chassisLength, wheelRadius, wheelWidth)
          obj.Center = initPos; 
          obj.ChassisWidth = chassisWidth;
          obj.ChassisLength = chassisLength;
          obj.WheelRadius = wheelRadius;
          obj.WheelWidth = wheelWidth;
          obj.WheelPos = 0;

          obj.Handles = { 
              Rectangle(initPos, chassisWidth, chassisLength, [1 1 0])
              Wheel(24, initPos+[0,chassisLength/2+wheelWidth/2], wheelRadius/2, wheelWidth, [[.7 .7 .7];[.3 .3 .3]], 0)
              Wheel(24, initPos-[0,chassisLength/2+wheelWidth/2], wheelRadius/2, wheelWidth, [[.7 .7 .7];[.3 .3 .3]], 0) 
          };

      end

      function Orientation = getOrientation(obj)
         Orientation = obj.Handles{1}.getOrientation();
      end

      function obj = moveBy(obj, dx, dy)
        obj.Center = obj.Center + [dx, dy];
        for i = 1 : length(obj.Handles)
            obj.Handles{i} = obj.Handles{i}.moveBy(dx, dy);
        end
      end

      function obj = rotateBy(obj, angle)
        for i = 1 : length(obj.Handles)
            obj.Handles{i} = obj.Handles{i}.rotateByOrign(angle, [obj.Center 0]);
        end
      end

      function obj = rotateByOrigin(obj, angle, origin)
        for i = 1 : length(obj.Handles)
            obj.Handles{i} = obj.Handles{i}.rotateByOrigin(angle, origin);
        end
        obj.Center = (obj.Center - origin(1:2))*[cosd(angle) -sind(angle); sind(angle) cosd(angle)].' + origin(1:2);
      end

      function obj = rotateWheelBy(obj, w, angle)
          obj.WheelPos = obj.WheelPos + angle;
          w = w + 1;
          a = obj.Handles{w}.getOrientation();
          c = obj.Handles{w}.Center;
          obj.Handles{w} = obj.Handles{w}.moveBy(-c(1), -c(2));
          obj.Handles{w} = obj.Handles{w}.rotateBy(a - 90);
          obj.Handles{w} = obj.Handles{w}.setAngularPostion(obj.WheelPos);
          obj.Handles{w} = obj.Handles{w}.rotateBy(90 - a);
          obj.Handles{w} = obj.Handles{w}.moveBy(c(1), c(2));
      end
   end
end