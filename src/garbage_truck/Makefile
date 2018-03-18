OD=$(HOME)/3d/gtruck
MODES= attach

TARGETS=	$(addsuffix .stl,$(addprefix $(OD)/,$(MODES)))

all:	$(TARGETS)

$(OD)/%.stl:	gt.scad
	openscad-nightly -D 'mode="$*"' -o $@ $<
