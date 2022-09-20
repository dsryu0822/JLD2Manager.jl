module JLD2Manager

cd(@__DIR__)
print("JLD2Manager.bat is in ")
println(pwd())
println("please run 'powersehll' or 'window terminal' as administrator")
println("       run 'julia'")
println(" type that 'using JLD2Manager' in REPL")
run(`icacls .\\src\\JLD2manager.bat /GRANT Everyone:F`)
run(`cmd /c assoc .jld2=JLD2Manager.bat`)

end # module