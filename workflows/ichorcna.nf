include { HMMCOPY_GCCOUNTER   } from '../modules/nf-core/modules/hmmcopy/gccounter/main'
include { HMMCOPY_GENERATEMAP } from '../modules/nf-core/modules/hmmcopy/generatemap/main'
include { HMMCOPY_MAPCOUNTER  } from '../modules/nf-core/modules/hmmcopy/mapcounter/main'
include { HMMCOPY_READCOUNTER } from '../modules/nf-core/modules/hmmcopy/readcounter/main'
include { ICHORCNA_RUN        } from '../modules/nf-core/modules/ichorcna/run/main'


ch_data = Channel.of(
  [
    [id: params.subject_name],
    file(params.bam, checkIfExists: true),
    file(params.bai, checkIfExists: true),
  ],
)
ref_fasta = file(params.ref_fasta, checkIfExists: true)


workflow ICHORCNA {

  if (! params.wig_gc) {
    HMMCOPY_GCCOUNTER(
      ref_fasta,
    )
    ch_wig_gc = HMMCOPY_GCCOUNTER.out.wig
  } else {
    ch_wig_gc = file(params.wig_gc, checkIfExists: true)
  }

  if (! params.wig_map) {
    HMMCOPY_GENERATEMAP(
      ref_fasta,
    )
    HMMCOPY_MAPCOUNTER(
      HMMCOPY_GENERATEMAP.out.bigwig,
    )
    ch_wig_map = HMMCOPY_MAPCOUNTER.out.wig
  } else {
    ch_wig_map = file(params.wig_map, checkIfExists: true)
  }

  HMMCOPY_READCOUNTER(
    ch_data,
  )

  ICHORCNA_RUN(
    HMMCOPY_READCOUNTER.out.wig,
    ch_wig_gc,
    ch_wig_map,
    [], // panel_of_normals (optional)
    [], // centromere (optional)
  )

}
