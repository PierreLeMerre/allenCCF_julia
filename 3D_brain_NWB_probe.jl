using GLMakie
using Makie
using FileIO
using DelimitedFiles
using DataFrames
using Colors
using Glob
using HDF5

Task = "Passive"
Brain_region = "HPC"

Dest_path = "/Volumes/labs/dmclab/Pierre/PFCmap/Data_recap_per_probe/3d_reconstruction/"*Brain_region*"/"*Task*"/"

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
colors = ["#92A691" "#e8cd00" "#e5a106" "#CE6161" "#9F453B" "#5A8DAF" "#3D6884" "#505770" "#4B6A2E" "#BA80B6" "#775B8A"] 
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

# import bregma
bregma = [540 570 65]

# import probe coordinates form NWB
# load file name from NWB files in database
# Get the filename list from nwbs, Carlen Dataset
# Location of the NWBs
src = "/Volumes/labs/dmclab/Pierre/NPX_Database/"*Brain_region*"/"*Task*"/"
# get hdf5 files
filelist = glob("*.nwb",src)

#for f in filelist

        f = filelist[1]        
        filename = split(f,'/')[end]
        println("Processing "*filename)
        Mouse = split(filename,'_')[1]
        Rec = split(split(filename,'_')[2],'.')[1]

        # read nwb
        nwb = h5open(f, "r")

        # corrected coordinates int CCFv3
        AP = round.(read(nwb["general/extracellular_ephys/electrodes/AP/"]).*100)
        DV = round.(read(nwb["general/extracellular_ephys/electrodes/DV/"]).*-100)
        ML = round.(read(nwb["general/extracellular_ephys/electrodes/ML/"]).*100)


        # Load mesh from obj file
        #with_theme(theme_dark()) do
        fig =  Figure(size = (1200,800))
        axs = Axis3(fig[1,1]; aspect = :data, azimuth = -0.5*pi, elevation = -0.3*pi)
        scene = mesh!(axs,brain_region, color = c, transparency=true, alpha=0.2)
        mesh!(brain_region2, color = c2, transparency=true, alpha=0.5)
        mesh!(brain_region3, color = c3, transparency=true, alpha=0.5)
        mesh!(brain_region4, color = c4, transparency=true)
        mesh!(brain_region5, color = c5, transparency=true)
        mesh!(brain_region6, color = c6, transparency=true)
        mesh!(brain_region7, color = c7, transparency=true)
        mesh!(brain_region8, color = c8, transparency=true)
        mesh!(brain_region9, color = c9, transparency=true, alpha=0.5)
        mesh!(brain_region10, color = c10, transparency=true, alpha=0.2)
        mesh!(brain_region11, color = c11, transparency=true, alpha=0.5)
        mesh!(brain_region12, color = c12, transparency=true, alpha=0.5)

        # probes
        #for (f,file) in enumerate(filelist)
        x, y, z = ([bregma[1]+AP[1], bregma[1]+AP[end]].*10,
                    [bregma[3]+DV[1], bregma[3]+DV[end]].*10,
                    [bregma[2]+ML[1], bregma[2]+ML[end]].*10)
        lines!(axs, x, y, z; color=:black, linewidth=5, transparency=true)
        #end

        hidedecorations!(axs)  # hides ticks, grid and lables
        hidespines!(axs)  # hide the frame

        axs.azimuth= 10.01
        axs.elevation= -0.4
        #rotate!(scene, qrotation(Vec3([0, 1, 0]), pi)) 
        #hidedecorations!.(axs; grid = false)
        #Camera3D(axs.scene)

        fig

        #GLMakie.save(Dest_path * "/" * Mouse * "_" * Rec *  "__3D.png",fig)


#end


