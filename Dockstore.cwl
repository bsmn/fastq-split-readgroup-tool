#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: bsmnetwork/fastq-split-readgroup-tool:1.1

inputs:
  fastq:
    type: File
    inputBinding:
      position: 1
    label: A fastq file, or gzipped fastq file.
    format: edam:format_1931
  prefix:
    type: string
    inputBinding:
      position: 2
    label: Output file name prefix, including directory.

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.prefix)

baseCommand: ["split-read-group"]

doc: |
  Split a fastq file based on read header information.
  Usage: split-read-group <fastq> prefix

s:author:
  - class: s:Person
    s:identifier: http://orcid.org/orcid.org/0000-0001-5729-7376
    s:email: mailto:kenneth.daily@sagebionetworks.org
    s:name: Kenneth Daily
 
$namespaces:
  s: https://schema.org/

$schemas:
 - https://schema.org/docs/schema_org_rdfa.html