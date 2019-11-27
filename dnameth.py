# PROTOTYPE FOR DNAmeth
import sys
from os import walk, path, sep, makedirs
import subprocess
import logging
import argparse

COMMAND_R = "Rscript"
PROGRAM = "DNAmeth"
LOG_PATH = '/pfs/out'

logging.basicConfig(filename = f"{LOG_PATH}/{PROGRAM}.log",
                    level = logging.DEBUG,
                    format = "%(levelname)s : %(asctime)s - %(message)s")
logger = logging.getLogger()

try:
	parser = argparse.ArgumentParser()
	parser.add_argument("-i", "--input", help="", required=True)
	parser.add_argument("-o", "--output", help="Output folder", default=LOG_PATH)
	parser.add_argument("-s", "--step", help="DNA methylation step (R script name) \
		(00_load_data, 01_clean_data, 02_bmiq, 03_cnv, 04_sva, 05_qc, 06_make_cg_gene)", required=True)
	parser.add_argument("-a", "--anno", help="Annotation file folder", default="")
	parser.add_argument("-c", "--cross", help="CrossHybrid file folder", default="")
	parser.add_argument("-p", "--pheno", help="Phenotype file folder", default="")
	parser.add_argument("-e", "--ehub", help="Path to ehub", default="")
	args = parser.parse_args()

except Exception as e:
    logger.error(e)
    sys.exit(1)

# Declare variables
# POSTFIX = "_dnameth"
SCRIPT_NAME = args.step + '.R'
INPUTF = path.normpath(args.input) + sep
OUTPUTF = path.normpath(args.output) + sep
ANNO = args.anno
CROSS = args.cross
PHENO = args.pheno
EHUB = args.ehub

# Ensure about output folder
if not path.exists(OUTPUTF):
    # OUTPUTF = OUTPUTF + '_' + PROGRAM + sep
    makedirs(OUTPUTF)

logger.info(f"""Preparing DNA methylation pipeline script with
step - {args.step}
input folder - {INPUTF}
output folder - {OUTPUTF}
additional agrs - {ANNO} {CROSS} {PHENO} {EHUB}""")

if (path.exists(INPUTF) and path.exists(OUTPUTF)):
    cmd = f"{COMMAND_R} {SCRIPT_NAME} {INPUTF} {OUTPUTF} {ANNO} {CROSS} {PHENO} {EHUB}"
    # Rscript 00_load_data.R {input_folder} {output_folder}
    logger.info(f"Executing: {str((cmd.strip()).split())}")
    subprocess.call((cmd.strip()).split())
else:
    logger.warning(f"Check the existence of the provided input folder: {args.input}")
    sys.exit()

logger.info("Done current datum")
logging.shutdown()
