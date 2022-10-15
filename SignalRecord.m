classdef SignalRecord
    
    %% props
    properties
        %% general props
        name = ''
        
        %% analisis data
        analysis = struct(...
            'fourier', false,...
            'discreet', false...
        )
    
        %% original data structure
        originalData = struct(...
            'duration', 0,...
            'ydata', struct(...
                'Fs', 0,...
                'y', [],...
                't', []...
            ),...
            'fdata', struct(...
                'F', [],...
                'y', []...
            ),...
            'ddata', struct(...
                'Fs', 0,...
                'y', [],...
                't', []...
            )...
        )
    
        %% new data structure
        newData = struct(...
            'duration', 0,...
            'ydata', struct(...
                'Fs', 0,...
                'y', [],...
                't', []...
            ),...
            'fdata', struct(...
                'F', [],...
                'y', []...
            ),...
            'ddata', struct(...
                'Fs', 0,...
                'y', [],...
                't', []...
            )...
        )
    
        %% changes for the new data
        changes = struct(...
            'amplification', struct(...
                'apply', false,...
                'value', 1 ...
            ),...
            'short', struct(...
                'apply', false,...
                'value', [0, 0] ...
            ),...
            'filters', struct(...
                'low', struct(...
                    'apply', false,...
                    'lim', 0 ...
                ),...
                'high', struct(...
                    'apply', false,...
                    'lim', 0 ...
                ),...
                'band', struct(...
                    'apply', false,...
                    'lims', [0, 0] ...
                ),...
                'stop', struct(...
                    'apply', false,...
                    'lim', [0, 0] ...
                )...
            )...
        )
        
    end
    
    %% methods
    methods
        
        %% constructor
        function obj = SignalRecord(name, duration, ydata , fdata, ddata)
            obj.name = name;
            obj.originalData.duration = duration;
            
            if exist('ydata','var')
                obj.originalData.ydata = ydata;
            end
            
            if exist('fdata','var')
                obj.originalData.fdata = fdata;
            end
            
            if exist('ddata','var')
                obj.originalData.ddata = ddata;
            end
        end
        
        %% setters
        function obj = setOriginalYData(obj, y, Fs, t)
            if ~exist('t','var')
                t = linspace(0, obj.duration, length(y));
            end
            
            data.y = y;
            data.Fs = Fs;
            data.t = t;
            
            obj.originalData.ydata = data;
        end
        
        function obj = setOriginalFData(obj, y, F)
            data.y = y;
            data.F = F;
            
            obj.originalData.fdata = data;
        end
        
        function obj = setOriginalDData(obj, y, Fs, t)
            data.y = y;
            data.Fs = Fs;
            data.t = t;
            
            obj.originalData.ddata = data;
        end
        
        function obj = setNewYData(obj, y, Fs, t)
            if ~exist('t','var')
                t = linspace(0, obj.duration, length(y));
            end
            
            data.y = y;
            data.Fs = Fs;
            data.t = t;
            
            obj.newData.ydata = data;
        end
        
        function obj = setNewFData(obj, y, F)
            data.y = y;
            data.F = F;
            
            obj.newData.fdata = data;
        end
        
        function obj = setNewDData(obj, y, Fs, t)
            data.y = y;
            data.Fs = Fs;
            data.t = t;
            
            obj.newData.ddata = data;
        end
        
        %% getters
        function [y, t, Fs] = getOriginalYData(obj)
            y = obj.originalData.ydata.y;
            t = obj.originalData.ydata.t;
            Fs = obj.originalData.ydata.Fs;
        end
        
        function [y, F] = getOriginalFData(obj)
            y = obj.originalData.fdata.y;
            F = obj.originalData.fdata.F;
        end
        
        function [y, t, Fs] = getOriginalDData(obj)
            y = obj.originalData.ddata.y;
            t = obj.originalData.ddata.t;
            Fs = obj.originalData.ddata.Fs;
        end
        
        function [y, t, Fs] = getNewYData(obj)
            y = obj.newData.ydata.y;
            t = obj.newData.ydata.t;
            Fs = obj.newData.ydata.Fs;
        end
        
        function [y, F] = getNewFData(obj)
            y = obj.newData.fdata.y;
            F = obj.newData.fdata.F;
        end
        
        function [y, t, Fs] = getNewDData(obj)
            y = obj.newData.ddata.y;
            t = obj.newData.ddata.t;
            Fs = obj.newData.ddata.Fs;
        end
        
        %% others
        % Fourier analisis
        function obj = applyFourierAnalysis(obj)
            
        end
        
        function obj = createFourierAnalysis(obj)
            
        end
        
        function obj = fourierAnalysis(obj)
            
        end
        
        % Wave functions
        
        
    end
end

