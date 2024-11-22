using GLMakie
using Makie
using FileIO
using DelimitedFiles
using DataFrames
using Colors
using Glob

#GLMakie.activate!()
GLMakie.activate!(inline=false)

include("acronym2id.jl")
include("acronym2hexcolor.jl")
include("acronym2mesh.jl")

# ccf_2017 data folder
src = "/Volumes/labs/dmclab/Pierre/ccf_2017/"
#structure tree
st = readdlm(src*"structure_tree_safe_2017.csv",',')
brain_region, hex_c = acronym2mesh(st,"root",src*"structure_meshes/")
brain_region2, hex_c2 = acronym2mesh(st,"MOs",src*"structure_meshes/")
brain_region3, hex_c3 = acronym2mesh(st,"ACAd",src*"structure_meshes/")
brain_region4, hex_c4 = acronym2mesh(st,"ACAv",src*"structure_meshes/")
brain_region5, hex_c5 = acronym2mesh(st,"PL",src*"structure_meshes/")
brain_region6, hex_c6 = acronym2mesh(st,"ILA",src*"structure_meshes/")
brain_region7, hex_c7 = acronym2mesh(st,"ORBm",src*"structure_meshes/")
brain_region8, hex_c8 = acronym2mesh(st,"ORBvl",src*"structure_meshes/")
brain_region9, hex_c9 = acronym2mesh(st,"ORBl",src*"structure_meshes/")
brain_region10, hex_c10 = acronym2mesh(st,"FRP",src*"structure_meshes/")
brain_region11, hex_c11 = acronym2mesh(st,"AId",src*"structure_meshes/")
brain_region12, hex_c12 = acronym2mesh(st,"AIv",src*"structure_meshes/")

# hex to rgba
Regions = ["MOs" "ACAd" "ACAv" "PL" "ILA" "ORBm" "ORBvl" "ORBl" "FRP" "AId" "AIv"] 
colors = ["#557d39" "#e8cd1c" "#e5a324" "#bf2026" "#f5999f" "#65cadb" "#488ccb" "#3c56a6" "#a9855b" "#c277b1" "#7d277d"]  
c = parse(Colorant, "#"*hex_c)
c2 = parse(Colorant, colors[1])
c3 = parse(Colorant, colors[2])
c4 = parse(Colorant, colors[3])
c5 = parse(Colorant, colors[4])
c6 = parse(Colorant, colors[5])
c7 = parse(Colorant, colors[6])
c8 = parse(Colorant, colors[7])
c9 = parse(Colorant, colors[8])
c10 = parse(Colorant, colors[9])
c11 = parse(Colorant, colors[10])
c12 = parse(Colorant, colors[11])

# import probe
bregma = [540 570 65]

src_probes = "/Users/pielem/OneDrive - Karolinska Institutet/Mac/Desktop/NWB_conversion/final_probe_list/"

filelist = glob("*_sites.csv",src_probes)


# Load mesh from obj file
#with_theme(theme_dark()) do
    fig =  Figure(size = (1200,800))
    axs = Axis3(fig[1,1]; aspect = :data, azimuth = -0.5*pi, elevation = -0.3*pi)
    scene = mesh!(axs,brain_region, color = c, transparency=true, alpha=0.2)
    mesh!(brain_region2, color = c2, transparency=true)
    mesh!(brain_region3, color = c3, transparency=true)
    mesh!(brain_region4, color = c4, transparency=true)
    mesh!(brain_region5, color = c5, transparency=true)
    mesh!(brain_region6, color = c6, transparency=true)
    mesh!(brain_region7, color = c7, transparency=true)
    mesh!(brain_region8, color = c8, transparency=true)
    mesh!(brain_region9, color = c9, transparency=true)
    mesh!(brain_region10, color = c10, transparency=true)
    mesh!(brain_region11, color = c11, transparency=true)
    mesh!(brain_region12, color = c12, transparency=true)

    # probes
    for (f,file) in enumerate(filelist)
    #    f = 1
    #    file = filelist[11]
       csv =readdlm(file,',')
        x, y, z = ([bregma[1]+csv[1,2], bregma[1]+csv[end,2]].*10,
                   [bregma[3]+csv[1,3], bregma[3]+csv[end,3]].*10,
                   [bregma[2]+csv[1,4], bregma[2]+csv[end,4]].*10)
        lines!(axs, x, y, z; color=:black, linewidth=5, transparency=true)
    end
    
    hidedecorations!(axs)  # hides ticks, grid and lables
    hidespines!(axs)  # hide the frame

    #rotate!(scene, qrotation(Vec3([0, 1, 0]), pi)) 
    #hidedecorations!.(axs; grid = false)
    #Camera3D(axs.scene)
    
    fig
#end


