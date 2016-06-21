!-*-f90-*-
program example
  use nuclei_hempel
  use class_ratelibrary
  use class_ratetable
  use class_rateapproximation

  implicit none
  ! parameters file containing tables and loading priority 
  character*200 :: parameters_filename = "./parameters"

  ! the weak rate library object
  type(RateLibrary) :: weakrate_library 

  ! function parameters
  integer :: A,Z,table_index
  double precision :: T9,logrhoye
  double precision :: temp_mev, qvalue_mev, echempot_mev
  double precision :: density_gcm3, ye
  double precision :: rate

  ! enums and physical constants
  include 'src/constants.inc'
  double precision :: eos_variables(total_eos_variables)
  
  ! Initialization 
  m_ref = m_amu !sets reference mass for NSE
  call set_up_Hempel !set's up EOS for nuclear abundances
  weakrate_library = new_RateLibrary(parameters_filename)
  call readtable(weakrate_library%eos_path) !read in EOS table 

  ! ------------------------------------------------------------------------ !
  ! There are three ways to access the weak rates.                           !
  ! But in each case, the return_weakrate function interface is used         !
  ! and the difference lies in the function parameters that are passed in.   !
  ! These three methods are detailed below.                                  !
  ! ------------------------------------------------------------------------ !
  
  A = 66
  Z = 26  ! Ni56
  T9 = 10.0d0 ! 10 GK
  logrhoye = 11.0d0 ! log10(density*ye [g/cm3])
  table_index = in_table(weakrate_library,A,Z,logrhoye,T9) ! retrieve table containing rate  
  
  rate = return_weakrate(weakrate_library,A,Z,T9,logrhoye,table_index,ecapture)
  print *, "return_weakrate_from_table: ",log10(rate)

  ! The above function (interface) call uses the return_weakrate_from_table function
  ! ------
  !    function return_weakrate_from_table(ratelibrary_object,A,Z,query_t9,query_lrhoye,idxtable,idxrate)
  ! ------
  ! This function is useful when you know which table you would like to get a specific rate from.
  ! The parameters are mostly self explanitory, note that idxtable is an index to the specific table
  ! that should be used and it corresponds to the table priority that is set in the ./parameters file
  ! e.g. if lmp is set to the highest priority, then idxtable=1 will pick the lmp table
  ! idxrate indicates which rate is requested see constants.inc for all possible choices
  ! The in_table function can be used to select the table with the highest priority (as set in the
  ! ./parameters file) that contains a rate for the nucleus of interest, if the table index isn't known 

  temp_mev = T9*1.0d9*kelvin_to_mev ! MeV
  ye = 0.28 ! electron fraction
  density_gcm3 = (10**logrhoye)/ye ! g/cm3
  call get_nuc_eos(density_gcm3,temp_mev,ye,eos_variables)
  echempot_mev = eos_variables(mueindex)
  qvalue_mev = return_hempel_qec(A,Z,Z-1) ! Get Q-value of Ni56 (MeV)
  
  rate = return_weakrate(ecapture,temp_mev,qvalue_mev,echempot_mev)
  print *, "return_weakrate_from_approx: ",log10(rate)

  ! The above function (interface) call uses the return_weakrate_from_approx function
  ! ------
  !   function return_weakrate_from_approx(idxrate,xtemp,xq,xmue) 
  ! ------
  ! This function returns an approximate weak rate estimate for a nucleus of a given Q.
  ! It is presently only defined for electron-capture and nue energy loss rates.

  rate = return_weakrate(weakrate_library,A,Z,density_gcm3,temp_mev,ye,echempot_mev,ecapture)
  print *, "return_weakrate_dynamic_search: ",log10(rate)
  
  ! The above function (interface) call uses the return_weakrate_dynamic_search function
  ! ------
  !   function return_weakrate_dynamic_search(this,A,Z,xrho,xtemp,xye,xmue,idxrate) 
  ! ------
  ! This function is a wrapper on the prior two functions. For the requested nucleus,
  ! it figures out which table to utilize (based on the priority hierarchy in ./parameters)
  ! and if no tabulated rate is available it uses the approximation. This is a convenience
  ! function and thus should be expected to be slower than calling the other functions directly
  ! since it must search for the correct table to use every time, but it is still decently fast.
  
  
end program example
