@enum RELAXATION NL MC SDP SOCP

tests = Dict(3 => "pglib_opf_case3_lmbd.m",
    5 => "pglib_opf_case5_pjm.m",
    14 => "pglib_opf_case14_ieee.m",
    24 => "pglib_opf_case24_ieee_rts.m",
    30 => "pglib_opf_case30_ieee.m",
    39 => "pglib_opf_case39_epri.m",
    57 => "pglib_opf_case57_ieee.m",
    73 => "pglib_opf_case73_ieee_rts.m",
    89 => "pglib_opf_case89_pegase.m",
    118 => "pglib_opf_case118_ieee.m",
    162 => "pglib_opf_case162_ieee_dtc.m",
    179 => "pglib_opf_case179_goc.m",
    200 => "pglib_opf_case200_tamu.m",
    240 => "pglib_opf_case240_pserc.m",
    300 => "pglib_opf_case300_ieee.m",
    500 => "pglib_opf_case500_tamu.m",
    588 => "pglib_opf_case588_sdet.m",
    1354 => "pglib_opf_case1354_pegase.m",
    1888 => "pglib_opf_case1888_rte.m",
    1951 => "pglib_opf_case1951_rte.m",
    2000 => "pglib_opf_case2000_tamu.m",
    2316 => "pglib_opf_case2316_sdet.m",
    2383 => "pglib_opf_case2383wp_k.m",
    2736 => "pglib_opf_case2736sp_k.m",
    2737 => "pglib_opf_case2737sop_k.m",
    2746 => "pglib_opf_case2746wop_k.m",
    2746 => "pglib_opf_case2746wp_k.m",
    2848 => "pglib_opf_case2848_rte.m",
    2853 => "pglib_opf_case2853_sdet.m",
    2868 => "pglib_opf_case2868_rte.m",
    2869 => "pglib_opf_case2869_pegase.m",
    3012 => "pglib_opf_case3012wp_k.m",
    3120 => "pglib_opf_case3120sp_k.m",
    3375 => "pglib_opf_case3375wp_k.m",
    4661 => "pglib_opf_case4661_sdet.m",
    6468 => "pglib_opf_case6468_rte.m",
    6470 => "pglib_opf_case6470_rte.m",
    6495 => "pglib_opf_case6495_rte.m",
    6515 => "pglib_opf_case6515_rte.m",
    9241 => "pglib_opf_case9241_pegase.m",
    10000 => "pglib_opf_case10000_tamu.m",
    13659 => "pglib_opf_case13659_pegase.m");

mutable struct MODEL
    optimal_value::Float64
    gap::Float64
    time::Float64
    relaxation::RELAXATION
    MODEL(relaxation;optimal_value=Inf,gap=1.0,time=0.0) = new(optimal_value,gap,time,relaxation)
end

mutable struct case
    file::String
    exact_value::Float64
    NL_model::MODEL
    MC_model::MODEL
    SDP_model::MODEL
    SOCP_model::MODEL
    case(file,exact_value,NL_model,MC_model,SDP_model,SOCP_model) = new(file,exact_value,NL_model,MC_model,SDP_model,SOCP_model)
end

mutable struct Bus
    bus_i::Int64
    type::Int64
    Pd::Float64
    Qd::Float64
    Gs::Float64
    Bs::Float64
    area::Int64
    Vm::Float64
    Va::Float64
    baseKV::Float64
    zone::Int64
    Vmax::Float64
    Vmin::Float64
    function Bus(Arrayattr)
        bus_i = parse(Int64,Arrayattr[1])
        type = parse(Int64,Arrayattr[2])
        Pd = parse(Float64,Arrayattr[3])
        Qd = parse(Float64,Arrayattr[4])
        Gs = parse(Float64,Arrayattr[5])
        Bs = parse(Float64,Arrayattr[6])
        area = parse(Int64,Arrayattr[7])
        Vm = parse(Float64,Arrayattr[8])
        Va = parse(Float64,Arrayattr[9])
        baseKV = parse(Float64,Arrayattr[10])
        zone = parse(Int64,Arrayattr[11])
        Vmax = parse(Float64,Arrayattr[12])
        Vmin = parse(Float64,Arrayattr[13])
        new(bus_i,type,Pd,Qd,Gs,Bs,area,Vm,Va,baseKV,zone,Vmax,Vmin)
    end
end

mutable struct Generator
    bus::Int64
    Pg::Float64
    Qg::Float64
    Qmax::Float64
    Qmin::Float64
    Vg::Float64
    mBase::Float64
    status::Int64
    Pmax::Float64
    Pmin::Float64
    function Generator(Arrayattr)
        bus = parse(Int64,Arrayattr[1])
        Pg = parse(Float64,Arrayattr[2])
        Qg = parse(Float64,Arrayattr[3])
        Qmax = parse(Float64,Arrayattr[4])
        Qmin = parse(Float64,Arrayattr[5])
        Vg = parse(Float64,Arrayattr[6])
        mBase = parse(Float64,Arrayattr[7])
        status = parse(Int64,Arrayattr[8])
        Pmax = parse(Float64,Arrayattr[9])
        Pmin = parse(Float64,Arrayattr[10])
        new(bus,Pg,Qg,Qmax,Qmin,Vg,mBase,status,Pmax,Pmin)
    end
end

mutable struct GenaratorCost
    two::Int64
    startup::Float64
    shutdown::Float64
    n::Int64
    c2::Float64
    c1::Float64
    c0::Float64
    function GenaratorCost(Arrayattr)
        two = parse(Int64,Arrayattr[1])
        startup = parse(Float64,Arrayattr[2])
        shutdown = parse(Float64,Arrayattr[3])
        n = parse(Int64,Arrayattr[4])
        c2 = parse(Float64,Arrayattr[5])
        c1 = parse(Float64,Arrayattr[6])
        c0 = parse(Float64,Arrayattr[7])
        new(two,startup,shutdown,n,c2,c1,c0)
    end
end

mutable struct Branch
    fbus::Int64
    tbus::Int64
    r::Float64
    x::Float64
    b::Float64
    rateA::Float64
    rateB::Float64
    rateC::Float64
    ratio::Float64
    angle::Float64
    status::Int64
    angmin::Float64
    angmax::Float64
    function Branch(Arrayattr)
        fbus = parse(Int64,Arrayattr[1])
        tbus = parse(Int64,Arrayattr[2])
        r = parse(Float64,Arrayattr[3])
        x = parse(Float64,Arrayattr[4])
        b = parse(Float64,Arrayattr[5])
        rateA = parse(Float64,Arrayattr[6])
        rateB = parse(Float64,Arrayattr[7])
        rateC = parse(Float64,Arrayattr[8])
        ratio = parse(Float64,Arrayattr[9])
        angle = parse(Float64,Arrayattr[10])
        status = parse(Int64,Arrayattr[11])
        angmin = parse(Float64,Arrayattr[12])
        angmax = parse(Float64,Arrayattr[13])
        new(fbus,tbus,r,x,b,rateA,rateB,rateC,ratio,angle,status,angmin,angmax)
    end
end

