OD=$(HOME)/3d/camera_mount
MODES= suspension intermediate mount bj

TARGETS=	$(addsuffix .stl,$(addprefix $(OD)/,$(MODES)))

all:	$(TARGETS)

$(OD)/%.stl:	camera_mount.scad
	openscad-nightly -D 'mode="$*"' -o $@ $<
