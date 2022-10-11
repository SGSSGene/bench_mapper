# Install conda

bash ./scripts/Miniconda3-latest-Linux-x86_64.sh -b -u -p $(pwd)/.miniconda3
source .miniconda3/bin/activate
conda install -c conda-forge -y mamba
mamba install -c bioconda -y bwa bowtie2 libgcrypt


# Install brew
#!TODO missing how to install brew
brew install google-sparsehash

# Build tools
scripts/install.sh
