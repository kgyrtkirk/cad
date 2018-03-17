OD=$(HOME)/3d/lift
MODES= car wall floor attach ground sphere

TARGETS=	$(addsuffix .stl,$(addprefix $(OD)/,$(MODES)))

all:	$(TARGETS)

$(OD)/%.stl:	lift.scad
	openscad-nightly -D 'mode="$*"' -o $@ $<
