#!/usr/bin/nextflow

nextflow.enable.dsl = 2


process prep {
  //publishDir '.', saveAs: { filename -> filename+"-${string}" }

  input:
  val(string)
  
  output:
  tuple val(string), file('init')
  
  script:
  """
  echo $string >init
  """
}

process proc_cpu {
  publishDir '.', saveAs: { filename -> filename+"-${string}" }

  input:
  tuple val(string), file('init')

  output:
  tuple val(string), file('out')

  script:
  """
  hello_cpu <init >out
  """
}

process proc_gpu {
  publishDir '.', saveAs: { filename -> filename+"-${string}" }

  input:
  tuple val(string), file('init')

  output:
  tuple val(string), file('out')

  script:
  """
  hello_gpu <init >out
  """
}


workflow {

  input = channel.of('a','b','c')

  prep(input)

  //proc_cpu(prep.out)
  proc_gpu(prep.out)


}
