#!/bin/bash

# commands for downloadng agora2 database from https://www.vmh.life/files/reconstructions/AGORA2/ for brevity

mkdir agora2

# mat files

cd agora2
mkdir mat

wget https://www.vmh.life/files/reconstructions/AGORA2/version2.00/mat_files/AGORA2_annotatedMat_A_C.zip && wget https://www.vmh.life/files/reconstructions/AGORA2/version2.00/mat_files/AGORA2_annotatedMat_D_F.zip && wget https://www.vmh.life/files/reconstructions/AGORA2/version2.00/mat_files/AGORA2_annotatedMat_G_P.zip && wget https://www.vmh.life/files/reconstructions/AGORA2/version2.00/mat_files/AGORA2_annotatedMat_R_Y.zip

unzip '*.zip'

# sbml files

cd ..
mkdir sbml

wget https://www.vmh.life/files/reconstructions/AGORA2/version2.00/sbml_files/AGORA2_annotatedSBML_A_Blau.zip && wget https://www.vmh.life/files/reconstructions/AGORA2/version2.00/sbml_files/AGORA2_annotatedSBML_
BOR_C.zip && wget https://www.vmh.life/files/reconstructions/AGORA2/version2.00/sbml_files/AGORA2_annotatedSBML_D_Ery.zip && wget https://www.vmh.life/files/reconstructions/AGORA2/version2.00/sbml_files/AGORA2_annotatedSBML_F_L.zip && wget https://www.vmh.life/files/reconstructions/AGORA2/version2.00/sbml_files/AGORA2_annotatedSBML_M_P.zip && wget https://www.vmh.life/files/reconstructions/AGORA2/version2.00/sbml_files/AGORA2_annotatedSBML_R_Spor.zip && wget https://www.vmh.life/files/reconstructions/AGORA2/version2.00/sbml_files/AGORA2_annotatedSBML_Staph_Stoq.zip && wget https://www.vmh.life/files/reconstructions/AGORA2/version2.00/sbml_files/AGORA2_annotatedSBML_Strep_Y.zip

unzip '*.zip'
