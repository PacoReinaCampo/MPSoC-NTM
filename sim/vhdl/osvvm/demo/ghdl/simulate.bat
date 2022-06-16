@echo off
call ../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../osvvm/src/NamePkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/TranscriptPkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/TextUtilPkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/OsvvmGlobalPkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/AlertLogPkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/SortListPkg_int.vhd
ghdl -a --std=08 ../../../../../osvvm/src/RandomBasePkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/RandomProcedurePkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/ResolutionPkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/NameStorePkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/MessageListPkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/VendorCovApiPkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/RandomPkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/CoveragePkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/MemoryPkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/MessagePkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/OsvvmContext.vhd
ghdl -a --std=08 ../../../../../osvvm/src/OsvvmTypesPkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/ScoreboardGenericPkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/ScoreboardPkg_slv.vhd
ghdl -a --std=08 ../../../../../osvvm/src/ScoreboardPkg_int.vhd
ghdl -a --std=08 ../../../../../osvvm/src/ReportPkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/ResizePkg.vhd
ghdl -a --std=08 ../../../../../osvvm/src/ScoreboardPkg_int_c.vhd
ghdl -a --std=08 ../../../../../osvvm/src/ScoreboardPkg_slv_c.vhd
ghdl -a --std=08 ../../../../../osvvm/src/TbUtilPkg.vhd

ghdl -a --std=08 ../../../../../osvvm/demo/Demo_Rand.vhd

ghdl -m --std=08 Demo_Rand
ghdl -r --std=08 Demo_Rand --ieee-asserts=disable-at-0 --disp-tree=inst > Demo_Rand.tree
pause