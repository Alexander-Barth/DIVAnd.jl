using Base.Test
using NetCDF
using Interpolations
using divand

bath_name = joinpath(ENV["HOME"],"Data","DivaData","Global","gebco_30sec_2.nc");

x0 = 27.0
x1 = 41.8
dx = 0.12
y0 = 40.3
y1 = 46.8
dy = 0.1
level  = 0
isglobal = true;


xi,yi,mi = load_mask(bath_name,isglobal,x0,x1,dx,y0,y1,dy,level)


levels = [0,100,1000]
xi,yi,mis = load_mask(bath_name,isglobal,x0,x1,dx,y0,y1,dy,levels)

@test mi == mis[:,:,1]
