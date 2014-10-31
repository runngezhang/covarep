% Harmonic Model + Phase Distortion (HMPD)
%
% Copyright (c) 2013 University of Crete - Computer Science Department(UOC-CSD)/ 
%                    Foundation for Research and Technology-Hellas - Institute
%                    of Computer Science (FORTH-ICS)
%
% License
%  This file is under the LGPL license,  you can
%  redistribute it and/or modify it under the terms of the GNU Lesser General 
%  Public License as published by the Free Software Foundation, either version 3 
%  of the License, or (at your option) any later version. This file is
%  distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
%  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
%  PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
%  details.
%
% This function is part of the Covarep project: http://covarep.github.io/covarep
%
% Author
%  Gilles Degottex <degottex@csd.uoc.gr>
%

% Smooth the PD, which is similar to computing its local trend
function PD = hmpd_phase_smooth(PD, nbat)

    winlen = round(nbat/2)*2+1;
    win = hann(winlen);
    win = win./sum(win);

    % Smooth the values in polar coordinates
    PDc = cos(PD);
    PDs = sin(PD);

    % Apply first a median filter:
    % Because: i) The glottal pulse is not supposed to drastically change from
    %             one frame to the next.
    %         ii) It keeps the outliers in the residual phase, which optimize
    %             the variance measurement.
    PDc = medfilt1(PDc, winlen, [], 1); % TODO mentionned in the publications ???
    PDs = medfilt1(PDs, winlen, [], 1);

    % Then smooth the steps of the median filter
    PDc = filtfilt(win, 1, PDc);
    PDs = filtfilt(win, 1, PDs);

    % Move back to radians
    PD = atan2(PDs, PDc);

return
