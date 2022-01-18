#! /usr/bin/env python
from nexus import settings,job,run_project
from nexus import generate_physical_system
from nexus import generate_pwscf
from nexus import generate_pw2qmcpack
from nexus import generate_qmcpack,loop,linear,vmc,dmc
from nexus import bundle                                                                                                                                                                                                             
from structure import *
settings(
    pseudo_dir    = 'pseudos',
    results       = '',
    runs          = 'runs',
    status_only   = 0,
    generate_only = 0,
    sleep         = 5,      # In seconds
    machine       = 'cori', # Use lowercase letters
    account       = 'm2113',   # QMCPACK
    user          = 'bkincaid'
    )
qmc_presub = '''
module unload cray-libsci
module load cray-hdf5/1.10.2.0
module load gcc
module list
'''
scf_presub = '''
export HDF5_USE_FILE_LOCKING=FALSE
module load espresso
module unload cray-libsci
module load cray-hdf5/1.10.2.0
module load gcc
module list
'''
system = generate_physical_system(
    units     = 'A',
    #DIRECT LATTICE VECTORS CARTESIAN COMPONENTS (ANGSTROM)
    axes      = [
                [12.0, 0.0, 0.0],
                [0.0, 12.0, 0.0],
                [0.0, 0.0, 12.0],
                ],
    elem      = ['Te'],  # positions below should correspond to this
    # CARTESIAN COORDINATES - PRIMITIVE CELL
    net_spin = 2,
    pos       = [
                [6.0, 6.0, 6.0],
                ],
    #tiling    = [[1, -1, 0], [1, 1, 0], [0, 0, 1]],
    tiling    = (1,1,1),
    use_prim  = True, # use SeeK-path library to identify prim cell
    #add_kpath = True, # use SeeK-path library to get prim k-path (use this for only getting band structure)
    Te        = 6,
    kgrid  = (1,1,1),   # Use this if interested in particular k-point excitations (QMC grid)
    kshift = (0.0,0.0,0.0),   # Use this if interested in particular k-point excitations
    )
sims = []
#### For QE
#NODES=4
#PROCS_PERNODE=32
#HT=1
#PROCS=NODES*PROCS_PERNODE
#NTHREADS=(32*HT/PROCS_PERNODE)
scf_dirs = {}
scf_dirs[1000] = generate_pwscf(
    identifier   = 'scf_1000',
    path         = 'scf_1000',
    job          = job(nodes=1, cpus_per_task=16, queue='debug', hours=0.5, constraint='haswell', app='pw.x', presub=scf_presub),
    input_type   = 'generic',
    calculation  = 'scf',
    nspin        = 2,   # 1 is non-polarized calculation (default)
    #noncolin     = True,
    #lspinorb     = True,
    #input_dft    = 'pbe', 
    input_dft    = 'pbe', 
    #exx_fraction = 0.15,
   #nqx1         = 1,
   #nqx2         = 1,
   #nqx3         = 1,
   #ecutfock     = 60,
    ecutwfc      = 1000,   
    #conv_thr     = 1e-7, 
    #occupations  = 'fixed',
    #smearing     = 'gaussian',
    #degauss      = 0.0001,
    #nosym        = True, # should be False if nscf is next
    #nosym_evc    = True,
    #noinv        = True,
    wf_collect   = True, # should be False if nscf is next
    verbosity    = 'high',  # verbosity must be set to high
    #disk_io      = 'low',
    system       = system,
    nbnd         = 12,       # a sensible nbnd value can be given 
    #kgrid        = (1,1,1),  # Must be high-density
    #kshift       = (0,0,0),
    tot_magnetization = 2,
    start_mag    = {"Te":0.50},
    pseudos      = ['Te.upf'], 
    #max_seconds  = (0.5-0.05)*3600,
    #restart_mode = 'restart',
    )
sims.append(scf_dirs[1000])

###### pw2qmcpack should use the same parallelization options (MPI tasks and k-pools) as the last scf/nscf calculation!
#conv = generate_pw2qmcpack(
#    identifier   = 'conv',
#    path         = 'scf',
#    job          = job(nodes=1, tasks_per_node=1, cpus_per_task=1, queue='debug', hours=0.50, constraint='knl', app=espresso_path+'pw2qmcpack.x', presub=scf_presub),
#    write_psir   = False,
#    dependencies = (scf,'orbitals'),
#    )
#sims.append(conv)
#
run_project(sims)
