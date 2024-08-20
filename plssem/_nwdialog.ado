capture program drop _nwdialog
program _nwdialog
	syntax anything(name=dialogname)
    qui nwset
	local netlist = "`r(names)'"
	if "`netlist'" != "" {
		.`dialogname'_dlg.netlist.Arrdropall
	}
	.`dialogname'_dlg.netlist.Arrpush " "
	foreach onenet of local netlist {
		.`dialogname'_dlg.netlist.Arrpush "`onenet'"
	}
end


capture program drop _nwdialog_append
program _nwdialog_append
	syntax anything(name=dialogname)
    qui nwset
	local netlist = "`r(names)'"
	if "`netlist'" != "" {
		.`dialogname'_dlg.netlist_append.Arrdropall
	}
	.`dialogname'_dlg.netlist.Arrpush " "
	foreach onenet of local netlist {
		.`dialogname'_dlg.netlist_append.Arrpush "main.cb_net.append `onenet'"
	}
end
*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
