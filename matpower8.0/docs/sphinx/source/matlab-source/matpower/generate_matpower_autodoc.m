function generate_matpower_autodoc(install_dir)
% generate_matpower_autodoc - Generate the stubs and symlinks for Ref Manual.
% ::
%
%   generate_matpower_autodoc(install_dir)
%
% Inputs:
%   install_dir (char array) : path to the install directory for the package
%
% Creates the .rst stubs and symlinks to the source files for all functions
% and classes to be included in the Reference Manual. Creates all of the
% inputs (lists of functions and classes) to pass to generate_autodoc_stubs
% and generate_source_symlinks.

%   MATPOWER
%   Copyright (c) 2023-2024, Power Systems Engineering Research Center (PSERC)
%   by Ray Zimmerman, PSERC Cornell
%
%   This file is part of MATPOWER.
%   Covered by the 3-clause BSD License (see LICENSE file for details).
%   See https://matpower.org for more info.

if nargin < 1
    matpower_dir = '~/dev/projects/matpower/';
end

sphinx_src_dir = [matpower_dir 'docs/sphinx/source/'];

lib_classes = { ...
    'mp_table', ...
    'mp_table_subclass', ...
};
lib_mp_classes = { ...
    'task', ...
    'task_pf', ...
    'task_cpf', ...
    'task_opf', ...
    'task_pf_legacy', ...
    'task_cpf_legacy', ...
    'task_opf_legacy', ...
    'task_shared_legacy', ...
    'dm_converter', ...
    'dm_converter_mpc2', ...
    'dm_converter_mpc2_legacy', ...
    'dmc_element', ...
    'dmce_branch_mpc2', ...
    'dmce_bus_mpc2', ...
    'dmce_gen_mpc2', ...
    'dmce_load_mpc2', ...
    'dmce_shunt_mpc2', ...
    'data_model', ...
    'data_model_cpf', ...
    'data_model_opf', ...
    'dm_element', ...
    'dme_branch', ...
    'dme_branch_opf', ...
    'dme_bus', ...
    'dme_bus_opf', ...
    'dme_gen', ...
    'dme_gen_opf', ...
    'dme_load', ...
    'dme_load_cpf', ...
    'dme_load_opf', ...
    'dme_shunt_cpf', ...
    'dme_shunt', ...
    'dme_shunt_opf', ...
    'dme_shared_opf', ...
    'form', ...
    'form_ac', ...
    'form_acc', ...
    'form_acp', ...
    'form_dc', ...
    'net_model', ...
    'net_model_ac', ...
    'net_model_acc', ...
    'net_model_acp', ...
    'net_model_dc', ...
    'nm_element', ...'
    'nme_branch_ac', ...
    'nme_branch_acc', ...
    'nme_branch_acp', ...
    'nme_branch_dc', ...
    'nme_branch', ...
    'nme_bus_acc', ...
    'nme_bus_acp', ...
    'nme_bus_dc', ...
    'nme_bus', ...
    'nme_gen_ac', ...
    'nme_gen_acc', ...
    'nme_gen_acp', ...
    'nme_gen_dc', ...
    'nme_gen', ...
    'nme_load_ac', ...
    'nme_load_acc', ...
    'nme_load_acp', ...
    'nme_load_dc', ...
    'nme_load', ...
    'nme_shunt_ac', ...
    'nme_shunt_acc', ...
    'nme_shunt_acp', ...
    'nme_shunt_dc', ...
    'nme_shunt', ...
    'math_model', ...
    'math_model_pf', ...
    'math_model_pf_ac', ...
    'math_model_pf_acci', ...
    'math_model_pf_accs', ...
    'math_model_pf_acpi', ...
    'math_model_pf_acps', ...
    'math_model_pf_dc', ...
    'math_model_cpf_acc', ...
    'math_model_cpf_acci', ...
    'math_model_cpf_accs', ...
    'math_model_cpf_acp', ...
    'math_model_cpf_acpi', ...
    'math_model_cpf_acps', ...
    'math_model_opf', ...
    'math_model_opf_ac', ...
    'math_model_opf_acc', ...
    'math_model_opf_acci', ...
    'math_model_opf_acci_legacy', ...
    'math_model_opf_accs', ...
    'math_model_opf_accs_legacy', ...
    'math_model_opf_acp', ...
    'math_model_opf_acpi', ...
    'math_model_opf_acpi_legacy', ...
    'math_model_opf_acps', ...
    'math_model_opf_acps_legacy', ...
    'math_model_opf_dc', ...
    'math_model_opf_dc_legacy', ...
    'mm_shared_pfcpf', ...
    'mm_shared_pfcpf_dc', ...
    'mm_shared_pfcpf_ac', ...
    'mm_shared_pfcpf_ac_i', ...
    'mm_shared_pfcpf_acc', ...
    'mm_shared_pfcpf_acci', ...
    'mm_shared_pfcpf_accs', ...
    'mm_shared_pfcpf_acp', ...
    'mm_shared_pfcpf_acpi', ...
    'mm_shared_pfcpf_acps', ...
    'mm_shared_opf_legacy', ...
    'mm_element', ...
    'mme_branch_opf_ac', ...
    'mme_branch_opf_acc', ...
    'mme_branch_opf_acp', ...
    'mme_branch_opf_dc', ...
    'mme_branch_opf', ...
    'mme_branch_pf_ac', ...
    'mme_branch_pf_dc', ...
    'mme_branch', ...
    'mme_bus_opf_ac', ...
    'mme_bus_opf_acc', ...
    'mme_bus_opf_acp', ...
    'mme_bus_opf_dc', ...
    'mme_bus_pf_ac', ...
    'mme_bus_pf_dc', ...
    'mme_bus', ...
    'mme_gen_opf_ac', ...
    'mme_gen_opf_dc', ...
    'mme_gen_opf', ...
    'mme_gen_pf_ac', ...
    'mme_gen_pf_dc', ...
    'mme_gen', ...
    'mme_load_cpf', ...
    'mme_load_pf_ac', ...
    'mme_load_pf_dc', ...
    'mme_load', ...
    'mme_shunt_cpf', ...
    'mme_shunt_pf_ac', ...
    'mme_shunt_pf_dc', ...
    'mme_shunt', ...
    'extension', ...
    'xt_reserves', ...
    'dmce_reserve_gen_mpc2', ...
    'dmce_reserve_zone_mpc2', ...
    'dme_reserve_gen', ...
    'dme_reserve_zone', ...
    'mme_reserve_gen', ...
    'mme_reserve_zone', ...
    'xt_3p', ...
    'dmce_bus3p_mpc2', ...
    'dmce_gen3p_mpc2', ...
    'dmce_load3p_mpc2', ...
    'dmce_line3p_mpc2', ...
    'dmce_xfmr3p_mpc2', ...
    'dmce_buslink_mpc2', ...
    'dme_bus3p', ...
    'dme_gen3p', ...
    'dme_load3p', ...
    'dme_line3p', ...
    'dme_xfmr3p', ...
    'dme_buslink', ...
    'dme_bus3p_opf', ...
    'dme_gen3p_opf', ...
    'dme_load3p_opf', ...
    'dme_line3p_opf', ...
    'dme_xfmr3p_opf', ...
    'dme_buslink_opf', ...
    'nme_bus3p', ...
    'nme_bus3p_acc', ...
    'nme_bus3p_acp', ...
    'nme_gen3p', ...
    'nme_gen3p_acc', ...
    'nme_gen3p_acp', ...
    'nme_load3p', ...
    'nme_line3p', ...
    'nme_xfmr3p', ...
    'nme_buslink', ...
    'nme_buslink_acc', ...
    'nme_buslink_acp', ...
    'mme_bus3p', ...
    'mme_gen3p', ...
    'mme_line3p', ...
    'mme_xfmr3p', ...
    'mme_buslink', ...
    'mme_buslink_pf_ac', ...
    'mme_buslink_pf_acc', ...
    'mme_buslink_pf_acp', ...
    'mme_bus3p_opf_acc', ...
    'mme_bus3p_opf_acp', ...
    'mme_gen3p_opf', ...
    'mme_line3p_opf', ...
    'mme_xfmr3p_opf', ...
    'mme_buslink_opf', ...
    'mme_buslink_opf_acc', ...
    'mme_buslink_opf_acp', ...
    'NODE_TYPE', ...
    'cost_table', ...
    'cost_table_utils', ...
    'element_container', ...
    'mapped_array', ...
};
lib_t_mp_classes = { ...
    'xt_legacy_dcline', ...
    'dmce_legacy_dcline_mpc2', ...
    'dme_legacy_dcline', ...
    'dme_legacy_dcline_opf', ...
    'nme_legacy_dcline', ...
    'nme_legacy_dcline_ac', ...
    'nme_legacy_dcline_acc', ...
    'nme_legacy_dcline_acp', ...
    'nme_legacy_dcline_dc', ...
    'mme_legacy_dcline', ...
    'mme_legacy_dcline_pf_ac', ...
    'mme_legacy_dcline_pf_dc', ...
    'mme_legacy_dcline_opf', ...
    'mme_legacy_dcline_opf_ac', ...
    'mme_legacy_dcline_opf_dc' ...
    'xt_oval_cap_curve', ...
    'mme_gen_opf_ac_oval', ...
};
lib_fcns = {
    'mp_table_class', ...
    'run_mp', ...
    'run_pf', ...
    'run_cpf', ...
    'run_opf', ...
};
lib_mp_fcns = {};
lib_t_fcns = {
    'test_matpower', ...
    't_mp_mapped_array', ...
    't_mp_table', ...
    't_mp_data_model', ...
    't_dmc_element', ...
    't_mp_dm_converter_mpc2', ...
    't_nm_element', ...
    't_port_inj_current_acc', ...
    't_port_inj_current_acp', ...
    't_port_inj_power_acc', ...
    't_port_inj_power_acp', ...
    't_node_test', ...
    't_run_mp', ...
    't_run_mp_3p', ...
    't_run_opf_default', ...
    't_pretty_print', ...
    't_mpxt_legacy_dcline', ...
    't_mpxt_reserves', ...
    't_case3p_a', ...
    't_case3p_b', ...
    't_case3p_c', ...
    't_case3p_d', ...
    't_case3p_e', ...
    't_case3p_f', ...
    't_case3p_g', ...
    't_case3p_h', ...
    't_case9_gizmo', ...
};
lib_t_classes = {
    'mp_foo_table', ...
};
lib_doc_fcns = {
    'generate_matpower_autodoc', ...
    'generate_autodoc_stubs', ...
    'generate_source_symlinks', ...
};
lib_legacy_classes = {
    '@opf_model', ...
};
lib_legacy_fcns = {
    'add_userfcn', ...
    'apply_changes', ...
    'bustypes', ...
    'calc_branch_angle', ...
    'calc_v_i_sum', ...
    'calc_v_pq_sum', ...
    'calc_v_y_sum', ...
    'case_info', ...
    'caseformat', ...
    'cdf2mpc', ...
    'compare_case', ...
    'connected_components', ...
    'cpf_corrector', ...
    'cpf_current_mpc', ...
    'cpf_default_callback', ...
    'cpf_detect_events', ...
    'cpf_flim_event', ...
    'cpf_flim_event_cb', ...
    'cpf_nose_event', ...
    'cpf_nose_event_cb', ...
    'cpf_p', ...
    'cpf_p_jac', ...
    'cpf_plim_event', ...
    'cpf_plim_event_cb', ...
    'cpf_predictor', ...
    'cpf_qlim_event', ...
    'cpf_qlim_event_cb', ...
    'cpf_register_callback', ...
    'cpf_register_event', ...
    'cpf_tangent', ...
    'cpf_target_lam_event', ...
    'cpf_target_lam_event_cb', ...
    'cpf_vlim_event', ...
    'cpf_vlim_event_cb', ...
    'd2Abr_dV2', ...
    'd2Ibr_dV2', ...
    'd2Imis_dV2', ...
    'd2Imis_dVdSg', ...
    'd2Sbr_dV2', ...
    'd2Sbus_dV2', ...
    'dAbr_dV', ...
    'dIbr_dV', ...
    'dImis_dV', ...
    'dSbr_dV', ...
    'dSbus_dV', ...
    'dcopf', ...
    'dcopf_solver', ...
    'dcpf', ...
    'define_constants', ...
    'e2i_data', ...
    'e2i_field', ...
    'ext2int', ...
    'extract_islands', ...
    'fdpf', ...
    'feval_w_path', ...
    'find_bridges', ...
    'find_islands', ...
    'fmincopf', ...
    'gausspf', ...
    'genfuels', ...
    'gentypes', ...
    'get_losses', ...
    'get_reorder', ...
    'hasPQcap', ...
    'have_feature_e4st', ...
    'have_feature_minopf', ...
    'have_feature_most', ...
    'have_feature_mp_core', ...
    'have_feature_pdipmopf', ...
    'have_feature_regexp_split', ...
    'have_feature_scpdipmopf', ...
    'have_feature_sdp_pf', ...
    'have_feature_smartmarket', ...
    'have_feature_syngrid', ...
    'have_feature_table', ...
    'have_feature_tralmopf', ...
    'i2e_data', ...
    'i2e_field', ...
    'idx_brch', ...
    'idx_bus', ...
    'idx_cost', ...
    'idx_ct', ...
    'idx_dcline', ...
    'idx_gen', ...
    'int2ext', ...
    'isload', ...
    'load2disp', ...
    'loadcase', ...
    'loadshed', ...
    'makeAang', ...
    'makeApq', ...
    'makeAvl', ...
    'makeAy', ...
    'makeB', ...
    'makeBdc', ...
    'makeJac', ...
    'makeLODF', ...
    'makePTDF', ...
    'makeSbus', ...
    'makeSdzip', ...
    'makeYbus', ...
    'make_vcorr', ...
    'make_zpv', ...
    'margcost', ...
    'miqps_matpower', ...
    'modcost', ...
    'mpoption', ...
    'mpoption_info_clp', ...
    'mpoption_info_cplex', ...
    'mpoption_info_fmincon', ...
    'mpoption_info_glpk', ...
    'mpoption_info_gurobi', ...
    'mpoption_info_intlinprog', ...
    'mpoption_info_ipopt', ...
    'mpoption_info_knitro', ...
    'mpoption_info_linprog', ...
    'mpoption_info_mips', ...
    'mpoption_info_mosek', ...
    'mpoption_info_osqp', ...
    'mpoption_info_quadprog', ...
    'mpoption_old', ...
    'mpver', ...
    'newtonpf', ...
    'newtonpf_I_cart', ...
    'newtonpf_I_hybrid', ...
    'newtonpf_I_polar', ...
    'newtonpf_S_cart', ...
    'newtonpf_S_hybrid', ...
    'nlpopf_solver', ...
    'opf', ...
    'opf_args', ...
    'opf_branch_ang_fcn', ...
    'opf_branch_ang_hess', ...
    'opf_branch_flow_fcn', ...
    'opf_branch_flow_hess', ...
    'opf_current_balance_fcn', ...
    'opf_current_balance_hess', ...
    'opf_execute', ...
    'opf_gen_cost_fcn', ...
    'opf_legacy_user_cost_fcn', ...
    'opf_power_balance_fcn', ...
    'opf_power_balance_hess', ...
    'opf_setup', ...
    'opf_veq_fcn', ...
    'opf_veq_hess', ...
    'opf_vlim_fcn', ...
    'opf_vlim_hess', ...
    'opf_vref_fcn', ...
    'opf_vref_hess', ...
    'order_radial', ...
    'pfsoln', ...
    'poly2pwl', ...
    'polycost', ...
    'pqcost', ...
    'printpf', ...
    'psse2mpc', ...
    'psse_convert', ...
    'psse_convert_hvdc', ...
    'psse_convert_xfmr', ...
    'psse_parse', ...
    'psse_parse_line', ...
    'psse_parse_section', ...
    'psse_read', ...
    'qps_matpower', ...
    'radial_pf', ...
    'remove_userfcn', ...
    'run_userfcn', ...
    'runcpf', ...
    'rundcopf', ...
    'rundcpf', ...
    'runduopf', ...
    'runopf', ...
    'runopf_w_res', ...
    'runpf', ...
    'runuopf', ...
    'save2psse', ...
    'savecase', ...
    'savechgtab', ...
    'scale_load', ...
    'set_reorder', ...
    'toggle_dcline', ...
    'toggle_iflims', ...
    'toggle_reserves', ...
    'toggle_softlims', ...
    'total_load', ...
    'totcost', ...
    'uopf', ...
    'update_mupq', ...
    'zgausspf', ...
};
lib_t_legacy_fcns = {
    'opf_nle_fcn1', ...
    'opf_nle_hess1', ...
    't_apply_changes', ...
    't_auction_case', ...
    't_auction_minopf', ...
    't_auction_mips', ...
    't_auction_tspopf_pdipm', ...
    't_case30_userfcns', ...
    't_case9_dcline', ...
    't_case9_opf', ...
    't_case9_opfv2', ...
    't_case9_pf', ...
    't_case9_pfv2', ...
    't_case9_save2psse', ...
    't_case_ext', ...
    't_case_int', ...
    't_chgtab', ...
    't_cpf', ...
    't_cpf_cb1', ...
    't_cpf_cb2', ...
    't_dcline', ...
    't_ext2int2ext', ...
    't_feval_w_path', ...
    't_get_losses', ...
    't_hasPQcap', ...
    't_hessian', ...
    't_islands', ...
    't_jacobian', ...
    't_load2disp', ...
    't_loadcase', ...
    't_makeLODF', ...
    't_makePTDF', ...
    't_margcost', ...
    't_miqps_matpower', ...
    't_modcost', ...
    't_mpoption', ...
    't_mpoption_ov', ...
    't_off2case', ...
    't_opf_dc_bpmpd', ...
    't_opf_dc_clp', ...
    't_opf_dc_cplex', ...
    't_opf_dc_default', ...
    't_opf_dc_glpk', ...
    't_opf_dc_gurobi', ...
    't_opf_dc_ipopt', ...
    't_opf_dc_mips', ...
    't_opf_dc_mips_sc', ...
    't_opf_dc_mosek', ...
    't_opf_dc_osqp', ...
    't_opf_dc_ot', ...
    't_opf_default', ...
    't_opf_fmincon', ...
    't_opf_ipopt', ...
    't_opf_knitro', ...
    't_opf_minopf', ...
    't_opf_mips', ...
    't_opf_model', ...
    't_opf_softlims', ...
    't_opf_tspopf_pdipm', ...
    't_opf_tspopf_scpdipm', ...
    't_opf_tspopf_tralm', ...
    't_opf_userfcns', ...
    't_pf_ac', ...
    't_pf_dc', ...
    't_pf_radial', ...
    't_printpf', ...
    't_psse', ...
    't_qps_matpower', ...
    't_runmarket', ...
    't_runopf_w_res', ...
    't_scale_load', ...
    't_total_load', ...
    't_totcost', ...
    't_vdep_load', ...
};

in = struct(...
    'class', struct(...
        'destdir', 'classes', ...
        'gh_base_url', 'https://github.com/MATPOWER/matpower/blob/master', ...
        'list', struct(...
            'mod', {'matpower', 'matpower.+mp', 'matpower.+mp'}, ...
            'src_path', {'lib', 'lib', 'lib/t'}, ...
            'names', {lib_classes, lib_mp_classes, lib_t_mp_classes} ...
        ) ...
    ), ...
    'function', struct(...
        'destdir', 'functions', ...
        'gh_base_url', 'https://github.com/MATPOWER/matpower/blob/master', ...
        'list', struct(...
            'mod', {'matpower', 'matpower.+mp'}, ...
            'src_path', {'lib', 'lib'}, ...
            'names', {lib_fcns, lib_mp_fcns} ...
        ) ...
    ) ...
);
in_test = struct(...
    'class', struct(...
        'destdir', 'tests', ...
        'gh_base_url', 'https://github.com/MATPOWER/matpower/blob/master', ...
        'list', struct(...
            'mod', {'matpower'}, ...
            'src_path', {'lib/t'}, ...
            'names', {lib_t_classes} ...
        ) ...
    ), ...
    'function', struct(...
        'destdir', 'tests', ...
        'gh_base_url', 'https://github.com/MATPOWER/matpower/blob/master', ...
        'list', struct(...
            'mod', {'matpower'}, ...
            'src_path', {'lib/t'}, ...
            'names', {lib_t_fcns} ...
        ) ...
    ) ...
);
in_legacy = struct(...
    'class', struct(...
        'destdir', 'legacy/classes', ...
        'gh_base_url', 'https://github.com/MATPOWER/matpower/blob/master', ...
        'list', struct(...
            'mod', {'matpower'}, ...
            'src_path', {'lib'}, ...
            'names', {lib_legacy_classes} ...
        ) ...
    ), ...
    'function', struct(...
        'destdir', 'legacy/functions', ...
        'gh_base_url', 'https://github.com/MATPOWER/matpower/blob/master', ...
        'list', struct(...
            'mod', {'matpower', 'matpower'}, ...
            'src_path', {'lib', 'lib/t'}, ...
            'names', {lib_legacy_fcns, lib_t_legacy_fcns} ...
        ) ...
    ) ...
);
installer = struct(...
    'function', struct(...
        'destdir', 'functions', ...
        'gh_base_url', 'https://github.com/MATPOWER/matpower/blob/master', ...
        'list', struct(...
            'mod', {'matpower'}, ...
            'src_path', {''}, ...
            'names', {{'install_matpower'}} ...
        ) ...
    ) ...
);

%% create stubs and symlinks for reference manual
generate_autodoc_stubs(in, [sphinx_src_dir 'ref-manual/']);
generate_source_symlinks(in, [sphinx_src_dir 'matlab-source/'], '../../../../../');
generate_autodoc_stubs(in_test, [sphinx_src_dir 'ref-manual/']);
generate_source_symlinks(in_test, [sphinx_src_dir 'matlab-source/'], '../../../../../');
generate_autodoc_stubs(in_legacy, [sphinx_src_dir 'ref-manual/']);
generate_source_symlinks(in_legacy, [sphinx_src_dir 'matlab-source/'], '../../../../../');
generate_autodoc_stubs(installer, [sphinx_src_dir 'ref-manual/']);
generate_source_symlinks(installer, [sphinx_src_dir 'matlab-source/'], '../../../../../');

%% create stubs and symlinks for How to Build Documentation
ind = struct(...
    'function', struct(...
        'destdir', 'builddocs', ...
        'gh_base_url', 'https://github.com/MATPOWER/matpower/blob/master', ...
        'list', struct(...
            'mod', {'matpower'}, ...
            'src_path', {'lib/t'}, ...
            'names', {lib_doc_fcns} ...
        ) ...
    ) ...
);
generate_autodoc_stubs(ind, [sphinx_src_dir 'howto/']);
generate_source_symlinks(ind, [sphinx_src_dir 'matlab-source/'], '../../../../../');
