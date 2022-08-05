using JLD2, DataFrames, Crayons

include("core.jl")

directory = ""

for _ in 1:5
    if ARGS |> isempty
        try
            using Gtk
            global directory = open_dialog_native("JLD2", GtkNullContainer(), ["*.jld2"]);
            break
        catch LoadError
            @error "There is no jld2 file to read, so we want to find your file via interactive dialog. Please install `Gtk.jl` package in current julia: Run `import Pkg; Pkg.add(\"Gtk\")` to install the Gtk package."
            run(`julia`)
        end
    else
        global directory = ARGS[1]
        break
    end
    if directory == "" continue end
end

println(readdir("directory/.."))

# while true
jldopen(directory) do jld2file
    # println(filesize(directory))
    # println("\nPlease type `ls`.")

    command = "h"
    idxl = jld2file |> keys |> length |> log10 |> ceil |> Int
    keyl = jld2file |> keys .|> length |> maximum
    filekeys = keys(jld2file)

    no_ask = 0
    for (idx, key) in enumerate(filekeys)
        if idx != maximum(idx)
            println("├─ " * lpad(idx, idxl) *" "* lpad(key, keyl))
        else
            println("└─ " * lpad(idx, idxl) *" "* lpad(key, keyl))
        end
    end
    while command != "exit"
        # println(command)
        if command ∈ ["help", "h", "?"]
            println(help_message)
        elseif command ∈ ["ls"]
            # textwidth
            println((" "^idxl) *" "* lpad("key", keyl) * lpad("size", 16) * lpad("type", 16))
            for (idx, key) in enumerate(filekeys)
                data = jld2file[key]
                println(lpad(idx, idxl) * " "
                    * lpad(key, keyl)
                    * lpad(sizeof(data), 16)
                    * lpad(typeof(data), 16)
                    );
            end
        elseif prod(isdigit.([a for a in command]))
            idx = parse(Int, command)
            data = jld2file[filekeys[idx]]
            # display(data)
            show(IOContext(stdout, :limit => true), "text/plain", data)
            # println(repr(MIME("text/plain"), data))
        elseif command ∈ filekeys
            data = jld2file[command]
            # println(repr(MIME("text/plain"), data))
            show(IOContext(stdout, :limit => true), "text/plain", data)
        elseif command == "q"
            println("exit...")
            break
        elseif command == "."
            for key in filekeys
                data = jld2file[key]
                print(Crayon(foreground = (194,94,95)), key)
                println(Crayon(reset=true), "")
                println(summary(data))
                show(data)
            end
        else
            no_ask += 1
            println("no ask: $no_ask")
        end
        println("\n    (h / ls / q)\n")
        print(Crayon(foreground = (194,94,95)), "JLD2>")
        print(Crayon(reset=true), " ")
        command = readline()
    end
end
# end