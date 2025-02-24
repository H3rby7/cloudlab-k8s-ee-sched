# Hardware

https://docs.cloudlab.us/hardware.html#(part._cloudlab-wisconsin)

Not all hardware has support to read the current power usage

Site                | type                                                                         | power   | sensors
------------------- | ---------------------------------------------------------------------------- | ------- | ------------------------------------
Apt (UTAH)          | [r320](https://www.apt.emulab.net/portal/show-nodetype.php?type=r320)        | static  | `Pwr Consumption`
Apt (UTAH)          | [c6220](https://www.apt.emulab.net/portal/show-nodetype.php?type=c6220)      | dynamic | `Input Voltage*Input Current`
Cloudlab Wisconsin  | [c220g1](https://www.wisc.cloudlab.us/portal/show-nodetype.php?type=c220g1)  | dynamic | `PSU1 PIN, [POWER USAGE, PSU1 POUT]`
Cloudlab Wisconsin  | [c220g2](https://www.wisc.cloudlab.us/portal/show-nodetype.php?type=c220g2)  | dynamic | `PSU1 PIN, [POWER USAGE, PSU1 POUT]`
Cloudlab Wisconsin  | [c220g5](https://www.wisc.cloudlab.us/portal/show-nodetype.php?type=c220g5)  | dynamic | `PSU1 PIN, [POWER USAGE, PSU1 POUT]`
Cloudlab Wisconsin  | [c6320](https://www.wisc.cloudlab.us/portal/show-nodetype.php?type=c6320)    | dynamic | `Pwr Consumption` (some nodes are always 0)
Cloudlab Clemson    | [r6525](https://www.clemson.cloudlab.us/portal/show-nodetype.php?type=r6525) | dynamic | `Pwr Consumption`
Cloudlab Clemson    | [r650](https://www.clemson.cloudlab.us/portal/show-nodetype.php?type=r650)   | probably | `Pwr Consumption`
Cloudlab Utah       | [m400](https://www.utah.cloudlab.us/portal/show-nodetype.php?type=m400)      | none    | ipmitools do not work
Cloudlab Utah       | [m510](https://www.utah.cloudlab.us/portal/show-nodetype.php?type=m510)      | none    | ipmitools have no power related info
Cloudlab Utah       | [xl170](https://www.utah.cloudlab.us/portal/show-nodetype.php?type=xl170)    | static  | `[Power Supply 1, Power Supply 2, PS 1 Output, PS 2 Output]`
Emulab              | [d430](https://www.emulab.net/portal/show-nodetype.php?type=d430)            | static  | `Pwr Consumption`
Emulab              | [d710](https://www.emulab.net/portal/show-nodetype.php?type=d710)            | dynamic | `System Level` (seems to be static for some nodes, maybe it is not dynamic after all, but just fluctuations?)
Emulab              | [pc3000](https://www.emulab.net/portal/show-nodetype.php?type=pc3000)        | n/a     | `n/a`

## Non-working Sites

Massachusetts (has/had) no public IPs to pool from, so the profile fails to start.

## C6620

Would need to calculate Watts from `Input Voltage` (Volts) and `Input Current` (Amps).

Could maybe be done with Prometheus ruls/relabelings etc.?

If not: the grafana dashboard needs adjusting as it queries namespaces from `node_ipmi_watts`

## PC3000

Setup does not complete within reasonable time as the [machine specs](https://www.emulab.net/portal/show-nodetype.php?type=pc3000) are very low.

## C6320


Always 0 nodes (for watts):
* https://www.clemson.cloudlab.us/portal/show-node.php?node_id=clnode098
* https://www.clemson.cloudlab.us/portal/show-node.php?node_id=clnode150

would work with amps * volts
