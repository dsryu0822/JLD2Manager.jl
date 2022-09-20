using JLD2, CSV, DataFrames, Crayons
# using Gtk
# trajectory = open_dialog_native("JLD2", GtkNullContainer(), ["*.jld2"]);

include("core.jl")

trajectory = []
cd(dirname(ARGS[1]))
push!(trajectory, basename(ARGS[1]))
while true
    filename = last(trajectory)
    jld2list = readdir()[(last.(split.(readdir(), '.')) .== "jld2")]
    # if length(jld2list) < 10
    #     display(jld2list)
    # else
        for cursor in jld2list
            if cursor == filename
                print(Crayon(foreground = (244,191,119)), "$cursor, ")
            elseif cursor in trajectory
                print(Crayon(reset = true), "$cursor, ")
            else
                print(Crayon(foreground = (64,64,64)), "$cursor, ")
            end
        end
    # end

    fileidx = findfirst(filename .== jld2list)
    println(Crayon(reset = true), "    [ $fileidx / $(length(jld2list)) ]")
    
    push!(trajectory, monitor(filename, jld2list))
end