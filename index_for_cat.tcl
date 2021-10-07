set filelist [glob *.pdb]
set sortedfilelist [lsort -dictionary $filelist]
foreach file $sortedfilelist {
set filewhext [file rootname $file]
mol new $file

set sel [ atomselect top "protein"]
set ind [ $sel get index ]
set fout [open "${filewhext}_indexfile.ind" "w"]
puts $fout $ind
close $fout

}