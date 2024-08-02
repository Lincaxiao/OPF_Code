function [TorF, vstr, rdate] = have_feature_optimoptions()
% have_feature_optimoptions - Detect availability/version info for :func:`optimoptions`.
%
% Private feature detection function implementing ``'optimoptions'`` tag for
% have_feature to detect support for :func:`optimoptions`, option setting
% function for MATLAB Optimization Toolbox 6.3 and later.
%
% See also have_feature, have_feature_optim, optimoptions.

%   MP-Opt-Model
%   Copyright (c) 2004-2024, Power Systems Engineering Research Center (PSERC)
%   by Ray Zimmerman, PSERC Cornell
%
%   This file is part of MP-Opt-Model.
%   Covered by the 3-clause BSD License (see LICENSE file for details).
%   See https://github.com/MATPOWER/mp-opt-model for more info.

TorF = 0;
vstr = '';
rdate = '';
if have_feature('matlab')
    v = have_feature('optim', 'all');
    if v.av && v.vnum >= 6.003      %% Opt Tbx 6.3+ (R2013a+, MATLAB 8.1+)
        TorF = 1;
        vstr = v.vstr;
        rdate = v.date;
    end
end
