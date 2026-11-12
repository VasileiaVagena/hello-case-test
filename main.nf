 nextflow
  #!/usr/bin/env nextflow

  /*
   * Pipeline parameters
   */
  params {
      // Path to a plain text file, for example one that says "hello world"
      input: Path = 'data/hello.txt'
  }

  /*
   * Process 1: Convert the text to UPPERCASE
   */
  process convertToUpper {
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
      main:
      // Read the text file
      text_file = channel.fromPath(params.input)

      // Make an UPPERCASE and a lowercase copy
      upper_files = convertToUpper(text_file)
      lower_files = convertToLower(text_file)

      publish:
      uppercase = upper_files
      lowercase = lower_files
  }

  /*
   * Where the results are saved (inside the `results` folder by default)
   */
  output {
      uppercase {
          path 'uppercase'
          mode 'copy'
      }
      lowercase {
          path 'lowercase'
          mode 'copy'
      }
  }
