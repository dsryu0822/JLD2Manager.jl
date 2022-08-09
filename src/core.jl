help_message = """
Usage:
  idx             Show the 'idx'th data
  name            Show the data with 'name'
  [command]       Excute command line
  .               Show all data

Available Aliasis:
  csv dat         `export data -csv`
* e data          `export data -auto`

Available Commands:
* export data -op Export the 'data' with -op format
                    -auto or none: autumatically choose format
                    -csv: export `*.csv`, availalbe for `Vector{any}`, `Matrix`, `DataFrame`
* plot data -op   Plot a UnicodePlot
                    -auto or none: autumatically choose style
                    -line: availalbe for `Vector{Number}`, `Matrix`
                    -scatter: availalbe for `Matrix`
       data1 data2  -scatter: availalbe for two `Vector{Number}`

  ls              Show list of reading file
  r idx			  Read the 'idx'th data
  r name		  Read the data with 'name'
  n               Go to next `*.jld2` file
  p               Go to previous `*.jld2` file
  cd fileidx      Go to `fileidx`th `*.jld2` file
  ?               Help about any command

 * means now developing  
"""

# clipboard()

function show_ls(jld2file)
	idxl = jld2file |> keys |> length |> log10 |> ceil |> Int
	keyl = jld2file |> keys .|> length |> maximum
	filekeys = keys(jld2file)
	# textwidth
	println((" "^idxl) *" "* lpad("key", keyl) * lpad("size", 16) * lpad("type", 16) * lpad("preview", 16))
	for (idx, key) in enumerate(filekeys)
		data = jld2file[key]
		datatype = typeof(data)
		print(lpad(idx, idxl) * " "
			* lpad(key, keyl)
			* lpad(sizeof(data), 16)
			* lpad(datatype, 16)
			);
		prvw = (datatype <: Number) ? lpad("$(trunc(data, digits = 6))", 16) : lpad("", 16)
		println(prvw)
	end
end

function show_data(data)
    show(IOContext(stdout, :limit => true), "text/plain", data)
    println()
end

function CLI(filekeys)
    input = readline()
    if isempty(input)
        input = ""
    elseif input ∈ filekeys
        input = "r " * input
    elseif prod(isdigit.([a for a in input]))
        id_object = parse(Int, input)
        if 1 ≤ id_object ≤ length(filekeys)
            input = "r " * filekeys[id_object]
        else
            input = ""
        end
    end
    CL = split(strip(input), " ")[.!isempty.(split(strip(input), " "))]
    push!(CL, "")
    if first(CL) == "csv"
        id_object = parse(Int, CL[2])
        if 1 ≤ id_object ≤ length(filekeys)
            CL[2] = filekeys[id_object]
        else
            CL = [""]
        end
    end
    push!(CL, "")
    return CL
end

function print_oneline(command)
    if command == "welcome"
        println("jld2 file opened")
    elseif command == "h"
        println(help_message)
    elseif command == "pwd"
        println(pwd())
    end
end

function print_mode(mode)
    if mode == :JLD2
        println(Crayon(reset=true), "")
        print(Crayon(foreground = (194,94,95)), "JLD2>")
        print(Crayon(reset=true), " ")
    end
end

function export_csv(data, filename, object)
    if isa(data, DataFrame)
        CSV.write("$filename.$object.csv", data)
    elseif isa(data, Matrix)
        _, colsize = size(data)
        open("$filename.$object.csv", "w") do csvfile
            for i in eachrow(data)
                for (lastcheck, j) in enumerate(i)
                    print(csvfile, j)
                    colsize != lastcheck ? print(csvfile, ",") : println(csvfile, "")
                end
            end
        end
    elseif isa(data, Vector)
        open("$filename.$object.csv", "w") do csvfile
            for element in data println(csvfile, element) end
        end
    end
end

function monitor(filename, jld2list)
    jldopen(filename) do jld2file
		filekeys = keys(jld2file)
		command = "welcome"
		object = ""

		page = 0
		while command != "exit"
			page += 1
			if command in ["welcome", "h", "pwd", "clc"]
                print_oneline(command)
			elseif command == "ls"
				show_ls(jld2file)
			elseif command == "r"
                show_data(jld2file[object])
            elseif command == "csv"
                data = jld2file[object]
                export_csv(data, filename, object)
			elseif command in ["n", "p"]
				newfileidx = mod(findfirst(filename .== jld2list) + ifelse(command == "p", -1, 1) - 1, length(jld2list)) + 1
				return jld2list[newfileidx]
            elseif command == "cd"
                return jld2list[mod(parse(Int, object) - 1,length(jld2list)) + 1]
			else
				println("page: $page")
			end
            print_mode(:JLD2)
            command, object = CLI(filekeys)
		end
	end
end