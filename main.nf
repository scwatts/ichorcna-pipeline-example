#!/usr/bin/env nextflow


include { ICHORCNA } from './workflows/ichorcna'


workflow {
  ICHORCNA()
}
