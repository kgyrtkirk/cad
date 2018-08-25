OD=$(HOME)/3d/scad
MODES= first_layer rod_26mm_32mm bigyo ford_rear_door_button spring-r03 dxf_dragon dxf_snail dxf_shell ramp0 tower_5x5 tower_rod1 cube20 filament_roll_end

TARGETS=	$(addsuffix .stl,$(addprefix $(OD)/,$(MODES)))

all:	$(TARGETS)

#$(OD)/first_layer.stl:	first_layer.scad
$(OD)/%.stl:	%.scad
	mkdir -p $(OD)
	openscad-nightly -o $@ $<

