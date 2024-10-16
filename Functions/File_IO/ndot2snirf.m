function ndot2snirf(filename, output, full, type)
% Converter from NeuroDOT data and info structure to SNIRF data and
% metadata structures.
%
% ndot2snirf(filename,output,full,type) takes a file with the '.mat' 
% extension in NeuroDOT format and converts it to the SNIRF format. 

% 'Filename' is the name of the file to be converted, followed by the 
% .mat extension.

% 'Output' is the filename (without extension) to be saved in SNIRF
% format. Output files are saved as '.snirf.' 
% 'Full' is an optional input, '1' stores additional information stored in
% NeuroDOT data as additional metaDataTags in the SNIRF output
% 'Type' is an optional input - the only currently acceptable value for this field is 'snirf.'%
%
% Copyright (c) 2017 Washington University 
% Created By: Emma Speh
% Eggebrecht et al., 2014, Nature Photonics; Zeff et al., 2007, PNAS.
%
% Washington University hereby grants to you a non-transferable, 
% non-exclusive, royalty-free, non-commercial, research license to use 
% and copy the computer code that is provided here (the Software).  
% You agree to include this license and the above copyright notice in 
% all copies of the Software.  The Software may not be distributed, 
% shared, or transferred to any third party.  This license does not 
% grant any rights or licenses to any other patents, copyrights, or 
% other forms of intellectual property owned or controlled by Washington 
% University.
% 
% YOU AGREE THAT THE SOFTWARE PROVIDED HEREUNDER IS EXPERIMENTAL AND IS 
% PROVIDED AS IS, WITHOUT ANY WARRANTY OF ANY KIND, EXPRESSED OR 
% IMPLIED, INCLUDING WITHOUT LIMITATION WARRANTIES OF MERCHANTABILITY 
% OR FITNESS FOR ANY PARTICULAR PURPOSE, OR NON-INFRINGEMENT OF ANY 
% THIRD-PARTY PATENT, COPYRIGHT, OR ANY OTHER THIRD-PARTY RIGHT.  
% IN NO EVENT SHALL THE CREATORS OF THE SOFTWARE OR WASHINGTON 
% UNIVERSITY BE LIABLE FOR ANY DIRECT, INDIRECT, SPECIAL, OR 
% CONSEQUENTIAL DAMAGES ARISING OUT OF OR IN ANY WAY CONNECTED WITH 
% THE SOFTWARE, THE USE OF THE SOFTWARE, OR THIS AGREEMENT, WHETHER 
% IN BREACH OF CONTRACT, TORT OR OTHERWISE, EVEN IF SUCH PARTY IS 
% ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

%% Parameters and Initialization
if ~exist('full','var')
    full = 0;
end

if ~exist('type','var') || numel(type) == 0
    type = 'snirf';
end

if ~exist('output','var')
    output = filename;
end

% Load NeuroDOT file
load(filename); % Load data and info


%% Create SNIRF Data and Metadata Structures
if strcmp(type , 'snirf')
    snf = snirfcreate;
    snf.nirs.conversionProgram = 'ndot2snirf';
    if exist('data','var')
        snf.nirs.data.dataTimeSeries = data'; 
    end
        if exist('info','var')   
            % Set time, length, and frequency units
            if isfield(info, 'misc')
                if isfield(info.misc, 'time')
                    snf.nirs.data.time = info.misc.time;
                end
                if isfield(info.misc, 'TimeUnit')
                    snf.nirs.metaDataTags.TimeUnit = info.misc.TimeUnit;
                end
                if isfield(info.misc, 'LengthUnit')
                    snf.nirs.metaDataTags.LengthUnit = info.misc.LengthUnit;
                end
                if isfield(info.misc, 'FrequencyUnit')
                    snf.nirs.metaDataTags.FrequencyUnit = info.misc.FrequencyUnit;
                end
            else
                snf.nirs.metaDataTags.TimeUnit = 's'; 
                snf.nirs.metaDataTags.LengthUnit = 'mm';
                snf.nirs.metaDataTags.FrequencyUnit = 'Hz';
                T = 1/info.system.framerate;
                nTp = size(snf.nirs.data.dataTimeSeries,1);
                snf.nirs.data.time = (1:nTp)*T;
            end
            
            
        %% info.io
        if isfield(info, 'io')
            if isfield(info.io, 'Nd')
                if full == 1
                    snf.nirs.metaDataTags.Nd = info.io.Nd; %custom NeuroDOT field
                end
            end
            if isfield(info.io, 'Ns')
                if full == 1
                    snf.nirs.metaDataTags.Ns = info.io.Ns; %custom NeuroDOT field
                end
            end
            if isfield(info.io, 'Nwl')
                if full == 1
                    snf.nirs.metaDataTags.Nwl = info.io.Nwl; %custom NeuroDOT field
                end
            end
            if isfield(info.io, 'comment')
                if full == 1
                    snf.nirs.metaDataTags.comment = info.io.comment; %custom NeuroDOT field
                end
            end
            if isfield(info.io, 'a')
                snf.nirs.metaDataTags.MeasurementDate = info.io.a.date; %required snirf field
            end
            if isfield(info.io, 'date')
                snf.nirs.metaDataTags.MeasurementDate = info.io.date; %required snirf field
            else
                snf.nirs.metaDataTags.MeasurementDate = 'n/a'; %required snirf field
            end
            if isfield(info.io, 'enc')
                if full ==1
                    snf.nirs.metaDataTags.enc = info.io.enc; %custom NeuroDOT field
                end
            end
            if isfield(info.io, 'framesize')
                if full == 1
                    snf.nirs.metaDataTags.framesize = info.io.framesize; %custom NeuroDOT field
                end
            end
            if isfield(info.io, 'naux')
                if full == 1
                    snf.nirs.metaDataTags.naux = info.io.naux; %custom NeuroDOT field
                end
            end
            if isfield(info.io, 'nblank')
                if full == 1
                    snf.nirs.metaDataTags.nblank = info.io.nblank; %custom NeuroDOT field
                end
            end
            if isfield(info.io, 'nframe')
                if full == 1
                    snf.nirs.metaDataTags.nframe = info.io.nframe; %custom NeuroDOT field
                end
            end
            if isfield(info.io, 'nmotu')
                if full == 1
                    snf.nirs.metaDataTags.nmotu = info.io.nmotu; %custom NeuroDOT field
                end
            end
            if isfield(info.io, 'nsamp')
                if full == 1
                    snf.nirs.metaDataTags.nsamp = info.io.nsamp; %custom NeuroDOT field
                end
            end
            if isfield(info.io, 'nts')
                if full == 1
                    snf.nirs.metaDataTags.nts = info.io.nts; %custom NeuroDOT field
                end
            end
            if isfield(info.io, 'pad')
                if full == 1
                    snf.nirs.metaDataTags.pad = info.io.pad; %custom NeuroDOT field
                end
            end
            if isfield(info.io, 'run')
                if full == 1
                    snf.nirs.metaDataTags.run = info.io.run; %custom NeuroDOT field
                end
            end
            if isfield(info.io, 'a')
                if isfield(info.io.a, 'time')
                    snf.nirs.metaDataTags.MeasurementTime = info.io.a.time; %required Snirf field
                else
                    snf.nirs.metaDataTags.MeasurementTime = info.io.a.start_time;
                end
            end
            if isfield(info.io, 'time')
                snf.nirs.metaDataTags.MeasurementTime = info.io.time; %required Snirf field
            end
            if isfield(info.io, 'tag')
                if full == 1
                    snf.nirs.metaDataTags.tag = info.io.tag; %custom NeuroDOT field
                end
            end
            if isfield(info.io, 'unix_time')
                snf.nirs.metaDataTags.UnixTime = info.io.unix_time; %optional Snirf field
            end
            if isfield(info.io, 'Nt')
                if full == 1
                    snf.nirs.metaDataTags.Nt = info.io.Nt; %custom NeuroDOT field
                end
            end
        end
                
        
        %% info.optodes
        if isfield(info,'optodes')
            if isfield(info.optodes,'CapName')
                if full == 1
                    snf.nirs.metaDataTags.CapName = info.optodes.CapName; %custom NeuroDOT field
                end
            end
            if isfield(info.optodes,'dpos2')
                snf.nirs.probe.detectorPos2D = info.optodes.dpos2; %required Snirf/Ndot field
            end
            if isfield(info.optodes,'dpos3')
                snf.nirs.probe.detectorPos3D = info.optodes.dpos3;%required Snirf/Ndot field
            end
            if isfield(info.optodes,'spos2')
                snf.nirs.probe.sourcePos2D = info.optodes.spos2; %required Snirf/Ndot field
            end
            if isfield(info.optodes,'spos3')
                snf.nirs.probe.sourcePos3D = info.optodes.spos3;%required Snirf/Ndot field
            end
        end
        
        
        %% info.pairs
        if istable(info.pairs)
            info.pairs = table2struct(info.pairs, 'ToScalar', true);
        end
        if isfield(info,'pairs')
            if isfield(info.pairs, 'Src')
                snf.nirs.data.measurementLists.sourceIndex = info.pairs.Src; %required Snirf/Ndot field
            end
            if isfield(info.pairs, 'Det')
                snf.nirs.data.measurementLists.detectorIndex = info.pairs.Det; %required Snirf/Ndot field
            end
            if isfield(info.pairs, 'WL')
                snf.nirs.data.measurementLists.wavelengthIndex = info.pairs.WL; %required Snirf/Ndot field
            end
            if isfield(info.pairs, 'Mod')
                snf.nirs.data.measurementLists.Mod = cellstr(info.pairs.Mod(:)); %required Snirf/Ndot field
            end
            if isfield(info.pairs, 'lambda')
                snf.nirs.data.measurementLists.wavelengthActual = info.pairs.lambda;
                snf.nirs.probe.wavelengths = [unique(info.pairs.lambda)]; %required Snirf/Ndot field
            end
        end
        
        % Remove measurementList to avoid confusion with measurementLists
        if isfield(snf.nirs.data,'measurementList')
            snf.nirs.data = rmfield(snf.nirs.data,'measurementList');
        end

          %% info.system
        if ~isfield(info, 'system')
            info.system = struct('framerate',[],'init_framerate',[],'Padname',[]);
        end
        if isfield(info.system, 'framerate')  
            T = 1/info.system.framerate;
            nTp = size(snf.nirs.data.dataTimeSeries,1);
            timeArray = (1:nTp)*T;
            snf.nirs.data.time = timeArray; % required snirf field
            snf.nirs.metaDataTags.framerate = info.system.framerate;
        else
            snf.nirs.data.time = [1:length(data)]'.*1; %required snirf field
        end
        
        if isfield(info.system, 'PadName')
            snf.nirs.metaDataTags.PadName = info.system.PadName;
        end        
        
        
        %% info.paradigm
        if isfield(info, 'paradigm')    % Updated 11/16/22 to format stim(i) according to specifications
            % [start duration value] : format for snirf stim(i).data
                fields = fieldnames(info.paradigm);
                idxPulse = ismember(cellfun(@(x) x(1:6), fields, 'UniformOutput', false), 'Pulse_');
                pulses = fields(idxPulse);
                k = 0;
                if isfield(info, 'misc')
                    if isfield(info.misc, 'stimDuration')
                        dur = info.misc.stimDuration;
                    else
                        dur =repmat(1, [length(pulses),1]); 
                    end
                else
                    if isfield(info.paradigm, 'Pulse_2') & isfield(info.paradigm, 'Pulse_1')
                        difference = diff(info.paradigm.synchpts);
                        difference = difference(2:length(difference));
                        temp_1 = info.paradigm.Pulse_1(2:length(info.paradigm.Pulse_1));
                        temp_1 = temp_1 - 2;
                        dur = [round(difference(1)./info.system.framerate), round(mean(difference(temp_1))./info.system.framerate)];
                    else
                        difference = diff(info.paradigm.synchpts);
                        dur = [round(mean(difference))./info.system.framerate];
                    end
                end
                for i = 1: length(pulses)
                    k = k + 1;
                    if ~isfield(info.paradigm, 'synchtype')
                        info.paradigm.synchtype = zeros(length(info.paradigm.synchpts),1);
                        for j = 1: length(pulses)
                            info.paradigm.synchtype((info.paradigm.([pulses{j}]))) = j;
                        end
                        info.paradigm.synchtype = info.paradigm.synchtype';
                    end
                    if isfield(info.paradigm, pulses{i})
                        info.paradigm.synchtimes = info.paradigm.synchpts./info.system.framerate;
                        np = length(info.paradigm.synchtimes(info.paradigm.([pulses{i}])));
                        if size(info.paradigm.synchtimes,2) > 1
                            info.paradigm.synchtimes = info.paradigm.synchtimes';
                        end
                        if size(info.paradigm.synchtype,2) > 1
                            info.paradigm.synchtype = info.paradigm.synchtype';
                        end
                        snf.nirs.stim(k).data = [info.paradigm.synchtimes(info.paradigm.([pulses{i}])),repmat(dur(i),1, np)',info.paradigm.synchtype(info.paradigm.([pulses{i}]))]; 
                        snf.nirs.stim(k).name = num2str(i);
                    end
                        if isfield(info,'io')
                            if isfield(info.io, 'a')
                                snf.nirs.stim(1).name = 'rest';
                                if strcmp(info.io.a.tag, 'resta')
                                    info.io.a.tag = 'rest';   
                                end
                             
                            else
                                if isfield(info.io, 'tag')
                                    snf.nirs.stim(1).name = 'rest';
                                end
                            end
                        end
                end
        end

        
 
        %% info.misc
        if ~isfield(info, 'misc')
            snf.nirs.metaDataTags.SubjectID = 'n/a'; %required snirf field
        else
            if ~isfield(info.misc, 'subject_id')
                snf.nirs.metaDataTags.SubjectID = 'n/a';
            else
                snf.nirs.metaDataTags.SubjectID = info.misc.subject_id;
            end
            if isfield(info.misc,'aux')
                snf.nirs.aux = info.misc.aux;
            end
        end
        end
        
    %% Aux
    if length(snf.nirs.aux.time) == 0
        snf.nirs.aux.name = 0;
        snf.nirs.aux.dataTimeSeries =0;
        snf.nirs.aux.time = 0;
        snf.nirs.aux.timeOffset = 0;
    end
    %% Create Remaining Required SNIRF measurementLists Fields
    snf.nirs.data.measurementLists.dataTypeIndex = repmat([0], size(data,1),1); % 0 
    snf.nirs.data.measurementLists.dataType = repmat([001], size(data,1),1);    % required Snirf field
    
    
    %% Save Output .snirf file
    [p,f,e]=fileparts(output);
    outputfilename=fullfile(p,f);
    % 'snf' must be a snirf structure containing {'formatVersion','nirs'} subfields
    savesnirf(snf, [outputfilename,'.snirf']);   
    
end
end


