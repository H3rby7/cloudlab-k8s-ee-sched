# Hardware

Not all hardware has support to read the current power usage

Site                | type                                                                         | power   | sensors
------------------- | ---------------------------------------------------------------------------- | ------- | ------------------------------------
Apt (UTAH)          | [r320](https://www.apt.emulab.net/portal/show-nodetype.php?type=r320)        | static  | `Pwr Consumption`
Apt (UTAH)          | [c6220](https://www.apt.emulab.net/portal/show-nodetype.php?type=c6220)      | dynamic | `Input Voltage*Input Current`
Cloudlab Wisconsin  | [c220g1](https://www.wisc.cloudlab.us/portal/show-nodetype.php?type=c220g1)  | dynamic | `PSU1_PIN, [POWER_USAGE, PSU1_POUT]`
Cloudlab Wisconsin  | [c220g2](https://www.wisc.cloudlab.us/portal/show-nodetype.php?type=c220g2)  | dynamic | `PSU1_PIN, [POWER_USAGE, PSU1_POUT]`
Cloudlab Clemson    | [r6525](https://www.clemson.cloudlab.us/portal/show-nodetype.php?type=r6525) | dynamic | `Pwr Consumption`
Cloudlab Utah       | [xl170](https://www.utah.cloudlab.us/portal/show-nodetype.php?type=xl170)    | static  | `[Power Supply 1, Power Supply 2, PS 1 Output, PS 2 Output]`
Emulab              | [d430](https://www.emulab.net/portal/show-nodetype.php?type=d430)            | static  | `Pwr Consumption`
Emulab              | [d710](https://www.emulab.net/portal/show-nodetype.php?type=d710)            | dynamic | `System Level`

## Non-working Sites

Massachusetts (has/had) no public IPs to pool from, so the profile fails to start.

## C6620

Would need to calculate Watts from `Input Voltage` (Volts) and `Input Current` (Amps).

Could maybe be done with Prometheus ruls/relabelings etc.?

If not: the grafana dashboard needs adjusting as it queries namespaces from `node_ipmi_watts`
