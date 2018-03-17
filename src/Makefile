OD=$(HOME)/3d/scad
MODES= first_layer

TARGETS=	$(addsuffix .stl,$(addprefix $(OD)/,$(MODES)))

all:	$(TARGETS)

$(OD)/first_layer.stl:	first_layer.scad
	mkdir -p $(OD)
	openscad-nightly -o $@ $<
