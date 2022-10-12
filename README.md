# Install conda
```
bash ./scripts/Miniconda3-latest-Linux-x86_64.sh -b -u -p $(pwd)/.miniconda3
source .miniconda3/bin/activate
conda install -c conda-forge -y mamba
mamba install -c bioconda -y bwa bowtie2 yara
```


# Install brew
#!TODO missing how to install brew
```
brew install google-sparsehash
```

# Build tools
```
export CC=gcc-12
export CXX=g++-12
export MAKEFLAGS="-j16"
scripts/compile.sh
```
