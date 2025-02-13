process fastqc {
    tag "$sample_name"

    input:
    tuple val(sample_name), path(fastq_file)

    output:
    path '*_fastqc.{zip,html}'

    publishDir "${params.outdir}/fastqc", mode: 'copy'

    script:
    """
    fastqc ${fastq_file}
    """
}
