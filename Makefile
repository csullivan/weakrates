include make.inc

SOURCES=src/input_parser.F90 \
	src/nuclei_distribution_helpers.F90 \
	src/ratetable.F90 \
	src/rateapprox.F90 \
	src/ratelibrary.F90 
#	src/interface.F90 

ifeq ($(INCLUDE_APPROX),1)
	NUCLEI_HEMPEL=1
        #take care of EOS dependences etc
	EXTRAINCS = -I./src/nuc_eos
	EXTRADEPS = src/nuc_eos/nuc_eos.a
	EXTRAOBJECTS = src/nuc_eos/nuc_eos.a
	EXTRAINCS += $(HDF5INCS)
	EXTRAOBJECTS += $(HDF5LIBS)
        #extra C library dependence
	EXTRACDEPS = ./src/Clibs.a
	CLIB_SRC = ./src/calc_delta_e.c
	CLIB_OBJECTS = $(CLIB_SRC:.c=.o)
	F_SOURCES = $(HEMPEL_DIRECTORY)sfho_frdm_composition_module.f
	F_OBJECTS=$(F_SOURCES:.f=.o )
	MODINC += -I$(HEMPEL_DIRECTORY)
	DEFS += -DINCLUDE_APPROX
endif


ifeq ($(OPENMP),1)
ifeq ($(F90),gfortran)
	F90FLAGS += -fopenmp
else
	F90FLAGS += -openmp
endif	
endif


EXTRADEPS = src/constants.inc
OBJECTS=$(SOURCES:.F90=.o )
ARCHIVE=weakrates.a

all: src/nuc_eos/nuc_eos.a weakrates.a example

example:  $(EXTRADEPS) $(EXTRACDEPS) $(F_OBJECTS) $(OBJECTS) example.F90
	$(F90) $(F90FLAGS) $(DEFS) $(MODINC) $(EXTRAINCS) -o $@ example.F90 $(OBJECTS) $(F_OBJECTS) $(EXTRAOBJECTS) $(EXTRACDEPS)

weakrates.a: $(EXTRADEPS) $(F_OBJECTS) $(OBJECTS) $(NT_OBJECTS) $(CLIB_OBJECTS)
	ar -r src/weakrates.a src/*.o

$(OBJECTS): %.o: %.F90 $(EXTRADEPS)
	$(F90) $(F90FLAGS) $(DEFS) $(MODINC) $(EXTRAINCS) -c $< -o $@

$(F_OBJECTS): %.o: %.f 
	$(F90) $(F90FLAGS) $(DEFS) $(MODINC) $(EXTRAINCS) -c $< -o $@	

src/nuc_eos/nuc_eos.a: src/nuc_eos/*.F90 src/nuc_eos/*.f
	$(MAKE) -C src/nuc_eos

src/Clibs.a: $(CLIB_OBJECTS)
	ar -rvs ./src/Clibs.a $(CLIB_OBJECTS)
$(CLIB_OBJECTS): %.o: %.c
	gcc $(CFLAGS) -c $< -o $@


clean:
	rm -rf example
	rm -rf src/*.o
	rm -rf src/*~
	rm -rf src/*.mod
	rm -rf src/*.a
	rm -rf *.o
	rm -rf *.mod
	rm -rf *~
	$(MAKE) -C src/nuc_eos clean	
	rm -rf $(HEMPEL_DIRECTORY)*.o
