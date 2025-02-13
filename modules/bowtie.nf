process bowtie {
    tag "$sample_name"

    input:
    tuple val(sample_name), path(fastq_file)

    output:
    path "${sample_name}.bam"

    publishDir "${params.outdir}/bowtie", mode: 'copy'

    script:
    """
    bowtie --threads ${task.cpus} -S -x ${params.reference} ${fastq_file} > ${sample_name}.sam
    samtools view -bS ${sample_name}.sam > ${sample_name}.bam
    rm ${sample_name}.sam
    """
}
