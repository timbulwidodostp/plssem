capture program drop _extract_valuelabels
program _extract_valuelabels
	syntax varlist(min=1 max=1)
	local lblname : value label `varlist'
	if "`lblname'" != "" {
		qui label list `lblname'
		local lblmin = `r(min)'
		local lblmax = `r(max)'
		local valuelabels ""
		forvalues i = `lblmin'/`lblmax' {
			local lblval : label `lblname' `i', strict
			if `"`lblval'"' != "" {
				local valuelabels `"`valuelabels' `i' "`lblval'""'
			}
		}
	}
	mata: st_global("r(valuelabels)", `"`valuelabels'"')
end
*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
