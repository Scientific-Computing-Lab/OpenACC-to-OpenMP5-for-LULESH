# OpenACC-to-OpenMP5-for-LULESH

This repository accompanies the study **"Can We Achieve Competitive OpenMP Offload Performance by Simply Translating from OpenACC?"**, focusing on the **LULESH** (Livermore Unstructured Lagrangian Explicit Shock Hydrodynamics) mini-app.

## Repository Contents

The repository contains multiple implementations of LULESH:

- **HeCBench LULESH OpenMP 4.5 and CUDA** – Original OpenMP 4.5 offload implementation and CUDA version from the HeCBench suite.
- **LULESH-OpenACC** – OpenACC version of LULESH.
- **LULESH-OpenACC-translation** – Automatically translated version of LULESH-OpenACC using the Intel Application Migration Tool for OpenACC to OpenMP 5.0 (contribution of this work).

## Goal

The purpose of this work is to evaluate whether competitive **OpenMP offload** performance can be achieved by **directly translating** an existing **OpenACC** application, without extensive manual optimizations.

## Compilation & Execution

Each implementation resides in its own subdirectory and can be compiled and executed independently.

### General Steps
1. **Navigate** to the desired version’s directory.
2. **Compile** with ```make```.
3. **Run** (for example) with ```./lulesh2.0 -s 300 -i 100```.

