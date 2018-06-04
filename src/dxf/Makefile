all: my_first_file.dxf my_second_file.dxf another_file.dxf

%.eps: %.svg
	inkscape -E $@ $<

%.dxf: %.eps
	pstoedit -dt -f dxf:-polyaslines\ -mm $< $@
