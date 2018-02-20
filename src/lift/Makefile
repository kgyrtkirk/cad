OD=$(HOME)/3d/lift
MODES= car wall floor

TARGETS=	$(addsuffix .stl,$(addprefix $(OD)/,$(MODES)))

all:	$(TARGETS)

$(OD)/%.stl:	lift.scad
	openscad-nightly -D 'mode="$*"' -o $@ $<
