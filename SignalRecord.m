classdef SignalRecord
    
    %% props
    properties
        % general props
        name = ''
        
        % original data structure
        originalSignal = struct(...
            'duration', 0,...
            'signal', struct(...
                'Fs', 0,...
                'y', [0],...
                't', [0]...
            ),...
            'fourier', struct(...
                'apply', false,...
                'F', [0],...
                'y', [0]...
            ),...
            'discreet', struct(...
                'apply', false,...
                'Fs', 0,...
                'y', [0],...
                't', [0]...
            )...
        )
    
        % new data structure
        modifiedSignal = struct(...
            'duration', 0,...
            'signal', struct(...
                'Fs', 0,...
                'y', [0],...
                't', [0]...
            ),...
            'fourier', struct(...
                'F', [0],...
                'y', [0]...
            ),...
            'discreet', struct(...
                'Fs', 0,...
                'y', [0],...
                't', [0]...
            )...
        )
    
         % changes for the new data
        amplification = struct(...
            'multiplier_A', 0, ...
            'multiplier_F', 0, ...
            'begin', 0, ...
            'finish', 0, ...
            'max_A', 0, ...
            'min_A', 0 ...
        )
        
        %% filters
        filters = struct(...
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
                'lims', [0, 0] ...
            )...
        )
        
    end
    
    %% methods
    methods
        
        %% constructor
        function obj = SignalRecord(name, y, Fs)
            obj.name = name;
            obj = obj.setOriginalSignal(y, Fs);
        end
        
        function setAll(originalSignal, modifiedSignal, modifications, filters)
            if exist('originalSignal','var')
                obj.originalSignal = originalSignal;
            end
            
            if exist('modifiedSignal','var')
                obj.modifiedSignal = modifiedSignal;
            end
           
            if exist('modifications','var')
                obj.modifications = modifications;
            end
            
            if exist('filters','var')
                obj.filters = filters;
            end
        end
        
        %% hooks
        function obj = Initialization(obj)
            obj = obj.Initializing();
            obj = obj.CleanState();
        end
        
        function obj = CleanState(obj)
            obj = obj.CleaningState();
            obj = obj.StateChange();
        end
        
        function obj = StateChange(obj)
            obj = obj.Amplify();
        end
        
        function obj = Amplify(obj)
            obj = obj.Amplifying();
            obj = obj.Filter();
        end
        
        function obj = Filter(obj)
            obj = obj.Filtering();
            obj = obj.Analyze();
        end
        
        function obj = Analyze(obj)
            obj = obj.Analyzing();
        end
        
        %% hooks process
        function obj = Initializing(obj)
        end
        
        function obj = CleaningState(obj)
            [y, t, Fs] = obj.getOriginalSignal();
            
            obj = obj.setModifiedSignal(y, Fs);
            
            finish = obj.originalSignal.duration;
            max_A = max(y);
            min_A = min(y);
            
            obj = obj.setAmplification(1, 1, 0, finish, max_A, min_A);
        end
        
        function obj = Amplifying(obj)
            obj = obj.updateAmplify();
        end
        
        function obj = Filtering(obj)
            obj = obj.updateFilter();
        end
        
        function obj = Analyzing(obj)
            obj = obj.updateAnalysis();
        end
        
        %% setters
        function obj = setOriginalSignal(obj, y, Fs)
            duration = length(y) / Fs;
            t = linspace(0, duration, length(y));
            
            signal.Fs = Fs;
            signal.y = y;
            signal.t = t;
            
            obj.originalSignal.duration = duration;
            obj.originalSignal.signal = signal;
            
            obj = obj.Initialization();
        end
        
        function obj = setOriginalFourier(obj, apply, y, F)
            fourier.apply = apply;
            fourier.y = y;
            fourier.F = F;
            
            obj.originalSignal.fourier = fourier;
        end
        
        function obj = setOriginalDiscreet(obj, apply, y, Fs, t)
            discreet.apply = apply;
            discreet.y = y;
            discreet.Fs = Fs;
            discreet.t = t;
            
            obj.originalSignal.discreet = discreet;
        end
        
        function obj = setModifiedSignal(obj, y, Fs)
            duration = length(y) / Fs;
            t = linspace(0, duration, length(y));
            
            signal.Fs = Fs;
            signal.y = y;
            signal.t = t;
            
            obj.modifiedSignal.duration = duration;
            obj.modifiedSignal.signal = signal;
        end
        
        function obj = setModifiedFourier(obj, y, F)
            fourier.y = y;
            fourier.F = F;
            
            obj.modifiedSignal.fourier = fourier;
        end
        
        function obj = setModifiedDiscreet(obj, y, Fs, t)
            discreet.y = y;
            discreet.Fs = Fs;
            discreet.t = t;
            
            obj.modifiedSignal.discreet = discreet;
        end
        
        function obj = setAmplification(obj, multiplier_A, multiplier_F, begin, finish, max_A, min_A)
            obj.amplification.multiplier_A = multiplier_A;
            obj.amplification.multiplier_F = multiplier_F;
            obj.amplification.begin = begin;
            obj.amplification.finish = finish;
            obj.amplification.max_A = max_A;
            obj.amplification.min_A = min_A;
        end
        
        %% getters
        function [y, t, Fs] = getOriginalSignal(obj)
            y = obj.originalSignal.signal.y;
            t = obj.originalSignal.signal.t;
            Fs = obj.originalSignal.signal.Fs;
        end
        
        function [apply, y, F] = getOriginalFourier(obj)
            apply = obj.originalSignal.fourier.apply;
            y = obj.originalSignal.fourier.y;
            F = obj.originalSignal.fourier.F;
        end
        
        function [apply, y, t, Fs] = getOriginalDiscreet(obj)
            apply = obj.originalSignal.discreet.apply;
            y = obj.originalSignal.discreet.y;
            t = obj.originalSignal.discreet.t;
            Fs = obj.originalSignal.discreet.Fs;
        end
        
        function [y, t, Fs] = getModifiedSignal(obj)
            y = obj.modifiedSignal.signal.y;
            t = obj.modifiedSignal.signal.t;
            Fs = obj.modifiedSignal.signal.Fs;
        end
        
        function [y, F] = getModifiedFourier(obj)
            y = obj.modifiedSignal.fourier.y;
            F = obj.modifiedSignal.fourier.F;
        end
        
        function [y, t, Fs] = getModifiedDiscreet(obj)
            y = obj.modifiedSignal.discreet.y;
            t = obj.modifiedSignal.discreet.t;
            Fs = obj.modifiedSignal.discreet.Fs;
        end
        
        function [multiplier_A, multiplier_F, begin, finish, max_A, min_A] = getAmplification(obj)
            multiplier_A = obj.amplification.multiplier_A;
            multiplier_F = obj.amplification.multiplier_F;
            begin = obj.amplification.begin;
            finish = obj.amplification.finish;
            max_A = obj.amplification.max_A;
            min_A = obj.amplification.min_A;
        end
        
        function [low, high, band, stop] = getFilters(obj)
            filters = obj.filters;
            
            low = filters.low;
            high = filters.high;
            band = filters.band;
            stop = filters.stop;    
        end
        
        %% Amplify Signal
        function obj = applyAmplify(obj, multiplier_A, multiplier_F, begin, finish, max_A, min_A)
            obj = obj.setAmplification(multiplier_A, multiplier_F, begin, finish, max_A, min_A);
            obj = obj.StateChange();
        end
        
        function obj = updateAmplify(obj)
            [y, t, Fs] = obj.getOriginalSignal();
            [multiplier_A, multiplier_F, begin, finish, max_A, min_A] = obj.getAmplification();
            
            newy = y * multiplier_A;
            newt = t / multiplier_F;
            
            li = newt >= begin;
            ls = newt <= finish;
            lims_arr = li .* ls;
            
            ypre = [];
            tres = [];
            
            for i = 1:length(lims_arr)
                if lims_arr(i) == true
                    ypre(end + 1) = newy(i);
                    tres(end + 1) = newt(i);
                end
            end
            
            yres = [];
            
            for i = ypre
                if i > max_A
                    yres(end + 1) = max_A;
                elseif i < min_A
                    yres(end + 1) = min_A;
                else
                    yres(end + 1) = i;
                    
                end
            end
            
            newFs = Fs * multiplier_F;

            obj = obj.setModifiedSignal(yres, newFs);
        end
        
        %% Analyze Signal
        function obj = updateAnalysis(obj)
            [fourier, ~, ~] = getOriginalFourier(obj);
            [discreet, ~, ~, ~] = getOriginalDiscreet(obj);
            
            if fourier == true
                obj = obj.updateFourierAnalisys();
            end
            if discreet == true
                obj = obj.updateDiscreetAnalisys();
            end
        end
        
        % Fourier analysis
        function [y, F] = fourierAnalysis(~, x, Fs)
            Y = fft(x);
            L = length(x);
            
            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            
            F = Fs*(0:(L/2))/L;
            y = P1;
        end
        
        function obj = applyFourierAnalisys(obj, apply)
            [y, t, Fs] = obj.getOriginalSignal();
            
            if apply == true
                [yf, F] = obj.fourierAnalysis(y, Fs);
                obj = obj.setOriginalFourier(true, yf, F);
            else
                obj = obj.setOriginalFourier(false, [0], [0]);
                obj = obj.setModifiedFourier([0], [0]);
            end 
            
            obj = obj.StateChange();
        end
        
        function obj = updateFourierAnalisys(obj)
            [y, t, Fs] = obj.getModifiedSignal();
            
            [yf, F] = obj.fourierAnalysis(y, Fs);
            obj = obj.setModifiedFourier(yf, F); 
            
        end
        
        % Discreet analysis
        function [y, F] = discreetAnalysis(~, x, Fs)
            Y = fft(x);
            L = length(x);
            
            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            
            F = Fs*(0:(L/2))/L;
            y = P1;
        end
        
        function obj = applyDiscreetAnalisys(obj, apply)
            [y, t, Fs] = obj.getOriginalSignal();
            
            if apply == true
                [yf, F] = obj.fourierAnalysis(y, Fs);
                obj = obj.setOriginalFourier(true, yf, F);
                obj = obj.updateFourierAnalisys();
            else
                obj = obj.setOriginalFourier(false, [0], [0]);
                obj = obj.setModifiedFourier([0], [0]);
            end   
            
        end
        
        function obj = updateDiscreetAnalisys(obj)
            [y, t, Fs] = obj.getModifiedSignal();
            
            [yf, F] = obj.fourierAnalysis(y, Fs);
            obj = obj.setModifiedFourier(yf, F); 
            
        end
        
        %% Filters
        function obj = updateFilter(obj)
            [low, high, band, stop] = getFilters(obj);
            
            if low.apply == true
                obj = obj.updateLowPassFilter();
            end
            if high.apply == true
                obj = obj.updateHighPassFilter();
            end
            if band.apply == true
                obj = obj.updateBandPassFilter();
            end
            if stop.apply == true
                obj = obj.updateBandStopFilter();
            end
        end
        
        % lowpass
        function obj = applyLowPassFilter(obj, apply, lim)
            obj.filters.low.apply = apply;
            
            if apply == true
                obj.filters.low.lim = lim;
            else
                obj.filters.low.lim = 0;
            end
            
            obj = obj.StateChange()
        end
        
        function obj = updateLowPassFilter(obj)
            lim = obj.filters.low.lim;
            
            [y, t, Fs] = obj.getModifiedSignal();
            
            Y = lowpass(y, lim, Fs);
            
            obj = obj.setModifiedSignal(Y, Fs);
        end
        
        % highpass
        function obj = applyHighPassFilter(obj, apply, lim)
            obj.filters.high.apply = apply;
            
            if apply == true
                obj.filters.high.lim = lim;
            else
                obj.filters.high.lim = 0;
            end
            
            obj.StateChange()
        end
        
        function obj = updateHighPassFilter(obj)
            lim = obj.filters.high.lim;
            
            [y, t, Fs] = obj.getModifiedSignal();
            
            Y = bandpass(y, lim, Fs);
            
            obj = obj.setModifiedSignal(Y, Fs);
        end
        
        % bandpass
        function obj = applyBandPassFilter(obj, apply, lims)
            obj.filters.band.apply = apply;
            
            if apply == true
                obj.filters.band.lims = lims;
            else
                obj.filters.stop.lims = [0 0];
            end
            
            obj.StateChange()
        end
        
        function obj = updateBandPassFilter(obj)
            lims = obj.filters.band.lims;
            
            [y, t, Fs] = obj.getModifiedSignal();
            
            Y = bandpass(y, lims, Fs);
            
            obj = obj.setModifiedSignal(Y, Fs);
        end
        
        % bandpass
        function obj = applyBandStopFilter(obj, apply, lims)
            obj.filters.high.apply = apply;
            
            if apply == true
                obj.filters.high.lims = lims;
            else
                obj.filters.high.lims = [0 0];
            end
            
            obj.StateChange() 
        end
        
        function obj = updateBandStopFilter(obj)
            lims = obj.filters.band.lims;
            
            [y, t, Fs] = obj.getModifiedSignal();
            
            Y = bandstop(y, lims, Fs);
            
            obj = obj.setModifiedSignal(Y, Fs);
        end
    end
end

