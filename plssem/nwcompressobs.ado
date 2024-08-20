capture program drop nwcompressobs
program nwcompressobs
	tempvar allmissing
	tempvar temp
	
	qui gen `allmissing' = .
	qui foreach var of varlist _all {
		capture encode `var', gen(`temp')
		if (_rc == 0){
			replace `allmissing' = 0 if `temp' != .
			drop `temp'
		}
		else {
			replace `allmissing' = 0 if `var' != .
		}
	}
	qui drop if (`allmissing' == .)
end
*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
