using Printf

macro time(expr)
    return :(timeit(() -> $(esc(expr))))
end

function timeit(f)
    t0 = time_ns()
    val = f()
    t1 = time_ns()
    Δt = (t1-t0)/1e9
    return Δt
end

function optimality_gap(model,opt_value)
    return (opt_value-objective_value(model))/opt_value*100
end

function optimality_gap_mosek(model, opt_value, file)
    p_g = value.(model[:p_g])
    Buses, Generators, GeneratorCosts, Branches = read_matlab_file(file)
    obj = sum([GeneratorCosts[k].c2*p_g[k]^2*100.0^2+GeneratorCosts[k].c1*p_g[k]*100.0+GeneratorCosts[k].c0 for k = 1:length(GeneratorCosts)])
    return abs((opt_value-obj)/(opt_value)*100)
end

function benchmark(tests, network=TYP, sdp=true, timelimit=600.0)
    cases = case[]
    full_data = raw"..\data\pglib-opf"
    count = 1
    for test in tests
        file = test[1]
        optimal_value = test[2][Int(network)+1]
        MODEL_NL = MODEL(NL)
        MODEL_MC = MODEL(MC)
        MODEL_SDP = MODEL(SDP)
        MODEL_SOCP = MODEL(SOCP)
        new_case = case(file,optimal_value,MODEL_NL,MODEL_MC,MODEL_SDP,MODEL_SOCP)
        if network == TYP
            filepath = joinpath(full_data,file*".m")
        elseif network == API
            filepath = joinpath(full_data,"api",file*"__api.m")
        else network == SAD
            filepath = joinpath(full_data,"sad",file*"__sad.m")
        end
        model_nl = build_problem(filepath,ipopt,NL)
        model_mc = build_problem(filepath,mosek, MC)
        model_sdp = build_problem(filepath,mosek, SDP)
        model_socp = build_problem(filepath,mosek, SOCP)
        set_time_limit_sec(model_nl, timelimit)
        set_time_limit_sec(model_mc, timelimit)
        set_time_limit_sec(model_sdp, timelimit)
        set_time_limit_sec(model_socp, timelimit)
        set_silent(model_nl)
        set_silent(model_mc)
        if sdp
            set_silent(model_sdp)
        end
        set_silent(model_socp)
        MODEL_NL.time = @time optimize!(model_nl)
        MODEL_MC.time = @time optimize!(model_mc)
        if sdp
            MODEL_SDP.time = @time optimize!(model_sdp)
        end
        MODEL_SOCP.time = @time optimize!(model_socp)
        MODEL_NL.optimal_value = objective_value(model_nl)
        MODEL_NL.gap = abs(optimality_gap(model_nl,optimal_value))
        if termination_status(model_mc) == MOI.OPTIMAL || termination_status(model_mc) == MOI.SLOW_PROGRESS
            p_g = value.(model_mc[:p_g])
            Buses, Generators, GeneratorCosts, Branches = read_matlab_file(filepath)
            obj = sum([GeneratorCosts[k].c2*p_g[k]^2*100.0^2+GeneratorCosts[k].c1*p_g[k]*100.0+GeneratorCosts[k].c0 for k = 1:length(GeneratorCosts)])
            MODEL_MC.optimal_value = obj
            MODEL_MC.gap = abs((optimal_value-obj)/(optimal_value)*100)
        end
        if sdp
            if termination_status(model_sdp) == MOI.OPTIMAL || termination_status(model_sdp) == MOI.SLOW_PROGRESS
                p_g = value.(model_sdp[:p_g])
                Buses, Generators, GeneratorCosts, Branches = read_matlab_file(filepath)
                obj = sum([GeneratorCosts[k].c2*p_g[k]^2*100.0^2+GeneratorCosts[k].c1*p_g[k]*100.0+GeneratorCosts[k].c0 for k = 1:length(GeneratorCosts)])
                MODEL_SDP.optimal_value = obj
                MODEL_SDP.gap = abs((optimal_value-obj)/(optimal_value)*100)
            end
        end
        if termination_status(model_socp) == MOI.OPTIMAL || termination_status(model_socp) == MOI.SLOW_PROGRESS
            p_g = value.(model_socp[:p_g])
            Buses, Generators, GeneratorCosts, Branches = read_matlab_file(filepath)
            obj = sum([GeneratorCosts[k].c2*p_g[k]^2*100.0^2+GeneratorCosts[k].c1*p_g[k]*100.0+GeneratorCosts[k].c0 for k = 1:length(GeneratorCosts)])
            MODEL_SOCP.optimal_value = obj
            MODEL_SOCP.gap = abs((optimal_value-obj)/(optimal_value)*100)
        end
        count += 1
        push!(cases,new_case)
    end
    cases
end

function print_cases_table(cases)
    @printf("%60s\n\n","Percentual Error Table (%)")
    @printf("%30s | %7s | %7s | %7s | %7s |\n","File Name","NL","MC","SDP","SOCP")
    for case in cases
        @printf("%30s | %7.3f | %7.3f | %7.3f | %7.3f |\n", case.file,case.NL_model.gap,case.MC_model.gap,case.SDP_model.gap,case.SOCP_model.gap)
    end
    println()
    @printf("%50s\n\n","Time Elapsed Table")
    @printf("%30s | %7s | %7s | %7s | %7s |\n","File Name","NL","MC","SDP","SOCP")
    for case in cases
        @printf("%30s | %7.3f | %7.3f | %7.3f | %7.3f |\n", case.file,case.NL_model.time,case.MC_model.time,case.SDP_model.time,case.SOCP_model.time)
    end
end

function print_cases_no_sdp_table(cases)
    @printf("%55s\n\n","Percentual Error Table (%)")
    @printf("%30s | %8s | %8s | %8s |\n","File Name","NL","MC","SOCP")
    for case in cases
        @printf("%30s | %8.3f | %8.3f | %8.3f |\n", case.file,case.NL_model.gap,case.MC_model.gap,case.SOCP_model.gap)
    end
    println()
    @printf("%45s\n\n","Time Elapsed Table")
    @printf("%30s | %8s | %8s | %8s |\n","File Name","NL","MC","SOCP")
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
    ax.set_title("Results dispersion graph")
    ax.legend()
    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlabel("Time (s)")
    ax.set_ylabel("Gap (%)")
    show()
end