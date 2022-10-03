classdef FileSistem
    
    properties(Access=private)
      singletonData = [];
   end
   
   methods(Abstract, Static)
      obj = instance();
   end
   
   methods 
      function singletonData = getSingletonData(obj)
         singletonData = obj.singletonData;
      end
      
      function obj = setSingletonData(obj, singletonData)
         obj.singletonData = singletonData;
      end
   end
    
end