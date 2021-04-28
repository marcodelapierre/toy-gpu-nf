## Toy pipeline to test Nextflow with GPUs at Pawsey


The pipeline requires [Nextflow](https://github.com/nextflow-io/nextflow) to run, with some special requirements:

* DSL2 syntax is used, so that Nextflow version `20.07.1` or higher is required;
* Slurm multi-cluster support is needed, so that an hacked version of Nextflow is required; a script to build and install one is provided.


Here are the highlights of the key requirements to run a CPU+GPU pipeline with containers on Pawsey multiple Slurm clusters:

* the pipeline is assumed to be run from Zeus;
* hacked version of Nextflow with Slurm multi-cluster support; in this example, `slurm_topaz` executor is used to submit the GPU jobs to Topaz;
* process options for GPU tasks: `executor = 'slurm_topaz'`, `queue = 'gpuq'`, `clusterOptions += " --gpus-per-node=1"`;
* Singularity options: 
  * `runOptions = "-B /group,/scratch --nv"`;
  * `//envWhitelist = 'SINGULARITY_BINDPATH, SINGULARITYENV_LD_LIBRARY_PATH'` commented out;
  * `--nv` is fine for non-GPU tasks, it will just print a warning in the output;
  * adding `-B /group,/scratch` here, because with multi-cluster submission the Singularity variables cannot be used as they differ among clusters.


Key files provided:

* `main.nf`
* `nextflow.config`, valid for test runs on Pawsey (uses debug queues)
* `job.sh` template Slurm script for Zeus at Pawsey
* `extra/` files:
  * `install-nextflow-hack-multi-cluster.sh`, a script to build and install hacked multi-cluster Nextflow
  * `log.sh`, a helper script to get enhanced logging for completed pipelines
  * `Dockerfile` used to build the toy container in use
* `src/`: source files for the toy CPU and GPU binaries in use
* `bin_/`: toy binaries (directory has broken name, to force using binaries from the container)
* `test-outputs/`: reference test outputs (currently the pipeline only outputs the equivalent of `test-out-a-cpu` and `test-out-a-gpu`)
