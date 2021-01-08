all: my_first_file.dxf my_second_file.dxf another_file.dxf car3.dxf car4.dxf car5.dxf

%.eps: %.svg
	inkscape -E $@ $<

%.dxf: %.eps
	pstoedit -dt -f dxf:-polyaslines\ -mm $< $@
