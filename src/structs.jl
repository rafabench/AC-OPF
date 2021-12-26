@enum RELAXATION NL MC SDP SOCP
@enum NETWORK TYP API SAD

# (case , [TYP, API, SAD])
case_tests = [
    ("pglib_opf_case3_lmbd"       , [5.8126e+03, 1.1236e+04, 5.9593e+03]),
    ("pglib_opf_case5_pjm"        , [1.7552e+04, 7.6377e+04, 2.6109e+04]),
    ("pglib_opf_case14_ieee"      , [2.1781e+03, 5.9994e+03, 2.7768e+03]),
    ("pglib_opf_case24_ieee_rts"  , [6.3352e+04, 1.3494e+05, 7.6918e+04]),
    ("pglib_opf_case30_as"        , [8.0313e+02, 4.9962e+03, 8.9735e+02]),
    ("pglib_opf_case30_ieee"      , [8.2085e+03, 1.8044e+04, 8.2085e+03]),
    ("pglib_opf_case39_epri"      , [1.3842e+05, 2.4967e+05, 1.4834e+05]),
    ("pglib_opf_case57_ieee"      , [3.7589e+04, 4.9290e+04, 3.8663e+04]),
    ("pglib_opf_case73_ieee_rts"  , [1.8976e+05, 4.2263e+05, 2.2760e+05]),
    ("pglib_opf_case89_pegase"    , [1.0729e+05, 1.3017e+05, 1.0729e+05]),
    ("pglib_opf_case118_ieee"     , [9.7214e+04, 2.4224e+05, 1.0516e+05]),
    ("pglib_opf_case162_ieee_dtc" , [1.0808e+05, 1.2099e+05, 1.0869e+05]),
    ("pglib_opf_case179_goc"      , [7.5427e+05, 1.9320e+06, 7.6253e+05]),
    ("pglib_opf_case200_activ"    , [2.7558e+04, 3.5701e+04, 2.7558e+04]),
    ("pglib_opf_case240_pserc"    , [3.3297e+06, 4.6406e+06, 3.4054e+06]),
    ("pglib_opf_case300_ieee"     , [5.6522e+05, 6.8499e+05, 5.6570e+05]),
    ("pglib_opf_case500_goc"      , [4.5495e+05, 6.9241e+05, 4.8740e+05]),
    ("pglib_opf_case588_sdet"     , [3.1314e+05, 3.9476e+05, 3.2936e+05]),
    ("pglib_opf_case793_goc"      , [2.6020e+05, 3.1885e+05, 2.8580e+05]),
    ("pglib_opf_case1354_pegase"  , [1.2588e+06, 1.4983e+06, 1.2588e+06]),
    ("pglib_opf_case1888_rte"     , [1.4025e+06, 1.9539e+06, 1.4139e+06]),
    ("pglib_opf_case1951_rte"     , [2.0856e+06, 2.4108e+06, 2.0924e+06]),
    ("pglib_opf_case2000_goc"     , [9.7343e+05, 1.4686e+06, 9.9288e+05]),
    ("pglib_opf_case2312_goc"     , [4.4133e+05, 5.7152e+05, 4.6235e+05]),
    ("pglib_opf_case2383wp_k"     , [1.8682e+06, 2.7913e+05, 1.9112e+06]),
    ("pglib_opf_case2736sp_k"     , [1.3080e+06, 6.5394e+05, 1.3266e+06]),
    ("pglib_opf_case2737sop_k"    , [7.7773e+05, 3.6715e+05, 7.9095e+05]),
    ("pglib_opf_case2742_goc"     , [2.7571e+05, 6.4219e+05, 2.7571e+05]),
    ("pglib_opf_case2746wop_k"    , [1.2083e+06, 5.1166e+05, 1.2337e+06]),
    ("pglib_opf_case2746wp_k"     , [1.6317e+06, 5.8183e+05, 1.6669e+06]),
    ("pglib_opf_case2848_rte"     , [1.2866e+06, 1.4970e+06, 1.2890e+06]),
    ("pglib_opf_case2853_sdet"    , [2.0524e+06, 2.4578e+06, 2.0692e+06]),
    ("pglib_opf_case2868_rte"     , [2.0096e+06, 2.2946e+06, 2.0213e+06]),
    ("pglib_opf_case2869_pegase"  , [2.4628e+06, 2.9296e+06, 2.4687e+06]),
    ("pglib_opf_case3012wp_k"     , [2.6008e+06, 7.2887e+05, 2.6195e+06]),
    ("pglib_opf_case3022_goc"     , [6.0138e+05, 6.5189e+05, 6.0143e+05]),
    ("pglib_opf_case3120sp_k"     , [2.1480e+06, 9.3692e+05, 2.1749e+06]),
    ("pglib_opf_case3375wp_k"     , [7.4382e+06, 5.8478e+06, 7.4382e+06]),
    ("pglib_opf_case3970_goc"     , [9.6099e+05, 1.4557e+06, 9.6555e+05]),
    ("pglib_opf_case4020_goc"     , [8.2225e+05, 1.2979e+06, 8.8969e+05]),
    ("pglib_opf_case4601_goc"     , [8.2624e+05, 7.9253e+05, 8.7818e+05]),
    ("pglib_opf_case4619_goc"     , [4.7670e+05, 1.0299e+06, 4.8435e+05]),
    ("pglib_opf_case4661_sdet"    , [2.2513e+06, 2.6953e+06, 2.2610e+06]),
    ("pglib_opf_case4837_goc"     , [8.7226e+05, 1.1578e+06, 8.7712e+05]),
    ("pglib_opf_case4917_goc"     , [1.3878e+06, 1.5479e+06, 1.3890e+06]),
    ("pglib_opf_case6468_rte"     , [2.0697e+06, 2.3135e+06, 2.0697e+06]),
    ("pglib_opf_case6470_rte"     , [2.2376e+06, 2.6065e+06, 2.2416e+06]),
    ("pglib_opf_case6495_rte"     , [3.0678e+06, 2.9750e+06, 3.0678e+06]),
    ("pglib_opf_case6515_rte"     , [2.8255e+06, 3.0617e+06, 2.8698e+06]),
    ("pglib_opf_case9241_pegase"  , [6.2431e+06, 7.0112e+06, 6.3185e+06]),
    ("pglib_opf_case9591_goc"     , [1.0617e+06, 1.4259e+06, 1.1674e+06]),
    ("pglib opf case10000_goc"    , [1.3540e+06, 2.3728e+06, 1.4902e+06]),
    ("pglib opf case10480_goc"    , [2.3146e+06, 2.7627e+06, 2.3147e+06]),
    ("pglib_opf_case13659_pegase" , [8.9480e+06, 9.2842e+06, 9.0422e+06]),
    ("pglib_opf_case19402_goc"    , [1.9778e+06, 2.3987e+06, 1.9838e+06]),
    ("pglib_opf_case24464_goc"    , [2.6295e+06, 2.4723e+06, 2.6540e+06]),
    ("pglib_opf_case30000_goc"    , [1.1423e+06, 1.3530e+06, 1.2866e+06])
    ];

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

