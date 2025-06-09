clear all

sjlog using gtfpch1, replace
use example
describe 
sjlog close, replace

sjlog using gtfpch2, replace
teddf K L = Y: CO2, dmu(Province) time(year) saving(ex.teddf.result, replace)
sjlog close, replace

sjlog using gtfpch3, replace
generate gK = 0
generate gL = 0
generate gY = Y
generate gCO2 = -CO2
teddf K L = Y: CO2, dmu(Province) time(year) gx(gK gL) gy(gY) gb(gCO2) saving(ex.teddf.direction.result, replace)
sjlog close, replace

sjlog using gtfpch4, replace
teddf K L = Y: CO2, dmu(Province) time(year) nonradial saving(ex.teddf.nonr.result, replace)
sjlog close, replace

sjlog using gtfpch5, replace
matrix wmatrix = (0.5,0.5,1,1)
teddf K L = Y: CO2, dmu(Province) time(year) nonradial wmat(wmatrix) saving(ex.teddf.nonr.weight.result, replace)
sjlog close, replace

sjlog using gtfpch6, replace
egen id = group(Province)
xtset id year
gtfpch K L = Y: CO2, dmu(Province) global saving(ex.gtfpch.result, replace)
sjlog close, replace

sjlog using gtfpch7, replace
gtfpch K L = Y: CO2, dmu(Province) nonradial global saving(ex.gtfpch.nonr.result, replace)
sjlog close, replace
