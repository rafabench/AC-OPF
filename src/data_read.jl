function read_matlab_file(prob_file::String)
    f = open(prob_file, "r+")
    filetext = readlines(prob_file, keep = true)

    bus_read = false
    gen_read = false
    gencost_read = false
    branch_read = false
    Buses = Bus[]
    Generators = Generator[]
    GenaratorCosts = GenaratorCost[]
    Branches = Branch[]
    for line in filetext
        line_t = replace(line,";\n" => "")
        line_t = replace(line_t,";" => "")
        attr = [i for i in split(line_t," ") if i != ""]
        if occursin("];",line)
            bus_read = false
            gen_read = false
            gencost_read = false
            branch_read = false
        end
        
        if bus_read
            new_bus = Bus(attr)
            push!(Buses,new_bus)
        end

        if gen_read
            new_gen = Generator(attr)
            push!(Generators,new_gen)
        end

        if gencost_read
            new_gencost = GenaratorCost(attr)
            push!(GenaratorCosts,new_gencost)
        end

        if branch_read
            new_branch = Branch(attr)
            push!(Branches,new_branch)
        end

        if occursin("mpc.bus ",line)
            bus_read = true
        end

        if occursin("mpc.gen ",line)
            gen_read = true
        end

        if occursin("mpc.gencost ",line)
            gencost_read = true
        end

        if occursin("mpc.branch ",line)
            branch_read = true
        end
    end

    return Buses,Generators,GenaratorCosts,Branches
end