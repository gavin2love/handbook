Juniper EX3300


	# 这个是重点
	set chassis aggregated-devices ethernet device-count   3
	# 下面是端口聚合
	delete interfaces ge-0/0/6 unit 0
	delete interfaces ge-0/0/35 unit 0
	set interfaces ge-0/0/6 ether-options 802.3ad ae2
	set interfaces ge-0/0/35 ether-options 802.3ad ae2
	set interfaces ae2 aggregated-ether-options lacp active
	set interfaces ae2 aggregated-ether-options lacp periodic fast
	set interfaces ae2 unit 0 family ethernet-switching port-mode trunk
	set interfaces ae2 unit 0 family ethernet-switching vlan members all