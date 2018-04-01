OD=$(HOME)/3d/scad
MODES= first_layer rod_26mm_32mm

TARGETS=	$(addsuffix .stl,$(addprefix $(OD)/,$(MODES)))

all:	$(TARGETS)

#$(OD)/first_layer.stl:	first_layer.scad
$(OD)/%.stl:	%.scad
	mkdir -p $(OD)
	openscad-nightly -o $@ $<

