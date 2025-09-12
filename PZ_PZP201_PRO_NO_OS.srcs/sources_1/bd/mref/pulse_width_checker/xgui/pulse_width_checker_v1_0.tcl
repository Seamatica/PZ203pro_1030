# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "MAX_PW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MIN_PW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_BITS" -parent ${Page_0}


}

proc update_PARAM_VALUE.MAX_PW { PARAM_VALUE.MAX_PW } {
	# Procedure called to update MAX_PW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_PW { PARAM_VALUE.MAX_PW } {
	# Procedure called to validate MAX_PW
	return true
}

proc update_PARAM_VALUE.MIN_PW { PARAM_VALUE.MIN_PW } {
	# Procedure called to update MIN_PW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MIN_PW { PARAM_VALUE.MIN_PW } {
	# Procedure called to validate MIN_PW
	return true
}

proc update_PARAM_VALUE.WIDTH_BITS { PARAM_VALUE.WIDTH_BITS } {
	# Procedure called to update WIDTH_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_BITS { PARAM_VALUE.WIDTH_BITS } {
	# Procedure called to validate WIDTH_BITS
	return true
}


proc update_MODELPARAM_VALUE.WIDTH_BITS { MODELPARAM_VALUE.WIDTH_BITS PARAM_VALUE.WIDTH_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_BITS}] ${MODELPARAM_VALUE.WIDTH_BITS}
}

proc update_MODELPARAM_VALUE.MIN_PW { MODELPARAM_VALUE.MIN_PW PARAM_VALUE.MIN_PW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MIN_PW}] ${MODELPARAM_VALUE.MIN_PW}
}

proc update_MODELPARAM_VALUE.MAX_PW { MODELPARAM_VALUE.MAX_PW PARAM_VALUE.MAX_PW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_PW}] ${MODELPARAM_VALUE.MAX_PW}
}

