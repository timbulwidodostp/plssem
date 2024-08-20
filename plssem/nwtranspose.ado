*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Link�ping University
*! Email	   : contact@nwcommands.org

capture program drop nwtranspose
program nwtranspose 
	version 9
	syntax [anything(name=netname)], [name(string) vars(string) xvars noreplace]
	
	_nwsyntax `netname', max(1)
	local transname "`netname'"

	if "`name'" != "" {
		local replace "noreplace"
	}
	
	if ("`replace'" != ""){
		// generate valid network name and valid varlist
		if "`name'" == "" {
			local name "_transp_`netname'"
		}
		
		// generate a new network
		nwduplicate `netname', name(`name')
		local transname "`name'"
	}
	
	// get transpose of network
	nwtomata `transname', mat(transnet)
	mata: transnet = transnet'
	
	nwreplacemat `transname', newmat(transnet)
	mata: mata drop transnet
end
*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
