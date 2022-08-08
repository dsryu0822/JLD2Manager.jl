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
* n               Go to next `*.jld2` file
* p               Go to previous `*.jld2` file
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

function read(directory, filename, jld2list)
    jldopen(joinpath(directory, filename)) do jld2file
		filekeys = keys(jld2file)
		input = ""

		# for (idx, key) in enumerate(filekeys)
		# 	if idx != maximum(idx)
		# 		println("├─ " * lpad(idx, idxl) *" "* lpad(key, keyl))
		# 	else
		# 		println("└─ " * lpad(idx, idxl) *" "* lpad(key, keyl))
		# 	end
		# end
    
		page = 0
		while input != "exit"
			page += 1
			if input in ["", "h", "q", "pwd"]
				if input == ""
					println("page: $page")
				elseif input == "h"
					println(help_message)
				elseif input == "q"
					break
				elseif input == "pwd"
					println(directory)
				end
			elseif input ∈ ["ls"]
				show_ls(jld2file)
			elseif prod(isdigit.([a for a in input]))
				idx = parse(Int, input)
				data = jld2file[filekeys[idx]]
				show(IOContext(stdout, :limit => true), "text/plain", data)
			elseif input ∈ filekeys
				data = jld2file[input]
				show(IOContext(stdout, :limit => true), "text/plain", data)
			elseif input == "."
				for key in filekeys
					data = jld2file[key]
					print(Crayon(foreground = (194,94,95)), key)
					println(Crayon(reset=true), "")
					show(IOContext(stdout, :limit => true), "text/plain", data)
				end
			elseif input in ["n", "p"]
				newfileidx = mod(findfirst(filename .== jld2list) + ifelse(input == "p", -1, 1) - 1, length(jld2list)) + 1
				return jld2list[newfileidx]
			else
				println("page: $page")
			end
			println("   (h / ls / q)\n")
			print(Crayon(foreground = (194,94,95)), "JLD2>")
			print(Crayon(reset=true), " ")
			input = readline()
		end
	end
end