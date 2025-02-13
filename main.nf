#!/usr/bin/env nextflow

// Import required processes
include { fastqc } from "./modules/fastqc.nf"
include { fastp } from "./modules/fastp.nf"
include { multiqc } from "./modules/multiqc.nf"
include { bowtie } from "./modules/bowtie.nf"

workflow nipt {
    // Read input CSV with sample names and single-end FASTQ files
    Channel
        .fromPath(params.input)
        .splitCsv(header: true)
        .map { row ->
            def sample_name = row.sample
            def fastq_file = file(row.read1) // Only single-end read
            tuple(sample_name, fastq_file)
        }
        .set { fastq_inputs }

    // Run Fastp (Trimming)
    trimmed_fastq = fastp(fastq_inputs)

    // Run FastQC (Quality Control)
    fastqc_results = fastqc(trimmed_fastq.fastq_trimmed)
    // Collect all FastQC outputs for MultiQC
    multiqc_input = fastqc_results.collect()
    multiqc_results = multiqc(multiqc_input)

    // Run Bowtie for single-end mapping
    bowtie_bam = bowtie(trimmed_fastq.fastq_trimmed)

    // View output BAM file for confirmation
    bowtie_bam.view { "Generated BAM file: ${it}" }
}

