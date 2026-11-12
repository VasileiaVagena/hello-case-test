#!/usr/bin/env nextflow

  /*
   * Pipeline parameters
   */
  params.input  = 'data/hello.txt'
  params.outdir = 'results'

  /*
   * Process 1: Convert the text to UPPERCASE
   */
  process convertToUpper {
      publishDir "${params.outdir}/uppercase", mode: 'copy'
      container 'quay.io/nf-core/ubuntu:20.04'

      input:
      path input_file

      output:
      path "UPPER-${input_file}"

      script:
      """
      cat "${input_file}" | tr '[a-z]' '[A-Z]' > "UPPER-${input_file}"
      """
  }

  /*
   * Process 2: Convert the text to lowercase
   */
  process convertToLower {
      publishDir "${params.outdir}/lowercase", mode: 'copy'
      container 'quay.io/nf-core/ubuntu:20.04'

      input:
      path input_file

      output:
      path "LOWER-${input_file}"

      script:
      """
      cat "${input_file}" | tr '[A-Z]' '[a-z]' > "LOWER-${input_file}"
      """
  }

  workflow {
      // Read the text file
      text_file = Channel.fromPath(params.input)

      // Make an UPPERCASE and a lowercase copy
      convertToUpper(text_file)
      convertToLower(text_file)
  }
