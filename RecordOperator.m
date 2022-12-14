classdef RecordOperator < Singleton

   methods(Static)
      function obj = instance()
         persistent uniqueInstance
         if isempty(uniqueInstance)
            obj = RecordOperator();
            uniqueInstance = obj;
         else
            obj = uniqueInstance;
         end
      end
   end
   
   methods
       function [C, Fs] = operate(A, B, whoA, whoB, op)
            if isequal(whoA, 'original')
                D = A.originalSignal.Signal;
            elseif isequal(whoA, 'modified')
                D = A.modifiedSignal.Signal;
            else
                D = A.originalSignal.Signal;
            end
            
            if isequal(whoB, 'original')
                E = B.originalSignal.Signal;
            elseif isequal(whoB, 'modified')
                E = B.modifiedSignal.Signal;
            else
                E = B.originalSignal.Signal;
            end
            
            if isequal(op, 'add')
                [C, Fs] = obj.add(D, E);
            elseif isequal(op, 'subtract')
                [C, Fs] = obj.subtract(D, E);
            elseif isequal(op, 'multiply')
                [C, Fs] = obj.multiply(D, E);
            elseif isequal(op, 'divide')
                [C, Fs] = obj.divide(D, E);
            elseif isequal(op, 'superposition')
                [C, Fs] = obj.superposition(D, E);
            elseif isequal(op, 'convolution')
                [C, Fs] = obj.convolution(D, E);
            else
                [C, Fs] = obj.add(D, E);
            end
            
       end
       
       function [C, Fs] = add(obj, A, B)
           [D, E, Fs] = obj.recordStandardize(A, B);
           C = D + E;
       end
       
       function [C, Fs] = subtract(obj, A, B)
           [D, E, Fs] = obj.recordStandardize(A, B);
           C = D - E;
       end
       
       function [C, Fs] = multiply(obj, A, B)
           [D, E, Fs] = obj.recordStandardize(A, B);
           C = D .* E;
       end
       
       function [C, Fs] = divide(obj, A, B)
           [D, E, Fs] = obj.recordStandardize(A, B);
           C = D ./ E;
       end
       
       function [C, Fs] = superposition(obj, A, B)
           [D, E, Fs] = obj.recordStandardize(A, B);
           
           C = [];
           
           for i = 1:length(D)
               if abs(D(i)) > abs(E(i))
                   C(end + 1) = D(i);
               else
                   C(end + 1) = E(i);
               end
           end
       end
       
       function [C, Fs] = convolution(obj, A, B)
           [D, E, Fs] = obj.recordEqFreq(A, B);
           C = conv(D, E);
       end
       
       function [C, D, Fs] = recordStandardize(obj, A, B)
           [C, D, Fs] = recordEqFreq(obj, A, B);
           
           lc = length(C);
           ld = length(D);
           
           if lc < ld
               C = obj.vectorSpace(C, ld);
           elseif ld < lc
               D = obj.vectorSpace(D, lc);
           end
       end
       
       function [C, D, Fs] = recordEqFreq(obj, A, B)
           Fa = A.Fs;
           Fb = B.Fs;
           ya = A.y;
           yb = B.y;
           
           sigma = gcd(length(ya), length(yb));
           
           x = Fb / sigma;
           y = Fa / sigma;
           
           C = obj.vectorReplication(ya, x);
           D = obj.vectorReplication(yb, y);
           Fs = x * Fa;
           
       end
       
       function C = vectorReplication(~, A, n)
           C = [];
           
           for x = 1:length(A)
               for y = 1:n
                  C(end + 1) = A(x);
               end
           end
       end
       
       function C = vectorSpace(~, A, n)
           l = length(A);
           
           if l < n
               r = n - length(A);
               add = zeros(1, r);
               
               C = [A add];
           else
               C = A;
           end
       end
   end
    
end