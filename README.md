# server_job_submission

#####Submiting Job To TRUBA#####

#	Download OpenVPN. Further steps to install OpenVPN can be followed from Truba user guide (http://wiki.grid.org.tr/index.php/OpenVPN%27i_Nas%C4%B1l_Kullanabilirim%3F). 

#	After the activation of OpenVPN, Truba connection can be established via a terminal window or Open OnDemand using your internet browser.
#	http://wiki.truba.gov.tr/index.php/OpenOndemand

#	executing 
#	ssh username@levrek1.ulakbim.gov.tr
#	in Terminal will connect you remotely to the TUBITAK's Truba Server.  
#	Following script is a sample to run NAMD simulation on Truba, Barbun-cuda partition. 

#	scontrol show partition=barbun-cuda 
#	will show the detailed information about the barbun-cuda partition.
#	https://docs.truba.gov.tr/TRUBA/kullanici-el-kitabi/hesaplamakumeleri.html further information about the other Truba partitions can be found here

#!/bin/bash
#SBATCH -p barbun-cuda 			#name of the partition
#SBATCH -A username			#Truba username
#SBATCH -J job_name			#job name
#SBATCH -N 1				#number of nodes
#SBATCH -n 40				#number of cores
#SBATCH --time=15-00:00:00		#max time to use indicated sources
#SBATCH --gres=gpu:1			#number of gpus
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mail_adress	#mail address


	#for general queue 
#module load centos7.3/app/namd/whole-runs-multicore 
	#particularly for cuda
module load centos7.3/app/namd/2017-11-10-multicore-cuda 

echo "SLURM_NODELIST $SLURM_NODELIST"
echo "NUMBER OF CORES $SLURM_NTASKS"

$NAMD_DIR/namd2  +p $SLURM_NTASKS  +idlepoll config.conf		#input file


#	Save the file with .slurm extension (ex. run_namd.slurm). 

#	If you edit the run_namd.sh script on your own PC, you need to copy and paste it to Truba, in your simulation folder. Open a terminal that is working directory is the same as the run_namd.slurm script. 
#	cp run_namd.slurm username@172.16.7.1:/truba/home/username/simulation_folder

#	The command above will make a copy of run_namd.slurm script in Truba, simulation folder. The other option for this copying process is using Open on Demand on a web browser. After the log in, you can drag and drop the script. 


#	sbatch run_namd.slurm 
#	will run the simulation when the server has proper node configuration. 
#	squeue 
#	command will check the job’s running status. 

 



#####Submiting Job To TOSUN##### 

#!/bin/bash
#
# CompecTA (c) 2018
#
# NAMD job submission script
#
# TODO:
#   - Set name of the job below changing "NAMD" value.
#   - Set the requested number of nodes (servers) with --nodes parameter.
#   - Set the requested number of tasks (cpu cores) with --ntasks parameter. (Total accross all nodes)
#   - Select the partition (queue) you want to run the job in:
#     - short : For jobs that have maximum run time of 120 mins. Has higher priority.
#     - long  : For jobs that have maximum run time of 7 days. Lower priority than short.
#     - longer: For testing purposes, queue has 31 days limit but only 3 nodes.
#     - cuda  : For CUDA jobs. Solver that can utilize CUDA acceleration can use this queue. 15 days limit.
#     - midst:
#   - Set the required time limit for the job with --time parameter.
#     - Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds"
#   - Put this script and all the input file under the same directory.
#   - Set the required parameters, input/output file names below.
#   - If you do not want mail please remove the line that has --mail-type and --mail-user. If you do want to get notification emails, set your email address.
#   - Put this script and all the input file under the same directory.
#   - Submit this file using:
#      sbatch namd_submit.sh
#
# -= Resources =-
#
#SBATCH --job-name=job_name			
#SBATCH --account=midst			
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=48
#SBATCH --qos=midst
#SBATCH --partition=midst 
#SBATCH --time=15-00:00:00
#SBATCH --output=%j-log.out
#SBATCH --mail-type=ALL
##SBATCH --usename@sabanciuniv.edu

INPUT_FILE="config.conf"

################################################################################
source /etc/profile.d/modules.sh
echo "source /etc/profile.d/modules.sh"
################################################################################

# Module File
echo "Loading NAMD..."
module load namd/2.13/multicore
echo

echo
echo "============================== ENVIRONMENT VARIABLES ==============================="
env
echo "===================================================================================="
echo

echo
echo "=================================== STACK SIZE ====================================="
ulimit -s unlimited
ulimit -l unlimited
ulimit -a
echo "===================================================================================="
echo

COMMAND="namd2 $INPUT_FILE +p$SLURM_NTASKS"

# Running Solver.
echo "Running NAMD command..."
echo $COMMAND
echo "===================================================================================="
NAMD_OUTPUT="namd.out-$SLURM_JOB_ID"
echo "Redirecting output to file: $NAMD_OUTPUT"
echo "-------------------------------------------"
$COMMAND > $NAMD_OUTPUT 2>&1
RET=$?

echo
echo "Solver exited with return code: $RET"
exit $RET


#	After editing related parts of the script save it with .sh extension (ex. tosun.sh) 

#	sbatch tosun.sh 
#	will run the NAMD simulation when the indicated configuration is available.
#	squeue 
#	command will check the job status. 	 


