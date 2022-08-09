using JLD2, DataFrames, Crayons

include("core.jl")

trajectory = []
cd(dirname(ARGS[1]))
push!(trajectory, basename(ARGS[1]))
while true
    # for _ in 1:5
    #     if ARGS |> isempty
    #         try
    #             using Gtk
    #             trajectory = open_dialog_native("JLD2", GtkNullContainer(), ["*.jld2"]);
    #             break
    #         catch LoadError
    #             @error "There is no jld2 file to read, so we want to find your file via interactive dialog. Please install `Gtk.jl` package in current julia: Run `import Pkg; Pkg.add(\"Gtk\")` to install the Gtk package."
    #             run(`julia`)
    #         end
    #     else
    #         trajectory = ARGS[1]
    #         break
    #     end
    #     if trajectory == "" continue end
    # end

    filename = last(trajectory)
    jld2list = readdir()[(last.(split.(readdir(), '.')) .== "jld2")]
    if length(jld2list) < 10
        display(jld2list)
    else
        println(jld2list)
    end
    # show(IOContext(stdout, :limit => true), "text/plain", jld2list)
    fileidx = findfirst(filename .== jld2list)
    println("    [ $fileidx / $(length(jld2list)) ]")
    
    # filename = read(directory, filename, jld2list)
    push!(trajectory, read(filename, jld2list))
end