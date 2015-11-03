!-*-f90-*-
program example
  use nuclei_hempel
  use class_ratelibrary
  implicit none
  !NuLib parameters file (weak rates and EOS)
  character*200 :: parameters_filename = "parameters"
  type(RateLibrary) :: weakrate_library
  include 'src/constants.inc'

  m_ref = m_amu
  call set_up_Hempel !set's up EOS for nuclear abundances
  weakrate_library = new_RateLibrary(parameters_filename)
  !print *, in_table(weakrate_library,78,33,10.0d0,10.0d0)
  
  
end program example
