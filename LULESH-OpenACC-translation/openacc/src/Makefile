SHELL = /bin/sh
.SUFFIXES: .cc .o

LULESH_EXEC = lulesh2.0

MPI_INC = /usr/local/include/openmpi
MPI_LIB = /usr/local/lib

SERCXX = pgc++ -DUSE_MPI=0
MPICXX = mpicxx -DUSE_MPI=1
#CXX = $(MPICXX)
CXX = $(SERCXX)
SOURCES2.0 = \
	lulesh.cc \
	lulesh-comm.cc \
	lulesh-util.cc \
	lulesh-init.cc \

OBJECTS2.0 = $(SOURCES2.0:.cc=.o)

#CXXFLAGS = -O3

OMPFLAGS = -mp=gpu -gpu=cc80,fastmath,unroll
CXXFLAGS +=--restrict -Mautoinline -Minline=levels:20 $(OMPFLAGS) -O3 -Minfo=accel -Msafeptr -mcmodel=medium -Wl,--no-relax -DSEDOV_SYNC_POS_VEL_LATE

LDFLAGS =  $(OMPFLAGS) 


.cc.o: lulesh.h
	@echo "Building $<"
	$(CXX) -c $(CXXFLAGS) -o $@ $<

all: $(LULESH_EXEC)

lulesh2.0: $(OBJECTS2.0)
	@echo "Linking"
	$(CXX) $(OBJECTS2.0) $(LDFLAGS) -lm -o $@

clean:
	/bin/rm -f *.gpu *.o *~ $(OBJECTS) $(LULESH_EXEC)
	/bin/rm -rf *.dSYM

tar: clean
	cd .. ; tar cvf lulesh-2.0.tar LULESH-2.0 ; mv lulesh-2.0.tar LULESH-2.0

