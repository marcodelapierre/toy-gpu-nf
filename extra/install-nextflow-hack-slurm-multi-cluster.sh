#!/bin/bash
 
# assuming this script is run on either Magnus or Galaxy
 
 
# CUSTOMISE : nextflow version we want to start with
nxf_version="v20.07.1"
 
 
# DO NOT need to change below this point
 
# this is good habit on Pawsey systems
export NXF_HOME="$MYGROUP/.nextflow"
 
# working directories
here=$(pwd)
tmp_dir="/tmp/tmp_nextflow_build_$((RANDOM))"

echo ""
echo "building nextflow in directory $tmp_dir"
echo"" 
mkdir -p $tmp_dir
cd $tmp_dir
 
# get nextflow repo to the right version
git clone https://github.com/nextflow-io/nextflow
cd nextflow
git checkout $nxf_version
 
# edit the code
# assuming the new executor is called "slurm-magnus"
sed -i 's/{HOME}/{MYGROUP}/g' Makefile
 
sed -i "/SlurmExecutor/ a\            'slurm_magnus': SlurmMagnusExecutor," \
    modules/nextflow/src/main/groovy/nextflow/executor/ExecutorFactory.groovy
 
sed -i "/SlurmExecutor/ a\            'slurm_topaz': SlurmTopazExecutor," \
    modules/nextflow/src/main/groovy/nextflow/executor/ExecutorFactory.groovy
 
sed -e 's/class SlurmExecutor/class SlurmMagnusExecutor/g' \
    -e "s/'sbatch'/&, '--clusters', 'magnus'/g" \
    -e "s/'squeue'/&, '--clusters', 'magnus'/g" \
    -e "s/'scancel'/&, '--clusters', 'magnus'/g" \
    modules/nextflow/src/main/groovy/nextflow/executor/SlurmExecutor.groovy >modules/nextflow/src/main/groovy/nextflow/executor/SlurmMagnusExecutor.groovy
 
sed -e 's/class SlurmExecutor/class SlurmTopazExecutor/g' \
    -e "s/'sbatch'/&, '--clusters', 'topaz'/g" \
    -e "s/'squeue'/&, '--clusters', 'topaz'/g" \
    -e "s/'scancel'/&, '--clusters', 'topaz'/g" \
    modules/nextflow/src/main/groovy/nextflow/executor/SlurmExecutor.groovy >modules/nextflow/src/main/groovy/nextflow/executor/SlurmTopazExecutor.groovy
 
# compile
module load java
 
make compile
make pack
make install
 
# retrieve nextflow executable
cd $here
cp -p $tmp_dir/nextflow/build/releases/nextflow-*-all nextflow
chmod +x nextflow
 
# test nextflow executable
./nextflow info
ok="$?"
 
# clean build dir
 rm -rf $tmp_dir

if [ "$ok" == "0" ] ; then 
# print final information
  echo ""
  echo "edited nextflow made available at $here/nextflow"
  echo ""
  echo "to use it, add these variables to your shell environment, or to your .bashrc or .bash_profile"
  echo "module load java"
  echo "export NXF_HOME=\"\$MYGROUP/.nextflow\""
  echo "export PATH=\"$here:\$PATH\""
  echo ""
else
  echo ""
  echo "something went wrong in the installation. OOPS."
fi

exit

