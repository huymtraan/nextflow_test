process multiqc {
    input:
    path fastqc_reports

    output:
    path 'multiqc_report.html'

    publishDir "${params.outdir}/multiqc", mode: 'copy'

    script:
    """
    multiqc ${fastqc_reports}
    """
}
