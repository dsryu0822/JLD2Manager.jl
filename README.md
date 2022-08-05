# JLD2Manager

Easy, lightweight CLI to manage *.jld2 files. JLD2Manager will make [JLD2.jl](https://github.com/JuliaIO/JLD2.jl) be more convinient.

## Usage

1. Install the `JLD2Manager`.
```
] add JLD2Manager
```
or
```
$ git clone https://github.com/rmsmsgood/JLD2Manager.jl.git
```

2. right-click any jld2 file → select `Open with` → and click `Choose another app` from the menu that appears.
![20220806_022723.png](20220806_022723.png#center)

3. Choose the `./src/JLD2manager.bat` in your local repository. If you get `JLD2Manager.jl` via `Pkg`, you may find `JLD2manager.bat` below directory:

```
C:/Users/(yourname)/.julia/packages/JLD2manager/(something)/src/
```

4. Just double-click jld2 file to open.

![Honeycam 2022-08-06 02-59-09.gif](Honeycam 2022-08-06 02-59-09.gif#center)

5. Chek your jld2 file.

![Honeycam 2022-08-06 03-00-53.gif](Honeycam 2022-08-06 03-00-53.gif#center)

## Future Work

I'm trying to implement a lot of things, e.g. simple visualization, file statistics, direct modifying, native julia-like command...