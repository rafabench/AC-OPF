using Printf

function optimality_gap(model,opt_value)
    return (opt_value-objective_value(model))/opt_value*100
end

function optimality_gap_mosek(model, opt_value, file)
    p_g = value.(model[:p_g])
    Buses, Generators, GeneratorCosts, Branches = read_matlab_file(file)
    obj = sum([GeneratorCosts[k].c2*p_g[k]^2*100.0^2+GeneratorCosts[k].c1*p_g[k]*100.0+GeneratorCosts[k].c0 for k = 1:length(GeneratorCosts)])
    return abs((opt_value-obj)/(opt_value)*100)
end

function benchmark(files,tests)
    cases = case[]
    full_data = "C:\\Users\\rafabench\\Downloads\\pglib-opf-master\\"
    optimal_values = Dict(tests[3]=>5.8126e3,
                        tests[5]=>1.7552e4,
                        tests[14]=>2.1781e3,
                        tests[24]=>6.3352e4,
                        tests[30]=>8.2085e3,
                        tests[39]=>1.3842e5,
                        tests[57]=>3.7589e4,
                        tests[73]=>1.8976e5,
                        tests[89]=>1.0729e5,
                        tests[118]=>9.7214e4,
                        tests[162]=>1.0808e5,
                        tests[179]=>7.5427e5,
                        tests[200]=>2.7558e4,
                        tests[240]=>3.3297e6,
                        tests[300]=>5.6522e5,
                        tests[500]=>7.2578e4,
                        tests[1354]=>1.2588e6)
    count = 1
    for file in files
        MODEL_NL = MODEL(NL)
        MODEL_MC = MODEL(MC)
        MODEL_SDP = MODEL(SDP)
        MODEL_SOCP = MODEL(SOCP)
        new_case = case(file,optimal_values[file],MODEL_NL,MODEL_MC,MODEL_SDP,MODEL_SOCP)
        model_nl = build_problem(full_data*file,() -> Ipopt.Optimizer(print_level = 0),NL)
        model_mc = build_problem(full_data*file,mosek, MC)
        model_sdp = build_problem(full_data*file,mosek, SDP)
        model_socp = build_problem(full_data*file,mosek, SOCP)
        set_silent(model_mc)
        set_silent(model_sdp)
        set_silent(model_socp)
        t_1 = time_ns()
        optimize!(model_nl)
        t_2 = time_ns()
        MODEL_NL.time = (t_2-t_1)/1e9
        t_1 = time_ns()
        optimize!(model_mc)
        t_2 = time_ns()
        MODEL_MC.time = (t_2-t_1)/1e9
        t_1 = time_ns()
        optimize!(model_sdp)
        t_2 = time_ns()
        MODEL_SDP.time = (t_2-t_1)/1e9
        t_1 = time_ns()
        optimize!(model_socp)
        t_2 = time_ns()
        MODEL_SOCP.time = (t_2-t_1)/1e9
        MODEL_NL.optimal_value = objective_value(model_nl)
        MODEL_NL.gap = abs(optimality_gap(model_nl,optimal_values[file]))
        if termination_status(model_mc) == MOI.OPTIMAL || termination_status(model_mc) == MOI.SLOW_PROGRESS
            p_g = value.(model_mc[:p_g])
            Buses, Generators, GeneratorCosts, Branches = read_matlab_file(full_data*file)
            obj = sum([GeneratorCosts[k].c2*p_g[k]^2*100.0^2+GeneratorCosts[k].c1*p_g[k]*100.0+GeneratorCosts[k].c0 for k = 1:length(GeneratorCosts)])
            MODEL_MC.optimal_value = obj
            MODEL_MC.gap = abs((optimal_values[file]-obj)/(optimal_values[file])*100)
        end
        if termination_status(model_sdp) == MOI.OPTIMAL || termination_status(model_sdp) == MOI.SLOW_PROGRESS
            p_g = value.(model_sdp[:p_g])
            Buses, Generators, GeneratorCosts, Branches = read_matlab_file(full_data*file)
            obj = sum([GeneratorCosts[k].c2*p_g[k]^2*100.0^2+GeneratorCosts[k].c1*p_g[k]*100.0+GeneratorCosts[k].c0 for k = 1:length(GeneratorCosts)])
            MODEL_SDP.optimal_value = obj
            MODEL_SDP.gap = abs((optimal_values[file]-obj)/(optimal_values[file])*100)
        end
        if termination_status(model_socp) == MOI.OPTIMAL || termination_status(model_socp) == MOI.SLOW_PROGRESS
            p_g = value.(model_socp[:p_g])
            Buses, Generators, GeneratorCosts, Branches = read_matlab_file(full_data*file)
            obj = sum([GeneratorCosts[k].c2*p_g[k]^2*100.0^2+GeneratorCosts[k].c1*p_g[k]*100.0+GeneratorCosts[k].c0 for k = 1:length(GeneratorCosts)])
            MODEL_SOCP.optimal_value = obj
            MODEL_SOCP.gap = abs((optimal_values[file]-obj)/(optimal_values[file])*100)
        end
        count += 1
        push!(cases,new_case)
    end
    cases
end

function benchmark_no_sdp(files,tests)
    cases = case[]
    full_data = "C:\\Users\\rafabench\\Downloads\\pglib-opf-master\\"
    optimal_values = Dict(tests[3]=>5.8126e3,
                        tests[5]=>1.7552e4,
                        tests[14]=>2.1781e3,
                        tests[24]=>6.3352e4,
                        tests[30]=>8.2085e3,
                        tests[39]=>1.3842e5,
                        tests[57]=>3.7589e4,
                        tests[73]=>1.8976e5,
                        tests[89]=>1.0729e5,
                        tests[118]=>9.7214e4,
                        tests[162]=>1.0808e5,
                        tests[179]=>7.5427e5,
                        tests[200]=>2.7558e4,
                        tests[240]=>3.3297e6,
                        tests[300]=>5.6522e5,
                        tests[500]=>7.2578e4,
                        tests[1354]=>1.2588e6,
                        tests[1888]=>1.4025e6,
                        tests[1951]=>2.0856e6,
                        tests[2000]=>1.2285e6,
                        tests[2316]=>1.7753e6,
                        tests[2736]=>1.3080e6,
                        tests[3012]=>2.6008e6,
                        tests[3375]=>7.4382e6,
                        tests[4661]=>2.2513e6)
    count = 1
    for file in files
        MODEL_NL = MODEL(NL)
        MODEL_MC = MODEL(MC)
        MODEL_SDP = MODEL(SDP)
        MODEL_SOCP = MODEL(SOCP)
        new_case = case(file,optimal_values[file],MODEL_NL,MODEL_MC,MODEL_SDP,MODEL_SOCP)
        model_nl = build_problem(full_data*file,() -> Ipopt.Optimizer(print_level = 0),NL)
        model_mc = build_problem(full_data*file,mosek, MC)
        model_socp = build_problem(full_data*file,mosek, SOCP)
        set_silent(model_mc)
        set_silent(model_socp)
        t_1 = time_ns()
        optimize!(model_nl)
        t_2 = time_ns()
        MODEL_NL.time = (t_2-t_1)/1e9
        t_1 = time_ns()
        optimize!(model_mc)
        t_2 = time_ns()
        MODEL_MC.time = (t_2-t_1)/1e9
        t_1 = time_ns()
        optimize!(model_socp)
        t_2 = time_ns()
        MODEL_SOCP.time = (t_2-t_1)/1e9
        MODEL_NL.optimal_value = objective_value(model_nl)
        MODEL_NL.gap = abs(optimality_gap(model_nl,optimal_values[file]))
        if termination_status(model_mc) == MOI.OPTIMAL || termination_status(model_mc) == MOI.SLOW_PROGRESS
            p_g = value.(model_mc[:p_g])
            Buses, Generators, GeneratorCosts, Branches = read_matlab_file(full_data*file)
            obj = sum([GeneratorCosts[k].c2*p_g[k]^2*100.0^2+GeneratorCosts[k].c1*p_g[k]*100.0+GeneratorCosts[k].c0 for k = 1:length(GeneratorCosts)])
            MODEL_MC.optimal_value = obj
            MODEL_MC.gap = abs((optimal_values[file]-obj)/(optimal_values[file])*100)
        end
        if termination_status(model_socp) == MOI.OPTIMAL || termination_status(model_socp) == MOI.SLOW_PROGRESS
            p_g = value.(model_socp[:p_g])
            Buses, Generators, GeneratorCosts, Branches = read_matlab_file(full_data*file)
            obj = sum([GeneratorCosts[k].c2*p_g[k]^2*100.0^2+GeneratorCosts[k].c1*p_g[k]*100.0+GeneratorCosts[k].c0 for k = 1:length(GeneratorCosts)])
            MODEL_SOCP.optimal_value = obj
            MODEL_SOCP.gap = abs((optimal_values[file]-obj)/(optimal_values[file])*100)
        end
        count += 1
        push!(cases,new_case)
    end
    cases
end

function print_cases_table(cases)
    @printf("%60s\n\n","Tabela de estimativa de erro em percentual")
    @printf("%30s | %7s | %7s | %7s | %7s |\n","Nome do Arquivo","NL","MC","SDP","SOCP")
    for case in cases
        @printf("%30s | %7.3f | %7.3f | %7.3f | %7.3f |\n", case.file,case.NL_model.gap,case.MC_model.gap,case.SDP_model.gap,case.SOCP_model.gap)
    end
    println()
    @printf("%50s\n\n","Tabela de tempo em segundos")
    @printf("%30s | %7s | %7s | %7s | %7s |\n","Nome do Arquivo","NL","MC","SDP","SOCP")
    for case in cases
        @printf("%30s | %7.3f | %7.3f | %7.3f | %7.3f |\n", case.file,case.NL_model.time,case.MC_model.time,case.SDP_model.time,case.SOCP_model.time)
    end
end

function print_cases_no_sdp_table(cases)
    @printf("%55s\n\n","Tabela de estimativa de erro em percentual")
    @printf("%30s | %8s | %8s | %8s |\n","Nome do Arquivo","NL","MC","SOCP")
    for case in cases
        @printf("%30s | %8.3f | %8.3f | %8.3f |\n", case.file,case.NL_model.gap,case.MC_model.gap,case.SOCP_model.gap)
    end
    println()
    @printf("%45s\n\n","Tabela de tempo em segundos")
    @printf("%30s | %8s | %8s | %8s |\n","Nome do Arquivo","NL","MC","SOCP")
    for case in cases
        @printf("%30s | %8.3f | %8.3f | %8.3f |\n", case.file,case.NL_model.time,case.MC_model.time,case.SOCP_model.time)
    end
end

function graph_dispersion(cases;sdp=true)
    nl_gap = [case.NL_model.gap for case in cases]
    nl_time = [case.NL_model.time for case in cases]
    mc_gap = [case.MC_model.gap for case in cases]
    mc_time = [case.MC_model.time for case in cases]
    sdp_gap = [case.SDP_model.gap for case in cases]
    sdp_time = [case.SDP_model.time for case in cases]
    socp_gap = [case.SOCP_model.gap for case in cases]
    socp_time = [case.SOCP_model.time for case in cases]
    fig = figure(1)
    ax = fig.add_subplot(1,1,1)
    ax.plot(nl_time,nl_gap, ".", label="NL")
    ax.plot(mc_time,mc_gap, ".", label="MC")
    if sdp
        ax.plot(sdp_time,sdp_gap, ".", label="SDP")
    end
    ax.plot(socp_time,socp_gap, ".", label="SOCP")
    ax.set_title("Gráfico de dispersão dos resultados")
    ax.legend()
    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlabel("Tempo (s)")
    ax.set_ylabel("Gap (%)")
    show()
end