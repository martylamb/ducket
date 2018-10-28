//$fn=60; // rendering option, see https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#$fa,_$fs_and_$fn

// when we make ridges, how many around the circle?  they will be evenly spaced.
crenellation_ridge_count = 60;

// creates a list of the angles pointing to the corners of of a regular polygon with the specified number of sides
function _regular_polygon_angles(nsides) = [ for (i = [0:nsides-1]) i*(360/nsides) ];
    
// creates a list of 2d coordinates defining the corners of a regular polygon with the specified number of sides
// circumscribed by a circle with the specified radius
function _regular_polygon_corners(nsides, r) = [ for (th = _regular_polygon_angles(nsides)) [r*cos(th), r*sin(th)]];

// creates a 3d regular polygon with height h circumscribed by a circle with radius r
module _regular_polygon(nsides, r, h) {
    //echo(nsides);
 	linear_extrude(height = h) polygon(_regular_polygon_corners(nsides, r));
}
 
// creates spheres at the corners of an n-sided polygon, used for bumps on top and cavities on bottom for staciking
module _corner_spheres(r, nsides, sphere_r) {
    for (corner = _regular_polygon_corners(nsides, r)) translate(corner) sphere(r = sphere_r);
}

// creates a crenellated ring that intersects with the the lip of a coin
module _crenellated_ring(r, nsides, lip_w) {
    intersection() {
        translate([0, 0, -2.5])
            difference() {
                _regular_polygon(nsides = nsides, r = r, h = 5);
                translate([0, 0, -1]) _regular_polygon(nsides = nsides, r = r - lip_w, h = 7);
            }
        for (i = [0 : crenellation_ridge_count])
            rotate([0, 0, (360 / crenellation_ridge_count) * i])
                rotate([45, 0, 0]) translate([0, -.5, -.5]) cube([r + 2, 1, 1]);
    }
}

module ducket(r = 12.7,                 // radius of circle circumscribing the ducket
                nsides = 3,             // number of sides for the ducket
                h = 3,                  // thickness of the ducket (not including any lip around it)
                lip_w = 5,              // width of raised lip around ducket, if any
                lip_h = 0,              // height of raised lip around ducket, if any
                bumps = false,          // true if stacking bumps are to be used
                crenellated = false)    // true if crenellating the lip and underside for stacking
{
    difference() {
        union() {
            _regular_polygon(nsides=nsides, r=r, h=h + lip_h);
            if (bumps)
                translate([0, 0, h + lip_h])
                    _corner_spheres(r = r - lip_w/2, 
                                    nsides = nsides, 
                                    sphere_r = lip_w / 4);
            if (crenellated)
               translate([0, 0, h + lip_h]) 
                _crenellated_ring(r = r, nsides = nsides, lip_w = lip_w);
        }
        union() {
            if (lip_h > 0) translate([0, 0, h]) _regular_polygon(nsides=nsides, r=r - lip_w, h=lip_h + 1);
            if (bumps)
                _corner_spheres(r = r - lip_w/2, 
                                nsides = nsides, 
                                sphere_r = lip_w / 4 + .4);
        }
        if (crenellated) translate([0, 0, 0]) _crenellated_ring(r = r + 0.1, nsides = nsides, lip_w = lip_w + 0.3);
    }
}
