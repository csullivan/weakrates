A Weak Interaction Rate Library With Interchangable Nuclear Data
--

[![DOI](https://zenodo.org/badge/19229/csullivan/weakrates.svg)](https://zenodo.org/badge/latestdoi/19229/csullivan/weakrates)

Author: [Chris Sullivan] (sullivan@nscl.msu.edu)

[National Superconducting Cyclotron Laboratory]

[Joint Institute for Nuclear Astrophysics: Center for the Evolution of the Elements]

Maintained permanently by the [NSCL Charge-Exchange group]

[Chris Sullivan]: https://people.nscl.msu.edu/~sullivan/
[National Superconducting Cyclotron Laboratory]: http://nscl.msu.edu/
[Joint Institute for Nuclear Astrophysics: Center for the Evolution of the Elements]: http://www.jinaweb.org/
[NSCL Charge-Exchange group]: https://groups.nscl.msu.edu/charge_exchange/


Copyright:		    
----------
This weak-rate library is open source, but copyrighted by Chris Sullivan 
and the NSCL Charge-Exchange group.
The code is released to the community under the
Creative Commons attribution-noncommercial-share alike license:

http://creativecommons.org/licenses/by-nc-sa/3.0/us

The license stipulates that you may use this library but must make reference to
this work, must not use it for any commercial purpose, and any code including or
using these routines or part of them may be made publically available,
and if so, only under the same license.

NOTICE: The software is provided "as is", without warranty of any kind,
express or implied, including but not limited to the warranties of
merchantability, fitness for a particular purpose and noninfringement.
In no event shall the authors be liable for any claim, damages or
other liability, whether in an action of contract, tort or otherwise,
arising from, out of or in connection with the software or the use or
other dealings in the software. The authors cannot guarantee they will
be able to provide support for integrating these routines into your simulations
if problems arise. It is the responsibility of the user of this library, not
the author, to check the physical correctness and consistency of any and all
outputs of this library.


Electron-Capture Rates on Nuclei:
---------------------------------

This library is a new module for estimating microphysical electron-capture rates on nuclei.
It utilizes the formalism discussed in:
<pre>
----[1]-----------------------------------------------------------------------------
| Sullivan, C., O'Connor, E., Zegers, R. G. T., Grubb, T., & Austin, S. M. (2015). |
| The Sensitivity of Core-Collapse Supernovae to Nuclear Electron Capture.         |
| The Astrophysical Journal (submitted)                                            |
| http://arxiv.org/abs/1508.07348                                                  |
| Contact: Chris Sullivan <sullivan@nscl.msu.edu>                                  |
------------------------------------------------------------------------------------
</pre>
At it's core, this code is a library of electron-capture rate tables and
are available as a part of the ratelibrary class (set in the parameters
file). In addition, number densities (abundances) and nuclear masses
are needed for a large set of nuclei. These are calculated via Matthias
Hempel's NSE mass distributions discussed below. This library provides
a variety of weak interaction rates for over 6000 species of nuclei. Emissivities
and opcaities for electron capture are provided in a sister code (NuLib), located
at http://www.nulib.org/. To utilize rates from this work, one must cite the above paper
as well the following publications from which the utilized weak-rate tables derive:
<pre>
----[2]-------------------------------------------------------------------------
| Fuller, G. M., Fowler, W. A., & Newman, M. J. (1982).                        |
| Stellar weak interaction rates for intermediate-mass nuclei.                 |
| II - A = 21 to A = 60. The Astrophysical Journal, 252, 715.                  |
| http://doi.org/10.1086/159597                                                |
----[3]-------------------------------------------------------------------------
| Oda, T., Hino, M., Muto, K., Takahara, M., & Sato, K. (1994).                |
| Rate Tables for the Weak Processes of sd-Shell Nuclei in Stellar Matter.     |
| Atomic Data and Nuclear Data Tables, 56(2), 231-403.                         |
| http://doi.org/10.1006/adnd.1994.1007                                        |
----[4]-------------------------------------------------------------------------
| Langanke, K., & Mart\'{i}nez-Pinedo, G. (2000).                              |
| Shell-model calculations of stellar weak interaction rates:                  |
| II. Weak rates for nuclei in the mass range in supernovae environments.      |
| Nuclear Physics A, 673(1-4), 481-508.                                        |
| http://doi.org/10.1016/S0375-9474(00)00131-7                                 |
----[5]-------------------------------------------------------------------------
| Langanke, K., & Mart\'{i}nez-Pinedo, G. (2003).                              |
| Electron capture rates on nuclei and implications for stellar core collapse. |
| Physical Review Letters 90, 241102.                                          |
| http://prl.aps.org/abstract/PRL/v90/i24/e241102                              |
--------------------------------------------------------------------------------
</pre>
In addition to the above rate tables, this library employes an approximate routine
for estimating the electron capture and neutrino energy loss rates for nuclei
which are not included in the tables, and for density and temperatures outside the
range of the tabulations. This routine is an analytic extension of the
rates present in the LMP data set and was introduced in reference [5] above.
This routine takes as input the ground state to ground state mass difference (Q),
as well as the temperature and electron chemical potential. A variety of nuclear
mass tables can be used in this code via Matthias Hempel's NSE composition routines
(see below for more information). Calculating the electron chemical-potential relies
upon nuclear equations of state which were compiled by 
Evan O'Connor and Christian Ott's and are used in this code via their nuc_eos routines.
These EOS are self consistent with the NSE compositions provided by Matthias Hempel.
Thus, if the approximate electron capture rate routine is used, in addition to
references [1] and [3], please also cite:
<pre>
----[6]-------------------------------------------------------------------------
| O'Connor, E., & Ott, C. D. (2010).					                            |
| A new open-source code for spherically symmetric stellar collapse to neutron |
| stars and black holes.                                                       | 
| Classical and Quantum Gravity, 27(11), 114103.			                      |	    
| http://doi.org/10.1088/0264-9381/27/11/114103                                | 
----[7]-------------------------------------------------------------------------
| Hempel, M., & Fischer, T. (2012).				                                  |
| New Equations of State in Simulations of Core-collapse Supernovae.           |
| The Astrophysical Journal, 70.					                                  |
| http://iopscience.iop.org/0004-637X/748/1/70                                 |
--------------------------------------------------------------------------------
</pre>
Installation:
-------------
1. Clone this repository to your local machine

2. Copy make.inc.template to make.inc and update with correct compiler information
   (Some options default options are implemented which should work for most users)
   
3. Run 'Make'

4. An input parameter file 'parameters_template' is located in the top leve directory.
   Rename the file to 'parameters' and set the relevant options here, including the
   absolute paths to the desired rate tables. Rate tables can be downloaded from:
   [LINK]

 *  That's it! The example executable should have compiled and be ready to use.  *

   ------------------
   
5. (optional) If approximate rate estimates for nuclei not included in the tabulated
   rate files are desired (see ref. [1])), an EOS and mass table will be necessary.
   This code utilizes the EOS driver routines and EOS from E. O'Connor and C. D. Ott
   located at http://www.stellarcollapse.org/equationofstate. Visit this website and
   obtain the EOS table of choice.
   
6. (optional) The EOS driver (nuc_eos module), requires the HDF5 libraries. They must be
   compiled with the same compiler that is used to compile this code. Two options exist:
   (a) download and compile the HDF5 libraries and update the relevant flags in make.inc
   (b) download the mesasdk (http://www.astro.wisc.edu/~townsend/static.php?ref=mesasdk)
   and utilize the gfortran compiler and HDF5 libs within it.
   
7. (optional) Matthias Hempel's NSE mass distributions (which include the necessary
   mass tables) are available from http://phys-merger.physik.unibas.ch/~hempel/eos.html.
   To enable these, the user must download the composition code and tables from his
   website and update the HEMPEL_DIRECTORY preprocessor flag to point to the directory
   of this library in make.inc. The SFHo table and EOS is used as an example in the
   code, you can change this by editting nuclei_distribution_helpers.F90 directly.
   Please see this file for more details.
   
8. (optional) A few small changes must be made to xxxx_xxxx_composition_module.f as
   provided by M. Hempel if the weak_rates module (electron-capture rates). Primarily
   a public (non-private) copy of the loaded nuclear masses must be exposed. e.g. for
   the SFHo EOS, one must add the following to the source file:
<pre>
   ---------------------------------------------------
   | double precision, dimension(kmax) :: sfho_mass  |
   |---------------------- & ------------------------|
   | sfho_mass = mass                                |
   ---------------------------------------------------
</pre>
   * Finally, update the path inside the *_composition.f to correctly point to the
   compotion binary.
