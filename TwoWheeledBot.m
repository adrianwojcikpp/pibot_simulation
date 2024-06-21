classdef TwoWheeledBot
   properties
      Center
      ChassisWidth
      ChassisLength
      WheelRadius
      WheelWidth
      WheelPos
      Handles
      e_th_old 
      e_m_old 
      Kwp 
      Kvp
      Kwd 
      Kvd
   end
   methods

      function obj = TwoWheeledBot(initPos, initOrietn, chassisWidth, chassisLength, wheelRadius, wheelWidth)
          obj.Center = initPos; 
          obj.ChassisWidth = chassisWidth;
          obj.ChassisLength = chassisLength;
          obj.WheelRadius = wheelRadius;
          obj.WheelWidth = wheelWidth;
          obj.WheelPos = [0 0];

          obj.Handles = { 
              Rectangle(initPos, chassisWidth, chassisLength, [1 1 0])
              Wheel(12, initPos+[0,chassisLength/2+wheelWidth/2], wheelRadius/2, wheelWidth, [[.7 .7 .7];[.3 .3 .3]], 0)
              Wheel(12, initPos-[0,chassisLength/2+wheelWidth/2], wheelRadius/2, wheelWidth, [[.7 .7 .7];[.3 .3 .3]], 0) 
          };

          obj.e_th_old = 0;
          obj.e_m_old = 0;
          obj.Kwp = 0;
          obj.Kvp = 0;
          obj.Kwd = 0;
          obj.Kvd = 0;

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
            obj.Handles{i} = obj.Handles{i}.rotateByOrigin(angle, [obj.Center 0]);
        end
      end

      function obj = rotateByOrigin(obj, angle, origin)
        for i = 1 : length(obj.Handles)
            obj.Handles{i} = obj.Handles{i}.rotateByOrigin(angle, origin);
        end
        obj.Center = (obj.Center - origin(1:2))*[cosd(angle) -sind(angle); sind(angle) cosd(angle)].' + origin(1:2);
      end

      function obj = rotateWheelBy(obj, w, angle)
          obj.WheelPos(w) = obj.WheelPos(w) + angle;
          pos = obj.WheelPos(w);
          w = 4 - w;
          a = obj.Handles{w}.getOrientation();
          c = obj.Handles{w}.Center;
          obj.Handles{w} = obj.Handles{w}.moveBy(-c(1), -c(2));
          obj.Handles{w} = obj.Handles{w}.rotateBy(a - 90);
          obj.Handles{w} = obj.Handles{w}.setAngularPostion(pos);
          obj.Handles{w} = obj.Handles{w}.rotateBy(90 - a);
          obj.Handles{w} = obj.Handles{w}.moveBy(c(1), c(2));
      end

      function obj = update(obj, w1, w2, ts)
        R = obj.WheelRadius;
        L = (obj.WheelWidth + obj.ChassisLength)/2;
        w = (w1-w2)*(R/L)/2;
        o = -obj.getOrientation;
        obj = obj.rotateBy(rad2deg(w*ts));
    
        v = (w1+w2)*R/2;
        obj = obj.moveBy(v*ts*cosd(o), v*ts*sind(o));
        obj = obj.rotateWheelBy(1, -w1*ts);
        obj = obj.rotateWheelBy(2, -w2*ts);
      end

      function [obj, w1, w2, e_m, e_th] = positionController(obj, ref)
        R = obj.WheelRadius;
        L = (obj.WheelWidth + obj.ChassisLength)/2;

        d = [ref(1) - obj.Center(1), ref(2) - obj.Center(2)];
        thd = rad2deg(atan2(d(1),d(2)));
        md = sqrt(d(1)^2 + d(2)^2);

        e_th = thd - (90 + obj.getOrientation());
        de_th = e_th - obj.e_th_old;
        obj.e_th_old = e_th;
        e_th = mod(e_th + 180, 360) - 180;
        w = obj.Kwp * deg2rad(e_th) + obj.Kwd *deg2rad(de_th);
    
        e_m = md;
        de_m = e_m - obj.e_m_old;
        obj.e_m_old = e_m;
        v = obj.Kvp * md  + obj.Kvd *de_m;
    
        w1 = (v - L*w)/R;
        w2 = (v + L*w)/R;

      end
   end
end