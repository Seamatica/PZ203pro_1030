# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "COUNT_LAST_SECOND_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DRIFT_COUNT_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NOMINAL_CYCLES_PER_SEC" -parent ${Page_0}
  ipgui::add_param $IPINST -name "UTC_SECONDS_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.COUNT_LAST_SECOND_WIDTH { PARAM_VALUE.COUNT_LAST_SECOND_WIDTH } {
	# Procedure called to update COUNT_LAST_SECOND_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COUNT_LAST_SECOND_WIDTH { PARAM_VALUE.COUNT_LAST_SECOND_WIDTH } {
	# Procedure called to validate COUNT_LAST_SECOND_WIDTH
	return true
}

proc update_PARAM_VALUE.DRIFT_COUNT_WIDTH { PARAM_VALUE.DRIFT_COUNT_WIDTH } {
	# Procedure called to update DRIFT_COUNT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DRIFT_COUNT_WIDTH { PARAM_VALUE.DRIFT_COUNT_WIDTH } {
	# Procedure called to validate DRIFT_COUNT_WIDTH
	return true
}

proc update_PARAM_VALUE.NOMINAL_CYCLES_PER_SEC { PARAM_VALUE.NOMINAL_CYCLES_PER_SEC } {
	# Procedure called to update NOMINAL_CYCLES_PER_SEC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NOMINAL_CYCLES_PER_SEC { PARAM_VALUE.NOMINAL_CYCLES_PER_SEC } {
	# Procedure called to validate NOMINAL_CYCLES_PER_SEC
	return true
}

proc update_PARAM_VALUE.UTC_SECONDS_WIDTH { PARAM_VALUE.UTC_SECONDS_WIDTH } {
	# Procedure called to update UTC_SECONDS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UTC_SECONDS_WIDTH { PARAM_VALUE.UTC_SECONDS_WIDTH } {
	# Procedure called to validate UTC_SECONDS_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.UTC_SECONDS_WIDTH { MODELPARAM_VALUE.UTC_SECONDS_WIDTH PARAM_VALUE.UTC_SECONDS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UTC_SECONDS_WIDTH}] ${MODELPARAM_VALUE.UTC_SECONDS_WIDTH}
}

proc update_MODELPARAM_VALUE.DRIFT_COUNT_WIDTH { MODELPARAM_VALUE.DRIFT_COUNT_WIDTH PARAM_VALUE.DRIFT_COUNT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DRIFT_COUNT_WIDTH}] ${MODELPARAM_VALUE.DRIFT_COUNT_WIDTH}
}

proc update_MODELPARAM_VALUE.COUNT_LAST_SECOND_WIDTH { MODELPARAM_VALUE.COUNT_LAST_SECOND_WIDTH PARAM_VALUE.COUNT_LAST_SECOND_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COUNT_LAST_SECOND_WIDTH}] ${MODELPARAM_VALUE.COUNT_LAST_SECOND_WIDTH}
}

proc update_MODELPARAM_VALUE.NOMINAL_CYCLES_PER_SEC { MODELPARAM_VALUE.NOMINAL_CYCLES_PER_SEC PARAM_VALUE.NOMINAL_CYCLES_PER_SEC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NOMINAL_CYCLES_PER_SEC}] ${MODELPARAM_VALUE.NOMINAL_CYCLES_PER_SEC}
}

