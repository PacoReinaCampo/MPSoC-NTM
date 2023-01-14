# Specify project info
variable tbEnt ring_buffer_testbench
variable projLibs {
  work
}
variable runTime "-all"

# This procedure is a hack to get the path to this script
# "info script" doesn't work for ModelSim do-files
proc getScriptDir {} {

  # Get the last command from the history
  set histLines [split [history] "\n"]
  set lastLineIndex [expr [llength $histLines] - 1 ]
  set lastLine [lindex $histLines $lastLineIndex]

  # Remove all quotes
  set trimmed [regsub -all {(\")} $lastLine {}]

  # Remove the first two words
  set trimmed [regsub -all {(^\s*\w+\s+\w+\s+)} $trimmed {}]

  # Remove the script name from the end of the string
  set trimmed [regsub -all {(run.do$)} $trimmed {}]

  # Trim whitespace
  set trimmed [string trim $trimmed]

  # Remove backslashes (ModelSim uses forward slash on all platforms)
  set trimmed [regsub -all {(\\)} $trimmed {}]

  # If the string is empty
  if {$trimmed eq ""} {
    return "./"
  }

  # The trimmed string should contain the location of this script
  return $trimmed
}

# Stop any ongoing simulation
if {[runStatus] != "nodesign"} {
  quit -sim
}

# cd to the dir of this file
cd [getScriptDir]

# Create the libraries if the folders don't exist
foreach lib $projLibs {
  if {![file isdirectory $lib]} {
    vlib $lib
  }
}

project open project.mpf
project compileall

proc runtb {} {
  global tbEnt runTime
  vsim -onfinish stop work.$tbEnt
  if {[file exists wave.do]} {
    do wave.do
  }
  run $runTime
}

echo "***************************************************************"
echo "*                                                             *"
echo "* Thank you for downloading this example from VHDLwhiz.com    *"
echo "*                                                             *"
echo "* Type \"runtb\" in the ModelSim console to run the testbench *"
echo "*                                                             *"
echo "* Like this:                                                  *"
echo "*                                                             *"
echo "* ModelSim> runtb                                             *"
echo "*                                                             *"
echo "***************************************************************"
