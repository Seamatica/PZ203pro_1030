# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "IDELAY_VALUE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "UDP_PAYLOAD_BYTES" -parent ${Page_0}


}

proc update_PARAM_VALUE.IDELAY_VALUE { PARAM_VALUE.IDELAY_VALUE } {
	# Procedure called to update IDELAY_VALUE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IDELAY_VALUE { PARAM_VALUE.IDELAY_VALUE } {
	# Procedure called to validate IDELAY_VALUE
	return true
}

proc update_PARAM_VALUE.UDP_PAYLOAD_BYTES { PARAM_VALUE.UDP_PAYLOAD_BYTES } {
	# Procedure called to update UDP_PAYLOAD_BYTES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UDP_PAYLOAD_BYTES { PARAM_VALUE.UDP_PAYLOAD_BYTES } {
	# Procedure called to validate UDP_PAYLOAD_BYTES
	return true
}


proc update_MODELPARAM_VALUE.IDELAY_VALUE { MODELPARAM_VALUE.IDELAY_VALUE PARAM_VALUE.IDELAY_VALUE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IDELAY_VALUE}] ${MODELPARAM_VALUE.IDELAY_VALUE}
}

proc update_MODELPARAM_VALUE.UDP_PAYLOAD_BYTES { MODELPARAM_VALUE.UDP_PAYLOAD_BYTES PARAM_VALUE.UDP_PAYLOAD_BYTES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UDP_PAYLOAD_BYTES}] ${MODELPARAM_VALUE.UDP_PAYLOAD_BYTES}
}

