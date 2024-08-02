classdef net_model_acp < mp.net_model_ac & mp.form_acp
% mp.net_model_acp - Concrete class for |MATPOWER| AC polar **network model** objects.
%
% This network model class and all of its network model element classes are
% specific to the AC polar formulation and therefore inherit from mp.form_acp.
%
% mp.net_model_acp Properties:
%   * va - vector of angles of complex voltage state variables, :math:`\va`
%   * vm - vector of magnitudes of complex voltage state variables, :math:`\vm`
%
% mp.net_model_acp Methods:
%   * net_model_acp - constructor, assign default network model element classes
%   * def_set_types - add voltage state variable set types for mp_idx_manager
%   * initial_voltage_angle - get vector of initial node voltage angles
%
% See also mp.net_model_ac, mp.net_model, mp.form_acp, mp.form_ac, mp.form,
% mp.nm_element.

%   MATPOWER
%   Copyright (c) 2019-2024, Power Systems Engineering Research Center (PSERC)
%   by Ray Zimmerman, PSERC Cornell
%
%   This file is part of MATPOWER.
%   Covered by the 3-clause BSD License (see LICENSE file for details).
%   See https://matpower.org for more info.

    properties
        va = [];
        vm = [];
    end

    methods
        function obj = net_model_acp()
            % Constructor, assign default network model element classes.
            % ::
            %
            %   nm = net_model_acp()
            %
            % This network model class and all of its network model element
            % classes are specific to the AC polar formulation and therefore
            % inherit from mp.form_acp.

            obj@mp.net_model_ac();
            obj.element_classes = ...
                { @mp.nme_bus_acp, @mp.nme_gen_acp, @mp.nme_load_acp, ...
                    @mp.nme_branch_acp, @mp.nme_shunt_acp };

            %% Due to a bug related to inheritance in constructors in
            %% Octave 5.2 and earlier (https://savannah.gnu.org/bugs/?52614),
            %% INIT_SET_TYPES() cannot be called directly in the
            %% MP_IDX_MANAGER constructor, as desired.
            %%
            %% WORKAROUND:  INIT_SET_TYPES() is called explicitly as needed
            %%              (if obj.node is empty) in BUILD() and DISPLAY(),
            %%              after object construction, but before object use.
        end

        function obj = def_set_types(obj)
            % Add voltage state variable set types for mp_idx_manager.
            % ::
            %
            %   nm.def_set_types()
            %
            % Add the following set types:
            %
            %   - ``'va'`` - VOLTAGE ANG VARS (va)
            %   - ``'vm'`` - VOLTAGE MAG VARS (vm)
            %
            % See also mp.net_model_ac.def_set_types,
            % mp.net_model.def_set_types, mp_idx_manager.

            def_set_types@mp.net_model_ac(obj);     %% call parent first
            obj.set_types.va = 'VOLTAGE ANG VARS (va)';
            obj.set_types.vm = 'VOLTAGE MAG VARS (vm)';
        end

        function va = initial_voltage_angle(obj, idx)
            % Get vector of initial node voltage angles.
            % ::
            %
            %   va = nm.initial_voltage_angle()
            %   va = nm.initial_voltage_angle(idx)
            %
            % Get vector of initial node voltage angles for all or a selected
            % subset of nodes.
            %
            % Input:
            %   idx (integer) : index of subset of voltages of interest;
            %       if missing or empty, include all
            %
            % Output:
            %   va (double) : vector of initial voltage angles

            va = obj.params_var('va');
            if nargin > 1 && ~isempty(idx)
                va = va(idx);
            end
        end
    end     %% methods
end         %% classdef
