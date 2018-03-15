"""


    cpme = divand_cpme_go(mask,pmn,xi,x,f,len,epsilon2,...);



# Input:
* `mask`: binary mask delimiting the domain. true is inside and false outside. For oceanographic application, this is the land-sea mask.

* `pmn`: scale factor of the grid. pmn is a tuple with n elements. Every
       element represents the scale factor of the corresponding dimension. Its
       inverse is the local resolution of the grid in a particular dimension.

*  `xi`: tuple with n elements. Every element represents a coordinate
  of the final grid on which the observations are interpolated

* `x`: tuple with n elements. Every element represents a coordinate of
  the observations

* `f`: value of the observations *minus* the background estimate (m-by-1 array).
    (see note)

* `len`: correlation length

* `epsilon2`: error variance of the observations (normalized by the error variance of the background field). `epsilon2` can be a scalar (all observations have the same error variance and their errors are decorrelated), a vector (all observations can have a difference error variance and their errors are decorrelated) or a matrix (all observations can have a difference error variance and their errors can be correlated). If `epsilon2` is a scalar, it is thus the *inverse of the signal-to-noise ratio*.

# Optional input arguments specified as keyword arguments also as for divand


# Output:

* `cpme`: the clever poor mans error


Compute a variational analysis of arbitrarily located observations to calculate the clever poor man's error. ONLY USE THIS VERSION IF YOU CANNOT RUN DIVANDGO with :cmpe activated (or directly divand_cpme)


"""


function divand_cpme_go(mask,pmn,xi,x,f,Labs,epsilon2; otherargs...)


    
    errorscale=1;

    # The factor 1.70677 is the best one in 2D but should be slightly different for other dimensions
    # Could be a small improvement. Also used in divand_aexerr


    if isa(Labs,Tuple)
        len=([x./1.70766 for x in Labs]...);
    else
        len=Labs./1.70766
    end


    
        cpme,bidon,zut =  divandgo(mask,pmn,xi,x,ones(size(f)),len,epsilon2,:none; otherargs...);
		@show size(cpme),size(bidon),size(zut)
        cpme=errorscale .* max.(-cpme.+1,0)

    return cpme

end

# Copyright (C) 2008-2017 Alexander Barth <barth.alexander@gmail.com>
#                         Jean-Marie Beckers   <JM.Beckers@ulg.ac.be>
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <http://www.gnu.org/licenses/>.

# LocalWords:  fi divand pmn len diag CovarParam vel ceil moddim fracdim
