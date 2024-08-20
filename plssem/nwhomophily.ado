*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Link�ping University
*! Email	   : contact@nwcommands.org

capture program drop nwhomophily
program def nwhomophily
	syntax varlist(min=1), homophily(string) density(real) [mode(string) nodes(string) name(string) stub(string) xvars undirected]
	
	local vc = wordcount("`varlist'")
	local hc = wordcount("`homophily'")
	local mc = wordcount("`'")
	
	if (`vc' != `hc') {
		di "{err}option {bf:homophily()} needs to have one entry for each variable in {it:varlist}."
		error 6300
	}

	// Check if this is the first network in this Stata session
	if "$nwtotal" == "" {
		global nwtotal = 0
	}
	
	if "`nodes'" == "" {
		local nodes = _N
		foreach var of varlist `varlist' {
			qui sum `varlist'
			local temp = r(N)
			local nodes = min(`temp',`nodes')
		}
	}
	else {
		if `nodes' > `=_N' {
			di "{err}Not enough observations of variables: {bf:`varlist'}{txt}"
			error 6044
		}
	}
	
	// generate valid network name and valid varlist
	if "`name'" == "" {
		local name "homophily"
	}
	if "`stub'" == "" {
		local stub "net"
	}
	
	nwvalidate `name'
	local assortname= r(validname)
	local gencmd "nwgenerate _tempassort ="
	
	tempname __temp0
	tempname __temp

		
	mata: `__temp0' = J(`nodes', `nodes', 0)
	forvalues i = 1/`vc'{
	
		local onevar = word("`varlist'",`i')
		local onehom = word("`homophily'",`i')
		local onemode = word("`mode'",`i')
		
		nwexpand `onevar' if _n <= `nodes', mode(`onemode') name(_tempexpand)
		nwtomata _tempexpand, mat(`__temp')
		nwdrop _tempexpand
		
		mata: `__temp' = `__temp' :* `onehom'
		mata: `__temp0' = `__temp0' :+ `__temp'
	}
	mata: `__temp0' = exp(`__temp0')
	nwdyadprob , mat(`__temp0') density(`density') name(`assortname') `undirected'
end
	
	
	


	
*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
