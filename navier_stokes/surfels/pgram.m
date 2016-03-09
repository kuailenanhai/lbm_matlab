classdef pgram < handle
    properties
        p0                      % one corner of the pgram.
        surface                 % the surface vector associated with this pgram.
        extrusion               % the vector describing the extrusion of 
                                % the surface into the fluid domain.
%         lattice_index           % the lattice velocity index that pgram corresponds to.
        area                    % area of this pgram. Equals magnitude of 
                                % cross(surface, extrusion).
        touched_cells           % handles of touched_cell objects
        overlap_areas           % the area of surfel-cell overlap corresponding to touched_cells.
        collected_particles     % collected particles in this pgram.
    end
    methods
        function obj = pgram(p0, surface, extrusion, dh)
            obj.p0 = p0;
            obj.surface = surface;
            obj.extrusion = extrusion;
            
            compute_area(obj, surface, extrusion);
            
        end
        
        function [fd, cell_indices] = distribute_particles(obj)
            for k = 1:length(obj.touched_cells)
                obj.touched_cells(k).distributed_particles = ...
                    obj.touched_cells(k).distributed_particles + ...
                    obj.overlap_areas(k) * obj.collected_particles;
            end
            fd = obj.overlap_areas / obj.area .* obj.collected_particles;
            cell_indices = obj.touched_cells;
        end
    end
    methods ( Access = private )
        function z = cross2d(v0,v1)
            v3 = cross([v0;0],[v1;0]);
            z = v3(3);
        end
        function compute_area(obj,v0,v1)
            obj.area = abs( cross2d(v0,v1) );
        end
        function determine_cell_relationships_lattice(obj)
            obj.touched_cells = [];
            obj.overlap_areas = [];
        end
    end
end