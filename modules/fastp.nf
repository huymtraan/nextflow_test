process fastp {
    tag "$sample_name"
    debug true
    input:
    tuple val(sample_name), path(fastq_file)

    output:
    path "${sample_name}_report.html", emit: html
    path "${sample_name}_report.json", emit: json
    tuple val(sample_name), path("${sample_name}_trimmed.fastq.gz"), emit: fastq_trimmed

    publishDir "${params.outdir}/fastp", mode: 'symlink'

    script:
    """
    echo ${task.cpus}
    fastp --in1 ${fastq_file} --out1 ${sample_name}_trimmed.fastq.gz \
        --html ${sample_name}_report.html --json ${sample_name}_report.json
    """
}
