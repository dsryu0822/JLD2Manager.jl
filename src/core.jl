help_message = """
Usage:
  idx             Show the 'idx'th data
*                   also 'idx1:idx2' works
  name            Show the data with 'name'
*                   also 'names1:names2' works
  [command]       
  .               Show all data

Available Aliasis:
* csv dat         `export data -csv`
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

* doc             Show Advanced feature
  exit            Stop this program
  ls              Show list of reading file
  r idx			  Read the 'idx'th data
  r name		  Read the data with 'name'
  n               Go to next `*.jld2` file
  p               Go to previous `*.jld2` file
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

function show_(data)
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
        input = "r " * input
    end
    CL = split(strip(input), " ")[.!isempty.(split(strip(input), " "))]
    push!(CL, "")
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

function get_(jld2file, object, filekeys)
    if prod(isdigit.([a for a in object]))
        return jld2file[filekeys[parse(Int, object)]]
    elseif object ∈ filekeys
        return jld2file[object]
    end
end

# function export(data, filename)
#     if isa(data, Matrix)
#         CSV.write("$filename.$ob")
# end

function read(filename, jld2list)
    jldopen(filename) do jld2file
		filekeys = keys(jld2file)
		command = "welcome"
		object = ""

		page = 0
		while command != "exit"
			page += 1
			if command in ["welcome", "h", "pwd"]
                print_oneline(command)
			elseif command == "ls"
				show_ls(jld2file)
			elseif command == "r"
                data = get_(jld2file, object, filekeys)
                show_(data)
            elseif command == "csv"
                data = get_(jld2file, object, filekeys)
                # export(data)
			elseif command in ["n", "p"]
				newfileidx = mod(findfirst(filename .== jld2list) + ifelse(command == "p", -1, 1) - 1, length(jld2list)) + 1
				return jld2list[newfileidx]
			else
				println("page: $page")
			end
            print_mode(:JLD2)
            command, object = CLI(filekeys)
		end
	end
end