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

function show_list(jld2file)
    for (idx, key) in enumerate(keys(jld2file))
        println("$key =>")
        println(jld2file[key])
    end
end