using JLD2, DataFrames, CSV, Crayons

include("core.jl")

abspath = []
push!(abspath, ARGS[1])
while true
    # for _ in 1:5
    #     if ARGS |> isempty
    #         try
    #             using Gtk
    #             abspath = open_dialog_native("JLD2", GtkNullContainer(), ["*.jld2"]);
    #             break
    #         catch LoadError
    #             @error "There is no jld2 file to read, so we want to find your file via interactive dialog. Please install `Gtk.jl` package in current julia: Run `import Pkg; Pkg.add(\"Gtk\")` to install the Gtk package."
    #             run(`julia`)
    #         end
    #     else
    #         abspath = ARGS[1]
    #         break
    #     end
    #     if abspath == "" continue end
    # end

    directory = dirname(last(abspath))
    filename = basename(last(abspath))
    jld2list = readdir(directory)[(last.(split.(readdir(directory), '.')) .== "jld2")]
    # show(IOContext(stdout, :limit => true), "text/plain", jld2list)
    display(jld2list)
    fileidx = findfirst(filename .== jld2list)
    println("    [ $fileidx / $(length(jld2list)) ]")
    
    # filename = read(directory, filename, jld2list)
    push!(abspath, joinpath(directory, read(directory, filename, jld2list)))
end